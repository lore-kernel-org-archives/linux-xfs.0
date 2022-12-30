Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABADC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiLaBxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLaBxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08DA1DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB42B81DFC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16660C433D2;
        Sat, 31 Dec 2022 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451609;
        bh=G7M0GPo2QMSQtwDDmJ22pseEXMJxV4Gxuw4AtltWmno=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cCajrsjpbg4Hrrr75DnKii6PRDilqvLBlf1DEln47ffEcVQ1eJxfbb+IJ7Spike3g
         CKPckWrmHRCwYu5WgD7aUiM027V8W3nb8C1OPCvKImQMvwIEQfv9FseGH0HCFFMmQu
         0tm051tnB62XLqcqIEazVKBwhhkq1bjJYLZduGAlpHhyVy7iQz2+9yFo0DFySZROaP
         /rlKCw9Wtn2s3/wNQY2tlMrRATKPwa8pl5POCt9gInvnP8El7w+55p92IQi+vaP4gH
         ldn+N4pbDyuZsAvc4ikKWCrcHlKB7BVb70TX1gyDbPfh6PfXr6VUYYvUW80ztoxBDj
         82sqMEDownM4w==
Subject: [PATCH 21/42] xfs: allow inodes to have the realtime and reflink
 flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871194.717073.18192234817486773032.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we can share blocks between realtime files, allow this
combination.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    3 ++-
 fs/xfs/scrub/inode.c          |    5 +++--
 fs/xfs/scrub/inode_repair.c   |    6 ------
 fs/xfs/xfs_ioctl.c            |    4 ----
 4 files changed, 5 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dcf816f2643b..0db719f80bf2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -675,7 +675,8 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* don't let reflink and realtime mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
 	/* COW extent size hint validation */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index f2c60c3515e7..3b19976b6066 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -329,8 +329,9 @@ xchk_inode_flags2(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && !S_ISREG(mode))
 		goto bad;
 
-	/* realtime and reflink make no sense, currently */
-	if ((flags & XFS_DIFLAG_REALTIME) && (flags2 & XFS_DIFLAG2_REFLINK))
+	/* realtime and reflink don't always go together */
+	if ((flags & XFS_DIFLAG_REALTIME) && (flags2 & XFS_DIFLAG2_REFLINK) &&
+	    !xfs_has_rtreflink(mp))
 		goto bad;
 
 	/* no bigtime iflag without the bigtime feature */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8566282827f8..9f946406cfa0 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -391,8 +391,6 @@ xrep_dinode_flags(
 		flags2 |= XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
-	if (flags & XFS_DIFLAG_REALTIME)
-		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (flags2 & XFS_DIFLAG2_REFLINK)
 		flags2 &= ~XFS_DIFLAG2_DAX;
 	if (!xfs_has_bigtime(mp))
@@ -1480,10 +1478,6 @@ xrep_inode_flags(
 	if (!(S_ISREG(mode) || S_ISDIR(mode)))
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
 
-	/* No reflink files on the realtime device. */
-	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME)
-		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
-
 	/* No mixing reflink and DAX yet. */
 	if (sc->ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fbe9bc50fc20..939cc6d862da 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1115,10 +1115,6 @@ xfs_ioctl_setattr_xflags(
 			return -EINVAL;
 	}
 
-	/* Clear reflink if we are actually able to set the rt flag. */
-	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
-
 	/* diflags2 only valid for v3 inodes. */
 	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
 	if (i_flags2 && !xfs_has_v3inodes(mp))

