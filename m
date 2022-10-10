Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF58C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 00:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiJJAd0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 20:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiJJAdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 20:33:04 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5324E65AC
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 17:07:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 96ACE11014C2;
        Mon, 10 Oct 2022 11:07:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ohgKa-0006Ch-Nt; Mon, 10 Oct 2022 11:07:40 +1100
Date:   Mon, 10 Oct 2022 11:07:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Oliver Sang <oliver.sang@intel.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, lkp@lists.01.org, lkp@intel.com,
        Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org
Subject: Re: [xfs]  a1df10d42b: xfstests.generic.31*.fail
Message-ID: <20221010000740.GU3600936@dread.disaster.area>
References: <202210052153.fedff8e6-oliver.sang@intel.com>
 <20221005213543.GP3600936@dread.disaster.area>
 <Y0J1oxBFwW53udvJ@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0J1oxBFwW53udvJ@xsang-OptiPlex-9020>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6343624f
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
        a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8 a=fl1LBcFEd7AkPq1s3CYA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 09, 2022 at 03:17:55PM +0800, Oliver Sang wrote:
> Hi Dave,
> 
> On Thu, Oct 06, 2022 at 08:35:43AM +1100, Dave Chinner wrote:
> > On Wed, Oct 05, 2022 at 09:45:12PM +0800, kernel test robot wrote:
> > > 
> > > Greeting,
> > > 
> > > FYI, we noticed the following commit (built with gcc-11):
> > > 
> > > commit: a1df10d42ba99c946f6a574d4d31951bc0a57e33 ("xfs: fix exception caused by unexpected illegal bestcount in leaf dir")
> > > url: https://github.com/intel-lab-lkp/linux/commits/UPDATE-20220929-162751/Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220831-195920
> > > 
> > > in testcase: xfstests
> > > version: xfstests-x86_64-5a5e419-1_20220927
> > > with following parameters:
> > > 
> > > 	disk: 4HDD
> > > 	fs: xfs
> > > 	test: generic-group-15
> > > 
> > > test-description: xfstests is a regression test suite for xfs and other files ystems.
> > > test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> > > 
> > > 
> > > on test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz (Ivy Bridge) with 8G memory
> > > 
> > > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > THe attached dmesg ends at:
> > 
> > [...]
> > [  102.727610][  T315] generic/309       IPMI BMC is not supported on this machine, skip bmc-watchdog setup!
> > [  102.727630][  T315] 
> > [  103.884498][ T7407] XFS (sda1): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> > [  103.993962][ T7431] XFS (sda1): Unmounting Filesystem
> > [  104.193659][ T7580] XFS (sda1): Mounting V5 Filesystem
> > [  104.221178][ T7580] XFS (sda1): Ending clean mount
> > [  104.223821][ T7580] xfs filesystem being mounted at /fs/sda1 supports timestamps until 2038 (0x7fffffff)
> > [  104.285615][  T315]  2s
> > [  104.285629][  T315] 
> > [  104.339232][ T1469] run fstests generic/310 at 2022-10-01 13:36:36
> > (END)
> > 
> > The start of the failed test. Do you have the logs from generic/310
> > so we might have some idea what corruption/shutdown event occurred
> > during that test run?
> 
> sorry for that. I attached dmesg for another run.

[  109.424124][ T1474] run fstests generic/310 at 2022-10-01 10:14:01
[  169.865043][ T7563] XFS (sda1): Metadata corruption detected at xfs_dir3_leaf_check_int+0x381/0x600 [xfs], xfs_dir3_leafn block 0x4000088 
[  169.865406][ T7563] XFS (sda1): Unmount and run xfs_repair
[  169.865510][ T7563] XFS (sda1): First 128 bytes of corrupted metadata buffer:
[  169.865639][ T7563] 00000000: 00 80 00 01 00 00 00 00 3d ff 00 00 00 00 00 00  ........=.......
[  169.865793][ T7563] 00000010: 00 00 00 00 04 00 00 88 00 00 00 00 00 00 00 00  ................
[  169.865945][ T7563] 00000020: 27 64 dd b1 81 61 45 2b 86 66 64 67 56 f2 40 58  'd...aE+.fdgV.@X
[  169.866122][ T7563] 00000030: 00 00 00 00 00 00 00 87 00 fc 00 00 00 00 00 00  ................
[  169.866293][ T7563] 00000040: 00 00 00 2e 00 00 00 08 00 00 00 31 00 00 00 0c  ...........1....
[  169.866467][ T7563] 00000050: 00 00 00 32 00 00 00 0e 00 00 00 33 00 00 00 10  ...2.......3....
[  169.866640][ T7563] 00000060: 00 00 00 34 00 00 00 12 00 00 00 35 00 00 00 14  ...4.......5....
[  169.866816][ T7563] 00000070: 00 00 00 36 00 00 00 16 00 00 00 37 00 00 00 18  ...6.......7....
[  169.867002][ T7563] XFS (sda1): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply+0x508/0x600 [xfs] (fs/xfs/xfs_buf.c:1552).  Shutting down filesystem.

I don't see any corruption in the leafn header or the first few hash
entries there. It does say it has 0xfc entries in the block, which
is correct for a full leaf of hash pointers. It has no stale
entries, which is correct according to the what the test does (it
does not remove directory entries at all. It has a forward pointer
but no backwards pointer, which is expected as the hash values tell
me this should be the left-most leaf block in the tree.

The error has been detected at write time, which means the problem
was detected before it got written to disk. But I don't see what
code in xfs_dir3_leaf_check_int() is even triggering a warning on a
leafn block here - what line of code does
xfs_dir3_leaf_check_int+0x381/0x600 actually resolve to?

.....

<nnngggghhh>

No wonder I can't reproduce this locally.

commit a1df10d42ba99c946f6a574d4d31951bc0a57e33 *does not exist in
the upstream xfs-dev tree*. The URL provided pointing to the commit
above resolves to a "404 page not found" error, so I have not idea
what code was even being tested here.

AFAICT, the patch being tested is this one (based on the github url
matching the patch title:

https://lore.kernel.org/linux-xfs/20220831121639.3060527-1-guoxuenan@huawei.com/

Which I NACKed almost a whole month ago! The latest revision of the
patch was posted 2 days ago here:

https://lore.kernel.org/linux-xfs/20221008033624.1237390-1-guoxuenan@huawei.com/

Intel kernel robot maintainers: I've just wasted the best part of 2
hours trying to reproduce and track down a corruption bug that this
report lead me to beleive was in the upstream XFS tree.

You need to make it very clear that your bug report is for a commit
that *hasn't been merged into an upstream tree*. The CI robot
noticed a bug in an *old* NACKed patch, not a bug in a new upstream
commit. Please make it *VERY CLEAR* where the code the CI robot is
testing has come from.

Not happy.

-- 
Dave Chinner
david@fromorbit.com
