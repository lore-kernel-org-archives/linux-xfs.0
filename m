Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F51C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 23:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbiCPX1y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238816AbiCPX1x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 19:27:53 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6631964C9
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:26:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 669815335B4;
        Thu, 17 Mar 2022 10:26:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUd2K-006KWD-Jj; Thu, 17 Mar 2022 10:26:36 +1100
Date:   Thu, 17 Mar 2022 10:26:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: Regression in XFS for fsync heavy workload
Message-ID: <20220316232636.GT3927073@dread.disaster.area>
References: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
 <20220316010627.GO3927073@dread.disaster.area>
 <20220316074459.GP3927073@dread.disaster.area>
 <20220316100934.6bcg75zcfvoyizzl@quack3.lan>
 <20220316193840.3t2ahjxnkvmk6okz@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316193840.3t2ahjxnkvmk6okz@quack3.lan>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6232722d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=rdsfuAKNP4PFHdmOdA4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 08:38:40PM +0100, Jan Kara wrote:
> On Wed 16-03-22 11:09:34, Jan Kara wrote:
> > On Wed 16-03-22 18:44:59, Dave Chinner wrote:
> > > On Wed, Mar 16, 2022 at 12:06:27PM +1100, Dave Chinner wrote:
> > > > On Tue, Mar 15, 2022 at 01:49:43PM +0100, Jan Kara wrote:
> > > > > Hello,
> > > > > 
> > > > > I was tracking down a regression in dbench workload on XFS we have
> > > > > identified during our performance testing. These are results from one of
> > > > > our test machine (server with 64GB of RAM, 48 CPUs, SATA SSD for the test
> > > > > disk):
> > > > > 
> > > > > 			       good		       bad
> > > > > Amean     1        64.29 (   0.00%)       73.11 * -13.70%*
> > > > > Amean     2        84.71 (   0.00%)       98.05 * -15.75%*
> > > > > Amean     4       146.97 (   0.00%)      148.29 *  -0.90%*
> > > > > Amean     8       252.94 (   0.00%)      254.91 *  -0.78%*
> > > > > Amean     16      454.79 (   0.00%)      456.70 *  -0.42%*
> > > > > Amean     32      858.84 (   0.00%)      857.74 (   0.13%)
> > > > > Amean     64     1828.72 (   0.00%)     1865.99 *  -2.04%*
> > > > > 
> > > > > Note that the numbers are actually times to complete workload, not
> > > > > traditional dbench throughput numbers so lower is better.
> > > ....
> > > 
> > > > > This should still
> > > > > submit it rather early to provide the latency advantage. Otherwise postpone
> > > > > the flush to the moment we know we are going to flush the iclog to save
> > > > > pointless flushes. But we would have to record whether the flush happened
> > > > > or not in the iclog and it would all get a bit hairy...
> > > > 
> > > > I think we can just set the NEED_FLUSH flag appropriately.
> > > > 
> > > > However, given all this, I'm wondering if the async cache flush was
> > > > really a case of premature optimisation. That is, we don't really
> > > > gain anything by reducing the flush latency of the first iclog write
> > > > wehn we are writing 100-1000 iclogs before the commit record, and it
> > > > can be harmful to some workloads by issuing more flushes than we
> > > > need to.
> > > > 
> > > > So perhaps the right thing to do is just get rid of it and always
> > > > mark the first iclog in a checkpoint as NEED_FLUSH....
> > > 
> > > So I've run some tests on code that does this, and the storage I've
> > > tested it on shows largely no difference in stream CIL commit and
> > > fsync heavy workloads when comparing synv vs as cache flushes. On
> > > set of tests was against high speed NVMe ssds, the other against
> > > old, slower SATA SSDs.
> > > 
> > > Jan, can you run the patch below (against 5.17-rc8) and see what
> > > results you get on your modified dbench test?
> > 
> > Sure, I'll run the test. I forgot to mention that in vanilla upstream kernel
> > I could see the difference in the number of cache flushes caused by the
> > XFS changes but not actual change in dbench numbers (they were still
> > comparable to the bad ones from my test). The XFS change made material
> > difference to dbench performance only together with scheduler / cpuidling /
> > frequency scaling fixes we have in our SLE kernel (I didn't try to pin down
> > which exactly - I guess I can try working around that by using performance
> > cpufreq governor and disabling low cstates so that I can test stock
> > vanilla kernels). Thanks for the patch!
> 
> Yup, so with limiting cstates and performance cpufreq governor I can see
> your patch helps significantly the dbench performance:
> 
>                    5.18-rc8-vanilla       5.18-rc8-patched
> Amean     1        71.22 (   0.00%)       64.94 *   8.81%*
> Amean     2        93.03 (   0.00%)       84.80 *   8.85%*
> Amean     4       150.54 (   0.00%)      137.51 *   8.66%*
> Amean     8       252.53 (   0.00%)      242.24 *   4.08%*
> Amean     16      454.13 (   0.00%)      439.08 *   3.31%*
> Amean     32      835.24 (   0.00%)      829.74 *   0.66%*
> Amean     64     1740.59 (   0.00%)     1686.73 *   3.09%*
> 
> The performance is restored to values before commit bad77c375e8d ("xfs: CIL
> checkpoint flushes caches unconditionally") as well as the number of
> flushes.

OK, good to know, thanks for testing quickly. I'll spin this up into
a proper patch that removes the async flush functionality and
support infrastructure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
