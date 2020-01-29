Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7289C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B088F2070E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZD7xEHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgA2RDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:03:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46552 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgA2RDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MvknjfPq4U3UBBgMUj4xh2scXK/t5P4q0wqJP9ZeWP0=; b=rZD7xEHdVWnotDb5UYfUQzuXwV
        3L+YzHpSP43TwRO0nLe7E8S7/12dZT9jYnV1QLQlIiJ/swpTHhF/bu8Zg36ChEkDGpFVo02VcWLIu
        oMFS6z4h3085bpL3SaRWmWGlxtr3+H4wC2tFWL0uO+J8WMLkIljXFqVj03FzjDBYFulNNpx5Hz6w8
        qG/pKqNf9wU4Tj5sqXDpHDa9/L5hls2SwiS9dI1oucEMjt3wheoEs5UG6JJNeJy7OqPoL0mfhQ4hZ
        dPqXXe+Db6Gb7LQNlvSYYevgcneLD14tIGiclfFiP+i39E7t109Ha6C7X3wHlqzbdNJU+rCMEECYn
        Jlz10vWg==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkE-0006qb-IR; Wed, 29 Jan 2020 17:03:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 01/30] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
Date:   Wed, 29 Jan 2020 18:02:40 +0100
Message-Id: <20200129170310.51370-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While the flags field in the ABI and the on-disk format allows for
multiple namespace flags, that is a logically invalid combination and
listing multiple namespace flags will return no results as no attr
can have both set.  Reject this case early with -EINVAL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 2 ++
 fs/xfs/xfs_ioctl32.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d42de92cb283..d974bf099d45 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -317,6 +317,8 @@ xfs_attrlist_by_handle(
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -EINVAL;
+	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 769581a79c58..9705172e5410 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -375,6 +375,8 @@ xfs_compat_attrlist_by_handle(
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -EINVAL;
+	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
-- 
2.24.1

