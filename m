Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D61C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBPUlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:41:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C910DCC0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C69B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B08C433EF;
        Thu, 16 Feb 2023 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580060;
        bh=O45aUgjcyJvR8ANe/boWduJFWooMpjvMJgNEDJaeDr4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=t/ZecVV2cYsOTo8EVVU9RMWh/x6vO1iXK7fmOnAabO8S6/mI2RB3nCX9PSnQ91VTH
         v4eGUKvbhuufSGgRh34u0NSYlJ3lltAW7+Tk5+dsqJJrSUEmrRHmWE4C7bcvhiZ8SY
         8/NB2is8O5tJxy/dR+Ta69YrQwSgB52KOVJLc/L/VFh8P9IJrhhZKa+Q+gYMEk1PnH
         3A2ezCRJFbR3t2wFI7yhLuu9H7T4U4tPjn+uvkXM2QQOSOjvq0Dy/fd3iuBWQ05Ope
         JPuSzKgMWFlwOYJh7hbyC3gfmqCLmZVBp24cDVLTIcAEUqDUm48hD6FzRbLZsyIFbC
         dV/IbxEF1EWWg==
Date:   Thu, 16 Feb 2023 12:40:59 -0800
Subject: [PATCH 1/4] xfs: fix multiple problems when doing getparents by
 handle
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873450.3474196.13907588460831548393.stgit@magnolia>
In-Reply-To: <167657873432.3474196.15004300376430244372.stgit@magnolia>
References: <167657873432.3474196.15004300376430244372.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few problems in the file handle processing part of GETPARENTS.
First, we need to validate that the fsid of the handle matches the
filesystem that we're talking to.  Second, we can skip the iget if the
inode number matches the open file.  Third, if we are going to do the
iget file, we need to use an UNTRUSTED lookup to guard against crap.
Finally, we mustn't leak any inodes that we iget.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index df5a45b97f8f..a1929b08c539 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1694,8 +1694,9 @@ xfs_ioc_get_parent_pointer(
 {
 	struct xfs_pptr_info		*ppi = NULL;
 	int				error = 0;
-	struct xfs_inode		*ip = XFS_I(file_inode(filp));
-	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_inode		*file_ip = XFS_I(file_inode(filp));
+	struct xfs_inode		*call_ip = file_ip;
+	struct xfs_mount		*mp = file_ip->i_mount;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1733,23 +1734,32 @@ xfs_ioc_get_parent_pointer(
 		return -ENOMEM;
 
 	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
-		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
-				0, 0, &ip);
-		if (error)
+		struct xfs_handle	*hanp = &ppi->pi_handle;
+
+		if (memcmp(&hanp->ha_fsid, mp->m_fixedfsid,
+							sizeof(xfs_fsid_t))) {
+			error = -EINVAL;
 			goto out;
+		}
 
-		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+		if (hanp->ha_fid.fid_ino != file_ip->i_ino) {
+			error = xfs_iget(mp, NULL, hanp->ha_fid.fid_ino,
+					XFS_IGET_UNTRUSTED, 0, &call_ip);
+			if (error)
+				goto out;
+		}
+
+		if (VFS_I(call_ip)->i_generation != hanp->ha_fid.fid_gen) {
 			error = -EINVAL;
 			goto out;
 		}
 	}
 
-	if (ip->i_ino == mp->m_sb.sb_rootino)
+	if (call_ip->i_ino == mp->m_sb.sb_rootino)
 		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
 
 	/* Get the parent pointers */
-	error = xfs_attr_get_parent_pointer(ip, ppi);
-
+	error = xfs_attr_get_parent_pointer(call_ip, ppi);
 	if (error)
 		goto out;
 
@@ -1762,6 +1772,8 @@ xfs_ioc_get_parent_pointer(
 	}
 
 out:
+	if (call_ip != file_ip)
+		xfs_irele(call_ip);
 	kmem_free(ppi);
 	return error;
 }

