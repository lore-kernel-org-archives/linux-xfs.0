Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C098DC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9122720736
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jb8Mqhz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEGMTA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA57C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cT07FDu0/fqvgbQV1hedPfYacsCEBz9m1tQM4tC1CRs=; b=Jb8Mqhz2TkNwbS+Qhk2Vj/I9L7
        lgaJy0azRQoGnnFz3VpJsAjR5FFHqsR7j42pH6sjzmARfS3R9d/xoDqXAPca/eDoBXtnvqN+LNNS1
        Yp1+AWm0sduppNvzjcKA6PpUtCFD8yAMIcQLBG7eLLnze9qy2P+4S+t1gDn1EoyFlL/U8cEAlYWGS
        9w79K+tx/llcr27jRI1zmDqsYoZjKVCn7XlS59T7c9F4kYJMXWiHJ1ePXynzv6Y+7a7XdzjSeuKeh
        Suex9ZqjHkkuKPw3qon+b/57bM+mkHptUe+CVu6cko9RyshoxOXsR97Iu0Cvt5ZV+yDPJA1nHyn42
        oRqWP6Gg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUR-00053H-Ef; Thu, 07 May 2020 12:18:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/58] xfs: ensure that the inode uid/gid match values match the icdinode ones
Date:   Thu,  7 May 2020 14:17:55 +0200
Message-Id: <20200507121851.304002-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 3d8f2821502d0b60bac2789d0bea951fda61de0c

Instead of only synchronizing the uid/gid values in xfs_setup_inode,
ensure that they always match to prepare for removing the icdinode
fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h    | 5 +++++
 libxfs/xfs_inode_buf.c | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index e95a4959..5cb5a87b 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -34,6 +34,8 @@ struct xfs_dir_ops;
 struct inode {
 	mode_t		i_mode;
 	uint32_t	i_nlink;
+	uint32_t	i_uid;
+	uint32_t	i_gid;
 	xfs_dev_t	i_rdev;		/* This actually holds xfs_dev_t */
 	unsigned long	i_state;	/* Not actually used in userspace */
 	uint32_t	i_generation;
@@ -43,6 +45,9 @@ struct inode {
 	struct timespec	i_ctime;
 };
 
+#define xfs_uid_to_kuid(uid)	(uid)
+#define xfs_gid_to_kgid(gid)	(gid)
+
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index c0cb5676..a7d39f24 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -220,7 +220,9 @@ xfs_inode_from_disk(
 
 	to->di_format = from->di_format;
 	to->di_uid = be32_to_cpu(from->di_uid);
+	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
 	to->di_gid = be32_to_cpu(from->di_gid);
+	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
-- 
2.26.2

