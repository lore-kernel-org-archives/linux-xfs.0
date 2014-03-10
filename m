Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D83ED7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 15:52:53 -0500 (CDT)
Date: Mon, 10 Mar 2014 15:52:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310205249.GS1935@sgi.com>
References: <531BD8B9.1090400@gmail.com>
 <20140310025523.GV6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310025523.GV6851@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

Hi Dave,

On Mon, Mar 10, 2014 at 01:55:23PM +1100, Dave Chinner wrote:
> On Sat, Mar 08, 2014 at 09:58:01PM -0500, Michael L. Semon wrote:
> > Hi!  I was playing a shell game with some precious backup data.  It 
> > went like this:
> > 
> > open a 36-GB source partition (DM linear, partitions from 2 drives, 
> >    v5-superblock XFS)
> > 
> > open a 32-GB aes-xts crypt (v4-superblock XFS)
> > 
> > `cp -av` from holding partition to crypt
> > 
> > It was during the cp operation that I got this multi-CPU version of 
> > the harmless lockdep:
> > 
> > =========================================================
> > [ INFO: possible irq lock inversion dependency detected ]
> > 3.14.0-rc5+ #6 Not tainted
> > ---------------------------------------------------------
> > kswapd0/25 just changed the state of lock:
> >  (&xfs_dir_ilock_class){++++-.}, at: [<791c09fa>] xfs_ilock+0xff/0x16c
> > but this lock took another, RECLAIM_FS-unsafe lock in the past:
> >  (&mm->mmap_sem){++++++}
> > 
> > and interrupts could create inverse lock ordering between them.
> > 
> > 
> > other info that might help us debug this:
> >  Possible interrupt unsafe locking scenario:
> > 
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&mm->mmap_sem);
> >                                local_irq_disable();
> >                                lock(&xfs_dir_ilock_class);
> >                                lock(&mm->mmap_sem);
> >   <Interrupt>
> >     lock(&xfs_dir_ilock_class);
> 
> Well, that's rather interesting. I'd love to know where we take the
> directory ilock with interupts disabled - and then take a page
> fault...  :/
> 
> ....
> 
> >   }
> >   ... key      at: [<795f1eec>] __key.44037+0x0/0x8
> >   ... acquired at:
> >    [<79064360>] __lock_acquire+0x397/0xa6c
> >    [<7906510f>] lock_acquire+0x8b/0x101
> >    [<790d1718>] might_fault+0x81/0xa9
> >    [<790f379a>] filldir64+0x92/0xe2
> >    [<7916f079>] xfs_dir2_sf_getdents+0x1a0/0x44c
> >    [<7917009e>] xfs_readdir+0xc4/0x126
> >    [<79171b8b>] xfs_file_readdir+0x25/0x3e
> >    [<790f385a>] iterate_dir+0x70/0x9b
> >    [<790f3a31>] SyS_getdents64+0x6d/0xcc
> >    [<792f85b8>] sysenter_do_call+0x12/0x36
> 
> All of these paths are from the syscall path, except for one in
> kswapd context. I don't see any stack trace here that could result
> in the above "deadlock". It looks to be yet another false
> positive...
> 
> > I call it harmless because its single-CPU variant can be reproduced
> > as far back as I could bisect in earlier testing (way before
> > kernel 2.6.20).  However, such lockdep splats have never manifested
> > in a noticeable problem on production kernels on x86.  Either
> > down_write_nested or down_read_nested is in all of them, depending
> > on which kernel version is in use.  At least one reclaim-related
> > function is in there as well.  vm_map_ram used to be in there, but Dave 
> > took care of that (thanks!).
> > 
> > This particular splat has been showing up more often, though.  It's not
> > tied to one particular commit, event, or change; just something that
> > has crept in gradually since maybe kernel 3.11.  It's like watching
> > grass grow or watching paint dry.
> 
> The above reports all indicate that the taking a page fault while
> holding the directory ilock is problematic. So have all the other
> new lockdep reports we've got that have been caused by that change.
> 
> Realistically, I think that the readdir locking change was
> fundamentally broken. Why? Because taking page faults while holding
> the ilock violates the lock order we have for inodes.  For regular
> files, the lock heirarchy is iolock -> page fault -> ilock, and we
> got rid of the need for the iolock in the inode reclaim path because
> of all the problems it caused lockdep. Now we've gone and
> reintroduced that same set of problems - only worse - by allowing
> the readdir code to take page faults while holding the ilock....
> 
> I'd like to revert the change that introduced the ilock into the
> readdir path, but I suspect that woul dbe an unpopular direction to
> take. However, we need a solution that doesn't drive us insane with
> lockdep false positives.
> 
> IOWs, we need to do this differently - readdir needs to be protected
> by the iolock, not the ilock, and only the block mapping routines in
> the readdir code should be protected by the ilock. i.e.  the same
> locking strategy that is used for regular files: iolock protects the
> contents of the file, the ilock protects the inode metadata.
> 
> What I think we really need to do is drive the ilock all the way
> into the block mapping functions of the directory code and to the
> places where the inode metadata is actually going to be modified.
> The iolock protects access to the directory data, and logging of
> changes to those blocks is serialised by the buffer locks, so we
> don't actually need the inode ilock to serialise access to the
> directory data - we only need the ilock for modifications to the
> inode and it's blockmaps itself, same as for regular files.
> 
> Changing the directory code to handle this sort of locking is going
> to require a bit of surgery. However, I can see advantages to moving
> directory data to the same locking strategy as regular file data -
> locking heirarchies are identical, directory ilock hold times are
> much reduced, we don't get lockdep whining about taking page faults
> with the ilock held, etc.
> 
> A quick hack at to demonstrate the high level, initial step of using
> the IOLOCK for readdir serialisation. I've done a little smoke
> testing on it, so it won't die immediately. It should get rid of all
> the nasty lockdep issues, but it doesn't start to address the deeper
> restructing that is needed.
> 
> Thoughts, comments? I'm especially interested in what SGI people
> have to say here because this locking change was needed for CXFS,
> and changing the directory locking iheirarchy is probably going to
> upset CXFS a lot...

Protecting directory contents with the iolock and pushing the ilock down
to protect the directory block mapping functions seems like a good
strategy to me.  In this area I think it's good to treat directories the
same as regular files.  I have not had a very close look yet... and
couldn't find where we take a fault with irqs disabled.  Maybe something
out of a workqueue?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
