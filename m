Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MKIMwO256847 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:18:23 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A66619EF77B
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 12:21:06 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id RBjojZPmdyTX2W2P for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 12:21:06 -0800 (PST)
Message-ID: <4D641AB1.7010101@sandeen.net>
Date: Tue, 22 Feb 2011 14:21:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Input/Output error
References: <4D63D9D8.3060204@storegrid.com>
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

On 2/22/11 9:44 AM, Srinivasan T wrote:
> Hi,
> 
> We are running an C++ application in AWS EC2 instance (CentOS 5.4)
> mounted with an EBS Volume (say /mymountpoint). We do more
> simultaneous writes to the EBS Volume from our application. But at
> some point we get 'ERROR: Input/output error'. After this, 'ls -l
> /mymountpoint' command itself fails with the i/o error. The
> filesystem which we use for the EBS Volume is xfs.
> 
> I unmounted the drive and done xfs_check and again mounted the drive.

xfs_check is read-only, FWIW, a task best handled these days
by xfs_repair -n.

> Now, everything seems to be working fine. But the issue still
> persists everytime when we do simultaneous writes.> 
> I believe the following details will be useful,
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# cat /etc/redhat-release
> CentOS release 5.4 (Final)

is quota in use?  Might you be running out of space on the fs?

Sadly I'm not even sure what xfs you might be running; there were centos kmod
rpms of older xfs for a while, and then more recent kernels have xfs.ko
built in, because RHEL5 started with official support for XFS later on.

line 1138 of file fs/xfs/xfs_trans.c does not line up with current RHEL5.

"modinfo xfs" might tell us at least where the xfs module was found,
and from there know where it came from.

But, xfs support on RHEL is best handled by Red Hat, I'm afraid.  And if this
is an old xfs kmod (which *cough* I did for centos years ago) it's not going
to be well supported by anyone.

-if- you have xfs-kmod installed, and a kernel rpm which contains xfs.ko
itself, I'd suggest trying again with the latter.

Barring all that, perhaps this is a known problem more obvious to another
person on this list ...

-Eric

> [root@domU-12-31-39-07-81-36 StoreGrid]# df -lTi
> Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
> /dev/sda1     ext3   1310720  107566 1203154    9% /
> /dev/sdb      ext3   19546112      11 19546101    1% /mnt
> none         tmpfs    186059       1  186058    1% /dev/shm
> /dev/sdh       xfs   1934272  495857 1438415   26% /mymountpoint
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# uname -a
> Linux domU-12-31-39-07-81-36 2.6.21.7-2.fc8xen #1 SMP Fri Feb 15 12:39:36 EST 2008 i686 i686 i386 GNU/Linux
> 
> Output of dmesg :
> 
> SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
> SGI XFS Quota Management subsystem
> Filesystem "sdh": Disabling barriers, not supported by the underlying device
> XFS mounting filesystem sdh
> Ending clean XFS mount for filesystem: sdh
> Filesystem "sdh": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xee201944
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
> xfs_force_shutdown(sdh,0x8) called from line 1139 of file fs/xfs/xfs_trans.c.  Return address = 0xee217778
> Filesystem "sdh": Corruption of in-memory data detected.  Shutting down filesystem: sdh
> Please umount the filesystem, and rectify the problem(s)
> I/O error in filesystem ("sdh") meta-data dev sdh block 0x3c0001       ("xfs_trans_read_buf") error 5 buf count 512
> I/O error in filesystem ("sdh") meta-data dev sdh block 0x780001       ("xfs_trans_read_buf") error 5 buf count 512
> xfs_force_shutdown(sdh,0x1) called from line 423 of file fs/xfs/xfs_rw.c.  Return address = 0xee217778
> xfs_force_shutdown(sdh,0x1) called from line 423 of file fs/xfs/xfs_rw.c.  Return address = 0xee217778
> Filesystem "sdh": Disabling barriers, not supported by the underlying device
> XFS mounting filesystem sdh
> Starting XFS recovery on filesystem: sdh (logdev: internal)
> Ending XFS recovery on filesystem: sdh (logdev: internal)
> 
> The XFS utilities are in v2.9.4
> 
> Any help would be appreciated.
> 
> Regards,
> Srinivasan
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
