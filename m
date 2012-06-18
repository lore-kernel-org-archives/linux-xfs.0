Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IKcsVx236436 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 15:38:54 -0500
Date: Mon, 18 Jun 2012 15:39:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/9] xfs: separate buffer indexing from block map
Message-ID: <20120618203919.GW4721@sgi.com>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339133914-11148-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Fri, Jun 08, 2012 at 03:38:26PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To support discontiguous buffers in the buffer cache, we need to
> separate the cache index variables from the I/O map. While this is
> currently a 1:1 mapping, discontiguous buffer support will break
> this relationship.
> 
> However, for caching purposes, we can still treat them the same as a
> contiguous buffer - the block number of the first block and the
> length of the buffer - as that is still a unique representation.
> Also, the only way we will ever access the discontiguous regions of
> buffers is via bulding the complete buffer in the first place, so
> using the initial block number and entire buffer length is a sane
> way to index the buffers.
> 
> Add a block mapping vector construct to the xfs_buf and use it in
> the places where we are doing IO instead of the current
> b_bn/b_length variables.

This patch does not apply even with Jan's patch.  Merged it manually.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
