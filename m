Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G5E3OW245808 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 00:14:03 -0500
Date: Fri, 16 Jul 2010 01:17:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: track AGs with reclaimable inodes in per-ag
	radix tree
Message-ID: <20100716051700.GB29915@infradead.org>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-2-git-send-email-david@fromorbit.com>
	<1279216900.2054.28.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279216900.2054.28.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, Jul 15, 2010 at 01:01:40PM -0500, Alex Elder wrote:
> Using the same tag represent a perag with reclaimable
> inodes as the tag representing an inode is reclaimable
> is nicely consistent...

Oh, didn't notice that when reviewing it.  Not sure I like it
too much.  If we ever grow more tags on the perag tree this
might get rather confusing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
