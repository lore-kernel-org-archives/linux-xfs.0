Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FC5C47098
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 01:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F203610E7
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 01:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFDBU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:20:59 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12829 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230053AbhFDBUz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 21:20:55 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AJRAGG6qYgVw+29Uknxze6CEaV5pOeYIsimQD?=
 =?us-ascii?q?101hICG9E/b5qynAppkmPHPP4gr5O0tApTnjAsa9qBrnnPYf3WB4B8bAYOCMgg?=
 =?us-ascii?q?eVxe9Zg7ff/w=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; 
   d="scan'208";a="109209807"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 04 Jun 2021 09:19:06 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 77CCF4C369E0;
        Fri,  4 Jun 2021 09:19:06 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 4 Jun 2021 09:18:55 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 4 Jun 2021 09:18:55 +0800
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
CC:     <darrick.wong@oracle.com>, <dan.j.williams@intel.com>,
        <david@fromorbit.com>, <hch@lst.de>, <agk@redhat.com>,
        <snitzer@redhat.com>, <rgoldwyn@suse.de>
Subject: [PATCH v4 06/10] fs/dax: Implement dax_holder_operations
Date:   Fri, 4 Jun 2021 09:18:40 +0800
Message-ID: <20210604011844.1756145-7-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 77CCF4C369E0.A2269
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is the case where the holder represents a filesystem.  The offset
translation from disk to block device is needed before we calling
->corrupted_range().

When a specific filesystem is being mounted, we use dax_set_holder() to
associate it with the dax_device.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c            | 16 ++++++++++++++++
 include/linux/dax.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 58faca85455a..1a7473f46df2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1762,3 +1762,19 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
+
+static int fs_dax_corrupted_range(struct dax_device *dax_dev,
+		struct block_device *bdev, loff_t offset, size_t size,
+		void *data)
+{
+	struct super_block *sb = dax_get_holder(dax_dev);
+	loff_t bdev_off = offset - (get_start_sect(bdev) << SECTOR_SHIFT);
+
+	if (!sb->s_op->corrupted_range)
+		return -EOPNOTSUPP;
+	return sb->s_op->corrupted_range(sb, bdev, bdev_off, size, data);
+}
+
+const struct dax_holder_operations fs_dax_holder_ops = {
+	.corrupted_range = fs_dax_corrupted_range,
+};
\ No newline at end of file
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 6e758daa5004..b35b3b8959a5 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -254,6 +254,8 @@ static inline bool dax_mapping(struct address_space *mapping)
 	return mapping->host && IS_DAX(mapping->host);
 }
 
+extern const struct dax_holder_operations fs_dax_holder_ops;
+
 #ifdef CONFIG_DEV_DAX_HMEM_DEVICES
 void hmem_register_device(int target_nid, struct resource *r);
 #else
-- 
2.31.1



