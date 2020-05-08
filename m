Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE558C54E95
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C08207DD
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VOIOsqke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEHGei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEHGeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BF3C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4ZUv5VxvQDElTAMHHDPpHqu0vRm4XMDNViOS1Tw7zdk=; b=VOIOsqkehBwIIuit5KkxLM12UO
        pLOlXxQhWWj3QHcDJzKq3j3LM5a5MzxqyDixTpQekxIN/qutdDmVdZXx8NrHVA3GdSpXnX78HFKiR
        CKkWoKH27+ifUjXDzvwlfMznLFU/WlBrkF4+d+GOMjgWo5rFM3Pz3dzbXtXmgq3s1bRgGb+UUXLGE
        hZrOwxo+yww13nmO+K8W3WG87TtouxrcVkWEMWpStxVw/WzJXhX6bvFDErbIyzPZUgWRVNf4r8P9n
        lIoztHpsRZd9QMJJ/dq6cBwVxIkaAPa2aNjn9ImAoDAcK2bN+to7IAtyLitds2ZcRycggyq6K8sw9
        VIKcFljA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwaj-0002uj-6p; Fri, 08 May 2020 06:34:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 05/12] xfs: call xfs_dinode_verify from xfs_inode_from_disk
Date:   Fri,  8 May 2020 08:34:16 +0200
Message-Id: <20200508063423.482370-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Keep the code dealing with the dinode together, and also ensure we verify
the dinode in the owner change log recovery case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 .../xfs-self-describing-metadata.txt           | 10 +++++-----
 fs/xfs/libxfs/xfs_inode_buf.c                  | 18 ++++++++----------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.txt
index 8db0121d0980c..e912699d74301 100644
--- a/Documentation/filesystems/xfs-self-describing-metadata.txt
+++ b/Documentation/filesystems/xfs-self-describing-metadata.txt
@@ -337,11 +337,11 @@ buffer.
 
 The structure of the verifiers and the identifiers checks is very similar to the
 buffer code described above. The only difference is where they are called. For
-example, inode read verification is done in xfs_iread() when the inode is first
-read out of the buffer and the struct xfs_inode is instantiated. The inode is
-already extensively verified during writeback in xfs_iflush_int, so the only
-addition here is to add the LSN and CRC to the inode as it is copied back into
-the buffer.
+example, inode read verification is done in xfs_inode_from_disk() when the inode
+is first read out of the buffer and the struct xfs_inode is instantiated. The
+inode is already extensively verified during writeback in xfs_iflush_int, so the
+only addition here is to add the LSN and CRC to the inode as it is copied back
+into the buffer.
 
 XXX: inode unlinked list modification doesn't recalculate the inode CRC! None of
 the unlinked list modifications check or update CRCs, neither during unlink nor
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 686a026b5f6ed..3aac22e892985 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -188,10 +188,18 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 	int			error;
+	xfs_failaddr_t		fa;
 
 	ASSERT(ip->i_cowfp == NULL);
 	ASSERT(ip->i_afp == NULL);
 
+	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", from,
+				sizeof(*from), fa);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * First get the permanent information that is needed to allocate an
 	 * inode. If the inode is unused, mode is zero and we shouldn't mess
@@ -627,7 +635,6 @@ xfs_iread(
 {
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
-	xfs_failaddr_t	fa;
 	int		error;
 
 	/*
@@ -652,15 +659,6 @@ xfs_iread(
 	if (error)
 		return error;
 
-	/* even unallocated inodes are verified */
-	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
-	if (fa) {
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
-				sizeof(*dip), fa);
-		error = -EFSCORRUPTED;
-		goto out_brelse;
-	}
-
 	error = xfs_inode_from_disk(ip, dip);
 	if (error)
 		goto out_brelse;
-- 
2.26.2

