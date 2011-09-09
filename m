Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89KDRbj057914 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 15:13:27 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98C2914B642
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 13:13:26 -0700 (PDT)
Received: from peace.netnation.com (peace.netnation.com [204.174.223.2]) by
	cuda.sgi.com with ESMTP id AHYGASvUtIbnC24i for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2011 13:13:26 -0700 (PDT)
Date: Fri, 9 Sep 2011 13:13:24 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: Re: [Drbd-dev] [3.1-rc4] XFS+DRBD hangs
Message-ID: <20110909201324.GD6195@hostway.ca>
References: <20110907221505.GC21603@hostway.ca>
	<20110908151305.GJ14243@barkeeper1-xen.linbit>
	<20110908174324.GA8043@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110908174324.GA8043@hostway.ca>
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
To: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 08, 2011 at 10:43:24AM -0700, Simon Kirby wrote:

> On Thu, Sep 08, 2011 at 05:13:05PM +0200, Lars Ellenberg wrote:
> 
> > Sorry for double posting on drbd-dev, I managed to strip the other lists from Cc.
> > 
> > > We upgraded from 2.6.36 which seemed to have a page leak (file pages left
> > > on the LRU) and so would eventually perform very poorly. 2.6.37 and
> > > 2.6.38 seemed to have some unix socket issue that caused heartbeat to
> > > wedge. Shall we enable lock debugging or something here?
> > 
> > That could help us understand that stack trace.
> > 
> > It looks like cpu 1 blocks in
> > 
> > > [ 1532.427149]  [<ffffffff8103d512>] ? try_to_wake_up+0xc2/0x270
> > > [ 1532.427149]  <<EOE>>  <IRQ>  [<ffffffff8103d6cd>] default_wake_function+0xd/0x10
> > 
> > Which does not make sense to me at all.
> 
> Well, good news, I think.. I believe this may be related to
> "PCI: Set PCI-E Max Payload Size on fabric", added by b03e7495a862b02829.
> 3.1-rc5 is running now with a patch to basically disable those changes,
> and has been stable for 12 hours. It usually hung in a few minutes
> before.
> 
> The XFS peoples say it was very likely not 58d84c4ee0389ddeb86238d5 which
> is the only other thing that changed between these versions that seems to
> be at all in the hang path.
> 
> Also, when the thing hangs, it stops pinging immediately, and with the
> PCI-E max payload thing active, the device that raises a bus error is
> actually the PCI-E to PCI-X bridge chip used to support the BCM5708 NICs,
> so that all seems related.

Except that I accidentally git reset out the patch, and so it's been
running unmodified 79016f648872549392d232cd648bd02298c2d2bb (past -rc5),
and still hasn't crashed, so I guess it _was_ the XFS changes, or
something else. Boggle. In any event, it's still running well. :)

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
