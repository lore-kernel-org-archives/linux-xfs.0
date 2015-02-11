Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 877A97F50
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 07:50:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75ACA304062
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 05:50:36 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kxxKrYlwcfGkx45T (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2015 05:50:33 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id t1BDoWI0013626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 13:50:32 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	t1BDoVkH005633
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 13:50:31 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	t1BDoU28024696 for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 13:50:30 GMT
Message-ID: <54DB5E70.80607@oracle.com>
Date: Wed, 11 Feb 2015 16:51:44 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: xfs_logprint segfault with external log
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

Hello,

I've obtained corrupted xfs log after some sanity xfs testing:

"log=logfile
log_size=855

dd if=/dev/zero "of=$log" bs=4096 count=$log_size
loopdev=$(losetup -f)
losetup $loopdev $log

mkfs.xfs -f -m crc=1 -llogdev=$loopdev,size=${log_size}b $SCRATCH_DEV
mount -t xfs -ologdev=$loopdev $SCRATCH_DEV $SCRATCH_MNT
./fdtree.sh  -l 4 -d 4 -C -o $SCRATCH_MNT
sync
umount $SCRATCH_MNT

xfs_logprint -l $loopdev $SCRATCH_DEV"

Test makes crc enabled xfs filesystem with the external log of minimal 
allowed size and then creates on this fs the small directory tree
with sub directories and files of fixed depth and size with help of 
fdtree utility: https://computing.llnl.gov/?set=code&page=sio_downloads

After that xfs_logprint stably reports bad data in log:

"Oper (307): tid: eec9b0c7  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
Oper (308): tid: 41000000  len: 805306368  clientid: ERROR  flags: none
LOCAL attr data

============================================================================
cycle: 1        version: 2              lsn: 1,3138     tail_lsn: 1,2
length of Log Record: 32256     prev offset: 3074               num ops: 375
uuid: 39a962b7-4c0d-4e0e-8bcd-39471f93bc1d   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: eec9b0c7  len: 48  clientid: TRANS  flags: none
**********************************************************************
* ERROR: data block=3138                                              *
**********************************************************************

xfs_logprint: unknown log operation type (2e00)
Bad data in log"

Subsequent call to "xfs_repair -n -l $loopdev $SCRATCH_DEV" passes and 
filesystem is mounted without errors.
I've supposed the using of inappropriate log size so updated log_size to 
default mkfs.xfs value for this device: "log_size=2560".
After that xfs_logprint core dumped with segfault (race condition):

"Feb 11 13:55:42 fedora.fedora kernel: xfs_logprint[14007]: segfault at 
29f16768 ip 00000000004028ed sp 00007fff61b46850 error 4 in 
xfs_logprint[400000+4e000]"

I have the following configuration on vbox virtual machine with vdi, 
fixed size /dev/sdb:

[root@fedora alex]# cat /etc/issue
Fedora release 20 (Heisenbug)
Kernel \r on an \m (\l)
[root@fedora alex]# uname -ir
3.19.0-rc6 x86_64
[root@fedora alex]# mkfs.xfs -V
mkfs.xfs version 3.2.2
[root@fedora alex]# xfs_logprint -V
xfs_logprint version 3.2.2
[root@fedora alex]# fdisk -l /dev/sdb

Disk /dev/sdb: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

abrt data with sosreport are collected and available on request.

Thanks,
Alexander Tsvetkov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
