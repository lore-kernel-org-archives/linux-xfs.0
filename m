Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59455 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750739AbdIGXjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 19:39:18 -0400
Date: Fri, 8 Sep 2017 09:38:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170907233844.GD17782@dastard>
References: <20170829235052.21050-1-david@fromorbit.com>
 <16359260.pvgM9Ovr5r@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16359260.pvgM9Ovr5r@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 04:01:57PM +0530, Chandan Rajendra wrote:
> On Wednesday, August 30, 2017 5:20:10 AM IST Dave Chinner wrote:
> > Everyone who tries to modify mkfs quickly learns that it is a pile
> > of spaghetti, the only difference in opinion is whether it is a
> > steaming, cold or rotten pile. This patchset attempts to untangle
> > the ball of pasta and turn it into a set of clear, obvious
> > operations that lead to a filesystem being formatted correctly.
> > 
> > The patch series is really in three parts, splitting the code up
> > into roughly three modules. The first part introduces a mkfs
> > parameters structure and factors the on-disk formatting code to use
> > only information in that structure. The second part introduces a
> > command line input structure and factors the input parsing to use
> > it. This requires a bunch of temporary code to keep the rest of
> > the code working. The third part is factoring the input validation
> > and geometry calculation code to use the input structure and put
> > the output into the mkfs parameter structure and to remove all the
> > temporary support code.
> > 
> > The result is three modules - input parsing, validation+calculations
> > and formatting - with well defined data flow between them. This also
> > paves the way to supporting config files to set defaults via a
> > separate (new) module. The overall data flow now looks like this:
> > 
> > Build defaults --\
> >                   ---> mkfs_default_params -> CLI -> mkfs_params
> > config file -----/
> > 
> > It is not worth spending a lot of time reviewing the temporary code
> > that is added - it gets removed before the end of the series. No
> > attempt has been made to ensure that mkfs works 100% correctly after
> > each patch is applied - the only guarantee is that it will build
> > cleanly. It /should/ work if a bisect lands in the middle of the
> > series, but trying to exhaustively test each patch is OK would take
> > more effort than it is worth. As such, testing has only been
> > performed on the whole series.
> > 
> > The new output from mkfs to indicate where it has sourced the
> > defaults from causes xfstests to have conniptions. This requires
> > some updates to the mkfs output filters that are already in place
> > but it is a fairly trivial update. Test xfs/191 has a couple of new
> > failures, but that is because the new code now correctly parses
> > things like agsize so that block and sector size based
> > specifications work with default mkfs values. This will require test
> > updates.
> > 
> > Future work will be to split the xfs_mkfs.c file into a file per
> > module (i.e. seperate files for CLI parsing, mkfs formating,
> > validation+calculation and, finally, one for config file support),
> > but otherwise the majority of the factoring work is now complete.
> > 
> > Comments, flames, etc all welcome.
> > 
> 
> Hi Dave,
> 
> For 4k blocksized xfs filesystem on ppc64, xfs/058 fails with mkfs refactor 
> patchset applied.
> 
> [root@localhost xfstests-dev]# ./check xfs/058
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/ppc64 localhost 4.13.0-next-20170905-00001-g9730219
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> MOUNT_OPTIONS -- /dev/loop1 /mnt/btrfs-xfstest-scratch
> 
> xfs/058 2s ... - output mismatch (see /root/repos/xfstests-dev/results//xfs/058.out.bad)
>     --- tests/xfs/058.out       2017-09-03 02:23:13.432063287 -0500
>     +++ /root/repos/xfstests-dev/results//xfs/058.out.bad       2017-09-07 05:07:49.850183977 -0500
>     @@ -13,16 +13,16 @@
>      fdblocks = 9223372036854775807
>      Test verb middlebit
>      Allowing fuzz of corrupted data with good CRC
>     -fdblocks = 9223372034707292159
>     +fdblocks = 9223372036854775807
>      Test verb lastbit
>      Allowing fuzz of corrupted data with good CRC
>     ...
>     (Run 'diff -u tests/xfs/058.out /root/repos/xfstests-dev/results//xfs/058.out.bad'  to see the entire diff)
> Ran: xfs/058
> Failures: xfs/058
> Failed 1 of 1 tests

That's a bug in xfs_db, not my patchset. Fixed by commit
592c10154f99 ("xfs_db: bit fuzzing should read the right bit when
flipping").

> Also, xfs/206 fails because the line 
> "Default configuration sourced from package build definitions" isn't getting 
> filtered out.

Lots of tests fail that way. I have a local xfstests patch that
filters these out that I haven't sent out yet. Attached below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

---
 common/xfs    | 3 ++-
 tests/xfs/206 | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/common/xfs b/common/xfs
index 2c34e0887747..3969582866cf 100644
--- a/common/xfs
+++ b/common/xfs
@@ -81,7 +81,8 @@ _scratch_mkfs_xfs()
 {
 	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
 	local mkfs_filter="sed -e '/less than device physical sector/d' \
-			       -e '/switching to logical sector/d'"
+			       -e '/switching to logical sector/d' \
+			       -e '/Default configuration/d'"
 	local tmp=`mktemp -u`
 	local mkfs_status
 
diff --git a/tests/xfs/206 b/tests/xfs/206
index 70997e3fe83e..01782b7b93a9 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -84,7 +84,8 @@ mkfs_filter()
 	    -e "s/\(sectsz\)\(=[0-9]* *\)/\1=512   /" \
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
-	    -e "/.*crc=/d"
+	    -e "/.*crc=/d" \
+	    -e "/^Default configuration/d"
 }
 
 # mkfs slightly smaller than that, small log for speed.
