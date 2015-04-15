Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A31C07F47
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 18:41:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21A1EAC006
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 16:41:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UsdCDiVJnHfpGs4r for <xfs@oss.sgi.com>;
	Wed, 15 Apr 2015 16:41:12 -0700 (PDT)
Date: Thu, 16 Apr 2015 09:25:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 4.1 lockdep problem
Message-ID: <20150415232529.GY13731@dastard>
References: <1429123657.16553.250.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429123657.16553.250.camel@redhat.com>
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
To: Eric Paris <eparis@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 15, 2015 at 01:47:37PM -0500, Eric Paris wrote:
> Booting 4.0 my system is totally fine. Although my 4.0 (probably)
> doesn't have any debug/lockdep code turned on.  Booting Fedora's 4.1
> this morning does cause some problems.
> 
> The first time I booted, I ran dracut -f, a lockdep popped out, and
> dracut never returned...
> 
> On successive boots I see that my system boots without error, but then
> the lockdep pops out when I ssh in. When I reboot, sshd actually
> segfaults instead of closing properly. 4.0 kernel has no such problem.
> Maybe this is yet another xfs false positive, but the segfaulting sshd
> is quite strange...
> 
> 
> [  225.300470] ======================================================
> [  225.300507] [ INFO: possible circular locking dependency detected ]
> [  225.300543] 4.1.0-0.rc0.git1.1.fc23.x86_64 #1 Not tainted
> [  225.300579] -------------------------------------------------------
> [  225.300615] sshd/11261 is trying to acquire lock:
> [  225.300650]  (&isec->lock){+.+.+.}, at: [<ffffffff813a7b35>] inode_doinit_with_dentry+0xc5/0x6a0
> [  225.300700]
>                but task is already holding lock:
> [  225.300771]  (&mm->mmap_sem){++++++}, at: [<ffffffff8120ae7f>] vm_mmap_pgoff+0x8f/0xf0
> [  225.300817]
>                which lock already depends on the new lock.

This isn't an XFS problem. XFS is just fine.

shmem, OTOH, is doing inode instantiation under the mmap_sem,
thereby causing all the inode locking paths in filesystems to be
inverted against mmap_sem.

Correct locking order is always VFS -> mmap_sem, as defined by the
write path, and the readdir path, which is where this is tripping
over.

>  
> [  225.300934]
>                the existing dependency chain (in reverse order) is:
> [  225.301012]
>                -> #2 (&mm->mmap_sem){++++++}:
> [  225.301012]        [<ffffffff8110d647>] lock_acquire+0xc7/0x2a0
> [  225.301012]        [<ffffffff8121c57c>] might_fault+0x8c/0xb0
> [  225.301012]        [<ffffffff8128f49a>] filldir+0x9a/0x130
> [  225.301012]        [<ffffffffa0176606>] xfs_dir2_block_getdents.isra.12+0x1a6/0x1d0 [xfs]
> [  225.301012]        [<ffffffffa0177064>] xfs_readdir+0x1a4/0x330 [xfs]
> [  225.301012]        [<ffffffffa0179f7b>] xfs_file_readdir+0x2b/0x30 [xfs]
> [  225.301012]        [<ffffffff8128f26a>] iterate_dir+0x9a/0x140
> [  225.301012]        [<ffffffff8128f7a1>] SyS_getdents+0x91/0x120
> [  225.301012]        [<ffffffff8188c8ee>] system_call_fastpath+0x12/0x76

Normal readdir path. Lock order is i_mutex -> xfs_dir_ilock ->
mmap_sem.

