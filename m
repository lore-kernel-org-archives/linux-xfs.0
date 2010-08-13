Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DFFFKt069017 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 10:15:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BA2B4B4E1C
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 08:15:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cUgKGiqzNIgNGV2r for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 08:15:42 -0700 (PDT)
Date: Fri, 13 Aug 2010 11:15:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Alignment size?
Message-ID: <20100813151539.GA22492@infradead.org>
References: <4C64715F.8060000@msgid.tls.msk.ru>
	<20100812234911.GC10429@dastard>
	<4C64E52E.2060806@msgid.tls.msk.ru>
	<20100813113915.GD10429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100813113915.GD10429@dastard>
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
Cc: Michael Tokarev <mjt@tls.msk.ru>, xfs@oss.sgi.com

On Fri, Aug 13, 2010 at 09:39:15PM +1000, Dave Chinner wrote:
> The workaround old versions of mkfs.xfs used was to create the fs
> with a sector size of 4k when it detected md raid5 underneath it so
> the sb and ag headers were all 4k aligned and sized, just like the
> rest of the filesystem....

That workaround is still in latests mkfs.xfs if you build against
the internal libdisk instead of libblkid.  And that's the case at
least for Debian, and probably a few other distributions as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
