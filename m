Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUG5F8A189465 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 10:05:15 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LZMg4ex64tsV8MgN (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 08:07:34 -0800 (PST)
Date: Fri, 30 Nov 2012 11:07:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4 V2] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121130160733.GE5667@infradead.org>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
	<20121129042633.GA6434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121129042633.GA6434@dastard>
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

On Thu, Nov 29, 2012 at 03:26:33PM +1100, Dave Chinner wrote:
> xfs: byte range granularity for XFS_IOC_ZERO_RANGE
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_IOC_ZERO_RANGE simply does not work properly for non page cache
> aligned ranges. Neither test 242 or 290 exercise this correctly, so
> the behaviour is completely busted even though the tests pass.
> 
> Fix it to support full byte range granularity as was originally
> intended for this ioctl.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
