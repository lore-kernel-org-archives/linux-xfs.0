Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753905AbdIGKbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 06:31:20 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v87ASsC1087839
        for <linux-xfs@vger.kernel.org>; Thu, 7 Sep 2017 06:31:20 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cu2qcnect-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2017 06:31:19 -0400
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 7 Sep 2017 20:31:16 +1000
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v87AVEfv36372550
        for <linux-xfs@vger.kernel.org>; Thu, 7 Sep 2017 20:31:14 +1000
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v87AVDub019472
        for <linux-xfs@vger.kernel.org>; Thu, 7 Sep 2017 20:31:13 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Date: Thu, 07 Sep 2017 16:01:57 +0530
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <16359260.pvgM9Ovr5r@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wednesday, August 30, 2017 5:20:10 AM IST Dave Chinner wrote:
> Everyone who tries to modify mkfs quickly learns that it is a pile
> of spaghetti, the only difference in opinion is whether it is a
> steaming, cold or rotten pile. This patchset attempts to untangle
> the ball of pasta and turn it into a set of clear, obvious
> operations that lead to a filesystem being formatted correctly.
> 
> The patch series is really in three parts, splitting the code up
> into roughly three modules. The first part introduces a mkfs
> parameters structure and factors the on-disk formatting code to use
> only information in that structure. The second part introduces a
> command line input structure and factors the input parsing to use
> it. This requires a bunch of temporary code to keep the rest of
> the code working. The third part is factoring the input validation
> and geometry calculation code to use the input structure and put
> the output into the mkfs parameter structure and to remove all the
> temporary support code.
> 
> The result is three modules - input parsing, validation+calculations
> and formatting - with well defined data flow between them. This also
> paves the way to supporting config files to set defaults via a
> separate (new) module. The overall data flow now looks like this:
> 
> Build defaults --\
>                   ---> mkfs_default_params -> CLI -> mkfs_params
> config file -----/
> 
> It is not worth spending a lot of time reviewing the temporary code
> that is added - it gets removed before the end of the series. No
> attempt has been made to ensure that mkfs works 100% correctly after
> each patch is applied - the only guarantee is that it will build
> cleanly. It /should/ work if a bisect lands in the middle of the
> series, but trying to exhaustively test each patch is OK would take
> more effort than it is worth. As such, testing has only been
> performed on the whole series.
> 
> The new output from mkfs to indicate where it has sourced the
> defaults from causes xfstests to have conniptions. This requires
> some updates to the mkfs output filters that are already in place
> but it is a fairly trivial update. Test xfs/191 has a couple of new
> failures, but that is because the new code now correctly parses
> things like agsize so that block and sector size based
> specifications work with default mkfs values. This will require test
> updates.
> 
> Future work will be to split the xfs_mkfs.c file into a file per
> module (i.e. seperate files for CLI parsing, mkfs formating,
> validation+calculation and, finally, one for config file support),
> but otherwise the majority of the factoring work is now complete.
> 
> Comments, flames, etc all welcome.
> 

Hi Dave,

For 4k blocksized xfs filesystem on ppc64, xfs/058 fails with mkfs refactor 
patchset applied.

[root@localhost xfstests-dev]# ./check xfs/058
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64 localhost 4.13.0-next-20170905-00001-g9730219
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
MOUNT_OPTIONS -- /dev/loop1 /mnt/btrfs-xfstest-scratch

xfs/058 2s ... - output mismatch (see /root/repos/xfstests-dev/results//xfs/058.out.bad)
    --- tests/xfs/058.out       2017-09-03 02:23:13.432063287 -0500
    +++ /root/repos/xfstests-dev/results//xfs/058.out.bad       2017-09-07 05:07:49.850183977 -0500
    @@ -13,16 +13,16 @@
     fdblocks = 9223372036854775807
     Test verb middlebit
     Allowing fuzz of corrupted data with good CRC
    -fdblocks = 9223372034707292159
    +fdblocks = 9223372036854775807
     Test verb lastbit
     Allowing fuzz of corrupted data with good CRC
    ...
    (Run 'diff -u tests/xfs/058.out /root/repos/xfstests-dev/results//xfs/058.out.bad'  to see the entire diff)
Ran: xfs/058
Failures: xfs/058
Failed 1 of 1 tests

I will debug this further and let you know about the results.

Also, xfs/206 fails because the line 
"Default configuration sourced from package build definitions" isn't getting 
filtered out.

-- 
chandan

