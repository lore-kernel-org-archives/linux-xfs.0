Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A5EC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D264064F08
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhBXWFx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:05:53 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42755 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233670AbhBXWFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 17:05:52 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 357E4E69549;
        Thu, 25 Feb 2021 09:05:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF2HN-002lwZ-5D; Thu, 25 Feb 2021 09:05:09 +1100
Date:   Thu, 25 Feb 2021 09:05:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: Fix CIL throttle hang when CIL space used going
 backwards
Message-ID: <20210224220509.GE4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-9-david@fromorbit.com>
 <20210224211810.GX7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224211810.GX7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=PAdQK3uECAhy7qkZSmwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 01:18:10PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 02:34:42PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A hang with tasks stuck on the CIL hard throttle was reported and
> > largely diagnosed by Donald Buczek, who discovered that it was a
> > result of the CIL context space usage decrementing in committed
> > transactions once the hard throttle limit had been hit and processes
> > were already blocked.  This resulted in the CIL push not waking up
> > those waiters because the CIL context was no longer over the hard
> > throttle limit.
> > 
> > The surprising aspect of this was the CIL space usage going
> > backwards regularly enough to trigger this situation. Assumptions
> > had been made in design that the relogging process would only
> > increase the size of the objects in the CIL, and so that space would
> > only increase.
> > 
> > This change and commit message fixes the issue and documents the
> > result of an audit of the triggers that can cause the CIL space to
> > go backwards, how large the backwards steps tend to be, the
> > frequency in which they occur, and what the impact on the CIL
> > accounting code is.

....

> Does this whole series fix the Donald's problem?

No, just this patch is needed to fix that problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