> [  225.301012]
>                -> #1 (&xfs_dir_ilock_class){++++.+}:
> [  225.301012]        [<ffffffff8110d647>] lock_acquire+0xc7/0x2a0
> [  225.301012]        [<ffffffff81105337>] down_read_nested+0x57/0xa0
> [  225.301012]        [<ffffffffa018ae12>] xfs_ilock+0xe2/0x2a0 [xfs]
> [  225.301012]        [<ffffffffa018b048>] xfs_ilock_attr_map_shared+0x38/0x50 [xfs]
> [  225.301012]        [<ffffffffa01289dd>] xfs_attr_get+0xbd/0x1b0 [xfs]
> [  225.301012]        [<ffffffffa019b01d>] xfs_xattr_get+0x3d/0x80 [xfs]
> [  225.301012]        [<ffffffff812a47df>] generic_getxattr+0x4f/0x70
> [  225.301012]        [<ffffffff813a7be2>] inode_doinit_with_dentry+0x172/0x6a0
> [  225.301012]        [<ffffffff813a914b>] sb_finish_set_opts+0xdb/0x260
> [  225.301012]        [<ffffffff813a9861>] selinux_set_mnt_opts+0x331/0x670
> [  225.301012]        [<ffffffff813ac3a7>] superblock_doinit+0x77/0xf0
> [  225.301012]        [<ffffffff813ac430>] delayed_superblock_init+0x10/0x20
> [  225.301012]        [<ffffffff8127af4a>] iterate_supers+0xba/0x120
> [  225.301012]        [<ffffffff813b1783>] selinux_complete_init+0x33/0x40
> [  225.301012]        [<ffffffff813c1a43>] security_load_policy+0x103/0x640
> [  225.301012]        [<ffffffff813b32d6>] sel_write_load+0xb6/0x790
> [  225.301012]        [<ffffffff81276f87>] vfs_write+0xb7/0x210
> [  225.301012]        [<ffffffff81277c9c>] SyS_write+0x5c/0xd0
> [  225.301012]        [<ffffffff8188c8ee>] system_call_fastpath+0x12/0x76

This is selinux during mount, calling into the filesystem with
isec->lock held, and taking the root directory inode lock to read
security context xattrs.

So, lock order is isec->lock -> xfs_dir_ilock.

XFS is different to some filesystems here, in that it has internal
directory locking. Hence the SElinux code not taking the i_mutex
before reading the xattrs doesn't hide this lack of inode locking
from lockdep here. This is why XFS is noisy here and ext4 isn't.

> [  225.301012]
>                -> #0 (&isec->lock){+.+.+.}:
> [  225.301012]        [<ffffffff8110ca82>] __lock_acquire+0x1cb2/0x1e50
> [  225.301012]        [<ffffffff8110d647>] lock_acquire+0xc7/0x2a0
> [  225.301012]        [<ffffffff81888c0d>] mutex_lock_nested+0x7d/0x460
> [  225.301012]        [<ffffffff813a7b35>] inode_doinit_with_dentry+0xc5/0x6a0
> [  225.301012]        [<ffffffff813a812c>] selinux_d_instantiate+0x1c/0x20
> [  225.301012]        [<ffffffff813a2efb>] security_d_instantiate+0x1b/0x30
> [  225.301012]        [<ffffffff81292e04>] d_instantiate+0x54/0x80
> [  225.301012]        [<ffffffff8120631c>] __shmem_file_setup+0xdc/0x250
> [  225.301012]        [<ffffffff8120a8e8>] shmem_zero_setup+0x28/0x70
> [  225.301012]        [<ffffffff812286ac>] mmap_region+0x66c/0x680
> [  225.301012]        [<ffffffff812289e3>] do_mmap_pgoff+0x323/0x410
> [  225.301012]        [<ffffffff8120aea0>] vm_mmap_pgoff+0xb0/0xf0
> [  225.301012]        [<ffffffff81226b86>] SyS_mmap_pgoff+0x116/0x2b0
> [  225.301012]        [<ffffffff810232db>] SyS_mmap+0x1b/0x30
> [  225.301012]        [<ffffffff8188c8ee>] system_call_fastpath+0x12/0x76

And this is a page fault into (IIRC) a shared anonymous space which
results in the lock order of mmap_sem -> isec->lock, which is a
clear inversion of the mmap_sem compared to every other place the
VFS is asked to instantiate inodes.

So, this isn't an XFS problem at all - it's merely the messenger
saying that either SElinux or the page fault code is using locks
in inappropriate ways.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
