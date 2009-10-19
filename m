Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J3piI1025331 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 22:51:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D625E11A5FAD
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:53:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 824Ph7zlGykezQS6 for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:53:17 -0700 (PDT)
Date: Sun, 18 Oct 2009 23:53:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091019035314.GA18296@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
	<89c4f90c0910150806g49c64037re550b478a7cf85e@mail.gmail.com>
	<20091018235910.GA30045@infradead.org>
	<20091019011710.GP9464@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091019011710.GP9464@discord.disaster>
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

On Mon, Oct 19, 2009 at 12:17:10PM +1100, Dave Chinner wrote:
> >  
> > +	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)) {
> > +		read_unlock(&pag->pag_ici_lock);
> > +		return ENOENT;
> > +	}
> 
> This needs an IRELE(ip) here, doesn't it?

No, the check is before the igrab now.  That was kinda the point as I
suspect that the igrab might be corrupting state of a reclaimable or
in reclaim inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
