Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9A4KxZ0125767 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 23:21:00 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E2D3175EBAA
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 21:22:26 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id iWwpPbdu6TthgJ9x for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 21:22:26 -0700 (PDT)
Date: Sat, 10 Oct 2009 06:22:24 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091010042224.GG1656@one.firstfloor.org>
References: <20091006184758.GA4780@infradead.org>
	<20091007044215.GK9464@discord.disaster>
	<87iqerymu0.fsf@basil.nowhere.org>
	<20091009023022.GL9464@discord.disaster>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091009023022.GL9464@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

On Fri, Oct 09, 2009 at 01:30:22PM +1100, Dave Chinner wrote:
> On Wed, Oct 07, 2009 at 10:24:07PM +0200, Andi Kleen wrote:
> > Dave Chinner <david@fromorbit.com> writes:
> > > On Tue, Oct 06, 2009 at 02:47:58PM -0400, Christoph Hellwig wrote:
> > >> Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
> > >> a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
> > >> and virtual machines to make smarter allocation decisions.
> > >
> > > Good idea, but perhaps the discard should be optional rather than
> > > unconditional.  My immediate thought was the SOP for setting up
> > > encrypted devices - fill the empty disk with random data before
> > > setting up the encrypted device. If you then send it a discard....
> >
> > This actually doesn't really work for SSDs, because SSDs typically
> > have more internal capacity than they advertise and when you fill
> > it up then it will just allocate new blocks and leave some of the
> > blocks with the existing data around.
> 
> Agreed, but initialisation with random data before encryption is not
> to delete existing information on the drive - it is to prevent
> simple side-channel attacks that can significantly reduce the
> strength of the encryption (e.g. an observer can tell the difference

I see. That makes sense.

Although to be pedantic your description above is slightly
wrong then -- you need to fill it up after setting up the encryption,
not before. In this case it might be actually more reasonable
to simply fill the file system with a random file (although on XFS
might need to reset inode limits first to catch the metadata
reservations)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
