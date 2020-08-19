Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F8FC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 23:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F2B620888
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 23:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHSX6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 19:58:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43091 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgHSX6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Aug 2020 19:58:47 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8F34D821B8C;
        Thu, 20 Aug 2020 09:58:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8Xya-0004DL-Kq; Thu, 20 Aug 2020 09:58:40 +1000
Date:   Thu, 20 Aug 2020 09:58:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200819235840.GA7941@dread.disaster.area>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
 <20200818233535.GD21744@dread.disaster.area>
 <20200819214322.GE6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819214322.GE6096@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=slvXnHkSztNsWyrOnaMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 02:43:22PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 19, 2020 at 09:35:35AM +1000, Dave Chinner wrote:
> > On Mon, Aug 17, 2020 at 03:57:39PM -0700, Darrick J. Wong wrote:
> The correct approach (I think) is to perform the shifting and masking on
> the raw __be64 value before converting them to incore format via
> be32_to_cpu, but now I have to work out all four cases by hand instead
> of letting the compiler do the legwork for me.  I don't remember if it's
> correct to go around shifting and masking __be64 values.
> 
> I guess the good news is that at least we have generic/402 to catch
> these kinds of persistence problems, but ugh.
> 
> Anyway, what are you afraid of?  The C compiler smoking crack and not
> actually overlapping the two union elements?  We could control for
> that...

No, I just didn't really like the way the code in the encode/decode
helpers turned out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
