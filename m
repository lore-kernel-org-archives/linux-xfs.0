Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9CAC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 21:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbiCRVw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 17:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiCRVw6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 17:52:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9986F2335C3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 14:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D8BB825D2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 21:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C2EC340E8;
        Fri, 18 Mar 2022 21:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647640296;
        bh=4AQZY0UbXXOZSm2eOXuPxI8pf1ncTdYf28gh3+or49o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hyjJAtkfqgGbcH31gQtY71KmPpZU7ut2HJ6eunKeKyreoXtyl2838SWZ0VXGeG9A7
         YrEPv9du2P4nwCpcM6nkBZUkJCaHga49QYnYA+KKSFeEPOcGt+ympPl6pqA6aFyjib
         3zZdbVUT1Rh+VdJWBZHxTak5elO0jxBBZ8UfWvLAbcJ3oL1+BRQa6KZru/TF9cIeiR
         nPCI1KZbKuRISpQ9SHAYB2ZXRfBeAerEZEemiZA1g8HEEMFGS0oWNmg0z7WIX9qs+A
         aF/W7s1zvTgq1QAr6BckYlAp6YeelRGoHo8+r7mF/+mjiyHjHiSQFa5CKbh5FC/8Yj
         5OvZRFg1pQmAw==
Date:   Fri, 18 Mar 2022 14:51:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <20220318215133.GG8224@magnolia>
References: <YjSNTd+U3HBq/Gsv@bfoster>
 <20220318214831.GH1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318214831.GH1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 19, 2022 at 08:48:31AM +1100, Dave Chinner wrote:
> On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> > Hi,
> > 
> > I'm not sure if this is known and/or fixed already, but it didn't look
> > familiar so here is a report. I hit a splat when testing Willy's
> > prospective folio bookmark change and it turns out it replicates on
> > Linus' current master (551acdc3c3d2). This initially reproduced on
> > xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> > xfs/006, but when I attempted to reproduce the latter a second time I
> > hit what looks like the same problem as xfs/264. Both tests seem to
> > involve some form of error injection, so possibly the same underlying
> > problem. The GPF splat from xfs/264 is below.
> 
> On a side note, I'm wondering if we should add xfs/006 and xfs/264
> to the recoveryloop group - they do a shutdown under load and a
> followup mount to ensure the filesystem gets recovered before
> the test ends and the fs is checked, so while thy don't explicitly
> test recovery, they do exercise it....
> 
> Thoughts?

Someone else asked about this the other day, and I proposed a 'recovery'
group for tests that don't run in a loop.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
