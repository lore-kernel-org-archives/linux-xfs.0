Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TBiiwF044817 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 06:44:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF445B2619
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:45:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bepjsEfRY4nfhvbC for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 04:45:43 -0700 (PDT)
Date: Wed, 29 Sep 2010 07:45:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] [PATCH 3/3] xfs: do not use xfs_mod_incore_sb_batch
	for per-cpu counters
Message-ID: <20100929114543.GB14048@infradead.org>
References: <20100929072221.583672974@bombadil.infradead.org>
	<20100929072238.456748707@bombadil.infradead.org>
	<20100929112720.GN5665@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929112720.GN5665@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 09:27:20PM +1000, Dave Chinner wrote:
> > +out_undo_ifreecount:
> > +	if (ifreedelta)
> > +		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, ifreedelta, rsvd);
> > +out_undo_icount:
> > +	if (idelta)
> > +		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, idelta, rsvd);
> 
> These two should be -ifreedelta and -idelta, right?

Indeed, fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
