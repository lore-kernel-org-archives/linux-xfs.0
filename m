Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN7YwZf041675 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 01:34:59 -0600
Date: Fri, 23 Nov 2012 02:37:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix the buffer log format for contiguous buffers
Message-ID: <20121123073708.GA5159@infradead.org>
References: <20121120224120.224166649@sgi.com>
	<20121120224146.479983109@sgi.com> <20121123014714.GB32450@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121123014714.GB32450@dastard>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Fri, Nov 23, 2012 at 12:47:14PM +1100, Dave Chinner wrote:
> This debug code is a lot more broken than just this. It's completely
> unaware of discontiguous buffers....
> 
> I'm wondering if we should just remove the XFS_TRANS_DEBUG code
> because it doesn't ever get used....

As far as I know it has been unused since I started working on XFS,
so removing it sounds fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
