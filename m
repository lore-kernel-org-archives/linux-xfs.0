Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UNOEtv048814 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 18:24:15 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0haFKYnQFIYFgzG0 for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 16:24:13 -0700 (PDT)
Date: Tue, 1 May 2012 09:24:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: separate buffer indexing from block map
Message-ID: <20120430232410.GP7015@dastard>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-3-git-send-email-david@fromorbit.com>
	<4F9EE7EC.4030203@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F9EE7EC.4030203@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 02:28:44PM -0500, Mark Tinguely wrote:
> On 04/24/12 01:33, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >To support discontiguous buffers in the buffer cache, we need to
> >separate the cache index variables from the I/O map. While this is
> >currently a 1:1 mapping, discontiguous buffer support will break
> >this relationship.
> >
> >However, for caching purposes, we can still treat them the same as a
> >contiguous buffer - the block number of the first block and the
> >length of the buffer - as that is still a unique representation.
> >Also, the only way we will ever access the discontiguous regions of
> >buffers is via bulding the complete buffer in the first place, so
> >using the initial block number and entire buffer length is a sane
> >way to index the buffers.
> >
> >Add a block mapping vector construct to the xfs_buf and use it in
> >the places where we are doing IO instead of the current
> >b_bn/b_length variables.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ...
> >+struct xfs_buf_map {
> >+	xfs_daddr_t		bm_bn;	/* block number for I/O */
> >+	int			bm_len;	/* size of I/O */
> >+};
> >+
> >  typedef struct xfs_buf {
> >  	/*
> >  	 * first cacheline holds all the fields needed for an uncontended cache
> >@@ -107,7 +114,7 @@ typedef struct xfs_buf {
> >  	 * fast-path on locking.
> >  	 */
> >  	struct rb_node		b_rbnode;	/* rbtree node */
> >-	xfs_daddr_t		b_bn;		/* block number for I/O */
> >+	xfs_daddr_t		b_bn;		/* block number of buffer */
> >  	int			b_length;	/* size of buffer in BBs */
> 
> Looks good.
> Do you plan to eventually remove b_bn and b_length from xfs_buf?

No. b_bn is a fast way of identifying unique buffers for cache
lookups and is located in the same cacheline as the tree node so we
don't take an extra cache miss on every buffer we traverse during
tree walks in _xfs_buf_find(). Also, b_length is used so often it is
much cleaner to keep it around than it s to iterate over all the
maps to calculate it every time it is needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
