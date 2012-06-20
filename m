Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6faof250858 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:41:36 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	W2GrTthFdFNsrAAC for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 23:41:34 -0700 (PDT)
Date: Wed, 20 Jun 2012 16:41:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Fix overallocation in xfs_buf_allocate_memory()
Message-ID: <20120620064133.GF30705@dastard>
References: <1338935546-3914-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1338935546-3914-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, David Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, Jun 06, 2012 at 12:32:26AM +0200, Jan Kara wrote:
> Commit de1cbee which removed b_file_offset in favor of b_bn introduced a bug
> causing xfs_buf_allocate_memory() to overestimate the number of necessary
> pages. The problem is that xfs_buf_alloc() sets b_bn to -1 and thus effectively
> every buffer is straddling a page boundary which causes
> xfs_buf_allocate_memory() to allocate two pages and use vmalloc() for access
> which is unnecessary.
> 
> Dave says xfs_buf_alloc() doesn't need to set b_bn to -1 anymore since the
> buffer is inserted into the cache only after being fully initialized now.
> So just make xfs_buf_alloc() fill in proper block number from the beginning.
> 
> CC: David Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Hmmm, the

Reviewed-by: Dave Chinner <dchinner@redhat.com>

I sent yesterday doesn't appear to have made it to the list. Oh
well, try again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
