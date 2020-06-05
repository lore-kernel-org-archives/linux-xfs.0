Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD05C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 21:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A8C207D5
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 21:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgFEVJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 17:09:47 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:40443 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbgFEVJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 17:09:46 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id EBC261A891C;
        Sat,  6 Jun 2020 07:09:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jhJaw-0000bd-F1; Sat, 06 Jun 2020 07:09:42 +1000
Date:   Sat, 6 Jun 2020 07:09:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/30] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
Message-ID: <20200605210942.GD2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-23-david@fromorbit.com>
 <20200605162637.GF23747@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605162637.GF23747@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=8O7YU9w8hxNdWdNW6gkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 12:26:37PM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:45:58PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Clean up xfs_reclaim_inodes() callers. Most callers want blocking
> > behaviour, so just make the existing SYNC_WAIT behaviour the
> > default.
> > 
> > For the xfs_reclaim_worker(), just call xfs_reclaim_inodes_ag()
> > directly because we just want optimistic clean inode reclaim to be
> > done in the background.
> > 
> > For xfs_quiesce_attr() we can just remove the inode reclaim calls as
> > they are a historic relic that was required to flush dirty inodes
> > that contained unlogged changes. We now log all changes to the
> > inodes, so the sync AIL push from xfs_log_quiesce() called by
> > xfs_quiesce_attr() will do all the required inode writeback for
> > freeze.
> > 
> 
> The above change should probably be a standalone patch, but not worth
> changing at this point:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> BTW, is there any reason we continue to drain the buffer lru for freeze
> as well?

Probably not - out of scope for this patch so I haven't really
thought about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
