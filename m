Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GH9eJP262044 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:09:40 -0500
Date: Fri, 16 Apr 2010 13:11:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: kill off l_sectbb_mask
Message-ID: <20100416171136.GE2729@infradead.org>
References: <1271355460.2680.94.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271355460.2680.94.camel@doink>
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
Cc: xfs@oss.sgi.com

On Thu, Apr 15, 2010 at 01:17:40PM -0500, Alex Elder wrote:
> There remains only one user of the l_sectbb_mask field in the log
> structure.  Just kill it off and compute the mask where needed
> from the power-of-2 sector size.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
