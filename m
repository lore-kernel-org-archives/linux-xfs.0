Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28ADC3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 07:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C662468E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 07:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCBHcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 02:32:21 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58031 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgCBHcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 02:32:21 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 53AA33A1768;
        Mon,  2 Mar 2020 18:32:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8fYn-0007ZV-53; Mon, 02 Mar 2020 18:32:17 +1100
Date:   Mon, 2 Mar 2020 18:32:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
Message-ID: <20200302073217.GL10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-6-bfoster@redhat.com>
 <20200228001345.GS8045@magnolia>
 <20200228140202.GD2751@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228140202.GD2751@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=A1sarbYbjiPlsWDTGM0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 09:02:02AM -0500, Brian Foster wrote:
> See my earlier comment around batching. Right now we only relog one item
> at a time and the relog reservation is intended to be the max possible
> reloggable item in the fs. This needs to increase to support some kind
> of batching here, but I think the prospective reloggable items right now
> (i.e. 2 or 3 different intent types) allows a fixed calculation size to
> work well enough for our needs.
> 
> Note that I think there's a whole separate ball of complexity we could
> delve into if we wanted to support something like arbitrary, per-item
> (set) relog tickets with different reservation values as opposed to one
> global, fixed size ticket. That would require some association between
> log items and tickets and perhaps other items covered by the same
> ticket, etc., but would provide a much more generic mechanism. As it is,
> I think that's hugely overkill for the current use cases, but maybe we
> find a reason to evolve this into something like that down the road..

From what I'm seeing, a generic, arbitrary relogging mechanism based
on a reservation stealing concept similar to the CIL is going to be
simpler, less invasive, easier to expand in future and more robust
than this "limited scope" proposal.

I'm firmly in the "do it right the first time" camp here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
