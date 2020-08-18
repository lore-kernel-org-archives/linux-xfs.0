Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB39C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470E720738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 23:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgHRXmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:42:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53575 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbgHRXmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 19:42:03 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 45C083A6A03;
        Wed, 19 Aug 2020 09:41:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8BEm-0007Gc-TC; Wed, 19 Aug 2020 09:41:52 +1000
Date:   Wed, 19 Aug 2020 09:41:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH v2 00/11] xfs: widen timestamps to deal with y2038
Message-ID: <20200818234152.GE21744@dread.disaster.area>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <20200818230121.GC21744@dread.disaster.area>
 <20200818231033.GO6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818231033.GO6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=2TmBx4tW1hcvlFtODfQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 04:10:33PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 19, 2020 at 09:01:21AM +1000, Dave Chinner wrote:
> > On Mon, Aug 17, 2020 at 03:56:48PM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > This series performs some refactoring of our timestamp and inode
> > > encoding functions, then retrofits the timestamp union to handle
> > > timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
> > > to the non-root dquot timer fields to boost their effective size to 34
> > > bits.  These two changes enable correct time handling on XFS through the
> > > year 2486.
> > 
> > A bit more detail would be nice :)
> 
> Heh, ok.
> 
> > Like, the inode timestamp has a range of slightly greater than 2^34
> > because 10^9 < 2^30. i.e.
> > 
> > Inode timestamp range in days:
> > 
> > $ echo $(((2**62 / (1000*1000*1000) / 86400) * 2**2))
> > 213500
> > $
> > 
> > While the quota timer range in days is:
> > $ echo $(((2**34 / 86400)))
> > 198841
> > $
> > 
> > There's ~15,000 days difference in range here, which in years is
> > about 40 years. Hence the inodes have a timestamp range out to
> > ~2485 from the 1901 epoch start, while quota timers have a range
> > out to only 2445 from the epoch start.
> 
> Quota timers have always treated the d_{b,i,rtb}timer value as an
> unsigned 32-bit integer, which means that it has /never/ been possible
> to set a timer expiration before 1/1/1970.  The quota timer range is
> therefore 198,841 days *after* 1970, not after 1901.
> 
> Therefore, the quota timer range in days is:
> 
> $ echo $(( ((2**34) + (2**31)) / 86400) ))
> 223696
> 
> So, technically speaking, the quota timers could go beyond 2486, but the
> current patchset clamps the quota counters to the same max as the
> inodes.  I guess I just proved the need for more details upfront.

Yeah, little things like quota timers and inode timestamps having a
different epoch value are kinda important to understand. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
