Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB8137CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 17:40:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F9AC30404E
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 15:40:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XLIFSUHOS8A1BNfg for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 15:40:14 -0700 (PDT)
Date: Wed, 1 Jun 2016 08:39:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix broken multi-fsb buffer logging
Message-ID: <20160531223956.GF12670@dastard>
References: <1464204667-10199-1-git-send-email-bfoster@redhat.com>
	<20160531083252.GR26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160531083252.GR26977@dastard>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, May 31, 2016 at 06:32:52PM +1000, Dave Chinner wrote:
> On Wed, May 25, 2016 at 03:31:07PM -0400, Brian Foster wrote:
> > Multi-block buffers are logged based on buffer offset in
> > xfs_trans_log_buf(). xfs_buf_item_log() ultimately walks each mapping in
> > the buffer and marks the associated range to be logged in the
> > xfs_buf_log_format bitmap for that mapping. This code is broken,
> > however, [....]
> 
> [snip description I've not read, and go look at the code changes]

....

> So from the code perspective the change looks correct. I've looked
> over all the other users of bp->b_maps[i].bm_len and loops over
> bli_format_count and I can't see any other obvious problems. I'm
> going to leave this under test overnight and see if anything pops
> up...

Passes all the tests I've thrown at it. multiple xfstests runs on
multiple machines with dir block sizes from 16k to 64k, fsmark runs
with 16k and 64k block sizes, dbench stress loops with up to 500
processes running at once, etc.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

I'll commit this when I get to updating the xfs trees now that
the merge window has closed and 4.7-rc1 is out. Hopefully that will
be later today....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
