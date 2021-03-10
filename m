Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B298DC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E5564FDD
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhCJWAe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:00:34 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34584 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232767AbhCJWA2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 17:00:28 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6F29C10417ED;
        Thu, 11 Mar 2021 09:00:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lK6sT-00138D-Hs; Thu, 11 Mar 2021 09:00:25 +1100
Date:   Thu, 11 Mar 2021 09:00:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210310220025.GH74031@dread.disaster.area>
References: <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
 <YEDc42Z1GjHBXi6S@bfoster>
 <20210304224848.GR4662@dread.disaster.area>
 <YEJHEt/vt6yuHbak@bfoster>
 <20210309004410.GC74031@dread.disaster.area>
 <20210309043559.GT3419940@magnolia>
 <YEgqp87obzpezjwT@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEgqp87obzpezjwT@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=G_Zz45Wr9hoFhOsRiecA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 09:10:47PM -0500, Brian Foster wrote:
> On Mon, Mar 08, 2021 at 08:35:59PM -0800, Darrick J. Wong wrote:
> > On Tue, Mar 09, 2021 at 11:44:10AM +1100, Dave Chinner wrote:
> > > On Fri, Mar 05, 2021 at 09:58:26AM -0500, Brian Foster wrote:
> > > I'm not going to play that "now jump through this hoop" game.  We
> > > add flags for on-off behaviours in internal functions -all the
> > > time-. If this makes the interface so complex and confusing that you
> > > don't understand it, then the interface was already too complex and
> > > confusing. And fixing that is *not in the scope of this patchset*.
> > > 
> > > Demanding that code be made perfect before it can be merged is
> > > really not very helpful. Especially when there are already plans to
> > > rework the API but that rework is dependent on a bunch of other
> > > changes than need to be done first.
> > > 
> > > iclogs are something that need to be moved behind the CIL, not sit
> > > in front of CIL. The CIL abstracts the journal and writing to the
> > > journal completely away from the transaction subsystem, yet the log
> > > force code punches straight through that abstraction and walks
> > > iclogs directly. The whole log force implementation needs to change,
> > > and I plan for the API that wraps the log forces to get reworked at
> > > that time.
> > 
> > So here's what I want to know: Do Dave's changes to the log force APIs
> > introduce broken behavior?  If the interfaces are so confusing that
> > /none/ of us understand it, can we introduce the appropriate wrappers
> > and documentation so that the rest of us plugging away at the rest of
> > the system can only call it the supported ways to achieve any of the
> > supported outcomes?
> > 
> 
> It looks to me that the changes to xlog_cil_force_seq() could
> essentially be replaced with something like:
> 
> /*
>  * Behold the magical async CIL force
>  * ... <explain what this does> ...
>  */
> static inline void
> xfs_cil_force_async(
> 	struct xlog	*log)
> {
> 	struct xfs_cil	*cil = log->l_cilp;
> 
> 	/* true for magic async CIL force */
> 	xlog_cil_push_now(log, cil->xc_current_sequence, true);
> }

Oh, is that what you are asking for? You were talking about changing
the API for all the callers that didn't use XFS_LOG_SYNC to make
them all async, not about a one-off, single use wrapper for the AIL.

If all you want is a single line wrapper function, then don't
suggest that the whole API should be reworked and callers changed to
use a new API. *Ask for a one-line wrapper to be added*.

This wrapper will still need to go away in the near future, but at
least it doesn't involve changing lots of unrelated code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
