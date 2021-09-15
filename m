Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8707EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E8160E94
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhIOXNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXNL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC21360E05;
        Wed, 15 Sep 2021 23:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747511;
        bh=aDCBUANc59DglqczAyjRdQYVOJF/QgLCE3xx3XlXPdU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L6aQntJlCXO+65cwj+xLmlHX5Fd71kkDGwicf9kWqf+xaqqZKeqI20y2qIPWtOh8G
         2si8TskiodRrx4UhQ9jAJdTKjdrK2EUw7KPPpWHDO2VT+JevUUSPWwgo3GGmwCMhSa
         yZeWYHIg65YwOiWQ9IhEuPQrTZnOXTsomyU2LFv8HsqQU0CWPgI2rVbY8waCRxTUVC
         QPoeLhRVh2betvVKOebtSl7rwJ5URLIFd9NU551zxe69pZ5F6iisqm43hQil/lrQ3q
         l3nTgF06AMTqK6z58VfUfyh07ASpxW8QqeY/Fm6VG8typM1PxcSbB3tdMTnrLPTEXz
         r70DFnLG7x1jA==
Subject: [PATCH 58/61] xfs: correct the narrative around misaligned
 rtinherit/extszinherit dirs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:51 -0700
Message-ID: <163174751141.350433.4536993190877447854.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 83193e5ebb0164d612aa620ceab7d3746e80e2a4

While auditing the realtime growfs code, I realized that the GROWFSRT
ioctl (and by extension xfs_growfs) has always allowed sysadmins to
change the realtime extent size when adding a realtime section to the
filesystem.  Since we also have always allowed sysadmins to set
RTINHERIT and EXTSZINHERIT on directories even if there is no realtime
device, this invalidates the premise laid out in the comments added in

In other words, this is not a case of inadequate metadata validation.
This is a case of nearly forgotten (and apparently untested) but
supported functionality.  Update the comments to reflect what we've
learned, and remove the log message about correcting the misalignment.

Fixes: 603f000b15f2 ("xfs: validate extsz hints against rt extent size when rtinherit is set")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c   |   28 ++++++++++++++++------------
 libxfs/xfs_trans_inode.c |   10 ++++------
 2 files changed, 20 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 70caf6e7..f98f5c47 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -589,23 +589,27 @@ xfs_inode_validate_extsize(
 	/*
 	 * This comment describes a historic gap in this verifier function.
 	 *
-	 * On older kernels, the extent size hint verifier doesn't check that
-	 * the extent size hint is an integer multiple of the realtime extent
-	 * size on a directory with both RTINHERIT and EXTSZINHERIT flags set.
-	 * The verifier has always enforced the alignment rule for regular
-	 * files with the REALTIME flag set.
+	 * For a directory with both RTINHERIT and EXTSZINHERIT flags set, this
+	 * function has never checked that the extent size hint is an integer
+	 * multiple of the realtime extent size.  Since we allow users to set
+	 * this combination  on non-rt filesystems /and/ to change the rt
+	 * extent size when adding a rt device to a filesystem, the net effect
+	 * is that users can configure a filesystem anticipating one rt
+	 * geometry and change their minds later.  Directories do not use the
+	 * extent size hint, so this is harmless for them.
 	 *
 	 * If a directory with a misaligned extent size hint is allowed to
 	 * propagate that hint into a new regular realtime file, the result
 	 * is that the inode cluster buffer verifier will trigger a corruption
-	 * shutdown the next time it is run.
+	 * shutdown the next time it is run, because the verifier has always
+	 * enforced the alignment rule for regular files.
 	 *
-	 * Unfortunately, there could be filesystems with these misconfigured
-	 * directories in the wild, so we cannot add a check to this verifier
-	 * at this time because that will result a new source of directory
-	 * corruption errors when reading an existing filesystem.  Instead, we
-	 * permit the misconfiguration to pass through the verifiers so that
-	 * callers of this function can correct and mitigate externally.
+	 * Because we allow administrators to set a new rt extent size when
+	 * adding a rt section, we cannot add a check to this verifier because
+	 * that will result a new source of directory corruption errors when
+	 * reading an existing filesystem.  Instead, we rely on callers to
+	 * decide when alignment checks are appropriate, and fix things up as
+	 * needed.
 	 */
 
 	if (rt_flag)
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index c2e98200..06d11a5c 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -140,16 +140,14 @@ xfs_trans_log_inode(
 	}
 
 	/*
-	 * Inode verifiers on older kernels don't check that the extent size
-	 * hint is an integer multiple of the rt extent size on a directory
-	 * with both rtinherit and extszinherit flags set.  If we're logging a
-	 * directory that is misconfigured in this way, clear the hint.
+	 * Inode verifiers do not check that the extent size hint is an integer
+	 * multiple of the rt extent size on a directory with both rtinherit
+	 * and extszinherit flags set.  If we're logging a directory that is
+	 * misconfigured in this way, clear the hint.
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
 	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
-		xfs_info_once(ip->i_mount,
-	"Correcting misaligned extent size hint in inode 0x%llx.", ip->i_ino);
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;

