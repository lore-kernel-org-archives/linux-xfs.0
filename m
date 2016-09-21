Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44054 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932640AbcIUXj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 19:39:57 -0400
Date: Thu, 22 Sep 2016 09:39:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fstests: test xfs_copy V5 XFS without -d option
Message-ID: <20160921233952.GO340@dastard>
References: <1474455620-25982-1-git-send-email-zlang@redhat.com>
 <20160921213729.GN340@dastard>
 <4b37d061-43b5-74f6-b544-0f97693270c5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b37d061-43b5-74f6-b544-0f97693270c5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Sep 21, 2016 at 05:07:15PM -0500, Eric Sandeen wrote:
> On 9/21/16 4:37 PM, Dave Chinner wrote:
> > On Wed, Sep 21, 2016 at 07:00:20PM +0800, Zorro Lang wrote:
> > As I said above, xfs_copy on v5 filesystems do not require the
> > "-d" option if xfs_admin can change the UUID on v5 filesystems.
> > i.e. if this works:
> > 
> > # xfs_admin -U generate /dev/pmem1
> > Clearing log and setting UUID
> > writing all SBs
> > new UUID = b4e22c8b-1bfb-4307-a3f2-4f55b5c9d61d
> > # echo $?
> > 0
> > #
> 
> "works," meaning "doesn't corrupt" I guess, right?

I meant "works" as in "fully supported". The requirement for "-d"
with xfs_copy was present in the first release that supported CRCs
(i.e. 3.2.0). That was added in commit a872b62 ("xfs_copy: band-aids
for CRC filesystems") for in 3.2.0-rc1.

> 3.2.2 actually
> allowed it to proceed, but corrupted the filesystem.

Sure, it had bugs. Which have since been fixed. :P

> Then later it,
> too, was restricted on v5 filesystems, and later those restrictions
> were lifted.

It was restricted from the first release, which is why I suggested
just testing whether the UUID can be changed, because that covers
all xfsprogs releases supporting CRCs up to the point where "-d" is
no longer necessary...

> Honestly, (and Dave helped push me in this direction as well), I think
> the addition of "-d" should just be removed; we now have a binary that
> /works/ and there's no reason to avoid running broken binaries - the
> whole point of testing is to find out whether what you're testing works,
> or if it's broken.  Skipping tests because they might fail leaves you with
> missing information about the environment you're testing.

Yes, though my point was wider than that, and about _requires rules
in general - they are simply checks for infrastructure an support
being present on the system the test is being run on. They do not,
and should not, try to determine if the functionality works or
whether the version being used has a specific bug in it or not -
the tests themselves will tell us that when they fail.

A reminder to people running xfstests in QE environments for older
distros: if there are tests that are known to fail because of a lack
of support or known, WONTFIX bugs, you are supposed to avoid running
them via the use of custom expunge files, not _requires rules.  Keep
distro release specific expunge files to list what tests should not
be run (you can add comments to those files to document the reasons)
in your QE configuration management environment and deploy them
appropriately to your test targets....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
