Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC41C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 05:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E28C64FC9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 05:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhCKFD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 00:03:28 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59480 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhCKFDI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 00:03:08 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C9C1178BB96;
        Thu, 11 Mar 2021 16:03:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKDTW-001A1S-Ay; Thu, 11 Mar 2021 16:03:06 +1100
Date:   Thu, 11 Mar 2021 16:03:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/45] xfs: CIL context doesn't need to count iovecs
Message-ID: <20210311050306.GP74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-32-david@fromorbit.com>
 <20210309031604.GS3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309031604.GS3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=kxRIhiW81b_YBtN67L8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 07:16:04PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:29PM +1100, Dave Chinner wrote:
> > @@ -471,7 +462,6 @@ xlog_cil_insert_items(
> >  	}
> >  	tp->t_ticket->t_curr_res -= len;
> >  	ctx->space_used += len;
> > -	ctx->nvecs += diff_iovecs;
> 
> If the tracking variable isn't necessary any more, should the field go
> away from xfs_cil_ctx?

Yes. I thought I cleaned that up. Fixed.

-- 
Dave Chinner
david@fromorbit.com
