Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8549DC34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 589DA20578
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qDCzyaCT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgBQNBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:01:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQNBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:01:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Tri66YUWLwebIk/MbG5877C5BbHNHUPJ/+HbO4cKfl8=; b=qDCzyaCT0rbOHkf6sICFJwpSHh
        xJlxa4fcL7u557VJGeYuKGkf6VD7F7E5Az4qT2OzQW9tU9hvsgQC/VQJ1Ts9XugqnZEmKhRhoK1Jv
        ZQUmCgC3WCbH8nOY75Aa8iTAVQ/o8T4rZB8FsbicghW4DvYbOPcPnTtRITNME3GhkhV9+WsJQ7fcV
        gath2DSmoiIEOPr0rLsm98L/I/Zd/+0p/q5CjhWTJOkl3Fl0y3DxOdkCPj3PJfnfAj+75JGdvGtY9
        bVObD4DvhFbJlPs0G+XJtBD9hbTv50rFdSx68bs8gDKabDKjNclLghugbFOR7Kubi1PFtOIwkOQ+v
        JuaQK1Hw==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g1L-0001yp-7q; Mon, 17 Feb 2020 13:01:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 23/31] xfs: properly type the buffer field in struct xfs_fsop_attrlist_handlereq
Date:   Mon, 17 Feb 2020 13:59:49 +0100
Message-Id: <20200217125957.263434-24-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The buffer field always points to a strut xfs_attrlist, so use the
proper type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ae77bcd8c05b..21920f613d42 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -597,7 +597,7 @@ typedef struct xfs_fsop_attrlist_handlereq {
 	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
 	__u32				flags;	/* which namespace to use */
 	__u32				buflen;	/* length of buffer supplied */
-	void				__user *buffer;	/* returned names */
+	struct xfs_attrlist __user	*buffer;/* returned names */
 } xfs_fsop_attrlist_handlereq_t;
 
 typedef struct xfs_attr_multiop {
-- 
2.24.1

