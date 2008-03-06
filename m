Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Mar 2008 03:10:24 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m26BA7cq017274
	for <xfs@oss.sgi.com>; Thu, 6 Mar 2008 03:10:08 -0800
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42D9065F041
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2008 03:10:35 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184]) by cuda.sgi.com with ESMTP id dEl8L5FemDiuCkVF for <xfs@oss.sgi.com>; Thu, 06 Mar 2008 03:10:35 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id d10so2606410tib.18
        for <xfs@oss.sgi.com>; Thu, 06 Mar 2008 03:10:34 -0800 (PST)
Message-ID: <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com>
Date: Thu, 6 Mar 2008 12:10:32 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <20080213214551.GR155407@sgi.com>
	 <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Mar 5, 2008 at 2:53 PM, Christian Røsnes
<christian.rosnes@gmail.com> wrote:
> > On Wed, Feb 13, 2008 at 11:51:51AM +0100, Christian Røsnes wrote:
>  >  > Over the past month I've been hit with two cases of "xfs_trans_cancel
>  >  > at line 1150"
>  >  > The two errors occurred on different raid sets. In both cases the
>  >  > error happened during
>  >  > rsync from a remote server to this server, and the local partition
>  >  > which reported
>  >  > the error was 99% full (as reported by df -k, see below for details).
>  >  >
>  >  > System: Dell 2850
>  >  > Mem: 4GB RAM
>  >  > OS: Debian 3 (32-bit)
>  >  > Kernel: 2.6.17.7 (custom compiled)
>  >  >
>
>  After being hit several times by the problem mentioned above (running
>  kernel 2.6.17.7),
>  I upgraded the kernel to version 2.6.24.3. I then ran a rsync test to
>  a 99% full partition:
>
>  df -k:
>  /dev/sdb1            286380096 282994528   3385568  99% /data
>
>  The rsync application will probably fail because it will most likely
>  run out of space,
>  but I got another xfs_trans_cancel kernel message:
>
>  Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1163 of
>  file fs/xfs/xfs_trans.c.  Caller 0xc021a010
>  Pid: 11642, comm: rsync Not tainted 2.6.24.3FC #1
>   [<c0212678>] xfs_trans_cancel+0x5d/0xe6
>   [<c021a010>] xfs_mkdir+0x45a/0x493
>   [<c021a010>] xfs_mkdir+0x45a/0x493
>   [<c01cbb8f>] xfs_acl_vhasacl_default+0x33/0x44
>   [<c0222d70>] xfs_vn_mknod+0x165/0x243
>   [<c0217b9e>] xfs_access+0x2f/0x35
>   [<c0222e6d>] xfs_vn_mkdir+0x12/0x14
>   [<c016057b>] vfs_mkdir+0xa3/0xe2
>   [<c0160644>] sys_mkdirat+0x8a/0xc3
>   [<c016069c>] sys_mkdir+0x1f/0x23
>   [<c01025ee>] syscall_call+0x7/0xb
>   =======================
>  xfs_force_shutdown(sdb1,0x8) called from line 1164 of file
>  fs/xfs/xfs_trans.c.  Return address = 0xc0212690
>
> Filesystem "sdb1": Corruption of in-memory data detected.  Shutting
>  down filesystem: sdb1
>  Please umount the filesystem, and rectify the problem(s)
>

Actually, a single mkdir command is enough to trigger the filesystem
shutdown when its 99% full (according to df -k):

/data# mkdir test
mkdir: cannot create directory `test': No space left on device


Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1163 of
file fs/xfs/xfs_trans.c.  Caller 0xc021a010
Pid: 23380, comm: mkdir Not tainted 2.6.24.3FC #1
 [<c0212678>] xfs_trans_cancel+0x5d/0xe6
 [<c021a010>] xfs_mkdir+0x45a/0x493
 [<c021a010>] xfs_mkdir+0x45a/0x493
 [<c01cbb8f>] xfs_acl_vhasacl_default+0x33/0x44
 [<c0222d70>] xfs_vn_mknod+0x165/0x243
 [<c0217b9e>] xfs_access+0x2f/0x35
 [<c0222e6d>] xfs_vn_mkdir+0x12/0x14
 [<c016057b>] vfs_mkdir+0xa3/0xe2
 [<c0160644>] sys_mkdirat+0x8a/0xc3
 [<c016069c>] sys_mkdir+0x1f/0x23
 [<c01025ee>] syscall_call+0x7/0xb
 [<c03b0000>] atm_reset_addr+0xd/0x83
 =======================
xfs_force_shutdown(sdb1,0x8) called from line 1164 of file
fs/xfs/xfs_trans.c.  Return address = 0xc0212690
Filesystem "sdb1": Corruption of in-memory data detected.  Shutting
down filesystem: sdb1
Please umount the filesystem, and rectify the problem(s)

df -k
-----
/dev/sdb1            286380096 282994528   3385568  99% /data

df -i
-----
/dev/sdb1            10341248 3570112 6771136   35% /data


xfs_info
--------
meta-data=/dev/sdb1              isize=512    agcount=16, agsize=4476752 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=71627792, imaxpct=25
         =                       sunit=16     swidth=32 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

xfs_db -r -c 'sb 0' -c p /dev/sdb1
----------------------------------
magicnum = 0x58465342
blocksize = 4096
dblocks = 71627792
rblocks = 0
rextents = 0
uuid = d16489ab-4898-48c2-8345-6334af943b2d
logstart = 67108880
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 4476752
agcount = 16
rbmblocks = 0
logblocks = 32768
versionnum = 0x3584
sectsize = 512
inodesize = 512
inopblock = 8
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 9
inopblog = 3
agblklog = 23
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 3570112
ifree = 0
fdblocks = 847484
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 16
width = 32
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 65536
features2 = 0


Christian
