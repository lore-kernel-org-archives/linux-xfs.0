Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B6097CB1
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 19:12:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E8DA304048
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 17:12:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id xAhpy4S3B6gSDCHs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 17:11:59 -0700 (PDT)
Date: Thu, 31 Mar 2016 17:11:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reverse-mapping, reflink, and scrub update
Message-ID: <20160401001128.GG5822@birch.djwong.org>
References: <20160305011530.GG27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305011530.GG27973@birch.djwong.org>
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
To: david@fromorbit.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi.

I've rebased the rmap+reflink patches against 4.6-rc1.  There are also
some patches to start the process of drafting a metadata scrubber for
XFS and/or to give us more to talk about at LSF.

The thirty or so bugfixes tacked on the end of the last patch series
seems to be stable enough that I integrated them into the main body of
the patches, partly to reduce the number of patches to review and
partly to avoid the situation where reviewers complain about something
in a patch only to discover that it's fixed by a later patch that
reorganizes everything.

The first fifteen patches from Dave's latest posting of rmapbt code
are integrated here too.  I've not gotten to the last two, primarily
because I need to add rmapbt and refcountbt update intents and want to
use the interval query code for rmap updates.  This will be its own
sprint, starting just after I send this email.  This leaves us
basically in the same place as we were at the end of the 4.5 cycle,
but rebased against 4.6.  One exception is that the "rmapxbt" is gone;
now there's only one rmapbt format regardless of whether reflink is
enabled.

As far as xfsprogs goes, I imported (I think) all the libxfs updates
from 4.6-rc1, and broke out the huge horrible libxfs changes into
individual patches that are direct descendants of the kernel-side
patches.  They have the same subject line + commit message, so as to
make it easier to cross-reference trees and to port changes from one
to another.  This also brings the xfsprogs libxfs updates for rmap and
reflink up to date with the stuff that has been hanging out in the
kernel.  Unfortunately that means there are now ~105 patches there.

There are also a bunch of xfstests updates that fix various test
errors and add more tests to check out recovery of extents being held
for CoW operations that didn't succeed before crashing; and ensure
that we can't have reflinked swap files.

There are also minor documentation and manpage updates.

Anyway, the development trees are now posted to github under
"djwong-devel" branches:

https://github.com/djwong/linux/commits/djwong-devel
https://github.com/djwong/xfsprogs/commits/djwong-devel
https://github.com/djwong/xfstests/commits/djwong-devel
https://github.com/djwong/xfs-documentation/commits/djwong-devel
https://github.com/djwong/man-pages/commits/djwong-devel

I'll patchbomb the mailing list when I finish the next XFS sprint or
before LSF, whichever comes first.

Christoph: Does that problem you observed with NFS blocking for a long
time when someone uses fallocate to unshare a lot of shared blocks?
The last patch in the kernel series disables the dirty page flush,
and I'm curious to see if it helps any.

(I'd conservatively assumed that a preemptive CoW had to fsync as
well, but let's evaluate if skipping it is worth the risk.)

--D

On Fri, Mar 04, 2016 at 05:15:30PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Dave's started reviewing the rmap/reflink patches I sent him, and said he'll
> trickle the patches (with various edits) out to the mailing list as he gets to
> them.  Therefore, I won't blast the mailing list with the kernel/xfsprogs
> patches that will soon be obsolete, though I will push out all the pending
> xfstests and xfsdocumentation fixes.
> 
> I've also renamed the confusing 'for-dave' branches on github to
> 'rmap-reflink-devel' to make it clearer that it's just a development branch and
> not what I'm trying to get pushed upstream.
> 
> Soooo... stuff I'm hoping to get upstream for 4.6:
> https://github.com/djwong/linux/tree/for-dave-for-4.6
> https://github.com/djwong/xfsprogs/tree/for-dave-for-4.6
> 
> Stuff I hope to get upstream:
> https://github.com/djwong/xfs-documentation/tree/reflink-devel
> https://github.com/djwong/xfstests/tree/reflink-dev
> 
> Development branch, not for upstream:
> https://github.com/djwong/linux/tree/rmap-reflink-devel
> https://github.com/djwong/xfsprogs/tree/rmap-reflink-devel
> 
> I'm taking a break from active development for a week or two to concentrate on
> finding and fixing bugs.  The content of the branches hasn't changed from
> a few days ago, so no need to re-pull if you just did.
> 
> --D
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
