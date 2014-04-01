Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F9B37F58
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 17:28:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88EEE30405F
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 15:28:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4F8a5bRN5krUwvte for <xfs@oss.sgi.com>;
	Tue, 01 Apr 2014 15:28:38 -0700 (PDT)
Date: Wed, 2 Apr 2014 09:28:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Message-ID: <20140401222823.GJ17603@dastard>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140401023711.GE4911@thunk.org>
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

On Mon, Mar 31, 2014 at 10:37:11PM -0400, Theodore Ts'o wrote:
> On Mon, Mar 31, 2014 at 01:51:48PM +1100, Dave Chinner wrote:
> > > especially given that based on a challenge which
> > > Greg K-H gave us at the kernel pannel at Collab Summit,
> >                ^^^^
> > 
> > Hmmmm. Not the way I remember it. Perhaps I should go look at the
> > video and check that Greg was addressing me directly as the xfstests
> > maintainer with those comments. After all, those lights on stage can
> > be blinding.....
> 
> Sorry, I thought in the discussions we had afterwards you agreed with
> me that *some* way of running xfststs easily was going to be a
> requirement, as it is somewhat doubtful that most non-file system
> developers will have the patience to deal with the "some assembly
> required" in order to actually run xfstests, and actually putting
> xfstests into the kernel sources wasn't going to be particularly
> useful unless we have some way of making it possible to run the tests
> in a semi-automated fashion.

Right, there was follup discussion about how we could potentially
acheive what Greg wanted, but it was more of a "we've got pieces
that we might be able to leverage" discussion than anything else.

> Whether that method is based on what I have in xfstests-bld, or some
> other way is I agree certainly up for discussion.  At the moment the
> system I have is only set up for ext4, although I will happily accept
> patches and work with other file system developers to enhance it so it
> can work with other file systems.

Right, that's pretty much where we finished the discussion at
the collab summit ;)

But that this is why I responded to your previous email - while you
likely had the best of intentions, you gave the impression that
xfstests-bld type of solution was fait accompli, when in fact we
haven't even really started defining the problem space and gathering
requirements yet...

> And of course, whether changes in the mainline kernel tree are
> manually propagated changes from the xfstests.git tree, or whether
> primary development happens in the kernel tree, is ultimately going to
> be up to you and the XFS developers who have stewardship of xfstests.
> I'm not sure I would be that excited about manual propagation of
> changes from one git tree to another, but that is of course, up to
> you.

And this is exactly my point, Ted. Again, you are presuming that the
implementation is going to require syncing commits across disparate
git trees and other such games will be needed to maintain separate
packages. Nothing could be further from the truth: we already have
this problem with the shared XFS kernel/userspace code and it's a
royal PITA keeping them in sync. Hence introducing the same
maintenance problem with new code and infrastructure is highly
undesirable and something we'll try to avoid at all costs.

Basically, we need to start with a proposal that outlines what we
need in the kernel tree for testing filesystems in place and go from
there. Once we've agreed on the big picture stuff and solved the
maintenance, packaging and "how do we run in place" architectural
issues, then we can start working on the implementation. I'm hoping
to write something up in the next week or two to being the process
and discussions, because I'm sure the -stable folk will have some
input on what they would like to be able to do.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
