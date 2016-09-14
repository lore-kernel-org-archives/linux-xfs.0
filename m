Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15072 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755275AbcINWvH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 18:51:07 -0400
Date: Wed, 14 Sep 2016 16:51:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 12/12] ext2: use iomap to implement DAX
Message-ID: <20160914225105.GB29323@linux.intel.com>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-13-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473847291-18913-13-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, ross.zwisler@linux.intel.com

On Wed, Sep 14, 2016 at 12:01:31PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Now that ext2 is using IOMAP, we need to select FS_IOMAP when EXT2_FS is
selected else we get a build error:

fs/built-in.o: In function `ext2_dax_fault':
/home/rzwisler/project/review/fs/ext2/file.c:112: undefined reference to `iomap_dax_fault'
fs/built-in.o: In function `ext2_dax_write_iter':
/home/rzwisler/project/review/fs/ext2/file.c:75: undefined reference to `iomap_dax_rw'
fs/built-in.o: In function `ext2_dax_read_iter':
/home/rzwisler/project/review/fs/ext2/file.c:45: undefined reference to `iomap_dax_rw'
Makefile:949: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1

With the following patch squashed into this commit:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

---
>From 9c084641049990339b40bfd52a0aebf300d896ea Mon Sep 17 00:00:00 2001
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Wed, 14 Sep 2016 16:48:36 -0600
Subject: [PATCH] ext2: build in FS_IOMAP support needed by ext2

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/Kconfig b/fs/ext2/Kconfig
index c634874e..3391f48 100644
--- a/fs/ext2/Kconfig
+++ b/fs/ext2/Kconfig
@@ -1,5 +1,6 @@
 config EXT2_FS
 	tristate "Second extended fs support"
+	select FS_IOMAP
 	help
 	  Ext2 is a standard Linux file system for hard disks.
 
-- 
2.9.0

