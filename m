Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C1B7k9159296 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 20:11:07 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZWOvHa8BZ9nwouGH for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 18:11:05 -0700 (PDT)
Date: Tue, 12 Jun 2012 11:11:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: xfs_release don't free eofblocks with extsize hint
Message-ID: <20120612011102.GJ22848@dastard>
References: <20120611192948.GX29173@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120611192948.GX29173@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2012 at 02:29:48PM -0500, Ben Myers wrote:
> Testing has shown that there is a regression when using extent size
> hints with NFS.  There are many more extents created than expected.
> 
> This is the workload, from a single NFS client:
> # for e in `seq 1 8`;
> do
> 	mkdir -p $e; (cd $e; dd if=/dev/zero of=file bs=4096k count=100) &
> done
> 
> # xfs_io -c extsize .
> [16777216] .
> 
> Here is the extent count for each file without this patch:
> 
> 385 387 387 387 400 398 379 334

So it is a 400MB file with roughly 400 1MB extents? IOWs, you're
getting one extent per 1MB NFS write over the wire?

Why aren't the extents being allocated adjacently? The allocator is
supposed to taka the last block of the previous adjacent extent as
the hint for the location of the new extent. This result implies
that either the allocator is broken or you are crossing the streams.
How many AGs do you have in your filesystem?

I just ran that test with a filesystem that has more than 8 AGs, and
the result it a single extent per file. When I have less than 8 AGs,
there is contention at the AG level for allocation, and the result
is allocation interleaving giving the above fragmentation levels.

So the allocator is working just fine, it's just that your
configuration is causing the streams to interleave, just like
delalloc used to before the speculative prealloc beyond EOF changes
in 2.6.38. (i.e. the I_DIRTY_RELEASE flag)

> In a comparison of traces, one with the above workload run locally and
> the other with the above workload over NFS, there were occasional calls
> to xfs_free_eofblocks in NFS but not on local workloads.  These turned
> out to be from xfs_release.

The reason that xfs_release() is doing this for NFS is that the
I_DIRTY_RELEASE mitigation code triggers off delayed allocation
blocks on the inode, and preallocation does not result in delalloc
being present.


> Not calling xfs_free_eofblocks when using the extent size hint resolves this
> issue when using extsize hints and NFS.  I suspect that delayed allocation
> mitigated the effect of xfs_free_eofblocks until commit aff3a9ed.

No, the I_DIRTY_RELEASE code is what mitigated the effect for
delayed allocation.  Using preallocation for extsize hints does not
result in delalloc being present, hence this stopped working for
such files.

So this could be fixed simply by checking for dirty pages whenteh
extentsize hint is set after eof truncation, just like we do for
delalloc. i.e:

	if (ip->i_delayed_blks ||
	    ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) &&
	     mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY)))
		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);

Alternatively, (and I think a better solution) is to treat files
with extent size hints on them exactly the same as files with
preallocation on them. i.e. in xfs_set_diflags() we set
XFS_DIFLAG_PREALLOC at the same time we set the XFS_DIFLAG_EXTSIZE,
and then all our truncate logic just works as expected for
physical preallocation beyond EOF on extsize hint files without
changing anything else....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
