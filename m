Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASDUnal182112 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 07:30:49 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YzHwZmNwJ16XdPyd (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 05:33:06 -0800 (PST)
Date: Wed, 28 Nov 2012 08:33:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121128133305.GA7426@infradead.org>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1354068063-1692-3-git-send-email-david@fromorbit.com>
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

On Wed, Nov 28, 2012 at 01:01:01PM +1100, Dave Chinner wrote:
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

Look good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
