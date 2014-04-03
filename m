Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB8CD29E05
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 20:14:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B842B8F8092
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 18:14:28 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GRuCH1H5uNp5BSCq for <xfs@oss.sgi.com>;
	Wed, 02 Apr 2014 18:14:26 -0700 (PDT)
Date: Thu, 3 Apr 2014 12:14:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Message-ID: <20140403011411.GL16336@dastard>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140402142620.GA6901@thunk.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, lsf@lists.linux-foundation.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 02, 2014 at 10:26:20AM -0400, Theodore Ts'o wrote:
> On Wed, Apr 02, 2014 at 09:28:23AM +1100, Dave Chinner wrote:
> > > And of course, whether changes in the mainline kernel tree are
> > > manually propagated changes from the xfstests.git tree, or whether
> > > primary development happens in the kernel tree, is ultimately going to
> > > be up to you and the XFS developers who have stewardship of xfstests.
> > > I'm not sure I would be that excited about manual propagation of
> > > changes from one git tree to another, but that is of course, up to
> > > you.
> > 
> > And this is exactly my point, Ted. Again, you are presuming that the
> > implementation is going to require syncing commits across disparate
> > git trees and other such games will be needed to maintain separate
> > packages. Nothing could be further from the truth: we already have
> > this problem with the shared XFS kernel/userspace code and it's a
> > royal PITA keeping them in sync. Hence introducing the same
> > maintenance problem with new code and infrastructure is highly
> > undesirable and something we'll try to avoid at all costs.
> 
> Actually, I was presuming that the thing that makes the most sense was
> to move all or most of the tests in xfstests into the kernel tests
> tree.  And then you complained that I was making a presumption that
> this was the only sane thing to do.  That's why I said, "if you want
> to do something insane, be my guest".

So, you think there's only one "sane" solution. That's a massive
assumption, and that's what I'm pointing out.

It's perfectly sane to treat the kernel tree as just another
downstream consumer of xfstests, and simple add infrastructure to
the kernel tree to source and build xfstests from the upstream repo.
Indeed, this is the existing model that seems to work for just about
everyone, so I see no reason why we should treat Greg's request any
differently.

IOWs, you're assumming that the only thing that makes sense is that
"kernel tree == upstream". We don't push code into the kernel tree
just because it's the Kernel Tree. We push code there if it makes
sense to do so - either from a commercial or technical PO. We have
no commercial motive to move xfstests into the kernel tree, and I
see a lot technical downsides to moving xfstests in it's entirity to the
kernel tree.

So, really, putting some infrastructure into the kernel tree to use
xfstests (i.e. a downstream consumer) makes a lot more sense from a
technical point of view than making the kernel tree the xfstests
upstream.

It's a sane way to solve the problem that Greg wanted solved - the
kernel tree carries the infrastructure needed to solve the "test in
place" use case that -stable maintainers want, but it doesn't turn
test development nor filesystem developer work flows on their head
nor make xfstests less useful to existing users.

> I have nothing against doing a formal requirements process, that's

I'm not doing anything formal, just doing the right thing to make
sure we don't do all the work and then be told "not acceptable"....

> fine, but I think there are certain things about what the final
> solution of "test in the kernel git tree" will look like that are
> pretty obvious.

Certain things, yes. Like using kvm to run the tests in a container.
Just what form that takes is not clear right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
