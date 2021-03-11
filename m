Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04078C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 04:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1ACB64FC9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 04:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCKETp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 23:19:45 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42087 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbhCKETe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 23:19:34 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 654911168;
        Thu, 11 Mar 2021 15:19:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKCnL-0019Dy-IG; Thu, 11 Mar 2021 15:19:31 +1100
Date:   Thu, 11 Mar 2021 15:19:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/45] xfs: introduce xlog_write_single()
Message-ID: <20210311041931.GN74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-29-david@fromorbit.com>
 <20210309023927.GP3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309023927.GP3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=FMc2FozTB0Qt66S5978A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 06:39:27PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:26PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Introduce an optimised version of xlog_write() that is used when the
> > entire write will fit in a single iclog. This greatly simplifies the
> > implementation of writing a log vector chain into an iclog, and sets
> > the ground work for a much more understandable xlog_write()
> > implementation.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 56 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 22f97914ab99..590c1e6db475 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2214,6 +2214,52 @@ xlog_write_copy_finish(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Write log vectors into a single iclog which is guaranteed by the caller
> > + * to have enough space to write the entire log vector into. Return the number
> > + * of log vectors written into the iclog.
> > + */
> > +static int
> > +xlog_write_single(
> > +	struct xfs_log_vec	*log_vector,
> > +	struct xlog_ticket	*ticket,
> > +	struct xlog_in_core	*iclog,
> > +	uint32_t		log_offset,
> > +	uint32_t		len)
> > +{
> > +	struct xfs_log_vec	*lv = log_vector;
> > +	void			*ptr;
> > +	int			index = 0;
> > +	int			record_cnt = 0;
> 
> Any reason these (and the return type) can't be unsigned?  I don't think
> negative indices or record counts have any meaning, right?

Correct, but I'm going to ignore that because the next patch already
addresses both of these things. Changing it here just means a
massive reject of the next patch where it replaces the return value
with a log vector, and the record count moves to a function
parameter that is, indeed, a uint32_t.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
