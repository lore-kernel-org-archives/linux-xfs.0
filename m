Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9K3dJ4p119884 for <xfs@oss.sgi.com>; Mon, 19 Oct 2009 22:39:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15AE2117C2C2
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2009 20:40:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	0qHVX20oS0lby0Fd for <xfs@oss.sgi.com>;
	Mon, 19 Oct 2009 20:40:51 -0700 (PDT)
Date: Tue, 20 Oct 2009 14:40:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091020034048.GA9464@discord.disaster>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
	<20091019011600.GO9464@discord.disaster>
	<20091019035426.GB18296@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091019035426.GB18296@infradead.org>
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
Cc: Patrick Schreurs <patrick@news-service.com>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Sun, Oct 18, 2009 at 11:54:26PM -0400, Christoph Hellwig wrote:
> On Mon, Oct 19, 2009 at 12:16:00PM +1100, Dave Chinner wrote:
> > > +	 * The hash lock here protects a thread in xfs_iget from racing with
> > > +	 * us on recycling the inode.  Once we have the XFS_IRECLAIM flag set
> > > +	 * it will not touch it.
> > >  	 */
> > > -	write_lock(&pag->pag_ici_lock);
> > 
> > Did you mean to remove this write_lock? The patch does not remove
> > the unlocks....
> 
> It's taken by the caller.

Ah, I guess I need to see the whole patch series, then.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
