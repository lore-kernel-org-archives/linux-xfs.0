Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61F137F60
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 05:27:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 369988F80B8
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 03:27:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 49ADkVwOQtfiBHz6 for
	<xfs@oss.sgi.com>; Thu, 03 Apr 2014 03:27:01 -0700 (PDT)
Date: Thu, 3 Apr 2014 12:26:44 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
In-Reply-To: <20140403011411.GL16336@dastard>
Message-ID: <alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>, linux-ext4@vger.kernel.org

On Thu, 3 Apr 2014, Dave Chinner wrote:

> Date: Thu, 3 Apr 2014 12:14:11 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>, lsf@lists.linux-foundation.org,
>     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
>     CPUs in build-all
> 
> On Wed, Apr 02, 2014 at 10:26:20AM -0400, Theodore Ts'o wrote:
> > On Wed, Apr 02, 2014 at 09:28:23AM +1100, Dave Chinner wrote:
> > > > And of course, whether changes in the mainline kernel tree are
> > > > manually propagated changes from the xfstests.git tree, or whether
> > > > primary development happens in the kernel tree, is ultimately going to
> > > > be up to you and the XFS developers who have stewardship of xfstests.
> > > > I'm not sure I would be that excited about manual propagation of
> > > > changes from one git tree to another, but that is of course, up to
> > > > you.
> > > 
> > > And this is exactly my point, Ted. Again, you are presuming that the
> > > implementation is going to require syncing commits across disparate
> > > git trees and other such games will be needed to maintain separate
> > > packages. Nothing could be further from the truth: we already have
> > > this problem with the shared XFS kernel/userspace code and it's a
> > > royal PITA keeping them in sync. Hence introducing the same
> > > maintenance problem with new code and infrastructure is highly
> > > undesirable and something we'll try to avoid at all costs.
> > 
> > Actually, I was presuming that the thing that makes the most sense was
> > to move all or most of the tests in xfstests into the kernel tests
> > tree.  And then you complained that I was making a presumption that
> > this was the only sane thing to do.  That's why I said, "if you want
> > to do something insane, be my guest".
> 
> So, you think there's only one "sane" solution. That's a massive
> assumption, and that's what I'm pointing out.
> 
> It's perfectly sane to treat the kernel tree as just another
> downstream consumer of xfstests, and simple add infrastructure to
> the kernel tree to source and build xfstests from the upstream repo.

That's what I think is the best approach as well. We'll still have
separate tree for the xfstests which works for everyone and
infrastructure in kernel tree which will simply use it.

Looking at rcutorture tests in kernel tree, they are indeed using
qemu and it looks like that they are running those tests directly
from init script - we really need an image to boot from.

We could use virtme

https://git.kernel.org/cgit/utils/kernel/virtme/virtme.git/

which seems like a best option. Alternatively we could allow users
passing their own image as well.

Then we would need init script which would download and build
xfstests, xfsprogs and possible other dependencies (such as fio)
and finally run xfstests itself. Colnsole output from the qemu can
be redirected to the file in the host, so that's ok, but we still
need a way to retrieve 'retults' directory from the test.

We'd also need a devices to test on (at least TEST_DEV and
SCRATCH_DEV). Those could be files a of set size exported to qemu as
block devices.

I think that looking at rcutorture test infrastructure is a good
start and we can possibly reuse parts of it for actually running the
qemu and then reuse parts of Ted's solution to run xfstests in the
virtual guest.

Thanks!
-Lukas

> Indeed, this is the existing model that seems to work for just about
> everyone, so I see no reason why we should treat Greg's request any
> differently.
> 
> IOWs, you're assumming that the only thing that makes sense is that
> "kernel tree == upstream". We don't push code into the kernel tree
> just because it's the Kernel Tree. We push code there if it makes
> sense to do so - either from a commercial or technical PO. We have
> no commercial motive to move xfstests into the kernel tree, and I
> see a lot technical downsides to moving xfstests in it's entirity to the
> kernel tree.
> 
> So, really, putting some infrastructure into the kernel tree to use
> xfstests (i.e. a downstream consumer) makes a lot more sense from a
> technical point of view than making the kernel tree the xfstests
> upstream.
> 
> It's a sane way to solve the problem that Greg wanted solved - the
> kernel tree carries the infrastructure needed to solve the "test in
> place" use case that -stable maintainers want, but it doesn't turn
> test development nor filesystem developer work flows on their head
> nor make xfstests less useful to existing users.
> 
> > I have nothing against doing a formal requirements process, that's
> 
> I'm not doing anything formal, just doing the right thing to make
> sure we don't do all the work and then be told "not acceptable"....
> 
> > fine, but I think there are certain things about what the final
> > solution of "test in the kernel git tree" will look like that are
> > pretty obvious.
> 
> Certain things, yes. Like using kvm to run the tests in a container.
> Just what form that takes is not clear right now...
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
