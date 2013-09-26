Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A4ED57F61
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 06:47:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 681E3304032
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 04:47:25 -0700 (PDT)
Received: from mail.host2max.com (mail.host2max.com [72.29.91.110]) by
	cuda.sgi.com with ESMTP id cgWw47HsW0A9mp9Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 04:47:17 -0700 (PDT)
From: "Ronnie Tartar" <rtartar@host2max.com>
Subject: Issues and new to the group
Date: Thu, 26 Sep 2013 07:47:13 -0400
Message-ID: <0e4201cebaae$24873680$6d95a380$@host2max.com>
MIME-Version: 1.0
Content-Language: en-us
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi, 

I have a 600GB xfs file system mounted that suddenly started running slow on
writes.  It takes about 2.5 to 3.5 seconds to write a single file.  Some
folders (with less number of files) work well.  But it will copy fast, then
slow for long periods of time.  This is a virtualized CentOS 5.9 64 bit box
on Citrix Xenserver 5.6SP2.  Doesn't seem to be a load i/o issue as most of
the load is system%.  My fragmentation is less than 1 %.    Any help would
be greatly appreciated.  I was looking to see if there was a better way to
mount this partition or allocate more memory, whatever it takes.  The
folders are image folders that have anywhere between 5 to 10 million images
in each folder.

Thanks

Fstab mount is: 
/dev/xvdb1              /images xfs
defaults,nodiratime,nosuid,nodev,allocsize=64m 1 1

Slabtop is:
Active / Total Objects (% used)    : 2705947 / 2872142 (94.2%)
 Active / Total Slabs (% used)      : 290008 / 290008 (100.0%)
 Active / Total Caches (% used)     : 111 / 165 (67.3%)
 Active / Total Size (% used)       : 1048796.52K / 1083850.55K (96.8%)
 Minimum / Average / Maximum Object : 0.02K / 0.38K / 128.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME

843080 836242  99%    0.44K 105385        8    421540K xfs_inode
839608 836242  99%    0.56K 119944        7    479776K xfs_vnode
461610 432085  93%    0.21K  25645       18    102580K dentry_cache
306200 306200 100%    0.09K   7655       40     30620K buffer_head
222570 121732  54%    0.12K   7419       30     29676K size-128
117439  97108  82%    0.52K  16777        7     67108K radix_tree_node
 30820  30814  99%    0.19K   1541       20      6164K xfs_ili
 13270  13266  99%    0.74K   2654        5     10616K ext3_inode_cache
  9390   9390 100%    0.25K    626       15      2504K size-256
  7682   7562  98%    0.16K    334       23      1336K vm_area_struct
  3068   1711  55%    0.06K     52       59       208K size-64
  2816   2786  98%    0.09K     64       44       256K sysfs_dir_cache
  2055   1275  62%    0.25K    137       15       548K filp
  1440   1289  89%    0.02K     10      144        40K anon_vma
  1120    999  89%    0.03K     10      112        40K size-32
   768    534  69%    0.08K     16       48        64K
selinux_inode_security
   756    698  92%    0.55K    108        7       432K inode_cache
   576    554  96%    0.58K     96        6       384K proc_inode_cache
   476    455  95%    1.00K    119        4       476K size-1024
   404    403  99%    2.00K    202        2       808K size-2048
   404    404 100%    4.00K    404        1      1616K size-4096
   360    350  97%    0.12K     12       30        48K bio     
   320    284  88%    0.50K     40        8       160K size-512

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
