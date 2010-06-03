Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53H5pFm167340 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 12:05:52 -0500
Date: Thu, 3 Jun 2010 13:08:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: dropping dmapi support, was Re: [PATCH 00/17] pending patches
Message-ID: <20100603170818.GA18591@infradead.org>
References: <20100531160727.842750532@bombadil.infradead.org>
	<1275584506.2468.57.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275584506.2468.57.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 03, 2010 at 12:01:46PM -0500, Alex Elder wrote:
> I would like to have a chance to submit an alternative to simply
> removing that code.  I recognize it sits in the first part of your
> patch series, and I will gladly do the work to rearrange them to
> put it at the end, in order to give me some time to develop my
> proposed change.
> 
> Basically what I'd like to do is update the DMAPI support code
> so that it is much better isolated.  I would like to replace
> the big ugly hunks that lie in common code paths with small
> function calls, so that their footprint is minimal and not
> distracting (along the lines of tracing calls).
> 
> I got a start on doing this, and had hoped to send the result
> pretty soon after your initial posting of the patch, but that
> work unfortunately got preempted by other more pressing stuff.
> I wanted to provide actual code to help make the discussion
> of the merits of removal versus cleanup more concrete.  I
> now think I'll be able to put something together within the
> next week or so.

I don't think it's a good idea.  I'm happy to not burn all bridges
and leave certain code structured in a way that makes adding it easier,
but if the hooks are as easy as you say above they can easily live in
an out of tree patchset.  The general Linux kernel policy is that we
don't keep hooks for out of tree code around, and I tend to agree to
it.  We kept all that dmapi cruft in, and it's never served any
purpose for us.  I think that HSM support is actually a very useful
feature, but the a kernel interface based on the DMAPI specification
much less so, and the horrible SGI implementation that used to be
in the XFS CVS tree even less so.

If you want to push a new one the metadata hooks really need to be
entirely outside the low-level filesystem, that is before calling
into the namespace inode operations, which is easily doable even
while keeping the current DMAPI core.

But what's much more difficult is the read/write path.  The dmapi
code really gets in the way there, and I have additional simplification
of this code pending that require this cruft to go away.  XFS currently
has a needlessly complicated write path, and getting closer to the
generic code will help us with lots of things like the upcoming multi
page write support.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
