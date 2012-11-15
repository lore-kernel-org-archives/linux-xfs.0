Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFGK8TS015120 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 10:20:08 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	aThBmeTRxHn9IEJM (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 08:22:13 -0800 (PST)
Date: Thu, 15 Nov 2012 11:22:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/32 V2] xfs: remove xfs_tosspages
Message-ID: <20121115162212.GB4019@infradead.org>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121114064247.GC1710@dastard>
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

On Wed, Nov 14, 2012 at 05:42:47PM +1100, Dave Chinner wrote:
> xfs: remove xfs_tosspages
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a buggy, unnecessary wrapper that is duplicating
> truncate_pagecache_range().
> 
> When replacing the call in xfs_change_file_space(), also ensure that
> the length being allocated/freed is always positive before making
> any changes. These checks are done in the lower extent manipulation
> functions, too, but we need to do them before any page cache
> operations.
> 
> Reported-by: Andrew Dahl <adahl@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good as long as Andrews fix is included.

I wonder if we should just fix the two places with checks for easy
backportability in a first patch and then have a second on top to
kill the useless wrapper?

Either way,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
