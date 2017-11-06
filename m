Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFOfJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:09 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUW-00023N-W7
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] xfs: mark xfs_errortag_ktype static
Date: Mon,  6 Nov 2017 15:34:51 +0100
Message-Id: <20171106143456.13567-4-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 92396d5eb259..4c9f35d983b2 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -203,7 +203,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	NULL,
 };
 
-struct kobj_type xfs_errortag_ktype = {
+static struct kobj_type xfs_errortag_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_errortag_sysfs_ops,
 	.default_attrs = xfs_errortag_attrs,
-- 
2.14.2

