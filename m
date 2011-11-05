Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA59XKil148572 for <xfs@oss.sgi.com>; Sat, 5 Nov 2011 04:33:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8770C223485
	for <xfs@oss.sgi.com>; Sat,  5 Nov 2011 02:33:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AtQbrrQFrZ6NyR4G for <xfs@oss.sgi.com>;
	Sat, 05 Nov 2011 02:33:19 -0700 (PDT)
Date: Sat, 5 Nov 2011 05:33:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfsprogs: fix various incorrect printf formats
Message-ID: <20111105093317.GB5303@infradead.org>
References: <20111025115233.GB22103@infradead.org>
	<20111025155916.GA19818@stranger.qboosh.pl>
	<20111102092012.GA3808@infradead.org>
	<20111105090029.GA15258@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111105090029.GA15258@stranger.qboosh.pl>
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
To: Jakub Bogusz <qboosh@pld-linux.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> >  			do_warn(
> > -_("inode 0x%" PRIu64 "bmap block 0x%" PRIu64 " claimed, state is %d\n"),
> > +_("inode 0x%" PRIu64 "bmap block 0x%" PRIx64 " claimed, state is %d\n"),
> >  				ino, bno, state);
> >  			break;
> >  		case XR_E_MULT:
> >  		case XR_E_INUSE_FS:
> >  			set_bmap(agno, agbno, XR_E_MULT);
> >  			do_warn(
> > -_("inode 0x%" PRIu64 " bmap block 0x%" PRIu64 " claimed, state is %d\n"),
> > +_("inode 0x%" PRIu64 " bmap block 0x%" PRIx64 " claimed, state is %d\n"),
> >  				ino, bno, state);
> >  			/*
> >  			 * if we made it to here, this is probably a bmap block
> 
> These two entries still need fix in the first format strings of both
> msgids...
> 
> I'm attaching my version of the whole patch.

I've already put the previous version in.  I'll commit the updates
attributed to you.

Sorry for the mess, and thanks a lot for looking over this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
