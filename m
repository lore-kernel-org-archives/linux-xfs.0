Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983B369D71
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589727; cv=none; b=bx+MjW6LO/HsJSpjYWkXMg8rH4LOwXF9AH/qX2JjAdAZNFT2TBAjs+5pncJQeTcJzL2U2xSlsS5DA3o1TuOyDgwmv8wmQs9JnJZwlO3DIIF80com8Rc8sz+wwOXtBzPFO56xvQ+q2UDoYX568ECi9fEvcviqiXC3iYE46ZhFofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589727; c=relaxed/simple;
	bh=YqDPPNmnRgdeYP7gXuCwYyR5JwTOwXOhXbJzKWXIfb0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8OFjtbV47BeMl4KqKdfDVpOseO2Jy5WTAYePDspyozqffw9QntrXxGDmgClY4yaZEPTReN8IRWwqP+/p8ETQjkrFpk6sTzG0MwVQlnOb1z0YwVqLvUt8rsK8G0pbGIzkuyntArikQHHv/O5cjKlN//+bXow0PKJNJPNxRfHChI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRsZI8Qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRsZI8Qs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E3C0D1F000FF;
	Fri,  9 Oct 2026 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589726;
	bh=SP9VZVCc6oxZox56dWFJY8slUbUOJtsWY/w18uDWij8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=TRsZI8Qs/FzvS7mrZpz7k5scLBvE+SgWmRgIjGHsVQTrM8kwXKAGeU2HU69PfUlxy
	 ildIqMYpvOdnbXHEDKtaEzkYsILbX692yR1qLA7mYe3zUUkQsH9NW2+eNiiZe+n2yn
	 YRyHqjFoUGAluMtMY62DlcDJGd8bkCYnguHZ5WEqYcuyxtgo4O8RrJSLP+mNN7Z8yd
	 fUuaEowH2KJnKworL3oIclmeUFBUtq1ltN60oSkBxbRxHrmShP7FPLa4SOfkNlPIOm
	 Ob6HAMYu6+7ftC+S7uqlr5uYJQEDGCU9VV1go4biOIBA9JQy7vtdRLnI5LqTVxRQRH
	 MRxNDbIln4HgQ==
Date: Fri, 09 Oct 2026 16:48:45 -0700
Subject: [PATCH 12/26] xfs: initialise error in xfs_defer_finish_one()
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, floss@jetm.me, linux-xfs@vger.kernel.org
Message-ID: <179158947586.3719791.10727146725354625862.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Javier Tia <javier@peridio.com>

Source kernel commit: 6176d21d7bd609632c5b7e87a3adb9be29ec1e72

xfs_defer_finish_one() declares error without an initialiser and only
assigns it inside the loop over dfp->dfp_work.  When that list is empty
the loop body never runs, control falls through to the "Done with the
dfp, free it" path, and the function returns an indeterminate value.

An item-less pending item reaches this through xfs_defer_add_barrier(),
which xfs_reap_ag_blocks() uses on any CONFIG_XFS_ONLINE_REPAIR kernel.
xfs_defer_finish_noroll() treats any non-EAGAIN return as fatal, so a
non-zero stack value turns a successful barrier into a
SHUTDOWN_CORRUPT_INCORE in the middle of a repair.  Zero is the correct
result: reaching the free path means the item loop drained without a
non-zero error.

Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index eae2397fbff86a..d6e3e05f7a4960 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -576,7 +576,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 

