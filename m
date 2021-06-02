Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9163EC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B06461242
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhFBWX2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:23:28 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38528 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhFBWX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 18:23:27 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 410A180B186;
        Thu,  3 Jun 2021 08:21:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loZF5-008FvI-5u; Thu, 03 Jun 2021 08:21:39 +1000
Date:   Thu, 3 Jun 2021 08:21:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/39] xfs:_introduce xlog_write_partial()
Message-ID: <20210602222139.GW664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-23-david@fromorbit.com>
 <20210527180659.GD2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527180659.GD2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=nTon7X_HkE1Qtu7nfooA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 11:06:59AM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:13:00PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Handle writing of a logvec chain into an iclog that doesn't have
> > enough space to fit it all. The iclog has already been changed to
> > WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
> > in the iclog is exclusively owned by this logvec chain.
> > 
> > The difference between the single and partial cases is that
> > we end up with partial iovec writes in the iclog and have to split
> > a log vec regions across two iclogs. The state handling for this is
> > currently awful and so we're building up the pieces needed to
> > handle this more cleanly one at a time.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Egad this diff is hard to read.  Brian's right, the patience diff is
> easier to understand and shorter to boot.
> 
> That said, I actually understand what the new code does now, so:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thx!

> Might be nice to hoist:
> 
> 	memcpy(ptr, reg->i_addr + reg_offset, rlen);
> 	xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
> 	(*record_cnt)++;
> 	*data_cnt += rlen;
> 
> into a helper but it's only four lines so I'm not gonna fuss any
> further.

Agreed, there are opportunities for further factoring and
simplification of this code, but I'll leave that for another
patchset rather than risking destabilisation at this late point.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
