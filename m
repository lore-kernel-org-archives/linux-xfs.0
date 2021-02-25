Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D1CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1397564F47
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhBYWXr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:23:47 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35942 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232631AbhBYWWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:22:40 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D89518284E1;
        Fri, 26 Feb 2021 09:21:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFP14-004LA3-8D; Fri, 26 Feb 2021 09:21:50 +1100
Date:   Fri, 26 Feb 2021 09:21:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: introduce xlog_write_single()
Message-ID: <20210225222150.GT4662@dread.disaster.area>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-11-david@fromorbit.com>
 <YDfv2urK2p8peO5R@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDfv2urK2p8peO5R@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=eYN5_DQUlCCoGLnqkd0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 07:43:38PM +0100, Christoph Hellwig wrote:
> On Wed, Feb 24, 2021 at 05:34:56PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Vector out to an optimised version of xlog_write() if the entire
> 
> s/Vector/Factor/ ?
> 
> > +	ptr = iclog->ic_datap + log_offset;
> > +	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> > +
> > +
> > +		/* ordered log vectors have no regions to write */
> 
> The two empty lines above look a little strange.
> 
> > +		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> > +			ASSERT(lv->lv_niovecs == 0);
> > +			goto next_lv;
> > +		}
> > +
> > +		reg = &lv->lv_iovecp[index];
> > +		ASSERT(reg->i_len % sizeof(int32_t) == 0);
> > +		ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> > +
> > +		ophdr = reg->i_addr;
> > +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > +		ophdr->oh_len = cpu_to_be32(reg->i_len -
> > +					sizeof(struct xlog_op_header));
> > +
> > +		memcpy(ptr, reg->i_addr, reg->i_len);
> > +		xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> > +		record_cnt++;
> > +
> > +		/* move to the next iovec */
> > +		if (++index < lv->lv_niovecs)
> > +			continue;
> > +next_lv:
> > +		/* move to the next logvec */
> > +		lv = lv->lv_next;
> > +		index = 0;
> > +	}
> 
> I always hated this (pre-existing) loop style.

Me too, but my brain was stretched just getting it factored into a
tighter loop so I wasn't looking too hard at the iteration methof
itself.

> What do you think of
> something like this (just whiteboard coding, might be completely broken),
> which also handles the ordered case with lv_niovecs == 0 as part of
> the natural loop:
> 
> 	for (lv = log_vector; lv; lv->lv_next) {
> 		for (index = 0; index < lv->lv_niovecs; index++) {
> 			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> 			struct xlog_op_header	*ophdr = reg->i_addr;
> 
> 			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> 			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> 
> 			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> 			ophdr->oh_len = cpu_to_be32(reg->i_len -
> 				sizeof(struct xlog_op_header));
> 			memcpy(ptr, reg->i_addr, reg->i_len);
> 			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> 			record_cnt++;
> 		}
> 	}

Yup, that is definitely an improvement. It wasnt' an option with the
way the existing code nested, but this is much, much neater. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
