Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 68F127F69
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 05:00:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC44EAC004
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 02:59:57 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id cpoO3HRYkaUVP3V3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 02:59:56 -0700 (PDT)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <guillaume.anciaux@epfl.ch>) id 1UHWrE-0004yu-6l
	for linux-xfs@oss.sgi.com; Mon, 18 Mar 2013 02:59:56 -0700
Date: Mon, 18 Mar 2013 02:59:56 -0700 (PDT)
From: anciaux <guillaume.anciaux@epfl.ch>
Message-ID: <1363600796196-34996.post@n7.nabble.com>
Subject: mount XFS partition fail after repair when uquota and gquota are used
MIME-Version: 1.0
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
To: linux-xfs@oss.sgi.com

I have been struggling to repair a partition after a RAID disk set failure.

Apparently the data is accessible with no problem since I can mount the
partition.

The problem is ONLY when I use the uquota and gquota mount option (which I
was using freely before the disk failure).

The syslog shows: 

Mar 18 09:35:50 storage kernel: [  417.885430] XFS (sdb1): Internal error
xfs_iformat(1) at line 319 of file
/build/buildd/linux-3.2.0/fs/xfs/xfs_inode.c.  Caller 0xffffffffa0308502
Mar 18 09:35:50 storage kernel: [  417.885634]  [<ffffffffa02c26cf>]
xfs_error_report+0x3f/0x50 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885651]  [<ffffffffa0308502>] ?
xfs_iread+0x172/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885663]  [<ffffffffa02c273e>]
xfs_corruption_error+0x5e/0x90 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885680]  [<ffffffffa030826c>]
xfs_iformat+0x42c/0x550 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885697]  [<ffffffffa0308502>] ?
xfs_iread+0x172/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885714]  [<ffffffffa0308502>]
xfs_iread+0x172/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885729]  [<ffffffffa02c71e4>]
xfs_iget_cache_miss+0x64/0x230 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885740]  [<ffffffffa02c74d9>]
xfs_iget+0x129/0x1b0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885763]  [<ffffffffa0323c46>]
xfs_qm_dqusage_adjust+0x86/0x2a0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885774]  [<ffffffffa02bfda1>] ?
xfs_buf_rele+0x51/0x130 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885787]  [<ffffffffa02ccf83>]
xfs_bulkstat+0x413/0x800 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885811]  [<ffffffffa0323bc0>] ?
xfs_qm_quotacheck_dqadjust+0x190/0x190 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885826]  [<ffffffffa02d66d5>] ?
kmem_free+0x35/0x40 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885843]  [<ffffffffa03246b5>]
xfs_qm_quotacheck+0xe5/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885862]  [<ffffffffa031de3c>] ?
xfs_qm_dqdestroy+0x1c/0x30 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885880]  [<ffffffffa0324a94>]
xfs_qm_mount_quotas+0x124/0x1b0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885897]  [<ffffffffa0310990>]
xfs_mountfs+0x5f0/0x690 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885910]  [<ffffffffa02ce322>] ?
xfs_mru_cache_create+0x162/0x190 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885923]  [<ffffffffa02d053e>]
xfs_fs_fill_super+0x1de/0x290 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885939]  [<ffffffffa02d0360>] ?
xfs_parseargs+0xbc0/0xbc0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.885953]  [<ffffffffa02ce665>]
xfs_fs_mount+0x15/0x20 [xfs]


I fear for the filesystem to be corrupted and xfs_repair not able to notice.
At least for the quota information.
Someone has any hint on what could be the problem ? On how I could
fix/regenerate the quota information ?


Thanks a lot for you help.

****************************************

Here are some information on my system:


cat /etc/os-release 
   NAME="Ubuntu"
   VERSION="12.04.2 LTS, Precise Pangolin"
   ID=ubuntu
   ID_LIKE=debian
   PRETTY_NAME="Ubuntu precise (12.04.2 LTS)"
   VERSION_ID="12.04"

uname -a 
   Linux storage 3.2.0-38-generic #61-Ubuntu SMP Tue Feb 19 12:18:21 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

dpkg -l | grep -i xfs
   ii  xfsdump                                  3.0.6                                              
Administrative utilities for the XFS filesystem
   ii  xfsprogs                                 3.1.7                                              
Utilities for managing the XFS filesystem

xfs_repair -V
   xfs_repair version 3.1.7





--
View this message in context: http://xfs.9218.n7.nabble.com/mount-XFS-partition-fail-after-repair-when-uquota-and-gquota-are-used-tp34996.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
