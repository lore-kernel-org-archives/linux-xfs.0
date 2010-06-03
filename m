Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53MVXNY181968 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 17:31:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08D61ABF5D1
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 15:36:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	RcmfpHunH3EXnxdY for <xfs@oss.sgi.com>;
	Thu, 03 Jun 2010 15:36:31 -0700 (PDT)
Date: Fri, 4 Jun 2010 08:33:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: dropping dmapi support, was Re: [PATCH 00/17] pending patches
Message-ID: <20100603223356.GA14752@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<1275584506.2468.57.camel@doink>
	<20100603170818.GA18591@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100603170818.GA18591@infradead.org>
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
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Thu, Jun 03, 2010 at 01:08:18PM -0400, Christoph Hellwig wrote:
> On Thu, Jun 03, 2010 at 12:01:46PM -0500, Alex Elder wrote:
> > I would like to have a chance to submit an alternative to simply
> > removing that code.  I recognize it sits in the first part of your
> > patch series, and I will gladly do the work to rearrange them to
> > put it at the end, in order to give me some time to develop my
> > proposed change.
> > 
> > Basically what I'd like to do is update the DMAPI support code
> > so that it is much better isolated.  I would like to replace
> > the big ugly hunks that lie in common code paths with small
> > function calls, so that their footprint is minimal and not
> > distracting (along the lines of tracing calls).
> > 
> > I got a start on doing this, and had hoped to send the result
> > pretty soon after your initial posting of the patch, but that
> > work unfortunately got preempted by other more pressing stuff.
> > I wanted to provide actual code to help make the discussion
> > of the merits of removal versus cleanup more concrete.  I
> > now think I'll be able to put something together within the
> > next week or so.
> 
> I don't think it's a good idea.  I'm happy to not burn all bridges
> and leave certain code structured in a way that makes adding it easier,
> but if the hooks are as easy as you say above they can easily live in
> an out of tree patchset.  The general Linux kernel policy is that we
> don't keep hooks for out of tree code around, and I tend to agree to
> it.  We kept all that dmapi cruft in, and it's never served any
> purpose for us.  I think that HSM support is actually a very useful
> feature, but the a kernel interface based on the DMAPI specification
> much less so, and the horrible SGI implementation that used to be
> in the XFS CVS tree even less so.
> 
> If you want to push a new one the metadata hooks really need to be
> entirely outside the low-level filesystem, that is before calling
> into the namespace inode operations, which is easily doable even
> while keeping the current DMAPI core.

Regardless of the implementation cruftiness, I think this a much
better approach. The events and checks really aren't XFS specific,
and putting them at a higher level cleanly separates the filesystem
functionality from the event+blocking functionality of DMAPI.

> But what's much more difficult is the read/write path.  The dmapi
> code really gets in the way there, and I have additional simplification
> of this code pending that require this cruft to go away.  XFS currently
> has a needlessly complicated write path, and getting closer to the
> generic code will help us with lots of things like the upcoming multi
> page write support.

That is true, and also intervening higher up in the IO path for
DMAPI would avoid a lot of the locking complexity that XFS has to go
through now to be able to block on events in dmapi calls.

Further, with ext4 gaining a persitent handle interface, adding
DMAPI to the VFS would also enable HSMs to work on more than just
XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
