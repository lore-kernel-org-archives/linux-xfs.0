Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A0C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 17:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350607AbiE0RTu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 13:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbiE0RTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 13:19:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E79B11E4AF;
        Fri, 27 May 2022 10:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDEA861E1F;
        Fri, 27 May 2022 17:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F019C385A9;
        Fri, 27 May 2022 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653671988;
        bh=kgWWZEomee2aFr4sKl+JOxnlUFftSDDwRa7N5NxoCCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IG/wZuXYBTtGc2ChQEvMcrGDpZVs8zqx1XW1OAjcPtK1Y2Md+eHxxOSmvdfCK75Dx
         gv4YX0RoH52QT9yXEcORzy7YACR9YX6SZY4dh5oja1zJmhTuUoIDydD25jV7fF1R06
         mY2ygo33ZJI1yJuITUlHJqzMYDE0TYtD/UAQ1CAmYzwu7Faxxa4mCL+cUo9in5HAJL
         kDbY4WfsEygMT0VgV5NrGiTAtRpnAXVXCM5a8MrAmfhn8Mjnql+zU7yIkebFy7qNW9
         cZo46xpYAG0gG0TRLuc6v38etxkWss37UGWLvub/CNaXYGFK46tCV59NFAYXfLnFQL
         5NENVFf6B3Aqg==
Date:   Fri, 27 May 2022 10:19:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <YpEIM3q0gF1q1Amu@magnolia>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area>
 <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpDw3uVFB7LjPquX@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 08:40:14AM -0700, Luis Chamberlain wrote:
> On Fri, May 27, 2022 at 03:24:02PM +0300, Amir Goldstein wrote:
> > On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
> > > Backport candidate: yes. Severe: absolutely not.
> > In the future, if you are writing a cover letter for an improvement
> > series or internal pull request and you know there is a backport
> > candidate inside, if you happen to remember to mention it, it would
> > be of great help to me.
> 
> Amir, since you wrote a tool enhancement to scrape for possible
> candidates, *if* we defined some sort of meta-data to describe
> this sort of stuff on the cover letter:
> 
> Backport candidate: yes. Severe: absolutely not
> 
> It would be useful when scraping. Therefore, leaving the effort
> to try to backport / feasibility to others. This would be different
> than a stable Cc tag, as those have a high degree of certainty.
> 
> How about something like:
> 
> Backport-candidate: yes
> Impact: low

This particular patch (because we've recently hit it internally too)
would have been one of those:

Stable-Soak: January 2022

patches that I was talking about.

--D

>   Luis
