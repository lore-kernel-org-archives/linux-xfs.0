Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397BEC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E0364FE6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhCKMmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhCKMml (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 07:42:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A2C061574
        for <linux-xfs@vger.kernel.org>; Thu, 11 Mar 2021 04:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dbXiju7Y7iHK8pMyh968m2VcHaA+OKoXI8T018uQKGY=; b=PPJfUkEwG49jYmSt6tTuNMgCin
        CEWRVpNIeWIEOMsJlnO2P1dt8BBKTE7aNCvxyQAmx0Yacw+lAaHJyGaNJvWUT2GhCpYGXb1UUm3Wk
        juhRyi66S056NfpdTK3Yvzu5Jg9bNCegi+iruZ4eN9Lkbr2cnmYgh37Y6O024G0FJYM0CkYgz9R/F
        D5bWBkx4+qyjofLevhTBgGtnoSOaGKmRmukJ2qe0JpwnM/V2xn6a37q8laBh4N2q3DdFqrJYaphwf
        c5ZJDFbWcO4ZpFPPavTIxoOIX5kXVE93v0bNDGoqyU5hPpcw/BXAU4RzgHAeB3rIkp4tD2x3/0qkB
        cei9x+Yg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKdI-007JdS-69; Thu, 11 Mar 2021 12:41:51 +0000
Date:   Thu, 11 Mar 2021 12:41:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing\
Message-ID: <20210311124140.GA1742851@infradead.org>
References: <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
 <YEDc42Z1GjHBXi6S@bfoster>
 <20210304224848.GR4662@dread.disaster.area>
 <YEJHEt/vt6yuHbak@bfoster>
 <20210309004410.GC74031@dread.disaster.area>
 <20210309043559.GT3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309043559.GT3419940@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 08:35:59PM -0800, Darrick J. Wong wrote:
> > So you won't review it until I have 100 outstanding patches in this
> > series and it's completely and utterly unreviewable?
> 
> Already unreviewable at 45, and I've only gotten through 2/3 of it.


Yes.  For patches that don't just repetitively apply similar changes
to a few places, about 20 patches is the max that is digestable.

> Here's something I haven't previously shared with all of you: Last cycle
> when we were going around and around on the ENOSPC/EDQUOT retry loop
> patches (which exploded from 13 to 41 patches) it was /very/ stressful
> to have to rework this and that part every day and a half for almost
> three weeks.

As someone part of the loop I was a little surprised how quickly you
did respin the patches.  In general if I have feedback that requires
a major rework of a non-trivial series, I do not want to touch it
instantly.  Let the discussion continue a bit, becaue it can easily
turn into another direction and create more work.  I think waiting a few
days before doing anything that involves a lot of work generally helpsto
make everyones life a little easier.

> (TLDR: git branch plz)

Yes, for any non-trivial series that really, really helps.
