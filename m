Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGUGrY214732 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:30:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D00415483C0
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:32:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wGAYwTFEPM4GzWOv for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:32:17 -0700 (PDT)
Date: Thu, 22 Apr 2010 12:32:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100422163211.GA2478@infradead.org>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
	<20100419140039.GQ5683@laptop> <20100420004149.GA14744@dastard>
	<20100420083840.GR5683@laptop> <20100420103216.GK15130@dastard>
	<20100421084004.GS5683@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100421084004.GS5683@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Wed, Apr 21, 2010 at 06:40:04PM +1000, Nick Piggin wrote:
> I'm saying that dynamic registration is no good, if we don't have a
> way to order the shrinkers.

We can happily throw in a priority field into the shrinker structure,
but at this stage in the release process I'd rather have an as simple
as possible fix for the regression.  And just adding the context pointer
which is a no-op for all existing shrinkers fits that scheme very well.

If it makes you happier I can queue up a patch to add the priorities
for 2.6.35.  I think figuring out any meaningful priorities will be
much harder than that, though.

> > If a change of interface means that we end up with shorter call
> > chains, less global state, more flexibilty, better batching and IO
> > patterns, less duplication of code and algorithms and it doesn't
> > cause any regressions, then where's the problem?
> 
> Yep that would all be great but I don't see how the interface change
> enables any of that at all. It seems to me that the advantage goes
> the other way because it doesn't put as much crap into your mount
> structure and you end up with an useful traversable list of mounts as
> a side-effect.

There really is not need for that.  The Linux VFS is designed to have
superblocks independent, which actually is a good thing as global
state gets in the way of scalability or just clean code.  Note that
a mounts list would be even worse as filesystems basically are not
concerned with mount points themselves.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
