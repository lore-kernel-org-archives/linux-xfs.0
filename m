Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeKFORc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 09:17:32 -0500
Date: Mon, 5 Nov 2018 20:54:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/8] fstests: fix quota failures on xfs
Message-ID: <20181106045402.GB28338@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
 <20181104160149.GD12788@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181104160149.GD12788@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 05, 2018 at 12:01:49AM +0800, Eryu Guan wrote:
> On Thu, Nov 01, 2018 at 04:19:02PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Several months ago I tried testing xfs with quotas enabled and was
> > surprised at the number of failures.  Since then I've been on a bug hunt
> > to triage the mess, and the following series fixes some of the low
> > hanging fruit.  Some of these are minor behavioral variations when quota
> > are enabled, and other fixes upgrade old v4 tests to work on v5
> > filesystems.
> > 
> > To reproduce the results, run xfstests with
> > 'MOUNT_OPTIONS="-o usrquota,grpquota,prjquota"' on a v5 filesystem.
> > Strike the ',grpquota' on a v4 filesystem.
> 
> I merged all patches but patch 3 and 8, because ..
> 
> > 
> > The first patch fixes the sporadic quota count failures when testing XFS
> > with quotas by replacing the xfs_spaceman call that cleans out (only)
> > speculative preallocations with a umount/mount pair that forcibly cleans
> > out /all/ preallocations and delayed allocations.
> > 
> > The second patch fixes bugs in a couple of tests that use error
> > injection to test log recovery paths but don't succeed in directly
> > causing the error to trip.
> > 
> > The third patch works around the fact that mounting xfs with quotas
> > requires a writable block device even for a ro mount, which leads to
> > a slightly different error message from the mount call.
> 
> The test still fails and patch needs further tweaks.

I'll have a look tomorrow.

> > 
> > Patch 4 and 5 fix the dump and restore tests to handle the case that
> > quota inodes get sent along with dumps when quotas are enabled.
> > 
> > Patch 6 updates xfs/205 to work with v5 filesystems.
> > 
> > Patch 7 changes tests that require specific quota mount options to clear
> > out the background quota mount options so that we test with /exactly/
> > the set of mount options.
> > 
> > Patch 8 filters v5 mount options out of tests that format v4
> > filesystems on the scratch device.
> 
> This patch touches _scratch_mkfs_xfs() and needs more careful testing.

Yeah, I thought of something today -- each test is run in a separate
child process from ./check, which means that if we force a v4
filesystem during a test, the ./check script is going to have to know
about the rewritten MOUNT_OPTIONS if it remounts the scratch device
after the test exits.  Hmm.  Not sure if we want a big complex machinery
to do that or just detect the incompatible mount options and _notrun...

--D

> Thanks,
> Eryu
