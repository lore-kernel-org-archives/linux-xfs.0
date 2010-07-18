Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6INURRL172334 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 18:30:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E53C1225E18
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 16:39:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	3kcyRfBbbvIu9vVB for <xfs@oss.sgi.com>;
	Sun, 18 Jul 2010 16:39:57 -0700 (PDT)
Date: Mon, 19 Jul 2010 09:33:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100718233320.GB32635@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<20100718045702.GB6282@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718045702.GB6282@infradead.org>
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
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, xfs@oss.sgi.com

On Sun, Jul 18, 2010 at 12:57:02AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 18, 2010 at 11:20:33AM +1000, Dave Chinner wrote:
> > So, back to the situation with the WARN_ON(). You're running
> > applications that are doing something that:
> > 
> > 	a) is not supported;
> > 	b) compromises data integrity guarantees;
> > 	c) is not reliably reported; and
> > 	d) might be causing hangs
> > 
> > Right now I'm not particularly inclined to dig into this further;
> > it's obvious the applications are doing something that is not
> > supported (by XFS or the generic page cache code), so this is the
> > first thing you really need to care about getting fixed if you value
> > your backups...
> 
> While it's slightly crazy it's also a pretty easy way for users to shoot
> themselve in their feet.  Unlike the generic filesystems with their
> simplistic i_mutex locking we have a way to assure this works properly
> in XFS with the shared/exclusive iolock, so I'm willing to look into
> this further.

Sorry, that wasn't paticularly clear - What I was trying to say is
that I'm not really interested in solving all the generic
buffered/direct IO coherency issues. I agree that it should not
hang, so we do need to find out why it hung....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
