Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E77C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 00:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E260861056
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 00:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhHRA4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 20:56:44 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:54839 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235566AbhHRA4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 20:56:44 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 76CDE1B4E9A;
        Wed, 18 Aug 2021 10:56:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mG9sG-001wlI-NX; Wed, 18 Aug 2021 10:56:08 +1000
Date:   Wed, 18 Aug 2021 10:56:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: rename xfs_has_attr()
Message-ID: <20210818005608.GM3657114@dread.disaster.area>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-3-david@fromorbit.com>
 <YRTV1pa3dQaKLwBi@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRTV1pa3dQaKLwBi@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=mQSyfN0N2jPgjQkMaq0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 09:03:34AM +0100, Christoph Hellwig wrote:
> On Tue, Aug 10, 2021 at 03:24:37PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_has_attr() is poorly named. It has global scope as it is defined
> > in a header file, but it has no namespace scope that tells us what
> > it is checking has attributes. It's not even clear what "has_attr"
> > means, because what it is actually doing is an attribute fork lookup
> > to see if the attribute exists.
> > 
> > Upcoming patches use this "xfs_has_<foo>" namespace for global
> > filesystem features, which conflicts with this function.
> > 
> > Rename xfs_has_attr() to xfs_attr_lookup() and make it a static
> > function, freeing up the "xfs_has_" namespace for global scope
> > usage.
> 
> Why not kill this function entirely as I suggested last time?

Because I think it's the wrong cleanup to apply to xfs_attr_set().
xfs_attr_set() needs to be split into two - a set() function and a
remove() function to get rid of all the conditional "if
(arg->value)" logic in it that separates set from remove. Most
of the code in the function is under such if/else clauses, and the
set() code is much more complex than the remove() case. Folding the
attr lookup into the xfs_attr_set() doesn't do anything to address
this high level badness, and to split it appropriately we need to
keep the common attr lookup code in it's own function.

I updated the patch to has a single xfs_attr_lookup() call instead
of one per branch, but I don't think removing the helper is the
right way to go here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
