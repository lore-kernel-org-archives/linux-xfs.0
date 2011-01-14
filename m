Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0E0R05t195502 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 18:27:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D034A1D3065E
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:29:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	Wg8UCIlTXmBfV8R5 for <xfs@oss.sgi.com>;
	Thu, 13 Jan 2011 16:29:13 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	7452505-1927428
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 10:59:12 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1PdXXI-0004vC-K4
	for xfs@oss.sgi.com; Fri, 14 Jan 2011 11:29:00 +1100
Date: Fri, 14 Jan 2011 11:29:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Issues with delalloc->real extent allocation
Message-ID: <20110114002900.GF16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Folks,

I've noticed a few suspicious things trying to reproduce the
allocate-in-the-middle-of-a-delalloc-extent,

Firstly preallocation into delalloc ranges behaves in a unexpected
and dangerous way. Preallocation uses unwritten extents to avoid
stale data exposure, but when issued into a range that is covered by
a delalloc extent, it does not use unwritten extents.

The code that
causes this is in xfs_bmapi():

		/*
		 * Determine state of extent, and the filesystem.
		 * A wasdelay extent has been initialized, so
		 * shouldn't be flagged as unwritten.
		 */
		if (wr && xfs_sb_version_hasextflgbit(&mp->m_sb)) {
			if (!wasdelay && (flags & XFS_BMAPI_PREALLOC))
				got.br_state = XFS_EXT_UNWRITTEN;
		}

This seems to be incorrect to me - a "wasdelay" extent has not yet
been initialised - there's data in memory, but there is nothing on
disk and we may not write it for some time. If we crash after this
transaction is written but before any data is written, we expose
stale data.

Not only that, it allocates the _entire_ delalloc extent that spans
the preallocation range, even when the preallocation range is only 1
block and the delalloc extent covers gigabytes. hence we actually
expose a much greater range of the file to stale data exposure
during a crash than just eh preallocated range. Not good.

Secondly, I think we have the same expose-the-entire-delalloc-extent
-to-stale-data-exposure problem in ->writepage. This onnne, however,
is due to using BMAPI_ENTIRE to allocate the entire delalloc extent
the first time any part of it is written to. Even if we are only
writing a single page (i.e. wbc->nr_to_write = 1) and the delalloc
extent covers gigabytes. So, same problem when we crash.

Finally, I think the extsize based problem exposed by test 229 is a
also a result of allocating space we have no pages covering in the
page cache (triggered by BMAPI_ENTIRE allocation) so the allocated
space is never zeroed and hence exposes stale data.

A possible solution to all of these problems is to allocate delalloc
space as unwritten extents.  It's obvious to see how this solves the
first two cases, but the last one is a bit less obvious. That one is
solved by the fact that unwritten extent conversion does not get
extent size aligned, so any block we don't write data for will
remain in the unwritten state and therefore correctly return zeros
for any read...

The issues with this approach are really about the cost of unwritten
extent conversion and the impact on low memory operation. The cost
is mainly a CPU cost due to delayed logging, but that will be
significant if we have to do an unwritten conversion on every IO
completion. Batching is definitely possible and would mostly
alleviate the overhead, but does add complexity and especially
w.r.t. unwritten extent conversion sometimes requiring allocation to
complete.

The impact on low memory behaviour is less easy to define and
handle. Extent conversion can block needing memory, so if we need to
complete the extent conversion to free memory we deadlock. For
delalloc writes, we can probably mark IO complete and pages clean
before we do the conversion in a batched, async manner. That would
leaves us with the same structure as we currently have, but adds
more complexity because we now need to track extent ranges in
"conversion pending" state for subsequent reads and sync operations.
i.e. an extent in a pending state is treated like a real extent for
the purposes of reading, but conversion needs to be completed during
a sync operation.

Another possibility for just the ->writepage problem is that we
could make delalloc allocation in ->writepage more like and EFI/EFD
type operation. That is, we allocate the space and log all the
changes in an allocation intent transaction (basically the same as
the current allocation transaction) and then add an allocation done
transaction that is issued at IO completion that basically
manipulation won't require IO to complete. Effectively this would be
logging all the xfs_ioend structures. Then in log recovery we simply
convert any range that does not have a done transaction to
unwritten, thereby preventing stale data exposure. The down side to
this approach is that it needs new transactions and log recovery
code, so is not backwards compatible.

I think is probably a simpler solution with lower overhead compared
to allocating unwritten extents everywhere. It doesn't solve the
extsize problem, but that probably should be handled up at the
->aio_write level, not at the ->write_page level.  Similarly, the
preallocation issue could easily be handled with small changes to
xfs_bmapi()....

I'm sure there are other ways to solve these problems, but these two
are the ones that come to mind for me.  I'm open to other solutions
or ways to improve on these ones, especially if they are simpler. ;)
Anyone got any ideas or improvements?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
