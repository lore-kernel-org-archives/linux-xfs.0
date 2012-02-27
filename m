Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RHHbp2107684 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 11:17:41 -0600
Date: Mon, 27 Feb 2012 12:17:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: merge xfs_qm_export_dquot into
	xfs_qm_scall_getquota
Message-ID: <20120227171727.GA22046@infradead.org>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022903.488870885@bombadil.infradead.org>
	<20120227015941.GI7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120227015941.GI7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> I should have replied to this patch, not the older rev.
> 
> I have a question about the error code, now we're not mapping errors to
> EFAULT and we used do... which is correct?

The old one looks finshy, but we even if we changed it it should be
in a separate patch with a good description.  I'll resend with this bit
fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
