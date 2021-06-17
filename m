Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB7DC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B0E61249
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhFQWM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 18:12:56 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59015 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhFQWM4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 18:12:56 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C14BA80B8EF;
        Fri, 18 Jun 2021 08:10:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lu0Dl-00Dxaa-Pi; Fri, 18 Jun 2021 08:10:45 +1000
Date:   Fri, 18 Jun 2021 08:10:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: separate out setting CIL context LSNs from
 xlog_write
Message-ID: <20210617221045.GE664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-7-david@fromorbit.com>
 <20210617202824.GZ158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617202824.GZ158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=BtyQ2grhFoPRCxbD2lwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 01:28:24PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 06:26:15PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In preparation for moving more CIL context specific functionality
> > into these operations.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks fine as a hoist, though I wonder why you didn't do this in patch
> 4?

Because I wanted to keep the xlog_write() api change separate to
relocating the lsn code out of xlog_write().

There are enough review comments of "don't move and modify in the
one patch" that I won't even bother trying to do even simple "move
and modify" operations in a single patch anymore.

I can combine them if you want, but then someone is bound to pop up
in another review cycle and say "please separate....". :/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
