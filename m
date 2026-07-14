Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653AB281525;
	Tue, 14 Jul 2026 06:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009205; cv=none; b=a9OEevlc03S52AovFPiYnJFDwSWUeY0dq6dmgidE/uKvAXPb+5EivMc72SECdcxIg+xm7AVA5q/DF4a/nDns8X7XRGLUNS71FdcqZf3MWzjSWpO3wvQ2dWIjS1MwW2ThOY+E7WJBf4GBh+/74d7vRAU125yUcgauPQ+k0VEnT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009205; c=relaxed/simple;
	bh=mMSizUDdDh49qgN19O4lGnxQDs+Svxlnjs/J+E+D8yo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAAjIaMB8VSryVDh/lUdiP4wpSgOcc5iIaekgDXr83coKdmhIKSBAk1GxMbPGtmJf/AkMiLFAxSzks/nJq+P/n55OKTk0HhKu9I5SHjmkkLYrjm5qpqSjdMGJ3bpp0OOmLoLCIppHGiEgC1VJGzlMaOpQQ1hm2MYfK9sgrN5AH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+eR6uAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+eR6uAl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A9F01F00A3A;
	Tue, 14 Jul 2026 06:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009204;
	bh=Xj+m5BMXjgPbuT93x0vCBh/G/2emdAhqdtWkqjNTtBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=N+eR6uAl8rTMNUZ786Uo58raJC7yusOWHCXEV33bVBXDPg3NIOAKJFLlfOeYak3vl
	 zwCE+gJytauTIMnt7oevyGb7zK+veFvlZcRK9DfG6rMyCYXm9q9fizWaLBp41JTGUL
	 8Wq67gq9NXhkHlBrKDyDqVqP9pL5jkYPgdX9n1x9MoMs8v4YDMOzSsXE4jxwtULBhR
	 Yi0L3iDIeIhd4nPo9dMXgrEnakGDElVErwIPhHg5CruQNq18qYxLZDcU5AF+RHGd/D
	 lQJ7ZK0Sg01DfGTuOCDl3TxEZ6BPadMvWaUqlSsS84rR5GC0c4B/YR4SM3KN6Si2wx
	 f/ycfvLM+ngZQ==
Date: Mon, 13 Jul 2026 23:06:43 -0700
Subject: [PATCH 3/6] xfs: handle non-inode owners for rtrmap record checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716881.268162.6869252550857617012.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that two helper functions in the rtrmapbt scrub code don't
actually handle non-inode owners correctly -- CoW staging extents and
rgsuperblock extents are not shareable, but they are mergeable.  Fix
these two helpers.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 2d9a3e98053e8c ("xfs: allow overlapping rtrmapbt records for shared data extents")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtrmap.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index b3b2cf17ba2c08..564d19a97a2f8f 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -87,6 +87,9 @@ xchk_rtrmapbt_is_shareable(
 		return false;
 	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
 		return false;
+	if (irec->rm_owner == XFS_RMAP_OWN_COW ||
+	    irec->rm_owner == XFS_RMAP_OWN_FS)
+		return false;
 	return true;
 }
 
@@ -146,6 +149,9 @@ xchk_rtrmap_mergeable(
 		return false;
 	if (r1->rm_flags != r2->rm_flags)
 		return false;
+	if (r1->rm_owner == XFS_RMAP_OWN_COW ||
+	    r1->rm_owner == XFS_RMAP_OWN_FS)
+		return true;
 	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
 }
 

