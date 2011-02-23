Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1N0idNh007881 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 18:44:40 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6048A2F440E
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:47:22 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	aLrckXGuDJzXeuH1 for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 16:47:22 -0800 (PST)
Date: Wed, 23 Feb 2011 11:47:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Input/Output error
Message-ID: <20110223004719.GH3166@dastard>
References: <4D63D9D8.3060204@storegrid.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D63D9D8.3060204@storegrid.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Srinivasan T <srinivasan@storegrid.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 22, 2011 at 09:14:24PM +0530, Srinivasan T wrote:
> Hi,
> 
> We are running an C++ application in AWS EC2 instance (CentOS 5.4)
> mounted with an EBS Volume (say /mymountpoint). We do more
> simultaneous writes to the EBS Volume from our application. But at
> some point we get 'ERROR: Input/output error'. After this, 'ls -l
> /mymountpoint' command itself fails with the i/o error. The
> filesystem which we use for the EBS Volume is xfs.
> 
> I unmounted the drive and done xfs_check and again mounted the
> drive. Now, everything seems to be working fine. But the issue still
> persists everytime when we do simultaneous writes.
> 
> I believe the following details will be useful,
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# cat /etc/redhat-release
> CentOS release 5.4 (Final)
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# df -lTi
> Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
> /dev/sda1     ext3   1310720  107566 1203154    9% /
> /dev/sdb      ext3   19546112      11 19546101    1% /mnt
> none         tmpfs    186059       1  186058    1% /dev/shm
> /dev/sdh       xfs   1934272  495857 1438415   26% /mymountpoint
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# uname -a
> Linux domU-12-31-39-07-81-36 2.6.21.7-2.fc8xen #1 SMP Fri Feb 15
> 12:39:36 EST 2008 i686 i686 i386 GNU/Linux
> 
> Output of dmesg :
> 
> SGI XFS with ACLs, security attributes, large block numbers, no
> debug enabled
> SGI XFS Quota Management subsystem
> Filesystem "sdh": Disabling barriers, not supported by the underlying device
> XFS mounting filesystem sdh
> Ending clean XFS mount for filesystem: sdh
> Filesystem "sdh": XFS internal error xfs_trans_cancel at line 1138
> of file fs/xfs/xfs_trans.c.  Caller 0xee201944
>  [<ee2032fe>] xfs_trans_cancel+0x59/0xe3 [xfs]
>  [<ee201944>] xfs_rename+0x8f8/0x954 [xfs]
>  [<ee201944>] xfs_rename+0x8f8/0x954 [xfs]
>  [<ee21458c>] xfs_vn_rename+0x30/0x70 [xfs]
>  [<c10bb5e3>] selinux_inode_rename+0x11f/0x16d
>  [<c1078d88>] vfs_rename+0x2c3/0x441
>  [<c107a77f>] sys_renameat+0x15a/0x1b4
>  [<c1074b7f>] sys_stat64+0xf/0x23
>  [<c1072d3b>] __fput+0x140/0x16a
>  [<c10841ee>] mntput_no_expire+0x11/0x6a
>  [<c107a800>] sys_rename+0x27/0x2b
>  [<c1005688>] syscall_call+0x7/0xb
>  =======================
> xfs_force_shutdown(sdh,0x8) called from line 1139 of file
> fs/xfs/xfs_trans.c.  Return address = 0xee217778
> Filesystem "sdh": Corruption of in-memory data detected.  Shutting
> down filesystem: sdh
> Please umount the filesystem, and rectify the problem(s)
> I/O error in filesystem ("sdh") meta-data dev sdh block 0x3c0001
> ("xfs_trans_read_buf") error 5 buf count 512
> I/O error in filesystem ("sdh") meta-data dev sdh block 0x780001
> ("xfs_trans_read_buf") error 5 buf count 512

Looks like an IO error reading the AGF during a transaction. That
would indicate a problem with your storage, not XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
