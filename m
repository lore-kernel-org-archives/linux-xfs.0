Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1THeGWJ035736 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 11:40:16 -0600
Date: Wed, 29 Feb 2012 11:40:19 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/8] xfs: merge xfs_qm_export_dquot into
	xfs_qm_scall_getquota
Message-ID: <20120229174019.GJ7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022903.488870885@bombadil.infradead.org>
	<20120227015941.GI7762@sgi.com>
	<20120227171727.GA22046@infradead.org>
	<20120227172310.GH28391@sgi.com>
	<20120228032740.GA18306@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228032740.GA18306@infradead.org>
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

On Mon, Feb 27, 2012 at 10:27:40PM -0500, Christoph Hellwig wrote:
> On Mon, Feb 27, 2012 at 11:23:10AM -0600, Ben Myers wrote:
> > On Mon, Feb 27, 2012 at 12:17:27PM -0500, Christoph Hellwig wrote:
> > > > I should have replied to this patch, not the older rev.
> > > > 
> > > > I have a question about the error code, now we're not mapping errors to
> > > > EFAULT and we used do... which is correct?
> > > 
> > > The old one looks finshy, but we even if we changed it it should be
> > > in a separate patch with a good description.  I'll resend with this bit
> > > fixed.
> > 
> > Sounds great.  ;)
> 
> Actually the patch is fine as-is.  If you look at the old
> xfs_qm_scall_getquota we'd return any error we get from xfs_qm_dqget
> as-is, and return ENOENT if XFS_IS_DQUOT_UNINITIALIZED is true.  The
> place where any other error is converted to EFAULT is never actually
> reached.

Apologies.. I see it now.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
