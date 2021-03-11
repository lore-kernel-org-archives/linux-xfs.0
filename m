Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCBEC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73FC764FCD
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCKDBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:01:37 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52713 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229851AbhCKDB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 22:01:27 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E21511041C2C;
        Thu, 11 Mar 2021 14:01:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKBZl-00181J-D8; Thu, 11 Mar 2021 14:01:25 +1100
Date:   Thu, 11 Mar 2021 14:01:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/45] xfs: log tickets don't need log client id
Message-ID: <20210311030125.GK74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-24-david@fromorbit.com>
 <20210309002134.GJ3419940@magnolia>
 <20210309011956.GE74031@dread.disaster.area>
 <20210309014800.GK3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309014800.GK3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=PLF7MgVf65JNm-yR7CwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 05:48:00PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 09, 2021 at 12:19:56PM +1100, Dave Chinner wrote:
> > On Mon, Mar 08, 2021 at 04:21:34PM -0800, Darrick J. Wong wrote:
> > > On Fri, Mar 05, 2021 at 04:11:21PM +1100, Dave Chinner wrote:
> > > >  static xlog_op_header_t *
> > > >  xlog_write_setup_ophdr(
> > > > -	struct xlog		*log,
> > > >  	struct xlog_op_header	*ophdr,
> > > > -	struct xlog_ticket	*ticket,
> > > > -	uint			flags)
> > > > +	struct xlog_ticket	*ticket)
> > > >  {
> > > >  	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > > > -	ophdr->oh_clientid = ticket->t_clientid;
> > > > +	ophdr->oh_clientid = XFS_TRANSACTION;
> > > >  	ophdr->oh_res2 = 0;
> > > > -
> > > > -	/* are we copying a commit or unmount record? */
> > > > -	ophdr->oh_flags = flags;
> > > > -
> > > > -	/*
> > > > -	 * We've seen logs corrupted with bad transaction client ids.  This
> > > > -	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
> > > > -	 * and shut down the filesystem.
> > > > -	 */
> > > > -	switch (ophdr->oh_clientid)  {
> > > > -	case XFS_TRANSACTION:
> > > > -	case XFS_VOLUME:
> > > 
> > > Reading between the lines, I'm guessing this clientid is some
> > > now-vestigial organ from the Irix days, where there was some kind of
> > > volume manager (in addition to the filesystem + log)?  And between the
> > > three, there was a need to dispatch recovered log ops to the correct
> > > subsystem?
> > 
> > I guess that was the original thought. It was included in the
> > initial commit of the log code to XFS in 1993 and never, ever used
> > in any code anywhere. So it's never been written to an XFS log,
> > ever.
> 
> In that case, can you get rid of the #define too, please?

Done.

-- 
Dave Chinner
david@fromorbit.com
