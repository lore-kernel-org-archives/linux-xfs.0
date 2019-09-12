Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32178C4CEC6
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 22:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EDE420856
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 22:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfILWqr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 18:46:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45147 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfILWqr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 18:46:47 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5887E43EADA;
        Fri, 13 Sep 2019 08:46:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8XrP-0007aV-6g; Fri, 13 Sep 2019 08:46:43 +1000
Date:   Fri, 13 Sep 2019 08:46:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190912224643.GQ16973@dread.disaster.area>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
 <20190912223519.GP16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912223519.GP16973@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=Y3Wc6XzqDh_2HXIujjQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 13, 2019 at 08:35:19AM +1000, Dave Chinner wrote:
> On Thu, Sep 12, 2019 at 10:32:22AM -0400, Brian Foster wrote:
> > The bmap block allocation code issues a sequence of retries to
> > perform an optimal allocation, gradually loosening constraints as
> > allocations fail. For example, the first attempt might begin at a
> > particular bno, with maxlen == minlen and alignment incorporated. As
> > allocations fail, the parameters fall back to different modes, drop
> > alignment requirements and reduce the minlen and total block
> > requirements.
> > 
> > For large extent allocations with an args.total value that exceeds
> > the allocation length (i.e., non-delalloc), the total value tends to
> > dominate despite these fallbacks. For example, an aligned extent
> > allocation request of tens to hundreds of MB that cannot be
> > satisfied from a particular AG will not succeed after dropping
> > alignment or minlen because xfs_alloc_space_available() never
> > selects an AG that can't satisfy args.total. The retry sequence
> > eventually reduces total and ultimately succeeds if a minlen extent
> > is available somewhere, but the first several retries are
> > effectively pointless in this scenario.
> > 
> > Beyond simply being inefficient, another side effect of this
> > behavior is that we drop alignment requirements too aggressively.
> > Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
> > unit:
> > 
> >  # xfs_io -c "falloc 0 1g" /mnt/file
> >  # <xfstests>/src/t_stripealign /mnt/file 32
> >  /mnt/file: Start block 347176 not multiple of sunit 32
> 
> Ok, so what Carlos and I found last night was an issue with the
> the agresv code leading to the maximum free extent calculated
> by xfs_alloc_longest_free_extent() being longer than the largest
> allowable extent allocation (mp->m_ag_max_usable) resulting in the
> situation where blen > args->maxlen, and so in the case of initial
> allocation here, we never run this:

Just to make it clear: carlos did all the hard work of narrowing it
down and isolating the accounting discrepancy in the allocation
code. All I did was put 2 and 2 together - the agresv discrepancy -
wrote a quick patch and did a trace to make sure I didn't get 5...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
