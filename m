Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B069BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiF1Ut1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiF1UtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A7B3122F
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3C36182E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBA0C341C8;
        Tue, 28 Jun 2022 20:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449360;
        bh=MWwc6DtU/vlWBKcuJpzc/pdhU0t8ktXdhprzUjeumto=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qunlljznq+dAguRzYxecpIWOPWCC4JZ2JcTCYZ4ZYvjg+enU9vhuohAL1DgXrJT34
         KP9mkjHKlHoN5apkxO2wsvd5LjmYThASH1ogjjZAF3kgRhwn7PDZseyE9+r3mDk4dO
         umSkiIu43RcgiI+cAQKvpPJ6D9ygNcMijX66bnKSbk4RUQ3OUIzE17c8FZG5TucnS0
         nBNXI8y+IGEiUOr2ms6xlgc8QGviSA+aAGKoU4PXdtl2dT8G1kYbhtfATpO3W0DeRA
         Lvz36N0hhqhDlnM8Xnqzy7xRz5d4it+qCaHmq+A6nSYZ+KAzoq3WRGNHgsEOSPNv2K
         g1PRaHY4YX7kw==
Subject: [PATCH 1/6] xfs_copy: don't use cached buffer reads until after
 libxfs_mount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:20 -0700
Message-ID: <165644936019.1089996.1994101193208059510.stgit@magnolia>
In-Reply-To: <165644935451.1089996.13716062701488693755.stgit@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

