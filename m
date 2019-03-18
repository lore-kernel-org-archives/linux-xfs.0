Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfCRVuR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Mar 2019 17:50:17 -0400
Date: Mon, 18 Mar 2019 17:50:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190318215014.GA21231@bfoster>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259894630.30230.10064390935593758177.stgit@magnolia>
 <20190314230841.GJ23020@dastard>
 <20190315031302.GF4929@magnolia>
 <20190315034038.GK23020@dastard>
 <20190315122939.GB5182@bfoster>
 <20190317224011.GO23020@dastard>
 <20190318124039.GA17956@bfoster>
 <20190318203506.GQ23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190318203506.GQ23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Mar 19, 2019 at 07:35:06AM +1100, Dave Chinner wrote:
> On Mon, Mar 18, 2019 at 08:40:39AM -0400, Brian Foster wrote:
> > On Mon, Mar 18, 2019 at 09:40:11AM +1100, Dave Chinner wrote:
> > > On Fri, Mar 15, 2019 at 08:29:40AM -0400, Brian Foster wrote:
> > > > On Fri, Mar 15, 2019 at 02:40:38PM +1100, Dave Chinner wrote:
> > > > > > If the delalloc extent crosses EOF then I think it makes sense to map it
> > > > > > in as unwritten, issue the write, and convert the extent to real during
> > > > > > io completion, and not split it up just to avoid having unwritten
> > > > > > extents past EOF.
> > > > > 
> > > > > Yup, makes sense. For a sequential write, they should always be
> > > > > beyond EOF. For anything else, we use unwritten.
> > > > > 
> > > > 
> > > > I'm not quite sure I follow the suggested change in behavior here tbh so
> > > > maybe this is not an issue, but another thing to consider is whether
> > > > selective delalloc -> real conversion for post-eof extents translates to
> > > > conditional stale data exposure vectors in certain file extension
> > > > scenarios.
> > > 
> > > No, it doesn't because the transaction that moves EOF is done after
> > > the data write into the region it exposes is complete. hence the
> > > device cache flush that occurs before the log write containing the
> > > transaction that moves the EOF will always result in the data being
> > > on stable storage *before* the extending szie transaction hits the
> > > journal and exposes it.
> > > 
> > 
> > Ok, but this ordering alone doesn't guarantee the data we've just
> > written is on-disk before the transaction hits the log.
> 
> Which transaction are you talking about? This ordering guarantees
> that the data is on stable storage before the EOF size change
> transactions that exposes the region is on disk (that's the whole
> point of updates after data writes).
> 
> If you are talking about the allocation transaction taht we are
> going to write the data into, then you are right that it doesn't
> guarantee that the data is on disk before that commits, but when the
> allocation is beyond EOF it doesn't matter ebcause is won't be
> exposed until after the data is written and the EOF moving
> transaction is committed.
> 

