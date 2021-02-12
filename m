Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C03C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217FD64E2A
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 22:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhBLWvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 17:51:50 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:58503 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232291AbhBLWrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 17:47:48 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D1232105815;
        Sat, 13 Feb 2021 09:46:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lAhDE-001qXg-U6; Sat, 13 Feb 2021 09:46:56 +1100
Date:   Sat, 13 Feb 2021 09:46:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: restore speculative_cow_prealloc_lifetime sysctl
Message-ID: <20210212224656.GB4662@dread.disaster.area>
References: <20210212172436.GK7193@magnolia>
 <20210212214802.GN7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212214802.GN7193@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=sv0dgCoiDhZ11eh4VQMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 01:48:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 9669f51de5c0 I tried to get rid of the undocumented cow gc
> lifetime knob.  The knob's function was never documented and it now
> doesn't really have a function since eof and cow gc have been
> consolidated.
> 
> Regrettably, xfs/231 relies on it and regresses on for-next.  I did not
> succeed at getting far enough through fstests patch review for the fixup
> to land in time.
> 
> Restore the sysctl knob, document what it did (does?), put it on the
> deprecation schedule, and rip out a redundant function.
> 
> Fixes: 9669f51de5c0 ("xfs: consolidate the eofblocks and cowblocks workers")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: use printk_ratelimited
> ---

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
