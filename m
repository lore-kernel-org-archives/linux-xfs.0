Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B40397F84
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 07:39:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4664EAC003
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 05:39:18 -0700 (PDT)
Received: from emea01-am1-obe.outbound.protection.outlook.com
	(mail-am1lp0014.outbound.protection.outlook.com
	[213.199.154.14]) by cuda.sgi.com with ESMTP id
	wNyyraUssyhvd5Vr (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 05:39:17 -0700 (PDT)
Message-ID: <51810CED.4080003@zynstra.com>
Date: Wed, 1 May 2013 13:39:09 +0100
From: James Dingwall <james.dingwall@zynstra.com>
MIME-Version: 1.0
Subject: Cleancache support in XFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html

$ grep -r cleancache fs/xfs
on the 3.9 kernel source suggests that no patch was submitted to enable 
cleancache for the XFS filesystem.  Since it was suggested that this 
could be a one liner I've had a go and my first effort is inline below.  
While this seems to compile OK I have no experience in filesystems so I 
would appreciate it if anyone can point out that it is obviously wrong 
and likely to eat my data before I try booting the kernel.

If it seems a reasonable attempt what would be the best way to check 
that it isn't doing nasty things?

Thanks,
James

--- xfs_super.c 2013-04-29 10:28:22.000000000 +0100
+++ xfs_super.cleancache.c      2013-05-01 13:22:44.367763564 +0100
@@ -61,6 +61,7 @@
  #include <linux/kthread.h>
  #include <linux/freezer.h>
  #include <linux/parser.h>
+#include <linux/cleancache.h>

  static const struct super_operations xfs_super_operations;
  static kmem_zone_t *xfs_ioend_zone;
@@ -1489,6 +1490,8 @@
                 goto out_unmount;
         }

+       cleancache_init_fs(sb);
+
         return 0;

   out_filestream_unmount:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
