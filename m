Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS7una1224394 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 01:56:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34A6D27B1C2
	for <xfs@oss.sgi.com>; Sun, 27 Nov 2011 23:56:48 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	n7uEP2RgVXZLVAI4 for <xfs@oss.sgi.com>;
	Sun, 27 Nov 2011 23:56:48 -0800 (PST)
Date: Mon, 28 Nov 2011 02:56:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
Message-ID: <20111128075646.GB6000@infradead.org>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
	<20111127235051.GX2386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111127235051.GX2386@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 28, 2011 at 10:50:51AM +1100, Dave Chinner wrote:
> > I had the expectation that physical block size WAS the fundamental/atomic
> > IO size for the disk, and anything smaller required read/modify/write.
> > So I made this suggestion (and I think hch concurred) so that we weren't
> > doing log IOs which required RMW & translation.
> 
> A RMW cycle does not mean the IO is not atomic. The write to disk
> will still be atomic, regardless of the read that ovvurred before.

I would not trust ATA disk to get this right generally.

> > Ok, if we have mismanaged the alignment and aligned to logical, not
> > physical, then I guess there would be an issue... but at that point
> > we've already messed up (though not catastrophically I guess)...
> 
> That's where I'm concerned - if alignment is screwed because the FS
> is 512B sector aligned (because something read the logical sector size),
> then using a 4k sector will result in torn writes because every 4k
> sector write is potentially made up of 2 4k write IOs, not 1.

Disks that implement the ATA level required to tell us about the
physical blocksize also have the alignment offset information in the
IDENTIFY data to tell us about aligned shifts.  But I haven't seen a
single one with a non-zero aligned offset in the wild.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
