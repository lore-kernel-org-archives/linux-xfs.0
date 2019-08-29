Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2629EC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4302073F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfH2Kcg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 06:32:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41427 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbfH2Kcg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 06:32:36 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DCE0243DE3D;
        Thu, 29 Aug 2019 20:32:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HjE-00030n-7z; Thu, 29 Aug 2019 20:32:32 +1000
Date:   Thu, 29 Aug 2019 20:32:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make attr lookup returns consistent
Message-ID: <20190829103232.GT1119@dread.disaster.area>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-2-david@fromorbit.com>
 <20190829074139.GA18966@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829074139.GA18966@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=ALDk4khcfHs2H3TaPAMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 12:41:39AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 28, 2019 at 02:23:48PM +1000, Dave Chinner wrote:
> > @@ -1289,29 +1301,32 @@ xfs_attr_node_get(xfs_da_args_t *args)
> >  	state->mp = args->dp->i_mount;
> >  
> >  	/*
> > -	 * Search to see if name exists, and get back a pointer to it.
> > +	  Search to see if name exists, and get back a pointer to it.
> >  	 */
> >  	error = xfs_da3_node_lookup_int(state, &retval);
> >  	if (error) {
> >  		retval = error;
> 
> Given that you are cleaning up this mess, can you check if there
> is any point in the weird xfs_da3_node_lookup_int calling conventions?

retval propagates down into child functions like
xfs_da3_path_shift(), xfs_dir2_leafn_lookup_int(), etc, so
untangling that mess is non-trivial.

> It looks like it can return errnos in both the return value and
> *revtval, and from a quick check it seems like all callers treat them
> more or less the same.

Maybe so, but I don't have the time to do a deep dive into both the
directory and the attribute code to determine what such a cleanup
might look like. I think it's way out of scope for the problem being
solved by this patchset...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
