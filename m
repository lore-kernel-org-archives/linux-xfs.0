Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6I4s5Sm119849 for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 23:54:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8E6D447D48
	for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 21:57:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qbFSnJB98rAnFoUJ for
	<xfs@oss.sgi.com>; Sat, 17 Jul 2010 21:57:04 -0700 (PDT)
Date: Sun, 18 Jul 2010 00:57:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100718045702.GB6282@infradead.org>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718012033.GA18888@dastard>
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
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, xfs@oss.sgi.com

On Sun, Jul 18, 2010 at 11:20:33AM +1000, Dave Chinner wrote:
> So, back to the situation with the WARN_ON(). You're running
> applications that are doing something that:
> 
> 	a) is not supported;
> 	b) compromises data integrity guarantees;
> 	c) is not reliably reported; and
> 	d) might be causing hangs
> 
> Right now I'm not particularly inclined to dig into this further;
> it's obvious the applications are doing something that is not
> supported (by XFS or the generic page cache code), so this is the
> first thing you really need to care about getting fixed if you value
> your backups...

While it's slightly crazy it's also a pretty easy way for users to shoot
themselve in their feet.  Unlike the generic filesystems with their
simplistic i_mutex locking we have a way to assure this works properly
in XFS with the shared/exclusive iolock, so I'm willing to look into
this further.

Ilia, would you be willing to test patches for this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
