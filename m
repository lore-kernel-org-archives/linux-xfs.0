Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGRFDk188293 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:27:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 449E81F1F832
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:27:15 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PaoRntsXmBwrlsF9 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 09:27:15 -0700 (PDT)
Date: Mon, 10 Oct 2011 12:27:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: make 203 pass on non-default block size
	filesystems
Message-ID: <20111010162714.GB11902@infradead.org>
References: <1318212855-20212-1-git-send-email-david@fromorbit.com>
	<1318212855-20212-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318212855-20212-3-git-send-email-david@fromorbit.com>
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

On Mon, Oct 10, 2011 at 01:14:15PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xfs_bmap output in the golden image is filesystem block size
> dependent. Make all writes 64k to ensure that the allocation/hole
> pattern is consistent across all supported filesystem block sizes.
> 
> Also, use the SCRATCH_DEV instead of the TEST_DEV so that we test
> according to MKFS_OPTIONS rather than test on whatever setup the
> TEST_DEV was created with.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
