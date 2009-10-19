Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J3rGY2025411 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 22:53:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D426155AB
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:54:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id U1Qk6ttGdviP9cNz for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:54:27 -0700 (PDT)
Date: Sun, 18 Oct 2009 23:54:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091019035426.GB18296@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
	<20091019011600.GO9464@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091019011600.GO9464@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Schreurs <patrick@news-service.com>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Mon, Oct 19, 2009 at 12:16:00PM +1100, Dave Chinner wrote:
> > +	 * The hash lock here protects a thread in xfs_iget from racing with
> > +	 * us on recycling the inode.  Once we have the XFS_IRECLAIM flag set
> > +	 * it will not touch it.
> >  	 */
> > -	write_lock(&pag->pag_ici_lock);
> 
> Did you mean to remove this write_lock? The patch does not remove
> the unlocks....

It's taken by the caller.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
