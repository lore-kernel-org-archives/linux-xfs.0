Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:47008 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752380AbeFEWiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 18:38:21 -0400
Date: Wed, 6 Jun 2018 08:38:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [lkp-robot] [xfs]  b027d4c97b:  fio.latency_2ms% +7.1% regression
Message-ID: <20180605223813.GI10363@dastard>
References: <20180605071657.GP16472@yexl-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180605071657.GP16472@yexl-desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: kernel test robot <xiaolong.ye@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, lkp@01.org

On Tue, Jun 05, 2018 at 03:16:57PM +0800, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed a +7.1%% regression of fio.latency_2ms% due to commit:
> 
> 
> commit: b027d4c97b9675c2ad75dec94be4e46dceb3ec74 ("xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure")
> https://git.kernel.org/cgit/fs/xfs/xfs-linux.git xfs-4.18-merge
....
> 8925a3dc4771004b b027d4c97b9675c2ad75dec94b 
> ---------------- -------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>      46.56 ±  3%      +7.1       53.61        fio.latency_2ms%
>       8.19            +0.2        8.40        fio.latency_100ms%
>       0.74 ±  3%      -0.1        0.68 ±  6%  fio.latency_250ms%
>      25.20 ±  6%      -7.3       17.86 ±  6%  fio.latency_4ms%
>       0.46 ±  9%      +0.2        0.69 ± 13%  fio.latency_750us%

This is not a regression. The number of IOs in the 4ms IO latency
bin has reduced by 7%, and inumber in the 2ms IO latency bin has
increased by 7%. IOWs, there's a measurable improvement in IO
latency as a result of those patches, not a regression.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
