Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KDvLZG094675 for <xfs@oss.sgi.com>; Fri, 20 May 2011 08:57:21 -0500
Subject: Re: [PATCH 1/4] xfs: add online discard support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <alpine.LFD.2.00.1105201330360.5226@dhcp-27-109.brq.redhat.com>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.156999943@bombadil.infradead.org>
	<1305842024.2825.86.camel@doink> <20110520102430.GA18199@infradead.org>
	<alpine.LFD.2.00.1105201330360.5226@dhcp-27-109.brq.redhat.com>
Date: Fri, 20 May 2011 08:57:17 -0500
Message-ID: <1305899837.3976.27.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 2011-05-20 at 13:43 +0200, Lukas Czerner wrote:
> On Fri, 20 May 2011, Christoph Hellwig wrote:
> 
> > On Thu, May 19, 2011 at 04:53:44PM -0500, Alex Elder wrote:
> > > The first is, why not support it for non-delaylog?
> > 
> > Because:
> > 
. . .
> > 
> > It's a bad idea to do the sort twice for no good reason, and adding
> > another parameter to further overload xfs_alloc_busy_clear behaviour
> > doesn't seem smart either.
> > 
> > > 		if (error == EOPNOTSUPP) {
> > > 			/*
> > > 			 * Report this once per mount point somehow?
> Actually, this is a good idea see https://lkml.org/lkml/2011/5/5/162. So
> you will get EOPNOTSUPP *only* if the device (as a whole) does not
> support discard.

I.e., if *any* component of the underlying storage supports
discard, the aggregate device supports discard.  (Rather than
only if *all* components support it.)  This seems pretty reasonable.

> > > 			 * If so, turn off the mount option?
> Not so good idea, as some people mentioned several times, you can change
> the devices in dmsetup to SSD (for example) without umount and you would
> like your previous mount option to work. In the opposite case, the user
> just gets warning (once a day perhaps?) and its up to him to deal with
> it.

Sorry, I wasn't following that discussion closely.

> Or, we can turn it of (with warning) and rely on the user to notice that
> it is turned off. But I would rather not rely on that.

I agree with you.  I didn't realize the underlying storage could
change attributes without notification of some kind.  The FS layer
might benefit from knowing when such changes take place.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
