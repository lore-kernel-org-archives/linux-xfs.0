Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 621637F76
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 08:16:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA146AC002
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 06:16:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id MJ3AZa3eTmbcPynj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 06:16:16 -0700 (PDT)
Date: Thu, 3 Apr 2014 14:16:10 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Message-ID: <20140403131610.GB7292@suse.de>
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
Cc: xfs@oss.sgi.com, lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>, linux-ext4@vger.kernel.org

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
> 

FWIW, I also don't think that xfstests or a framework should go into the
kernel tree for the following reasons

1. Tests can be created during the release cycle and it does not make
   sense to tie the availabilty of tests to the availability of a kernel.
   If someone is running tests against historical tests, they must first
   checkout the most recent kernel tree, build xfstests and then checkout
   the old tree. Yes, users can be given a patch against the kernel tree
   to add a new test but they still have this awkward switching back and
   forth between the branch that has the test and the kernel they are
   running the test against.

   Recent example -- trinity 1.3 does not trigger MM bugs. Until recently,
   the latest git version of trinity caused massive damage.  If trinity had
   been in the tree someone might have accidentally concluded that 3.13 was
   "fine"

2. It would be relatively easy for someone to mistakenly bisect xfstests
   instead of bisecting the kernel although my understanding is that tests
   do not change per-se, only new ones are added. There may be
   exceptions to this rule

3. With testing automation, it's not that hard to download the
   requirements for it. mmtests prefers to use a local mirror but falls
   back to downloading tarballs, checking out git trees or mercurcial
   trees as appropriate. It's just a few lines of code (most of which is
   auto-generated from a template).

4. Testing monoculture. Sometimes the value of a benchmark is because
   different people run it differently for whatever reason. My IO tests for
   example all tune the benchmark to at least 2*RAM but that misses the cases
   where there are regressions in IO to a file that fits in memory. xfstests
   might have similar problems but minimally it would be a shame if the
   framework always used the same mount options for example. FWIW I've
   had bugs reported that were real bugs and only revealed because the
   benchmark parameters made no sense but still found a bug by accident.

Overall I have little motivation to having all the tests in the kernel
tree. That said, I already have an automated framework I can use so I
would not feel as strongly about the problem.

The point is that putting tests in tree or out of tree is neither sane nor
insane. It's simply different approaches so people on the thread should
be wary of trying to label the other person as being mental just because
of where they want to stick a test.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
