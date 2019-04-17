Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39625 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728486AbfDQB11 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:27:27 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 1/4] fs/iomap: Introduce src_addr for COW in fsdax mode.
Date: Wed, 17 Apr 2019 09:27:12 +0800
Message-ID: <20190417012715.8287-2-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org

When using reflink, coping the source blocks before writing data
into new allocated blocks is required.  In fsdax mode, we need a source
blocks' start address to handle the COW operation.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 include/linux/iomap.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0fefb5455bda..3b3aec2311c5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -61,6 +61,10 @@ struct iomap {
 	u16			flags;	/* flags for mapping */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
+	u64			src_addr; /* disk offset of mapping, bytes,
+					   * the source blocks' start address
+					   * for cow in dax
+					   */
 	void			*inline_data;
 	void			*private; /* filesystem private */
 
-- 
2.17.0
