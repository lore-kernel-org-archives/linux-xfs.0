Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 465D77F74
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 09:27:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41082304053
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 07:27:10 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id TEqrA97YU8eSpROJ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Apr 2014 07:27:06 -0700 (PDT)
Date: Wed, 2 Apr 2014 10:26:20 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Message-ID: <20140402142620.GA6901@thunk.org>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140401222823.GJ17603@dastard>
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
Cc: Sedat Dilek <sedat.dilek@gmail.com>, lsf@lists.linux-foundation.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 02, 2014 at 09:28:23AM +1100, Dave Chinner wrote:
> > And of course, whether changes in the mainline kernel tree are
> > manually propagated changes from the xfstests.git tree, or whether
> > primary development happens in the kernel tree, is ultimately going to
> > be up to you and the XFS developers who have stewardship of xfstests.
> > I'm not sure I would be that excited about manual propagation of
> > changes from one git tree to another, but that is of course, up to
> > you.
> 
> And this is exactly my point, Ted. Again, you are presuming that the
> implementation is going to require syncing commits across disparate
> git trees and other such games will be needed to maintain separate
> packages. Nothing could be further from the truth: we already have
> this problem with the shared XFS kernel/userspace code and it's a
> royal PITA keeping them in sync. Hence introducing the same
> maintenance problem with new code and infrastructure is highly
> undesirable and something we'll try to avoid at all costs.

Actually, I was presuming that the thing that makes the most sense was
to move all or most of the tests in xfstests into the kernel tests
tree.  And then you complained that I was making a presumption that
this was the only sane thing to do.  That's why I said, "if you want
to do something insane, be my guest".

I have nothing against doing a formal requirements process, that's
fine, but I think there are certain things about what the final
solution of "test in the kernel git tree" will look like that are
pretty obvious.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
