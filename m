Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56881 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756500AbdLOWFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 17:05:22 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 20/78] xarray: Add MAINTAINERS entry
Date: Fri, 15 Dec 2017 14:03:52 -0800
Message-Id: <20171215220450.7899-21-willy@infradead.org>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82ad0eabce4f..bb5ffa12cf8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14894,6 +14894,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
 S:	Maintained
 F:	arch/x86/entry/vdso/
 
+XARRAY
+M:	Matthew Wilcox <mawilcox@microsoft.com>
+M:	Matthew Wilcox <willy@infradead.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	Documentation/core-api/xarray.rst
+F:	lib/idr.c
+F:	lib/xarray.c
+F:	include/linux/idr.h
+F:	include/linux/xarray.h
+F:	tools/testing/radix-tree
+
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.15.1

