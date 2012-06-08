Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58NDOG4014527 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 18:13:24 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rkBcmZa0mJzRFEw3 for <xfs@oss.sgi.com>;
	Fri, 08 Jun 2012 16:13:22 -0700 (PDT)
Date: Sat, 9 Jun 2012 09:13:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: xfs_vm_writepage clear iomap_valid when
	!buffer_uptodate (REV2)
Message-ID: <20120608231320.GZ22848@dastard>
References: <20120601192207.D6DE99F997@arenaud-laptop>
	<20120605114516.GM4347@dastard> <4FCDFCE5.5020702@sgi.com>
	<4FD253D6.9060909@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD253D6.9060909@sgi.com>
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
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 08, 2012 at 03:34:46PM -0400, Alain Renaud wrote:
> 
>   On filesytems with a block size smaller than PAGE_SIZE we currently have
> a problem with unwritten extents.  If a we have multi-block page for
> which an unwritten extent has been allocated, and only some of the
> buffers have been written to, and they are not contiguous, we can expose
> stale data from disk in the blocks between the writes after extent
> conversion.
> 
> Example of a page with unwritten and real data.
> buffer  content
> 0       empty  b_state = 0
> 1       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
> 2       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
> 3       empty  b_state = 0
> 4       empty  b_state = 0
> 5       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
> 6       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
> 7       empty  b_state = 0
> 
> Buffers 1, 2, 5, and 6 have been written to, leaving 0, 3, 4, and 7 empty.
> Currently buffers 1, 2, 5, and 6 are added to a single ioend, and when IO has
> completed, extent conversion creates a real extent from block 1 through block
> 6, leaving 0 and 7 unwritten.  However buffers 3 and 4 were not written to
> disk, so stale data is exposed from those blocks on a subsequent read.
> 
> Fix this by setting iomap_valid = 0 when we find a buffer that is not
> Uptodate.  This ensures that buffers 5 and 6 are not added to the same
> ioend as buffers 1 and 2.  Later these blocks will be converted into two
> separate real extents, leaving the blocks in between unwritten.
> 
> Signed-off-by: Alain Renaud <arenaud@sgi.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
