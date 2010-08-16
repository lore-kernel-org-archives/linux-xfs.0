Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G1sg8f210832 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 20:54:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED8B5CB3050
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 19:04:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	pdSGFD9CoALUBbpQ for <xfs@oss.sgi.com>;
	Sun, 15 Aug 2010 19:04:14 -0700 (PDT)
Date: Mon, 16 Aug 2010 11:55:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs.fsck change that is unhelpful
Message-ID: <20100816015505.GJ10429@dastard>
References: <4C670101.8050901@tlinx.org> <20100815005240.GH10429@dastard>
	<4C674AE8.7030107@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C674AE8.7030107@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Aug 14, 2010 at 07:03:20PM -0700, Linda Walsh wrote:
> 
> 
> Dave Chinner wrote:
> >On Sat, Aug 14, 2010 at 01:48:01PM -0700, Linda A. Walsh wrote:
> >>Some time ago, when I upgraded a system, I ran into problems when
> >>it hit a file system that was offline.  It wasn't a critical
> >>partition, so it normally wouldn't have been an issue, but somewhere
> >>along the line
> >>someone mangled fsck.xfs.
> >
> >fsck.xfs is behaving identically to e2fsck when presented with an
> >invalid block device - it exits with an error of 8, which is defined
> >as "operational error" in the e2fsck man page.
> ---
> 	That may be fine for the ext2 fs, but I am asserting that in actual
> practice, with xfs, it does more harm than good.

For whom?

> >That sounds like a problem with the distro init scripts or you've
> >stuffed up your /etc/fstab config (i.e. fs_passno is wrong). Indeed,
> >setting fs_passno = 0 will cause the filesysetm fsck to be skipped
> >completely on boot, regardless of the fs type...
> ---
> 	Yes, you are right.  They are setup to be check in the order
> I would want them mounted.  But I don't see the benefit to being
> compliant with a checking mechanism for a file system that is
> actually needs fsck.
> 
> 	It was long a *feature* of xfs, that xfs.fsck, was a noop.

It wasn't a feature - it was simply to ensure that initscripts
worked. There was simply no reason for it to do anything else until
someone discovered that their booot problems were caused by
non-standard behaviour. i.e.  fsck wasn't catching non-existent
devices and telling the init scripts...

Fundamentally, a filesystem should integrate with common
infrastructure as best as possible, and if that means behaving like
other fsck programs for missing block devices, then IMO we
absolutely should be doing that.

> 	I don't see that making it fail in ways fsck does for a file
> system that *needs* fsck, is productive.  Sure, it may be dotting i's
> and crossing t's, but in reality, is that a standard xfs should be
> living down to?

Being different for the sake of being different is misguided at
best. There's a time and place for differentiation between
filesystems, but interactions with init scripts is definitely
not that place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
