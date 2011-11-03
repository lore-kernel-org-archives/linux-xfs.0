Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3B38pA000884 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 06:03:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F12B1541861
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 04:03:07 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1x9uhMSsUzFB3f75 for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 04:03:07 -0700 (PDT)
Date: Thu, 3 Nov 2011 07:03:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair fails with corrupt dinode 17491441757, extent total =
	1, nblocks = 0.  This is a bug.
Message-ID: <20111103110306.GA8382@infradead.org>
References: <201110311156.20421.arekm@maven.pl>
	<201111031140.46783.arekm@maven.pl>
	<20111103104850.GA26259@infradead.org>
	<201111031157.39179.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201111031157.39179.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 11:57:38AM +0100, Arkadiusz Mi??kiewicz wrote:
> > In the meantime is there any chance you could send the output of
> > 
> > 	xfs_repair -n -vv -m 1
> > 
> > for this filesystem?
> 
> Will such repair done on metadumped & restored image be enough for you?

Yes.

I also looked at the memory heuristics and found some fairly obvious
flaws.  I'll have some test patches for you ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
