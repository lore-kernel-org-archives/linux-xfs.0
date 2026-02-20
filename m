Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7972AD2C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 01:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549294; cv=none; b=sVFPpwg3hpwfhJ5+XXodlKIPPPEMMOQKL8TTvACOu/CRvQOM3R9QoX7j6bssVJGNOUc+CQE7baWvRay0Hr9/vjj7vZwQiHMbvCktfrem2pbCn4C1GzpO+64Y4UNbmoIlienlTDgKbyLabTOGLt/j60vlzy3tKg8HKGvnjhQppVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549294; c=relaxed/simple;
	bh=Mk2t5yGxAxnJZsXxzqOaIE+HmQfb33pS4WMTPye26ZA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKOvZ1elh0iHyZ+1ktQs4LguLfAPE1qEOrezsG8B7hbHkYvDtZvEHM5IrESqA+ut0Jab5V1xwt1+fvnr8Nsq3x9qXXKPhEV2ZaWk/IKvrVypajiedhFX9Yr5OXJv7rQfqwc9L81C9bhfAzTvYEFn6x2z7ajnecldF0eCRUKcpGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiCvEIVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiCvEIVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FD2C4CEF7;
	Fri, 20 Feb 2026 01:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549294;
	bh=Mk2t5yGxAxnJZsXxzqOaIE+HmQfb33pS4WMTPye26ZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QiCvEIVnXn9MQUTqV5YT2QRoEk5oyw1Z8hx0wybr+PLnuWUMhVPBydmXqDLo7VlMX
	 tBZ4fkrTglb1G7AQeCShP4osZmrUItzCxas06CQ2UCO5gbh+1rQFv6Tf+STrRpAP65
	 g5iYwMOvsM06dqu3lkeZMqtyWr+JSQRSHT0UWdXxSAnOPeZWeb9YYjsRIXI8WwkKix
	 A2uXZCHoofnBjqlDLIvtEnWmpxJlufI/ILz5uIGG9FQkhC0QNruhf2QUcjaldwjvvE
	 nTmvM1yYE2PXGd/EUpp+ivn0CZZ8HwxN3ntt0uYJKjnGIf7cZKejy5GBF17AmA401t
	 nMkXE6GDcfnfw==
Date: Thu, 19 Feb 2026 17:01:33 -0800
Subject: [PATCH 6/6] xfs: don't report half-built inodes to fserror
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, samsun1006219@gmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <177154903791.1351708.4543112738693282340.stgit@frogsfrogsfrogs>
In-Reply-To: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
References: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Sam Sun apparently found a syzbot way to fuzz a filesystem such that
xfs_iget_cache_miss would free the inode before the fserror code could
catch up.  Frustratingly he doesn't use the syzbot dashboard so there's
no C reproducer and not even a full error report, so I'm guessing that:

Inodes that are being constructed or torn down inside XFS are not
visible to the VFS.  They should never be reported to fserror.
Also, any inode that has been freshly allocated in _cache_miss should be
marked INEW immediately because, well, it's an incompletely constructed
inode that isn't yet visible to the VFS.

Reported-by: Sam Sun <samsun1006219@gmail.com>
Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_health.c |    8 ++++++--
 fs/xfs/xfs_icache.c |    9 ++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 6475159eb9302c..239b843e83d42a 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -316,8 +316,12 @@ xfs_rgno_mark_sick(
 
 static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
 {
-	/* Report metadata inodes as general filesystem corruption */
-	if (xfs_is_internal_inode(ip)) {
+	/*
+	 * Do not report inodes being constructed or freed, or metadata inodes,
+	 * to fsnotify.
+	 */
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIM) ||
+	    xfs_is_internal_inode(ip)) {
 		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
 				GFP_NOFS);
 		return;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dbaab4ae709f9c..f13e55b75d66c4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -636,6 +636,14 @@ xfs_iget_cache_miss(
 	if (!ip)
 		return -ENOMEM;
 
+	/*
+	 * Set XFS_INEW as early as possible so that the health code won't pass
+	 * the inode to the fserror code if the ondisk inode cannot be loaded.
+	 * We're going to free the xfs_inode immediately if that happens, which
+	 * would lead to UAF problems.
+	 */
+	xfs_iflags_set(ip, XFS_INEW);
+
 	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
 	if (error)
 		goto out_destroy;
@@ -713,7 +721,6 @@ xfs_iget_cache_miss(
 	ip->i_udquot = NULL;
 	ip->i_gdquot = NULL;
 	ip->i_pdquot = NULL;
-	xfs_iflags_set(ip, XFS_INEW);
 
 	/* insert the new inode */
 	spin_lock(&pag->pag_ici_lock);

