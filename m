Return-Path: <SRS0=Ptmy=CP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8F6C43461
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Sep 2020 21:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F185620838
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Sep 2020 21:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgIFVn3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Sep 2020 17:43:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55818 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbgIFVn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Sep 2020 17:43:26 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B272A824820;
        Mon,  7 Sep 2020 07:43:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kF2RW-0006nX-4Z; Mon, 07 Sep 2020 07:43:22 +1000
Date:   Mon, 7 Sep 2020 07:43:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, Christoph Hellwig <hch@lst.de>,
        Gao Xiang <hsiangkao@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH v6 00/11] xfs: widen timestamps to deal with y2038
Message-ID: <20200906214322.GJ12131@dread.disaster.area>
References: <159901538766.548109.8040337941204954344.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159901538766.548109.8040337941204954344.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=c2G1fFWkcBAuiYV251wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 07:56:27PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series performs some refactoring of our timestamp and inode
> encoding functions, then retrofits the timestamp union to handle
> timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
> to the non-root dquot timer fields to boost their effective size to 34
> bits.  These two changes enable correct time handling on XFS through the
> year 2486.
> 
> On a current V5 filesystem, inodes timestamps are a signed 32-bit
> seconds counter, with 0 being the Unix epoch.  Quota timers are an
> unsigned 32-bit seconds counter, with 0 also being the Unix epoch.
> 
> This means that inode timestamps can range from:
> -(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).
> 
> And quota timers can range from:
> 0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).
> 
> With the bigtime encoding turned on, inode timestamps are an unsigned
> 64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
> are a 34-bit unsigned second counter right shifted two bits, with 0
> being the Unix epoch, and capped at the maximum inode timestamp value.
> 
> This means that inode timestamps can range from:
> 0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)
> 
> Quota timers could theoretically range from:
> 0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).
> 
> But with the capping in place, the quota timers maximum is:
> max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).
> 
> v2: rebase to 5.9, having landed the quota refactoring
> v3: various suggestions by Amir and Dave
> v4: drop the timestamp unions, add "is bigtime?" predicates everywhere
> v5: reintroduce timestamp unions as *legacy* timestamp unions
> v6: minor stylistic changes
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

The whole series looks good to me now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
