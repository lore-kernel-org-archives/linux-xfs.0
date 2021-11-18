Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E50C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 04:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00B9610FB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 04:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242878AbhKRElZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 23:41:25 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38364 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242170AbhKRElZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Nov 2021 23:41:25 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D7F1D8A114C;
        Thu, 18 Nov 2021 15:38:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mnZBl-00AAjC-Ks; Thu, 18 Nov 2021 15:38:21 +1100
Date:   Thu, 18 Nov 2021 15:38:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: only CIL pushes require a start record
Message-ID: <20211118043821.GV449541@dread.disaster.area>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-3-david@fromorbit.com>
 <YYzMjlKMbS/TjWU9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYzMjlKMbS/TjWU9@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6195d8c0
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=mPZ-REoamRbRSRuxCosA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 10, 2021 at 11:55:58PM -0800, Christoph Hellwig wrote:
> >  struct xlog_cil_trans_hdr {
> > +	struct xlog_op_header	oph[2];
> >  	struct xfs_trans_header	thdr;
> > +	struct xfs_log_iovec	lhdr[2];
> 
> I find the logic where xlog_cil_build_trans_hdr stuffs oph[1] and
> thdr into a single log_iovec rather confusing even if it is correct.
> But I'd also rather get this series in and see if it can be cleaned
> up later, so I'll just leave that as a note here.
> 
> >  	struct xlog_ticket	*tic = ctx->ticket;
> > +	uint32_t		tid = cpu_to_be32(tic->t_tid);
> 
> This needs to be a __be32.

*nod*.

> > -	hdr->thdr.th_tid = tic->t_tid;
> > +	hdr->thdr.th_tid = tid;
> 
> And this needs to keep using the not byteswapped version.
> (but it appears we never look at the trans header in recovery anyway
> currently).

Right, it's never, ever been used, except in xfs_logprint. Prior to
delayed logging, it was defined as:

        __int32_t       th_tid;                 /* transaction id (unused) */

So it was always zero. It is still unused by anything except
logprint, in which case I noticed that it was byteswapped compared
to the op header TID, which made searches for ophdrs that matched
the transaction header TID difficult.

I've changed it back to what it was and added a note to the code to
indicate that the transaction header is in host byte order, not big
endian.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
