Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E1EC4167B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 03:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F3423EB1
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 03:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395061AbgLKD0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 22:26:00 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:40412 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395058AbgLKDZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 22:25:51 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 570881AC85E;
        Fri, 11 Dec 2020 14:25:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1knZ3E-002hek-2V; Fri, 11 Dec 2020 14:25:00 +1100
Date:   Fri, 11 Dec 2020 14:25:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: silence a cppcheck warning
Message-ID: <20201211032500.GB632069@dread.disaster.area>
References: <20201210235747.469708-1-hsiangkao@redhat.com>
 <20201211011744.GA632069@dread.disaster.area>
 <20201211020944.GA487622@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211020944.GA487622@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=20KFwNOVAAAA:8 a=Vt2AcnKqAAAA:8
        a=i3X5FwGiAAAA:8 a=7-415B0cAAAA:8 a=z1ScFDMkDwBob12exCIA:9
        a=CjuIK1q_8ugA:10 a=v10HlyRyNeVhbzM4Lqgd:22 a=mmqRlSCDY2ywfjPLJ4af:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 10:09:44AM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On Fri, Dec 11, 2020 at 12:17:44PM +1100, Dave Chinner wrote:
> > On Fri, Dec 11, 2020 at 07:57:47AM +0800, Gao Xiang wrote:
> > > This patch silences a new cppcheck static analysis warning
> > > >> fs/xfs/libxfs/xfs_sb.c:367:21: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
> > >     if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> > > 
> > > introduced from my patch. Sorry I didn't test it with cppcheck before.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > 
> 
> ...
> 
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 7 ++-----
> > >  1 file changed, 2 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index bbda117e5d85..ae5df66c2fa0 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -360,11 +360,8 @@ xfs_validate_sb_common(
> > >  		}
> > >  	}
> > >  
> > > -	/*
> > > -	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> > > -	 * would imply the image is corrupted.
> > > -	 */
> > > -	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> > > +	if ((sbp->sb_unit && !xfs_sb_version_hasdalign(sbp)) ||
> > > +	    (!sbp->sb_unit && xfs_sb_version_hasdalign(sbp))) {
> > >  		xfs_notice(mp, "SB stripe alignment sanity check failed");
> > >  		return -EFSCORRUPTED;
> > 
> > But, ummm, what's the bug here? THe logic looks correct to me -
> > !!sbp->sb_unit will have a value of 0 or 1, and
> > xfs_sb_version_hasdalign() returns a bool so will also have a value
> > of 0 or 1. That means the bitwise XOR does exactly the correct thing
> > here as we are operating on two boolean values. So I don't see a bug
> > here, nor that it's a particularly useful warning.
> > 
> > FWIW, I've never heard of this "cppcheck" analysis tool. Certainly
> > I've never used it, and this warning seems to be somewhat
> > questionable so I'm wondering if this is just a new source of random
> > code churn or whether it's actually finding real bugs?
> 
> Here is a reference of the original report:
> https://www.mail-archive.com/kbuild@lists.01.org/msg05057.html

Ok, so it's just generating noise, not pointing out actual bugs.
Yup:

cppcheck possible warnings: (new ones prefixed by >>, may not real problems)

So it's even telling us that it might just be generating noise.

> The reason I didn't add "Fixes:" or "Reported-by:" or use "fix" in the
> subject since I (personally) don't think it's worth adding, since I
> have no idea when linux kernel runs with "cppcheck" analysis tool
> (I only heard "sparse and smatch are using "before.) and I don't think
> it's actually a bug here.
> 
> If "cppcheck" should be considered, I'm also wondering what kind of
> options should be used for linux kernel. And honestly, there are many
> other analysis tools on the market, many of them even complain about
> "strcpy" and should use "strcpy_s" instead (or many other likewise).
> 
> Personally I don't think it's even worth adding some comments about
> this since it's a pretty straight-forward boolean algebra on my side
> (but yeah, if people don't like it, I can update it as well since
>  it's quite minor to me.)

If the checker is not pointing out actual bugs, we should just
ignore it. That's what we do with coverity, etc. The code is fine,
I don't find it hard to read or in any way confusing, so I think
it's fine to ignore it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
