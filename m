Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8885F801C
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 04:38:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FBADAC003
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 02:38:39 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id AITrCSCB1PDQirjF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Feb 2013 02:38:35 -0800 (PST)
Date: Fri, 15 Feb 2013 11:38:31 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS slow when project quota exceeded (again)
Message-ID: <20130215103831.GA7458@quack.suse.cz>
References: <20130214131452.GB605@quack.suse.cz>
	<20130215071607.GT26694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130215071607.GT26694@dastard>
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
Cc: dchinner@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 15-02-13 18:16:07, Dave Chinner wrote:
> On Thu, Feb 14, 2013 at 02:14:52PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> >   this is a follow up on a discussion started here:
> > http://www.spinics.net/lists/xfs/msg14999.html
> > 
> > To just quickly sum up the issue: 
> > When project quota gets exceeded XFS ends up flushing inodes using
> > sync_inodes_sb(). I've tested (in 3.8-rc4) that if one writes 200 MB to a
> > directory with 100 MB project quota like:
> > 	fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > 	for (i = 0; i < 50000; i++)
> > 		pwrite(fd, buf, 4096, i*4096);
> > it takes about 3 s to finish, which is OK. But when there are lots of
> > inodes cached (I've tried with 10000 inodes cached on the fs), the same
> > test program runs ~140 s.
> 
> So, you're testing the overhead of ~25,000 ENOSPC flushes. I could
> brush this off and say "stupid application" but I won't....
  Yes, stupid... NFS. This is what happens when NFS client writes to a
directory over project quota. So as much as I agree the workload is
braindamaged we don't have a choice to fix a client and we didn't find a
reasonable fix on NFS server side either. So that's why we ended up with
XFS changes.

> > This is because sync_inodes_sb() iterates over
> > all inodes in superblock and waits for IO and this iteration eats CPU
> > cycles.
> 
> Yup, exactly what I said here:
> 
> http://www.spinics.net/lists/xfs/msg15198.html
> 
> Iterating inodes takes a lot of CPU.
> 
> I think the difference in the old method and the current one is that
> we only do one inode cache iteration per write(), not one per
> get_blocks() call. Hence we've removed the per-page overhead of
> flushing, and now we just have the inode cache iteration overhead.
> 
> The fix to that problem is mentioned here:
> 
> http://www.spinics.net/lists/xfs/msg15186.html
> 
> Which is to:
> 
> 	a) throttle speculative allocation as EDQUOT approaches; and
> 	b) efficiently track speculative preallocation
> 	   for all the inodes in the given project, and write back
> 	   and trim those inodes on ENOSPC.
> 
> both of those are still a work in progress. I was hoping that we'd
> have a) in 3.9, but that doesn't seem likely now the merge window is
> just about upon us....
  Yeah, I know someone is working on a better solution. I was mostly
wondering why writeback_inodes_sb() isn't enough - i.e. why do you really
need to wait for IO completion. And you explained that below. Thanks!

> It's trying to prevent the filesystem for falling into worst case IO
> patterns at ENOSPC when there are hundreds of threads banging on the
> filesystem and essentially locking up the system. i.e. we have to
> throttle the IO submission rate from ENOSPC flushing artificially -
> we really only need one thread doing the submission work, so we need
> to throttle all concurrent callers while we are doing that work.
> sync_inodes_sb() does that. And then we need to prevent individual
> callers from trying to allocate space too frequently, which we do by
> waiting for IO that was submitted in the flush. sync_inodes_sb()
> does that, too.
  I see so the waiting for IO isn't really a correctness thing but just a
way to slow down processes bringing fs out of space so that they don't lock
up the system. Thanks for explanation!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
