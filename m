Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A446651AB
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389126; cv=none; b=nACKZuIoJLpsLGOc9BLJn90GEWI+1YGHwuEATQmThLZs5ieURrfU0P8+i0TyAQc00ISmmiuZ8D8izzSVweVt/nePVQEqRC8wjtXSEYQ4VzW9iPm9xLE+Zb7lcgzjhVgNA9XHTNVFMD9SAz2E0vGsrDEXxMozDcnh4TM4Zwhmgzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389126; c=relaxed/simple;
	bh=If4c9oRl2OsJo1VphCUEVVZT6rqN1YX70OQc6SG1wU4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lsfD6KDq1lMbOyR3ERYv82wfQCItT7km39irvOxMv1Y52NXrP3Z4Q+IgxxETylXvsM8EWWHTsag3goFCPFdvYT0ZF+5edaWxNAH5wu+U4Qzj1AlLp0Y2UbrKy6Nt/MadqYSwXuX7JKRd/E8r25nK2NzWRYaaYWuiKoemvf2ou+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyxo9CQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyxo9CQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6D3C072AA;
	Wed, 17 Apr 2024 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389126;
	bh=If4c9oRl2OsJo1VphCUEVVZT6rqN1YX70OQc6SG1wU4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pyxo9CQ2q0L/UegPaVtFuv15aVjzzE4GAI1RG1p7FGP0Hh/Pe+j02B95Nl8UztLLn
	 ozb+E2RKuL9df0gqimhg510lCjaeuyE+MYlexqquOJ3IZCc0zlRKlT0BIVbzij/6ff
	 Fj3RdTHofrHPoZcUzvSpl9SYkydL8OELD9eq/L1iOiAP3S4rGovbmgVZ5ipGjUbFXo
	 U7mNaMkmU+JOZeatSse2yMWnk0cK993KPlk2aLvZc32i1iPaKJejlJogcfGoA4nAzD
	 jwswM+y0sADQt3xkZm2L03Q6deoFzhnSq4PPKBXSA75qEuzq3bb0ghm7RCSlhGzRe/
	 Vgqug0HmVfZYA==
Date: Wed, 17 Apr 2024 14:25:25 -0700
Subject: [PATCH 14/67] xfs: elide ->create_done calls for unlogged deferred
 work
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842550.1853449.14439998355705416176.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 9c07bca793b4ff9f0b7871e2a928a1b28b8fa4e3

Extended attribute updates use the deferred work machinery to manage
state across a chain of smaller transactions.  All previous deferred
work users have employed log intent items and log done items to manage
restarting of interrupted operations, which means that ->create_intent
sets dfp_intent to a log intent item and ->create_done uses that item to
create a log intent done item.

However, xattrs have used the INCOMPLETE flag to deal with the lack of
recovery support for an interrupted transaction chain.  Log items are
optional if the xattr update caller didn't set XFS_DA_OP_LOGGED to
require a restartable sequence.

In other words, ->create_intent can return NULL to say that there's no
log intent item.  If that's the case, no log intent done item should be
created.  Clean up xfs_defer_create_done not to do this, so that the
->create_done functions don't have to check for non-null dfp_intent
themselves.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 29ec0bd81..722ff6a77 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -195,6 +195,10 @@ xfs_defer_create_done(
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
+	/* If there is no log intent item, there can be no log done item. */
+	if (!dfp->dfp_intent)
+		return;
+
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:

