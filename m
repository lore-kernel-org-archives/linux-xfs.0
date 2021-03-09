Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFCAC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 01:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2E465267
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 01:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCIBsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 20:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhCIBsB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 20:48:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 136FF65274;
        Tue,  9 Mar 2021 01:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615254481;
        bh=kvzro4qk+8FFU10YwmraVMZFKP/Eue4wVH/kX10Cx5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WR35zBkaDBagf/J7OoBM0XrCpbSTDQNfoTf0SN5JbbgSoImk1i6n3XZ7YZQzuo00A
         JQ3BnOhxB5XAedVP5ctOzUkF8SQUqbVRTxhdtok2T4BqB/OMampZqYCUL7Pjo0J/mh
         f+KyyQSXPK+2U1gnIzyWXrTIL6avstlPju6tuU9bJx8VBiOeOgtwI8WM10ejbym8V3
         xhm861w8WbsBf5DBZHHuq8/r9z+JA1gY3VOVZCt+o3NVyW9fHBAsmpJL5WmMEt3ucV
         Uy8no+6jOcFzWQteyXdeOKeELss8dtml3NPjfY+R0ajidHeO/mQOQqqZCxsl2rhNL4
         iJAk7MBeIe/SQ==
Date:   Mon, 8 Mar 2021 17:48:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/45] xfs: log tickets don't need log client id
Message-ID: <20210309014800.GK3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-24-david@fromorbit.com>
 <20210309002134.GJ3419940@magnolia>
 <20210309011956.GE74031@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309011956.GE74031@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 12:19:56PM +1100, Dave Chinner wrote:
> On Mon, Mar 08, 2021 at 04:21:34PM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 05, 2021 at 04:11:21PM +1100, Dave Chinner wrote:
> > >  static xlog_op_header_t *
> > >  xlog_write_setup_ophdr(
> > > -	struct xlog		*log,
> > >  	struct xlog_op_header	*ophdr,
> > > -	struct xlog_ticket	*ticket,
> > > -	uint			flags)
> > > +	struct xlog_ticket	*ticket)
> > >  {
> > >  	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> > > -	ophdr->oh_clientid = ticket->t_clientid;
> > > +	ophdr->oh_clientid = XFS_TRANSACTION;
> > >  	ophdr->oh_res2 = 0;
> > > -
> > > -	/* are we copying a commit or unmount record? */
> > > -	ophdr->oh_flags = flags;
> > > -
> > > -	/*
> > > -	 * We've seen logs corrupted with bad transaction client ids.  This
> > > -	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
> > > -	 * and shut down the filesystem.
> > > -	 */
> > > -	switch (ophdr->oh_clientid)  {
> > > -	case XFS_TRANSACTION:
> > > -	case XFS_VOLUME:
> > 
> > Reading between the lines, I'm guessing this clientid is some
> > now-vestigial organ from the Irix days, where there was some kind of
> > volume manager (in addition to the filesystem + log)?  And between the
> > three, there was a need to dispatch recovered log ops to the correct
> > subsystem?
> 
> I guess that was the original thought. It was included in the
> initial commit of the log code to XFS in 1993 and never, ever used
> in any code anywhere. So it's never been written to an XFS log,
> ever.

In that case, can you get rid of the #define too, please?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
