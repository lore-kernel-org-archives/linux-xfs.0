Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BBZ8d9161486 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 05:35:09 -0600
Date: Wed, 11 Jan 2012 06:35:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
Message-ID: <20120111113507.GB14423@infradead.org>
References: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs masters <xfs-masters@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>

On Fri, Jan 06, 2012 at 04:42:18PM +0530, Amit Sahrawat wrote:
> Removing the macro, as this is no more needed in the code. 
> Tried to find the reference when it was last used - but the usage 
> for this seemed to have been dropped long time ago.
> 
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>

This looks good, but the subject should be something like:

"xfs: kill the unused XFS_BB_FSB_OFFSET macro"


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
