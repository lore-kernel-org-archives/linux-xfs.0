Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RHN57S107943 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 11:23:05 -0600
Date: Mon, 27 Feb 2012 11:23:10 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/8] xfs: merge xfs_qm_export_dquot into
	xfs_qm_scall_getquota
Message-ID: <20120227172310.GH28391@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022903.488870885@bombadil.infradead.org>
	<20120227015941.GI7762@sgi.com>
	<20120227171727.GA22046@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120227171727.GA22046@infradead.org>
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

On Mon, Feb 27, 2012 at 12:17:27PM -0500, Christoph Hellwig wrote:
> > I should have replied to this patch, not the older rev.
> > 
> > I have a question about the error code, now we're not mapping errors to
> > EFAULT and we used do... which is correct?
> 
> The old one looks finshy, but we even if we changed it it should be
> in a separate patch with a good description.  I'll resend with this bit
> fixed.

Sounds great.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
