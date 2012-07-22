Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6M4v76R095575 for <xfs@oss.sgi.com>; Sat, 21 Jul 2012 23:57:09 -0500
Date: Sun, 22 Jul 2012 00:57:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] xfs: probe data buffer from page cache for unwritten
	extents
Message-ID: <20120722045703.GA17235@infradead.org>
References: <50091696.4000903@oracle.com> <5009A786.3080500@sgi.com>
	<500A4B24.40908@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <500A4B24.40908@oracle.com>
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
To: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Sat, Jul 21, 2012 at 02:24:36PM +0800, Jie Liu wrote:
> >Output:
> >
> >HOLE/DATA at 512K 786432 / 528384   <- undiscovered hole here
> >HOLE/DATA at 516K 786432 / 528384   <- okay, data but we should
> >                                        return next page as hole.
> >HOLE/DATA at 520K 532480 / 819200   <- hole is discovered because
> >                                       there is no trailing data
> Oops! for xfs_seek_hole(), I should use min_t() to pre-claculate
> offset before searching page cache.
> Thanks for your prompt feedback.  I'll do some extra tests and post
> the revised soon.

Yes, the above test cases should go into xfstests.

Thanks to both of you to spend all the effort on this feature.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
