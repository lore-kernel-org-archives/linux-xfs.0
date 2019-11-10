Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AD7C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 03:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E5D208C3
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 03:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfKJCtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:49:25 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48794 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727896AbfKJCtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Nov 2019 21:49:25 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3518D3A0FF1;
        Sun, 10 Nov 2019 13:49:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iTdHz-0000WK-IG; Sun, 10 Nov 2019 13:49:19 +1100
Date:   Sun, 10 Nov 2019 13:49:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191110024919.GJ4614@dread.disaster.area>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319672136.834699.13051359836285578031.stgit@magnolia>
 <20191109223238.GH4614@dread.disaster.area>
 <20191110001803.GP6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110001803.GP6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=U2hPAowFaGFElcFuaAEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 09, 2019 at 04:18:03PM -0800, Darrick J. Wong wrote:
> On Sun, Nov 10, 2019 at 09:32:38AM +1100, Dave Chinner wrote:
> > On Thu, Nov 07, 2019 at 11:05:21PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > -		if (unlikely(
> > > -		       be32_to_cpu(sib_info->back) != last_blkno ||
> > > -		       sib_info->magic != dead_info->magic)) {
> > > -			XFS_ERROR_REPORT("xfs_da_swap_lastblock(3)",
> > > -					 XFS_ERRLEVEL_LOW, mp);
> > > +		if (XFS_IS_CORRUPT(mp,
> > > +		    be32_to_cpu(sib_info->back) != last_blkno ||
> > > +		    sib_info->magic != dead_info->magic)) {
> 
> They're both ugly, IMHO.  One has horrible indentation that's too close
> to the code in the if statement body, the other is hard to read as an if
> statement.

I was more commenting on the new code. The old code is horrible,
yes, but I don't think the new code is much better. :(

> > >  			error = -EFSCORRUPTED;
> > >  			goto done;
> > >  		}
> > 
> > This is kind of what I mean - is it two or three  logic statments
> > here? No, it's actually one, but it has two nested checks...
> > 
> > There's a few other list this that are somewhat non-obvious as to
> > the logic...
> 
> I'd thought about giving it the shortest name possible, not bothering to
> log the fsname that goes with the error report, and making the if part
> of the macro:
> 
> #define IFBAD(cond) if ((unlikely(cond) ? assert(...), true : false))
> 
> IFBAD(be32_to_cpu(sib_info->back) != last_blkno ||
>       sib_info->magic != dead_info->magic)) {
> 	xfs_whatever();
> 	return -EFSCORRUPTED;
> }
> 
> Is that better?

Look at what quoting did to it - it'll look the same as above in
patches, unfortunately, so I don't think "short as possible" works
any better.

Perhaps s/IFBAD/XFS_CORRUPT_IF/ ?

		XFS_CORRUPT_IF(be32_to_cpu(sib_info->back) != last_blkno ||
				sib_info->magic != dead_info->magic)) {
			xfs_error(mp, "user readable error message");
			return -EFSCORRUPTED;
		}

That solves the patch/quote indent problem, documents the code well,
and only sacrifices a single tab for the condition statements...

/me gets back on his bike and leaves the shed coated in wet paint.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
