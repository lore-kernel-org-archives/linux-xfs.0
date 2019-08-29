Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B61C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 09:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175E92339E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 09:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfH2JOf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 05:14:35 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39359 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726245AbfH2JOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 05:14:35 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4EDD443C78E;
        Thu, 29 Aug 2019 19:14:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3GVj-0002Sp-Le; Thu, 29 Aug 2019 19:14:31 +1000
Date:   Thu, 29 Aug 2019 19:14:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reverse search directory freespace indexes
Message-ID: <20190829091431.GR1119@dread.disaster.area>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-6-david@fromorbit.com>
 <20190829082310.GA13557@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829082310.GA13557@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=4BO8LJeqczPL_zcit0oA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 01:23:10AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 29, 2019 at 04:30:42PM +1000, Dave Chinner wrote:
> > 		create time(sec) / rate (files/s)
> >  File count     vanilla             Prev commit		Patched
> >   10k	      0.41 / 24.3k	   0.42 / 23.8k       0.41 / 24.3k
> >   20k	      0.74 / 27.0k	   0.76 / 26.3k       0.75 / 26.7k
> >  100k	      3.81 / 26.4k	   3.47 / 28.8k       3.27 / 30.6k
> >  200k	      8.58 / 23.3k	   7.19 / 27.8k       6.71 / 29.8k
> >    1M	     85.69 / 11.7k	  48.53 / 20.6k      37.67 / 26.5k
> >    2M	    280.31 /  7.1k	 130.14 / 15.3k      79.55 / 25.2k
> >   10M	   3913.26 /  2.5k                          552.89 / 18.1k
> 
> Impressive!

Yeah, i think the  drop-off in performance at 10M inodes is caused
by running out of RAM at about 6M inodes, and so there's extra CPU
time spent in direct memory reclaim after than so the single
threaded create performance is lower from as a result.

> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> 
> FYI, the Off here should be all lower case.  Patch 2 actually has the
> same issue, but I only noticed it here.

Yeah, 3 of 5 patches are like that. No idea how - I use macros for
all these sobs and rvbs and they all use lower case....

> > @@ -1781,6 +1782,9 @@ xfs_dir2_node_find_freeblk(
> >  		 */
> >  		ifbno = fblk->blkno;
> >  		fbno = ifbno;
> > +		xfs_trans_brelse(tp, fbp);
> > +		fbp = NULL;
> > +		fblk->bp = NULL;
> 
> Hmm.  Doesn't this actually belong into the previous patch?

Yup, I'll move them.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
