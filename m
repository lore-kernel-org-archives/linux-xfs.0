Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 05:53:17 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m25DqurT011261
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 05:52:59 -0800
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 036DB655FD2
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2008 05:53:23 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185]) by cuda.sgi.com with ESMTP id 9HNvOPA3rZDYOSsw for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 05:53:23 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id d10so1998157tib.18
        for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 05:53:21 -0800 (PST)
Message-ID: <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
Date: Wed, 5 Mar 2008 14:53:18 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080213214551.GR155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <20080213214551.GR155407@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 13, 2008 at 10:45 PM, David Chinner <dgc@sgi.com> wrote:
> On Wed, Feb 13, 2008 at 11:51:51AM +0100, Christian Røsnes wrote:
>  > Over the past month I've been hit with two cases of "xfs_trans_cancel
>  > at line 1150"
>  > The two errors occurred on different raid sets. In both cases the
>  > error happened during
>  > rsync from a remote server to this server, and the local partition
>  > which reported
>  > the error was 99% full (as reported by df -k, see below for details).
>  >
>  > System: Dell 2850
>  > Mem: 4GB RAM
>  > OS: Debian 3 (32-bit)
>  > Kernel: 2.6.17.7 (custom compiled)
>  >
>  > I've been running this kernel since Aug 2006 without any of these
>  > problems, until a month ago.
>  >
>  > I've not used any of the previous kernel in the 2.6.17 series.
>  >
>  > /usr/src/linux-2.6.17.7# grep 4K .config
>  > # CONFIG_4KSTACKS is not set
>  >
>  >
>  > Are there any known XFS problems with this kernel version and nearly
>  > full partitions ?
>
>  Yes. Deadlocks that weren't properly fixed until 2.6.18 (partially
>  fixed in 2.6.17) and an accounting problem in the transaction code
>  that leads to the shutdown you are seeing. The accounting problem is
>  fixed by this commit:
>
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=45c34141126a89da07197d5b89c04c6847f1171a
>
>  which I think went into 2.6.22.
>
>  Luckily, neither of these problems result in corruption.
>
>
>  > I'm thinking about upgrading the kernel to a newer version, to see if
>  > it fixes this problem.
>  > Are there any known XFS problems with version 2.6.24.2 ?
>
>  Yes - a problem with readdir. The fix is currently in the stable
>  queue (i.e for 2.6.24.3):
>
>  http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=commit;h=ee864b866419890b019352412c7bc9634d96f61b
>
>  So we are just waiting for Greg to release 2.6.24.3 now.
>
>  Cheers,
>
>  Dave.
>  --
>  Dave Chinner
>  Principal Engineer
>  SGI Australian Software Group
>

After being hit several times by the problem mentioned above (running
kernel 2.6.17.7),
I upgraded the kernel to version 2.6.24.3. I then ran a rsync test to
a 99% full partition:

df -k:
/dev/sdb1            286380096 282994528   3385568  99% /data

The rsync application will probably fail because it will most likely
run out of space,
but I got another xfs_trans_cancel kernel message:

Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1163 of
file fs/xfs/xfs_trans.c.  Caller 0xc021a010
Pid: 11642, comm: rsync Not tainted 2.6.24.3FC #1
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
 =======================
xfs_force_shutdown(sdb1,0x8) called from line 1164 of file
fs/xfs/xfs_trans.c.  Return address = 0xc0212690
Filesystem "sdb1": Corruption of in-memory data detected.  Shutting
down filesystem: sdb1
Please umount the filesystem, and rectify the problem(s)

Trying to umount /dev/sdb1 fails (umount just hangs) .
Rebooting the system seems to hang also - and I believe the kernel
outputs this message
when trying to umount /dev/sdb1:

  xfs_force_shutdown(sdb1,0x1) called from line 420 of file fs/xfs/xfs_rw.c.
  Return address = 0xc021cb21

After waiting 5 minutes I power-cycle the system to bring it back up.

After the restart, I ran:

xfs_check /dev/sdb1

(there was no output from xfs_check).

Could this be the same problem I experienced with 2.6.17.7 ?

Thanks
Christian

btw - I've previously run memtest overnight and not found any memory problems.
