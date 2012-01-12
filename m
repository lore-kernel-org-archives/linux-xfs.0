Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CHoGpR009522 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:50:16 -0600
Date: Thu, 12 Jan 2012 11:50:16 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
Message-ID: <20120112175016.GV20739@sgi.com>
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com> <4F0DF9C1.2060302@sgi.com>
	<20120112162210.GA3925@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120112162210.GA3925@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jeff.liu@oracle.com, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hey,

On Thu, Jan 12, 2012 at 11:22:10AM -0500, Christoph Hellwig wrote:
> With all the complications that we got compared to the initial version,
> namely multiple hole extents, dirty unwritten extent detection and
> so on I think it's time to stop using xfs_bmapi_read against Dave's
> initial suggestion, and switch to using xfs_bmap_search_extents
> directly.
> 
> The rationale for that is that
> 
>   a) using xfs_bmapi_read makes hole detection more complex, given
>      that it has to fill potentially multiple xfs_bmbt_irec structures
>      instead of skipping over them
>   b) reading two extents at a time means we have to duplicate all the
>      detection code.
    c) having a cursor here means that Jeff can always get the job done
       with a single btree search, which could be an important
       optimisation for heavily preallocated workloads.

> if we use xfs_bmap_search_extents we need a bit of boilerplate code,
> but xfs_seek_data becomes really simple - we just loop over
> xfs_bmap_search_extents until we either find an extent or EOF.
> If we find an extent and it's unwritten we might have to probe for
> dirty areas from one single point, or just skip it but the code is
> still simple.  xfs_seek_hole is just as simple - if
> xfs_bmap_search_extents fits the condition for a hole as written
> down in xfs_bmapi_read we've found it, if not we might again have
> to do the unwritten extent probing, but just from a single place
> instead of duplicating it twice.

I agree that this is a good idea.  I would like to reiterate my
suggestion that Jeff go for the 'simple' implementation (assume
unwritten extents contain data) before going about scanning unwritten
extents for holes/data.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
