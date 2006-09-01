Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 06:43:12 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [62.242.22.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k81DgqDW029130
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 06:42:52 -0700
Date: Fri, 1 Sep 2006 15:45:12 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: vmsplice can't work well
Message-ID: <20060901134512.GD25434@kernel.dk>
References: <44F4440F.1090300@gmail.com> <20060829140542.GN12257@kernel.dk> <44F5CC08.8010205@mnsu.edu> <20060830174815.GF7331@kernel.dk> <44F5D3C6.1010108@mnsu.edu> <20060831092440.GC5528@kernel.dk> <20060901131913.GG5737019@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060901131913.GG5737019@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Jeffrey E. Hundstad" <jeffrey.hundstad@mnsu.edu>, xfs@oss.sgi.com, nathans@sgi.com

On Fri, Sep 01 2006, David Chinner wrote:
> On Thu, Aug 31, 2006 at 11:24:41AM +0200, Jens Axboe wrote:
> > XFS list,
> > 
> > On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
> > > Jens Axboe wrote:
> > > >On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
> > > >  
> > > >>I tried your splie-git...tar.gz file and tried the splice-cp.  It 
> > > >>produced files that are the right length... but the files only contain 
> > > >>nulls.  Here's the straces:
> > > >>    
> > > >
> > > >Works for me as well. Could be an fs issue, how large was the README and
> > > >what filesystem did you use?
> > > >
> > > >  
> > > The file was 1130 bytes (it was the README in that directory.)  The 
> > > filesystem is XFS.
> > > 
> > 
> > I can reproduce this quite easily, doing:
> > 
> > nelson:~ # splice-cp sda.blktrace.0 foo
> > 
> > nelson:~ # md5sum sda.blktrace.0 foo
> > 4754070ae77091468c830ea23b125d68  sda.blktrace.0
> > efdc7b9d00692fdfe91a691277209267  foo
> 
> Busted write side - splice-in works fine, splice-out is an alias
> for /dev/zero. The reason it's full of NULLs:
> 
> death:/mnt# xfs_bmap -vv foo
> foo: no extents
> death:/mnt#
> 
> It's a hole.  Nothing has been flushed out to disk.
> 
> Interesting - the inode is leaving pipe_to_file() dirty, the page is
> dirty, the buffer head is dirty, delay, mapped and uptodate. The
> page is the only page in the radix tree and the radix tree is marked
> dirty.
> 
> But it never gets flushed out. Even when I use dd to seek past the
> first disk block and write further into the file, I still end up
> with a hole in the range where the original splice write should
> be which means it was no longer in the page cache.
> 
> Copying a large file I can see dirty memory increase to tens of
> megabytes.  Nothing is going to disk, writeback is not going above
> zero.  Interestingly, when the write completes, the size of the page
> cache drops by almost exactly the size of the file being written -
> almost like a truncate_inode_pages() is occuring on file close.
> 
> Oh, look - we _are_ tossing away all the pages on close.
> 
> xfs_splice_write() hasn't updated the xfs inode size when extending the
> file. The linux inode  has the correct value, but xfs thinks that it's
> only got a speculative allocation EOF (i.e. 0) so we invalidate it
> before it gets to disk.
> 
> The patch below just copies some code out of xfs_write() where it
> updates the xfs inode size and drops it in xfs_splice_write(). It's
> almost certainly not the right fix, but the bucket under the pipe will
> now catch most of the bits....

Good analysis and fix, Dave! I don't have time to test it right now,
perhaps Jeffrey can give it a shot? Will you make sure this gets into
2.6.18?

-- 
Jens Axboe
