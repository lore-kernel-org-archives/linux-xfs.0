Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B9FC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C963861001
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFCD6R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:58:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51876 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhFCD6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 23:58:17 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2C53D861B2A;
        Thu,  3 Jun 2021 13:56:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loeSt-008LWT-VI; Thu, 03 Jun 2021 13:56:15 +1000
Date:   Thu, 3 Jun 2021 13:56:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/39] xfs: implement percpu cil space used calculation
Message-ID: <20210603035615.GN664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-31-david@fromorbit.com>
 <20210527184121.GM202144@locust>
 <20210602234747.GY664593@dread.disaster.area>
 <20210603012609.GD26402@locust>
 <20210603022814.GM664593@dread.disaster.area>
 <20210603030148.GT26380@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603030148.GT26380@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=RGEL1jq4ltTio9VZ7QMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:01:48PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 03, 2021 at 12:28:14PM +1000, Dave Chinner wrote:
> > On Wed, Jun 02, 2021 at 06:26:09PM -0700, Darrick J. Wong wrote:
> > > So assuming that I grokked it all on the second try, maybe a comment is
> > > in order for the aggregate function?
> > > 
> > > 	/*
> > > 	 * We're in the middle of switching cil contexts.  Reset the
> > > 	 * counter we use to detect when the current context is nearing
> > > 	 * full.
> > > 	 */
> > > 	ctx->space_used = 0;
> > 
> > Hmmmm - I'm not sure where you are asking I put this comment...
> 
> Sorry, I meant the comment to be placed above the
> "cilpcp->space_used = 0;" in the _aggregate function.

Ok. That'll cause rejects on all the subsequent patches so there's
not much point in posting just an update to this patch with that
done. I guess I'm sending out another 39 patches before the end of
the day.... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
