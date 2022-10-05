Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E4DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 21:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJEVfv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJEVfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 17:35:48 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19D53804A5
        for <linux-xfs@vger.kernel.org>; Wed,  5 Oct 2022 14:35:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8F2158AC846;
        Thu,  6 Oct 2022 08:35:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ogC3L-00G4t3-Kp; Thu, 06 Oct 2022 08:35:43 +1100
Date:   Thu, 6 Oct 2022 08:35:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, lkp@lists.01.org, lkp@intel.com,
        Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org
Subject: Re: [xfs]  a1df10d42b: xfstests.generic.31*.fail
Message-ID: <20221005213543.GP3600936@dread.disaster.area>
References: <202210052153.fedff8e6-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210052153.fedff8e6-oliver.sang@intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=633df8b2
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=aq-iy-2zej2EoO07X30A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 05, 2022 at 09:45:12PM +0800, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: a1df10d42ba99c946f6a574d4d31951bc0a57e33 ("xfs: fix exception caused by unexpected illegal bestcount in leaf dir")
> url: https://github.com/intel-lab-lkp/linux/commits/UPDATE-20220929-162751/Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220831-195920
> 
> in testcase: xfstests
> version: xfstests-x86_64-5a5e419-1_20220927
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: xfs
> 	test: generic-group-15
> 
> test-description: xfstests is a regression test suite for xfs and other files ystems.
> test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> 
> on test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz (Ivy Bridge) with 8G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):

THe attached dmesg ends at:

[...]
[  102.727610][  T315] generic/309       IPMI BMC is not supported on this machine, skip bmc-watchdog setup!
[  102.727630][  T315] 
[  103.884498][ T7407] XFS (sda1): EXPERIMENTAL online scrub feature in use. Use at your own risk!
[  103.993962][ T7431] XFS (sda1): Unmounting Filesystem
[  104.193659][ T7580] XFS (sda1): Mounting V5 Filesystem
[  104.221178][ T7580] XFS (sda1): Ending clean mount
[  104.223821][ T7580] xfs filesystem being mounted at /fs/sda1 supports timestamps until 2038 (0x7fffffff)
[  104.285615][  T315]  2s
[  104.285629][  T315] 
[  104.339232][ T1469] run fstests generic/310 at 2022-10-01 13:36:36
(END)

The start of the failed test. Do you have the logs from generic/310
so we might have some idea what corruption/shutdown event occurred
during that test run?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
