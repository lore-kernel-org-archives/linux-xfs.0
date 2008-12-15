Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBF5b4JK020256
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 23:37:04 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BFBE1EDD6
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 21:37:01 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	V1iytyiGKxL34lGs for <linux-xfs@oss.sgi.com>;
	Sun, 14 Dec 2008 21:37:01 -0800 (PST)
Date: Mon, 15 Dec 2008 16:36:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS over SSD
Message-ID: <20081215053656.GE32301@disturbed>
References: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
	<493D334C.5010006@sandeen.net>
	<5d96567b0812080711x34bb93d6vd8e4f88d9b190e9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5d96567b0812080711x34bb93d6vd8e4f88d9b190e9@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Mon, Dec 08, 2008 at 05:11:58PM +0200, Raz wrote:
> On Mon, Dec 8, 2008 at 4:46 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > Raz wrote:
> >> I am thinking of using XFS over a SSD disk.
> >> 1. Can I separate xfs meta data ( not just the logging) from the SSD ?
> >> can I put the meta on a different disk ?
> >
> > Are you talking about just the log (see the mkfs man page for external
> > logs, as Justin suggested) or all metadata?  For the latter, using the
> > realtime subvolume does accomplish this (data on one volume, metadata on
> > the other) but that's not used very often.
> >
> > -Eric
> >
> I am referring to all the meta data. 128K of erase block for some block map
> update is a big penalty.

That's not an issue for smart SSDs like the intel one. They
internally use a log-based structure that means that small writes
don't end up requiring an entire erase block to be rewritten.  That
is, they have a low write amplification factor.

Such SSDs don't really care that much about the filesystem structure
and random write patterns. Older/cheaper SSDs have a much larger
write amplification factor and so are unsuited to traditional
filesystem structures.....

Google "SSD write amplification" for more information.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
