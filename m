Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R1xbni012796 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 19:59:37 -0600
Date: Sun, 26 Feb 2012 19:59:41 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/8] xfs: merge xfs_qm_export_dquot into
	xfs_qm_scall_getquota
Message-ID: <20120227015941.GI7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022903.488870885@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022903.488870885@bombadil.infradead.org>
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

Hi Christoph,

On Sun, Feb 19, 2012 at 09:28:16PM -0500, Christoph Hellwig wrote:
> The is no good reason to have these two separate, and for the next change
> we would need the full struct xfs_dquot in xfs_qm_export_dquot, so better
> just fold the code now instead of changing it spuriously.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I should have replied to this patch, not the older rev.

I have a question about the error code, now we're not mapping errors to
EFAULT and we used do... which is correct?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
