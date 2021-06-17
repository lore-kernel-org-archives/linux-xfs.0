Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D919C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 21:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3250961249
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 21:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhFQV6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 17:58:42 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53914 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231372AbhFQV6l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 17:58:41 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B522B80BC3E;
        Fri, 18 Jun 2021 07:56:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltzzz-00DxO6-6O; Fri, 18 Jun 2021 07:56:31 +1000
Date:   Fri, 18 Jun 2021 07:56:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move xlog_commit_record to xfs_log_cil.c
Message-ID: <20210617215631.GC664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-4-david@fromorbit.com>
 <20210617175039.GU158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617175039.GU158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=WmhBK8nuL9-Iy07OVAAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 10:50:39AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 06:26:12PM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 2fb0ab02dda3..2c8b25888c53 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -783,6 +783,48 @@ xlog_cil_build_trans_hdr(
> >  	tic->t_curr_res -= lvhdr->lv_bytes;
> >  }
> >  
> > +/*
> > + * Write out the commit record of a checkpoint transaction associated with the
> > + * given ticket to close off a running log write. Return the lsn of the commit
> > + * record.
> > + */
> > +int
> 
> static int, like the robot suggests?

Huh. How did that get dropped? I definitely made this static in the
original patch....

> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Ta.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
