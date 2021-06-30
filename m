Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8BDC11F65
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 21:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F9D361474
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 21:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhF3Vvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 17:51:36 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50652 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232042AbhF3Vvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 17:51:36 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6AC6C69A1C;
        Thu,  1 Jul 2021 07:49:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyi4t-001Hgw-GP; Thu, 01 Jul 2021 07:49:03 +1000
Date:   Thu, 1 Jul 2021 07:49:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <20210630214903.GF664593@dread.disaster.area>
References: <20210630061431.1750745-1-david@fromorbit.com>
 <20210630061431.1750745-2-david@fromorbit.com>
 <20210630160843.GM13784@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630160843.GM13784@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=RaIoV-Duqy7ywgANOlkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 09:08:43AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 30, 2021 at 04:14:29PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 1721fce2ec94..fee4fbadea0a 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2062,7 +2062,7 @@ xlog_recover_add_to_cont_trans(
> >  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
> >  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
> >  
> > -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> > +	ptr = kvrealloc(old_ptr, old_len, len + old_len, GFP_KERNEL);
> 
> kvrealloc can return null, so this needs to check for that and -ENOMEM,
> right?  It'll suck that log recovery fails, but such is life.

Ok, looking through the code it seems that returning -ENOMEM here
is a non-destructive (i.e. retry-able) failure. It will simply stop
processing the log at the point this occurs and abort all pending
objects that haven't been processed. The error message is less than
stellar ("log mount/recovery failed: error %d") but at least no
other damage will be done. I'll update it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
