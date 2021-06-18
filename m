Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB41C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 22:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E4EF611B0
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 22:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFRWgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 18:36:46 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59170 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhFRWgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 18:36:44 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 60FCF6AF69;
        Sat, 19 Jun 2021 08:34:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1luN4H-00ELbv-Pl; Sat, 19 Jun 2021 08:34:29 +1000
Date:   Sat, 19 Jun 2021 08:34:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor out log write ordering from
 xlog_cil_push_work()
Message-ID: <20210618223429.GL664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-6-david@fromorbit.com>
 <20210617195904.GW158209@locust>
 <YMytZZVUOtDVyyAj@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMytZZVUOtDVyyAj@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=aQX-SKaLA1MnPBA9iPEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 03:27:49PM +0100, Christoph Hellwig wrote:
> On Thu, Jun 17, 2021 at 12:59:04PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 17, 2021 at 06:26:14PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > So we can use it for start record ordering as well as commit record
> > > ordering in future.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > This tricked me for a second until I realized that xlog_cil_order_write
> > is the chunk of code just prior to the xlog_cil_write_commit_record
> > call.
> 
> Yeah, moving the caller at the same time as the factoring is a trick
> test for every reader.  I think this needs to be documented in the
> commit log.  Or even better moved to a separate log, but it seems you
> get shot for that kind of suggestion on the xfs list these days..

Sorry, what? This should be a straight factoring - the place we do
the ordering check must not change because that'll break shit.

Ngggh.

Yeah, thanks git. When I rebased the patch, it's merged the hunk
into the wrong place. It gets fixed up later when I move the ordering
inside the xlog_cil_write_commit_record() function, but this patch
by itself was silently broken by the tooling.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
