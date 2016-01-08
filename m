Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8E887F37
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 18:16:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EDC7304039
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 16:16:10 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iZMKjJzLKstfHXZG for <xfs@oss.sgi.com>;
	Thu, 07 Jan 2016 16:16:05 -0800 (PST)
Date: Fri, 8 Jan 2016 11:15:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] block: introduce del_gendisk_queue()
Message-ID: <20160108001544.GQ21461@dastard>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160106045627.38788.90127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160106045627.38788.90127.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Tue, Jan 05, 2016 at 08:56:27PM -0800, Dan Williams wrote:
> Historically we have waited for filesystem specific heuristics to
> attempt to guess when a block device is gone.  Sometimes this works, but
> in other cases the system can hang waiting for the fs to trigger its
> shutdown protocol.
> 
> The initial motivation for this investigation was to prevent DAX
> mappings (direct mmap access to persistent memory) from leaking past the
> lifetime of the hosting block device.  However, Dave points out that
> these shutdown operations are needed in other scenarios.  Quoting Dave:
> 
>     For example, if we detect a free space corruption during allocation,
>     it is not safe to trust *any active mapping* because we can't trust
>     that we having handed out the same block to multiple owners. Hence
>     on such a filesystem shutdown, we have to prevent any new DAX
>     mapping from occurring and invalidate all existing mappings as we
>     cannot allow userspace to modify any data or metadata until we've
>     resolved the corruption situation.
> 
> The current block device shutdown sequence of del_gendisk +
> blk_cleanup_queue is problematic.  We want to tell the fs after
> blk_cleanup_queue that there is no possibility of recovery, but by that
> time we have deleted partitions and lost the ability to find all the
> super-blocks on a block device.
> 
> del_gendisk_queue() combines block device shutdown, blk_cleanup_queue(),
> with block device end of life notification, del_gendisk().  A later
> patch builds on this sequence to additionally communicate to the fs that
> it should force-fail all future i/o since the queue is permanently dead.

This still is two changes in one. Adding the force failure feature
is a separate change to creating del_gendisk_queue().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
