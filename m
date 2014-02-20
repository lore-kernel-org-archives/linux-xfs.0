Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9C747FB5
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 18:14:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9755930407F
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 16:13:57 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UBwtz3AnwdgFYAJ0 for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 16:13:55 -0800 (PST)
Date: Thu, 20 Feb 2014 11:13:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: mmap_sem -> isec->lock lockdep issues with shmem (was Re: [PATCH
	2/3] xfs: fix directory inode iolock lockdep false positive)
Message-ID: <20140220001329.GG4916@dastard>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-3-git-send-email-david@fromorbit.com>
	<5304F70C.8070601@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5304F70C.8070601@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, xfs@oss.sgi.com

[cc linux-mm because it shmem craziness that is causing the problem]
[cc linux-security-module because it is security contexts that need
 lockdep annotations.]

On Wed, Feb 19, 2014 at 01:25:16PM -0500, Brian Foster wrote:
> On 02/18/2014 11:16 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The change to add the IO lock to protect the directory extent map
> > during readdir operations has cause lockdep to have a heart attack
> > as it now sees a different locking order on inodes w.r.t. the
> > mmap_sem because readdir has a different ordering to write().
> > 
> > Add a new lockdep class for directory inodes to avoid this false
> > positive.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Hey Dave,
> 
> I'm not terribly familiar with lockdep, but I hit the attached "possible
> circular locking dependency detected" warning when running with this patch.
> 
> (Reproduces by running generic/001 after a reboot).

Ok, you're testing on an selinux enabled system, I didn't.

> Feb 19 12:22:03 localhost kernel: [  101.487018] 
> Feb 19 12:22:03 localhost kernel: [  101.487018] -> #2 (&xfs_dir_ilock_class){++++..}:
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff810f3ec2>] lock_acquire+0xa2/0x1d0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff810ed147>] down_read_nested+0x57/0xa0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa05a0022>] xfs_ilock+0x122/0x250 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa05a01af>] xfs_ilock_attr_map_shared+0x1f/0x50 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa0565d50>] xfs_attr_get+0x90/0xe0 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa055b9d7>] xfs_xattr_get+0x37/0x50 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff812483ef>] generic_getxattr+0x4f/0x70
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8133fd5e>] inode_doinit_with_dentry+0x1ae/0x650
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff813402d8>] sb_finish_set_opts+0xd8/0x270
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81340702>] selinux_set_mnt_opts+0x292/0x5f0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81340ac8>] superblock_doinit+0x68/0xd0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81340b8d>] selinux_sb_kern_mount+0x3d/0xa0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81335536>] security_sb_kern_mount+0x16/0x20
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8122333a>] mount_fs+0x8a/0x1b0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8124285b>] vfs_kern_mount+0x6b/0x150
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8124561e>] do_mount+0x23e/0xb90
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff812462a3>] SyS_mount+0x83/0xc0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8178ed69>] system_call_fastpath+0x16/0x1b

So, we take the ilock on the directory xattr read path during
security attribute initialisation so we have a inode->i_isec->lock -> ilock
path, which is normal.

> Feb 19 12:22:03 localhost kernel: [  101.487018] -> #1 (&isec->lock){+.+.+.}:
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff810f3ec2>] lock_acquire+0xa2/0x1d0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81780d77>] mutex_lock_nested+0x77/0x3f0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8133fc42>] inode_doinit_with_dentry+0x92/0x650
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81340dcc>] selinux_d_instantiate+0x1c/0x20
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8133517b>] security_d_instantiate+0x1b/0x30
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81237d70>] d_instantiate+0x50/0x70
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811bcb70>] __shmem_file_setup+0xe0/0x1d0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811bf988>] shmem_zero_setup+0x28/0x70
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811d8653>] mmap_region+0x543/0x5a0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811d89b1>] do_mmap_pgoff+0x301/0x3c0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811c18f0>] vm_mmap_pgoff+0x90/0xc0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811d6f26>] SyS_mmap_pgoff+0x116/0x270
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8101f9b2>] SyS_mmap+0x22/0x30
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8178ed69>] system_call_fastpath+0x16/0x1b

What the hell?  We instantiate an shmem filesystem *inode* under the
mmap_sem? 

And so we have a mmap_sem -> inode->i_isec->lock path on a *shmem* inode.


> Feb 19 12:22:03 localhost kernel: [  101.487018] 
> Feb 19 12:22:03 localhost kernel: [  101.487018] -> #0 (&mm->mmap_sem){++++++}:
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff810f351c>] __lock_acquire+0x18ec/0x1aa0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff810f3ec2>] lock_acquire+0xa2/0x1d0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff811cc8fc>] might_fault+0x8c/0xb0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff812341c1>] filldir+0x91/0x120
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa053f2f7>] xfs_dir2_sf_getdents+0x317/0x380 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa054001b>] xfs_readdir+0x16b/0x230 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffffa05427fb>] xfs_file_readdir+0x2b/0x40 [xfs]
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff81234008>] iterate_dir+0xa8/0xe0
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff812344b3>] SyS_getdents+0x93/0x120
> Feb 19 12:22:03 localhost kernel: [  101.487018]        [<ffffffff8178ed69>] system_call_fastpath+0x16/0x1b

And then we have the mmap_sem in readdir, which inode->ilock ->
mmap_sem.


> Feb 19 12:22:03 localhost kernel: [  101.487018] 
> Feb 19 12:22:03 localhost kernel: [  101.487018] other info that might help us debug this:
> Feb 19 12:22:03 localhost kernel: [  101.487018] 
> Feb 19 12:22:03 localhost kernel: [  101.487018] Chain exists of:
> Feb 19 12:22:03 localhost kernel: [  101.487018]   &mm->mmap_sem --> &isec->lock --> &xfs_dir_ilock_class
> Feb 19 12:22:03 localhost kernel: [  101.487018] 
> Feb 19 12:22:03 localhost kernel: [  101.487018]  Possible unsafe locking scenario:
> Feb 19 12:22:03 localhost kernel: [  101.487018] 
> Feb 19 12:22:03 localhost kernel: [  101.487018]        CPU0                    CPU1
> Feb 19 12:22:03 localhost kernel: [  101.487018]        ----                    ----
> Feb 19 12:22:03 localhost kernel: [  101.487018]   lock(&xfs_dir_ilock_class);
> Feb 19 12:22:03 localhost kernel: [  101.487018]                                lock(&isec->lock);
> Feb 19 12:22:03 localhost kernel: [  101.487018]                                lock(&xfs_dir_ilock_class);
> Feb 19 12:22:03 localhost kernel: [  101.487018]   lock(&mm->mmap_sem);

So that's just another goddamn false positive.

The problem here is that it's many, many layers away from XFS, and
really doesn't involve XFS at all. It's caused by shmem
instantiating an inode under the mmap_sem...

Basically, the only way I can see that this is even remotely
preventable is that inode->isec->ilock needs a per-sb lockdep
context so that lockdep doesn't confuse the lock heirarchies of
completely unrelated filesystems when someone does something crazy
like the page fault path is currently doing.

Fmeh:

struct super_block {
....
#ifdef CONFIG_SECURITY
        void                    *s_security;
#endif

So I can't even isolate it to the security subsystem pointer in
the superblock because there isn't a generic structure to abstract
security specific stuff from the superblock without having to
implement the same lockdep annotations in every security module
uses xattrs to store security information.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
