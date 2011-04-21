Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LK6CQR172886 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 15:06:12 -0500
Subject: Re: [PATCH] xfs: add an x86 compat handler for XFS_IOC_ZERO_RANGE
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110421132103.GA3861@infradead.org>
References: <20110421132103.GA3861@infradead.org>
Date: Thu, 21 Apr 2011 15:08:36 -0500
Message-ID: <1303416516.2581.521.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2011-04-21 at 09:21 -0400, Christoph Hellwig wrote:
> XFS_IOC_ZERO_RANGE uses struct xfs_flock64, and thus requires argument
> translation for 32-bit binaries on x86.  Add the required
> XFS_IOC_ZERO_RANGE_32 defined and add it to the list of commands that
> require xfs_flock64 translation.  
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  That case was simply missed in commit 44722352
(xfs: Introduce XFS_IOC_ZERO_RANGE).

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
