Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA4CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D3A864DEC
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhA1V7e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:59:34 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60450 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231551AbhA1V7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 16:59:33 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D250F10163E;
        Fri, 29 Jan 2021 08:58:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l5FJQ-003WNU-W4; Fri, 29 Jan 2021 08:58:49 +1100
Date:   Fri, 29 Jan 2021 08:58:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reduce buffer log item shadow allocations
Message-ID: <20210128215848.GR4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-6-david@fromorbit.com>
 <20210128165435.GF2599027@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210128165435.GF2599027@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=IkcTkHD0fZMA:10 a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=xPTKlSvaio025FIijmAA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 11:54:35AM -0500, Brian Foster wrote:
> On Thu, Jan 28, 2021 at 03:41:54PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we modify btrees repeatedly, we regularly increase the size of
> > the logged region by a single chunk at a time (per transaction
> > commit). This results in the CIL formatting code having to
> > reallocate the log vector buffer every time the buffer dirty region
> > grows. Hence over a typical 4kB btree buffer, we might grow the log
> > vector 4096/128 = 32x over a short period where we repeatedly add
> > or remove records to/from the buffer over a series of running
> > transaction. This means we are doing 32 memory allocations and frees
> > over this time during a performance critical path in the journal.
> > 
> > The amount of space tracked in the CIL for the object is calculated
> > during the ->iop_format() call for the buffer log item, but the
> > buffer memory allocated for it is calculated by the ->iop_size()
> > call. The size callout determines the size of the buffer, the format
> > call determines the space used in the buffer.
> > 
> > Hence we can oversize the buffer space required in the size
> > calculation without impacting the amount of space used and accounted
> > to the CIL for the changes being logged. This allows us to reduce
> > the number of allocations by rounding up the buffer size to allow
> > for future growth. This can safe a substantial amount of CPU time in
> > this path:
> > 
> > -   46.52%     2.02%  [kernel]                  [k] xfs_log_commit_cil
> >    - 44.49% xfs_log_commit_cil
> >       - 30.78% _raw_spin_lock
> >          - 30.75% do_raw_spin_lock
> >               30.27% __pv_queued_spin_lock_slowpath
> > 
> > (oh, ouch!)
> > ....
> >       - 1.05% kmem_alloc_large
> >          - 1.02% kmem_alloc
> >               0.94% __kmalloc
> > 
> > This overhead here us what this patch is aimed at. After:
> > 
> >       - 0.76% kmem_alloc_large                                                                                                                                      ▒
> >          - 0.75% kmem_alloc                                                                                                                                         ▒
> >               0.70% __kmalloc                                                                                                                                       ▒
> > 
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf_item.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 17960b1ce5ef..0628a65d9c55 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> ...
> > @@ -181,10 +182,18 @@ xfs_buf_item_size(
> >  	 * count for the extra buf log format structure that will need to be
> >  	 * written.
> >  	 */
> > +	bytes = 0;
> >  	for (i = 0; i < bip->bli_format_count; i++) {
> >  		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> > -					  nvecs, nbytes);
> > +					  nvecs, &bytes);
> >  	}
> > +
> > +	/*
> > +	 * Round up the buffer size required to minimise the number of memory
> > +	 * allocations that need to be done as this item grows when relogged by
> > +	 * repeated modifications.
> > +	 */
> > +	*nbytes = round_up(bytes, 512);
> 
> If nbytes starts out as zero anyways, what's the need for the new
> variable? Otherwise looks reasonable.

Personal preference. It makes the code clear that we are returning
just the size of this item, not blindly adding it to an external
variable.

Just another example of an API wart that is a hold over from ancient
code from before the days of delayed logging. ->iop_size is always
called with nvecs = nbytes = 0, so they only ever return the
size/vecs the item will use. The ancient code passed running count
variables to these functions, not "always initialised to zero".
varaibles. We should really clean that up across the entire
interface at some point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