The extending transaction that you referred to above and with respect to
the device cache flush. I'm simply saying that the transaction has to be
ordered with respect to full writeback completion as well, which is also
what you are saying further down. (We're in agreement... ;)).

> As I've previously proposed, what I suspect we should be doing is
> not commiting the allocation transaction until IO completion, which
> closes this stale data exposure hole completely and removes the need
> for allocating unwritten extentsi and then having to convert them.
> Direct IO could also do this, and so it could stop using unwritten
> extents, too....
> 

That sounds like an interesting (and potentially more efficient)
alternative to using unwritten extents across the board only to convert
them as I/Os complete. I guess we'd need to make sure that the
allocation transaction holds across potentially many ioends considering
the max extents size of 8GB or so. I suppose the locking and handling of
fragmented allocation cases could get a bit interesting there as well,
but it's probably worth a prototype attempt at least to survey the
concept... (I wonder if Darrick is still paying attention or found
something more interesting to do..? :D)

I also assume we'd still need to use unwritten extents for cases where
the allocation completes before all of the extent is within EOF (i.e.,
the extent zeroing idea you mentioned on irc..).

> > > > I think even the post-eof zeroing code may be susceptible to
> > > > this problem if the log happens to push after a truncate transaction
> > > > commits but before the associated dirty pages are written back..
> > > 
> > > That's what this code in xfs_setattr_size() handles:
> > > 
> > >         /*
> > >          * We are going to log the inode size change in this transaction so
> > >          * any previous writes that are beyond the on disk EOF and the new
> > >          * EOF that have not been written out need to be written here.  If we
> > >          * do not write the data out, we expose ourselves to the null files
> > >          * problem. Note that this includes any block zeroing we did above;
> > >          * otherwise those blocks may not be zeroed after a crash.
> > >          */
> > >         if (did_zeroing ||
> > >             (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
> > >                 error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> > >                                                 ip->i_d.di_size, newsize - 1);
> > >                 if (error)
> > >                         return error;
> > >         }
> > > 
> > 
> > Ah, I forgot about this code. So this combined with the above provides
> > correctness for this particular case with respect to stale data exposure
> > after a crash. AFAICT this is still a performance tradeoff as the
> > zeroing may not be necessary if the post-eof extents happened to be
> > unwritten. This optimization is also achieved "for free" in this path
> > because did_zeroing is only set if iomap had to physically zero some
> > pages.
> > 
> > This also only covers one extension scenario. It looks like the typical
> > write extend scenario is intended to be handled similarly by submitting
> > the di_size update transaction from data write completion. It looks to
> > me that this should be fairly robust in most common cases (i.e.,
> > background writeback and/or fsync()), but I'm not totally convinced this
> > is always robust because write time extension doesn't perform the same
> > kind of writeback ordering as the truncate example above.
> 
> It depends on IO completion order as to whether writeback is truly
> robust. Calling filemap_write_and_wait_range() doesn't change that,
> because it doesn't strictly order IO completions and so we can still
> expose a region under IO that hasn't been signalled as complete by
> the hardware.
> 

Indeed.

> > Consider sync_file_range() for example.
> 
> sync_file_range() is not a data integrity operation - it does not
> ensure disk caches are flushed and so cannot provide any crash
> guarantees. hence we can completely ignore when we talk about data
> integrity operations - it's no different from normal writeback.
> 

Of course. I am by no means claiming sync_file_range() is an integrity
operation. Technically neither is background writeback, even though the
latter has fairly predictable behavior. I'm simply using
sync_file_range() as an example and means to simulate out of order
writeback for test purposes.

> > Suppose we have a large,
> > physical post-eof prealloc extent and perform a sparse extended write to
> > the last block of that extent followed by a sync_file_range() of the
> > just written data. The file write should physically zero the pagecache
> > for the preallocated region before the write, then the proper write
> > completes and returns. Nothing has changed on disk so far. A
> > sync_file_range() call sets the range start/end in the writeback_control
> > and works its way through __filemap_fdatawrite_range() to
> > write_cache_pages() and our writeback mechanism for the requested pages
> > only. From there, the same logic applies as for background writeback: we
> > issue writeback and I/O completion commits a file extension transaction.
> > AFAICT, nothing has guaranteed writeback has even initiated on any of
> > the zeroed pages over the non-unwritten extent that has just been pulled
> > within EOF, which means we are susceptible to stale data exposure until
> > that happens.
> 
> Yup, yet another reason why sync_file_range() is useless as a data
> integrity operation. I've had to explain this repeatedly to people
> over the past 10-15 years, and eventually the man page was updated
> with this:
> 
> Warning
> 	This  system  call  is extremely dangerous and should not be
> 	used in portable programs.  None of these operations writes
> 	out the file's meta¿ data.  Therefore, unless the
> 	application is strictly performing overwrites of
> 	already-instantiated disk blocks, there are no guarantees
> 	that the  data will be available after a crash.  There is no
> 	user interface to know if a write is purely an overwrite.
> 	On filesystems using copy- on-write semantics (e.g., btrfs)
> 	an overwrite of existing allocated blocks  is  impossible.
> 	When writing  into  preallocated  space,  many filesystems
> 	also  require calls into the block allocator, which this
> 	system call does not sync out to disk.  This system call
> 	does not flush disk write caches and thus does not provide
> 	any data integrity on systems with volatile disk write
> 	caches.
> 
> > 
...
> 
> Yup, but keep in mind this is exactly what is expected from using
> sync_file_range(). Friends don't let friends use sync_file_range()
> because it's a guaranteed vector for user data corruption and stale
> data exposure.
> 

Again, I'm using sync_file_range() as a dumb lever to control writeback
completion ordering. It's a test tool for my purposes and not something
I'd suggest for use otherwise or that should inherently provide
integrity guarantees. Please don't get distracted reading more into it
than that. We can induce the exact same writeback behavior and stale
data exposure problem using something like hole punch instead, for
example, and it's just as reliable a reproducer.

The broader point is that by controlling writeback ordering, we can
explicitly demonstrate stale data exposure. If fixed properly, we should
never expect stale data exposure even in the event of out of order
writeback completion, regardless of the cause.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
