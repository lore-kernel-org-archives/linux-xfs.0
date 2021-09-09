Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBB8C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 21:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D3C6105A
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 21:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbhIIVWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:22:46 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52588 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346551AbhIIVWq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 17:22:46 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 83E0E109927;
        Fri, 10 Sep 2021 07:21:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mORUD-00Acfr-2L; Fri, 10 Sep 2021 07:21:33 +1000
Date:   Fri, 10 Sep 2021 07:21:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] xfs: intent item whiteouts
Message-ID: <20210909212133.GE2361455@dread.disaster.area>
References: <20210902095927.911100-1-david@fromorbit.com>
 <YTnyDZ8mx3ucqKBn@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTnyDZ8mx3ucqKBn@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=8S--rd9alnqilZpKfsUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 09, 2021 at 01:37:49PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 02, 2021 at 07:59:20PM +1000, Dave Chinner wrote:
> > HI folks,
> > 
> > This is a patchset built on top of Allison's Logged Attributes
> > and my CIL Scalibility patch sets.
> 
> Do you have a git tree with all applied somewhere to help playing
> with this series?

Not yet, because the patch stack it is build on top of has a bunch
of other WIP, not-quite-fully-working stuff in it so I haven't been
able to run it through a full fstests pass yet (hence the RFC tag).
The next version (hopefully early next week) will be rebased
directly on top of the CIL scalability work and I'll push out those
branches into a git tree when it's actually been more fully tested
and survived some recovery stress looping.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
