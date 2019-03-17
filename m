Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:28444 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727241AbfCQWkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Mar 2019 18:40:14 -0400
Date: Mon, 18 Mar 2019 09:40:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190317224011.GO23020@dastard>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259894630.30230.10064390935593758177.stgit@magnolia>
 <20190314230841.GJ23020@dastard>
 <20190315031302.GF4929@magnolia>
 <20190315034038.GK23020@dastard>
 <20190315122939.GB5182@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315122939.GB5182@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Mar 15, 2019 at 08:29:40AM -0400, Brian Foster wrote:
> On Fri, Mar 15, 2019 at 02:40:38PM +1100, Dave Chinner wrote:
> > > If the delalloc extent crosses EOF then I think it makes sense to map it
> > > in as unwritten, issue the write, and convert the extent to real during
> > > io completion, and not split it up just to avoid having unwritten
> > > extents past EOF.
> > 
> > Yup, makes sense. For a sequential write, they should always be
> > beyond EOF. For anything else, we use unwritten.
> > 
> 
> I'm not quite sure I follow the suggested change in behavior here tbh so
> maybe this is not an issue, but another thing to consider is whether
> selective delalloc -> real conversion for post-eof extents translates to
> conditional stale data exposure vectors in certain file extension
> scenarios.

No, it doesn't because the transaction that moves EOF is done after
the data write into the region it exposes is complete. hence the
device cache flush that occurs before the log write containing the
transaction that moves the EOF will always result in the data being
on stable storage *before* the extending szie transaction hits the
journal and exposes it.

> I think even the post-eof zeroing code may be susceptible to
> this problem if the log happens to push after a truncate transaction
> commits but before the associated dirty pages are written back..

That's what this code in xfs_setattr_size() handles:

        /*
         * We are going to log the inode size change in this transaction so
         * any previous writes that are beyond the on disk EOF and the new
         * EOF that have not been written out need to be written here.  If we
         * do not write the data out, we expose ourselves to the null files
         * problem. Note that this includes any block zeroing we did above;
         * otherwise those blocks may not be zeroed after a crash.
         */
        if (did_zeroing ||
            (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
                error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
                                                ip->i_d.di_size, newsize - 1);
                if (error)
                        return error;
        }

        error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);

i.e. it ensures the data and post-eof zeroing is on disk before the
truncate transaction is started. We already hold the IOLOCK at this
point and drained in-flight direct IO, so no IO that can affect the
truncate region will begin or be in progress after the flush and
wait above is complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
