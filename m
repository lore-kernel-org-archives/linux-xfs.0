Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfCRMkm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Mar 2019 08:40:42 -0400
Date: Mon, 18 Mar 2019 08:40:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190318124039.GA17956@bfoster>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259894630.30230.10064390935593758177.stgit@magnolia>
 <20190314230841.GJ23020@dastard>
 <20190315031302.GF4929@magnolia>
 <20190315034038.GK23020@dastard>
 <20190315122939.GB5182@bfoster>
 <20190317224011.GO23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317224011.GO23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Mar 18, 2019 at 09:40:11AM +1100, Dave Chinner wrote:
> On Fri, Mar 15, 2019 at 08:29:40AM -0400, Brian Foster wrote:
> > On Fri, Mar 15, 2019 at 02:40:38PM +1100, Dave Chinner wrote:
> > > > If the delalloc extent crosses EOF then I think it makes sense to map it
> > > > in as unwritten, issue the write, and convert the extent to real during
> > > > io completion, and not split it up just to avoid having unwritten
> > > > extents past EOF.
> > > 
> > > Yup, makes sense. For a sequential write, they should always be
> > > beyond EOF. For anything else, we use unwritten.
> > > 
> > 
> > I'm not quite sure I follow the suggested change in behavior here tbh so
> > maybe this is not an issue, but another thing to consider is whether
> > selective delalloc -> real conversion for post-eof extents translates to
> > conditional stale data exposure vectors in certain file extension
> > scenarios.
> 
> No, it doesn't because the transaction that moves EOF is done after
> the data write into the region it exposes is complete. hence the
> device cache flush that occurs before the log write containing the
> transaction that moves the EOF will always result in the data being
> on stable storage *before* the extending szie transaction hits the
> journal and exposes it.
> 

Ok, but this ordering alone doesn't guarantee the data we've just
written is on-disk before the transaction hits the log.

> > I think even the post-eof zeroing code may be susceptible to
> > this problem if the log happens to push after a truncate transaction
> > commits but before the associated dirty pages are written back..
> 
> That's what this code in xfs_setattr_size() handles:
> 
>         /*
>          * We are going to log the inode size change in this transaction so
>          * any previous writes that are beyond the on disk EOF and the new
>          * EOF that have not been written out need to be written here.  If we
>          * do not write the data out, we expose ourselves to the null files
>          * problem. Note that this includes any block zeroing we did above;
>          * otherwise those blocks may not be zeroed after a crash.
>          */
>         if (did_zeroing ||
>             (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
>                 error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
>                                                 ip->i_d.di_size, newsize - 1);
>                 if (error)
>                         return error;
>         }
> 

Ah, I forgot about this code. So this combined with the above provides
correctness for this particular case with respect to stale data exposure
after a crash. AFAICT this is still a performance tradeoff as the
zeroing may not be necessary if the post-eof extents happened to be
unwritten. This optimization is also achieved "for free" in this path
because did_zeroing is only set if iomap had to physically zero some
pages.

This also only covers one extension scenario. It looks like the typical
write extend scenario is intended to be handled similarly by submitting
the di_size update transaction from data write completion. It looks to
me that this should be fairly robust in most common cases (i.e.,
background writeback and/or fsync()), but I'm not totally convinced this
is always robust because write time extension doesn't perform the same
kind of writeback ordering as the truncate example above.

Consider sync_file_range() for example. Suppose we have a large,
physical post-eof prealloc extent and perform a sparse extended write to
the last block of that extent followed by a sync_file_range() of the
just written data. The file write should physically zero the pagecache
for the preallocated region before the write, then the proper write
completes and returns. Nothing has changed on disk so far. A
sync_file_range() call sets the range start/end in the writeback_control
and works its way through __filemap_fdatawrite_range() to
write_cache_pages() and our writeback mechanism for the requested pages
only. From there, the same logic applies as for background writeback: we
issue writeback and I/O completion commits a file extension transaction.
AFAICT, nothing has guaranteed writeback has even initiated on any of
the zeroed pages over the non-unwritten extent that has just been pulled
within EOF, which means we are susceptible to stale data exposure until
that happens.

While reasoning about this I realized this should be pretty easy to
test:

- pre-seed a small fs with a data pattern (0xab)
- mount with a 1mb alloc size (for ease of test)
- run something like the following (uses default 0xcd data pattern)

# xfs_io -f -x -c "pwrite 0 4k" -c fsync -c "pwrite 32k 4k" \
	-c "sync_range -w 32k 4k" -c "sync_range -b 32k 4k" \
	-c "shutdown -f" /mnt/file

- remount and check the file:

# hexdump /mnt/file                                                                                                                                                                                                         
0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001000 abab abab abab abab abab abab abab abab
*
0008000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0009000

... which clearly shows stale data exposure. Hmm, this might actually be
a good fstest if we don't have one already. 

Brian

>         error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> 
> i.e. it ensures the data and post-eof zeroing is on disk before the
> truncate transaction is started. We already hold the IOLOCK at this
> point and drained in-flight direct IO, so no IO that can affect the
> truncate region will begin or be in progress after the flush and
> wait above is complete.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
