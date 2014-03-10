Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B9227F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 16:20:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29FE08F804B
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 14:20:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wM0QtOcWBdVEuE6Q for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 14:20:32 -0700 (PDT)
Date: Tue, 11 Mar 2014 08:20:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310212027.GA6851@dastard>
References: <531BD8B9.1090400@gmail.com> <20140310025523.GV6851@dastard>
	<20140310205249.GS1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310205249.GS1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 10, 2014 at 03:52:49PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Mon, Mar 10, 2014 at 01:55:23PM +1100, Dave Chinner wrote:
> > On Sat, Mar 08, 2014 at 09:58:01PM -0500, Michael L. Semon wrote:
> > > Hi!  I was playing a shell game with some precious backup data.  It 
> > > went like this:
> > > 
> > > open a 36-GB source partition (DM linear, partitions from 2 drives, 
> > >    v5-superblock XFS)
> > > 
> > > open a 32-GB aes-xts crypt (v4-superblock XFS)
> > > 
> > > `cp -av` from holding partition to crypt
> > > 
> > > It was during the cp operation that I got this multi-CPU version of 
> > > the harmless lockdep:
> > > 
> > > =========================================================
> > > [ INFO: possible irq lock inversion dependency detected ]
> > > 3.14.0-rc5+ #6 Not tainted
> > > ---------------------------------------------------------
> > > kswapd0/25 just changed the state of lock:
> > >  (&xfs_dir_ilock_class){++++-.}, at: [<791c09fa>] xfs_ilock+0xff/0x16c
> > > but this lock took another, RECLAIM_FS-unsafe lock in the past:
> > >  (&mm->mmap_sem){++++++}
> > > 
> > > and interrupts could create inverse lock ordering between them.
> > > 
> > > 
> > > other info that might help us debug this:
> > >  Possible interrupt unsafe locking scenario:
> > > 
> > >        CPU0                    CPU1
> > >        ----                    ----
> > >   lock(&mm->mmap_sem);
> > >                                local_irq_disable();
> > >                                lock(&xfs_dir_ilock_class);
> > >                                lock(&mm->mmap_sem);
> > >   <Interrupt>
> > >     lock(&xfs_dir_ilock_class);
> > 
> > Well, that's rather interesting. I'd love to know where we take the
> > directory ilock with interupts disabled - and then take a page
> > fault...  :/
.....
> > Realistically, I think that the readdir locking change was
> > fundamentally broken. Why? Because taking page faults while holding
> > the ilock violates the lock order we have for inodes.  For regular
> > files, the lock heirarchy is iolock -> page fault -> ilock, and we
> > got rid of the need for the iolock in the inode reclaim path because
> > of all the problems it caused lockdep. Now we've gone and
> > reintroduced that same set of problems - only worse - by allowing
> > the readdir code to take page faults while holding the ilock....
> > 
> > I'd like to revert the change that introduced the ilock into the
> > readdir path, but I suspect that woul dbe an unpopular direction to
> > take. However, we need a solution that doesn't drive us insane with
> > lockdep false positives.
> > 
> > IOWs, we need to do this differently - readdir needs to be protected
> > by the iolock, not the ilock, and only the block mapping routines in
> > the readdir code should be protected by the ilock. i.e.  the same
> > locking strategy that is used for regular files: iolock protects the
> > contents of the file, the ilock protects the inode metadata.
> > 
> > What I think we really need to do is drive the ilock all the way
> > into the block mapping functions of the directory code and to the
> > places where the inode metadata is actually going to be modified.
> > The iolock protects access to the directory data, and logging of
> > changes to those blocks is serialised by the buffer locks, so we
> > don't actually need the inode ilock to serialise access to the
> > directory data - we only need the ilock for modifications to the
> > inode and it's blockmaps itself, same as for regular files.
> > 
> > Changing the directory code to handle this sort of locking is going
> > to require a bit of surgery. However, I can see advantages to moving
> > directory data to the same locking strategy as regular file data -
> > locking heirarchies are identical, directory ilock hold times are
> > much reduced, we don't get lockdep whining about taking page faults
> > with the ilock held, etc.
> > 
> > A quick hack at to demonstrate the high level, initial step of using
> > the IOLOCK for readdir serialisation. I've done a little smoke
> > testing on it, so it won't die immediately. It should get rid of all
> > the nasty lockdep issues, but it doesn't start to address the deeper
> > restructing that is needed.
> > 
> > Thoughts, comments? I'm especially interested in what SGI people
> > have to say here because this locking change was needed for CXFS,
> > and changing the directory locking iheirarchy is probably going to
> > upset CXFS a lot...
> 
> Protecting directory contents with the iolock and pushing the ilock down
> to protect the directory block mapping functions seems like a good
> strategy to me. 

Ok, it seems like a good strategy, but does it work for CXFS? What
about the other option of a combination of ilock for mapping and
read, and buffer locks for stabilisation?

> In this area I think it's good to treat directories the
> same as regular files.  I have not had a very close look yet... and
> couldn't find where we take a fault with irqs disabled.  Maybe something
> out of a workqueue?

Workqueues don't run with interrupts disabled. Yes, we take inode
locks in workqueue context (e.g. AIL tail pushing), but that's not
what is being warned about here. And the page fault only comes from
the filldir callback which runs copy_to_user(), and that most
definitely does not occur in interrupt context.

FWIW, it's invalid to take the ilock in interrupt context because
it's a sleeping lock without using trylock semantics. If you use
"trylock" semantics, then lockdep doesn't complain about that
because it can't deadlock. I *think* that lockdep is complaining
about reclaim contexts, not interrupts, and it's issuing this
"interrupts disabled" deadlocks because the memory reclaim state
code is piggy-backed on the interrupt state tracking within lockdep.
Either way, though, lockdep is wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
