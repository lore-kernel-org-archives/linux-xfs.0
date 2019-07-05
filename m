Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54004 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfGENO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 09:14:57 -0400
Date: Fri, 5 Jul 2019 14:14:46 +0100
From: Sheriff Esseson <sheriffesseson@gmail.com>
Subject: [Linux-kernel-mentees] [PATCH] Doc : fs : move xfs.txt to admin-guide
Message-ID: <20190705131446.GA10045@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: skhan@linuxfoundation.org
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linuxfoundation.org

As suggested by Matthew Wilcox, xfs.txt is primarily a guide on available
options when setting up an XFS. This makes it appropriate to be placed under
the admin-guide tree.

Thus, move xfs.txt to admin-guide and fix broken references.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---

The reference to xfs.txt from dax.txt in itself is not looking good. Maybe, we
need something more inspirational.

 Documentation/{filesystems => admin-guide}/xfs.txt | 0
 Documentation/filesystems/dax.txt                  | 2 +-
 MAINTAINERS                                        | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename Documentation/{filesystems => admin-guide}/xfs.txt (100%)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/admin-guide/xfs.txt
similarity index 100%
rename from Documentation/filesystems/xfs.txt
rename to Documentation/admin-guide/xfs.txt
diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index 6d2c0d340..b2b19738b 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -76,7 +76,7 @@ exposure of uninitialized data through mmap.
 These filesystems may be used for inspiration:
 - ext2: see Documentation/filesystems/ext2.txt
 - ext4: see Documentation/filesystems/ext4/
-- xfs:  see Documentation/filesystems/xfs.txt
+- xfs:  see Documentation/admin-guide/xfs.txt


 Handling Media Errors
diff --git a/MAINTAINERS b/MAINTAINERS
index 01a52fc96..fc309b0a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17374,7 +17374,7 @@ L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
-F:	Documentation/filesystems/xfs.txt
+F:	Documentation/admin-guide/xfs.txt
 F:	fs/xfs/

 XILINX AXI ETHERNET DRIVER
--
_______________________________________________
Linux-kernel-mentees mailing list
Linux-kernel-mentees@lists.linuxfoundation.org
https://lists.linuxfoundation.org/mailman/listinfo/linux-kernel-mentees

2.22.0
