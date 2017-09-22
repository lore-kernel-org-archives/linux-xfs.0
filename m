Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34723 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751653AbdIVCSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 22:18:44 -0400
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 0/3] Fix/harden "quick" tests for realtime subvolumes
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <20170922020240.2503987-1-rwareing@fb.com>
Date: Thu, 21 Sep 2017 19:18:37 -0700
Content-Transfer-Encoding: 7bit
Message-ID: <3EC8B10D-4B2B-4448-8600-8536754DD690@fb.com>
References: <20170922020240.2503987-1-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Oh, and here's my exclude list:

generic/050 <--- Test is fine, message mis-match (xfsprogs?)
generic/449 <--- Test fails on XFS without realtime subvol
generic/451 <--- Test fails on XFS without realtime subvol
xfs/005     <--- Test is fine, message mis-match (xfsprogs?)
xfs/187     <---- Fails with "Need to update test 187 so that
                   initial subtests do not use features2"

So these are unrelated to realtime sub-volumes.

Richard


Richard Wareing <rwareing@fb.com> wrote:

> Some tests have issues when being run with realtime subvolumes.  This patch
> set aims to harden fs tests so we can get reliable/reproducible test runs
> with fstests for realtime subvolumes.
>
> Two new _require functions are introduced along with a new flag to
> automatically set the rtinherit=1 option upon mkfs'ing.
>
> The problems I found were usually one of:
> 1. Snapshot + subsequent test being performed without regard to the  
> realtime
> subvolume.
> 2. Use of functions which are not supported by realtime devices.  Not  
> setting
> rtinherit on scratch devices for these cases fixes these tests.   
> Non-scratch
> cases are more tricky since we don't control what goes into the  
> MKFS_OPTIONS
> variable.
> 3. xfs_repair being used directly without checking for RT devices.
>
> After fixing these cases, you get 86 good "quick: xfs tests & 180 good  
> "quick"
> generic tests with the bulk are not run due to the lack of reflink and/or  
> quota
> support on realtime scratch targets.
>
> P.S. I haven't forgotten about the non-"quick" tests, but I had to start
> somewhere, and break this up a bit into a more manageable problem.
>
>
> Richard Wareing (3):
>   xfs/realtime: Add require_no_realtime function
>   xfs/realtime: Default rtinherit=1, add _require_no_rtinherit function
>   xfs/realtime: Fix direct invocations of xfs_repair
>
>  common/rc                      | 32 +++++++++++++++++++++++++++++++-
>  tests/generic/250              |  1 +
>  tests/generic/252              |  1 +
>  tests/generic/409              |  1 +
>  tests/generic/410              |  1 +
>  tests/generic/411              |  1 +
>  tests/generic/427              |  1 +
>  tests/generic/441              |  1 +
>  tests/xfs/019                  |  1 +
>  tests/xfs/031                  |  1 +
>  tests/xfs/070                  |  4 ++--
>  tests/xfs/077                  |  1 +
>  tests/xfs/170                  |  1 +
>  tests/xfs/187                  |  1 +
>  tests/xfs/189                  |  1 +
>  tests/xfs/191-input-validation |  1 +
>  tests/xfs/202                  |  1 +
>  tests/xfs/284                  |  1 +
>  tests/xfs/291                  |  3 ++-
>  19 files changed, 51 insertions(+), 4 deletions(-)
>
> -- 
> 2.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


