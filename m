Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A84CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 19:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbiEXTuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 15:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241024AbiEXTuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 15:50:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CB779391
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 12:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55914B81B9A
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 19:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C382C34100;
        Tue, 24 May 2022 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653421808;
        bh=bcJ77HFb+92D2bKQBAuYNSecE2qLqDAwEO+V3iW0Ebg=;
        h=Date:From:To:Cc:Subject:From;
        b=PUhDVuRpch89CB17XhFxsPKrEcGuhfjR3KNO63kssaecDqxpyO0iEeb+DDjYYSaBX
         mfppgpJZnLwr5olatCzrP1fAJeepSxmF6X+XE3BksLs8jxt8sf4/QzIhL2PsyUNizD
         LTcVIJuyE8FvDQRf4oXa4YwglpZU0CgjSjgFfVqIwFdMy50qtxEGmkRi0TeP2z2q3f
         iFl5E9fF2OxzqtUymNK7JwNmUTqHid0RVr2doi5NlYdUY3/bwjFhrJg8Ys5IulnSko
         uw2wW2LbseHXSmY0IWhy4Xy++T/buHJp6MVgNwB7ZzXmX/mILrbfH2Bd6xDQToMU7X
         tLDrC20pJCr2w==
Date:   Tue, 24 May 2022 12:50:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_copy: don't use cached buffer reads until after
 libxfs_mount
Message-ID: <Yo027/k+vAYsUt4U@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I accidentally tried to xfs_copy an ext4 filesystem, but instead of
rejecting the filesystem, the program instead crashed.  I figured out
that zeroing the superblock was enough to trigger this:

# dd if=/dev/zero of=/dev/sda bs=1024k count=1
# xfs_copy  /dev/sda /dev/sdb
Floating point exception

The exact crash happens in this line from libxfs_getbuf_flags, which is
called from the main() routine of xfs_copy:

	if (btp == btp->bt_mount->m_ddev_targp) {
		(*bpp)->b_pag = xfs_perag_get(btp->bt_mount,
				xfs_daddr_to_agno(btp->bt_mount, blkno));

The problem here is that the uncached read filled the incore superblock
with zeroes, which means mbuf.sb_agblocks is zero.  This causes a
division by zero in xfs_daddr_to_agno, thereby crashing the program.

In commit f8b581d6, we made it so that xfs_buf structures contain a
passive reference to the associated perag structure.  That commit
assumes that no program would try a cached buffer read until the buffer
cache is fully set up, which is true throughout xfsprogs... except for
the beginning of xfs_copy.  For whatever reason, it attempts an uncached
read of the superblock to figure out the real superblock size, then
performs a *cached* read with the proper buffer length and verifier.
The cached read crashes the program.

Fix the problem by changing the (second) cached read into an uncached read.

Fixes: f8b581d6 ("libxfs: actually make buffers track the per-ag structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 copy/xfs_copy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 41f594bd..79f65946 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -748,7 +748,7 @@ main(int argc, char **argv)
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
 
-	error = -libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
+	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			1 << (sb->sb_sectlog - BBSHIFT), 0, &sbp,
 			&xfs_sb_buf_ops);
 	if (error) {
