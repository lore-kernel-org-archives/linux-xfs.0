Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA9EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 23:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244198AbiECXWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 19:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237650AbiECXWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 19:22:36 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFEAD1D0F2
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 16:19:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D44B2534673;
        Wed,  4 May 2022 09:18:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm1nG-007hKs-A8; Wed, 04 May 2022 09:18:58 +1000
Date:   Wed, 4 May 2022 09:18:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <20220503231858.GE1098723@dread.disaster.area>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-5-david@fromorbit.com>
 <20220503225918.GI8265@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503225918.GI8265@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6271b864
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=kRbTnoPrP7JZoWBFS2QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 03:59:18PM -0700, Darrick J. Wong wrote:
> On Mon, May 02, 2022 at 06:20:18PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because stupid dumb fuzzers.
> 
> Dumb question: Should we make db_flds[] in db/sb.c (userspace) report
> each individual feature flag as a field_t?

Maybe, but we do already have the versionnum command that dumps the
feature bits in text/human readable format....

> I've been wondering why none
> of my fuzz tests ever found these problems, and it's probably because
> it never hit the magic bits that $scriptkiddie happened to hit.

Yeah, you've probably never cleared just the dirv2 bit. That one has
an assert on it these days because the kernel only supports v2-based
directory formats.  In other cases, things still work but we
probably don't do the right thing for v5 formats :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
