Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3870DC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 21:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D2E61883
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 21:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTVtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 17:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhCTVsd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 20 Mar 2021 17:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A8076148E;
        Sat, 20 Mar 2021 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616276912;
        bh=gLKsuG2g0dteVb/OkiGntYYLEXDUUE0BKDyibYB8WWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UHPI7tPPP5T16oGItRbt0jsmuswK/2bNDVCYpd1KNn8tEk1DK+4OG9QkiRjvLYvYZ
         SuJt7IZLVaikW7iNuSA6X4HbP3ZZ7/89ij5E/f/O446cVbiW+cRhXFu+2OBEiEyTGw
         dOab+IKszcaS7x2CF70mrcN9XM1vvwPpePdBUVq+B4A/j57aGJjLNENY9DzkjQOkB8
         wWKkFZoc7JkqZ0rFcPT5WnfwWqIPY3EkkvVsj+QK0CqjMdessg+j6kGAeLK626j7EN
         VOHAi+jm6Y62XvP/rjC2/q5jNkm4Au8ua+MqGBfXw3Cku70s4lxGi+S9s2/FWA8DOd
         n5zVkWYnt/fWA==
Date:   Sat, 20 Mar 2021 14:48:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210320214831.GA22100@magnolia>
References: <20210311042302.GA137676@embeddedor>
 <20210311044700.GU3419940@magnolia>
 <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
 <20210320201711.GY22100@magnolia>
 <d5a9046e-e204-c854-34fe-2a39e58faea4@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5a9046e-e204-c854-34fe-2a39e58faea4@embeddedor.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 20, 2021 at 03:20:55PM -0500, Gustavo A. R. Silva wrote:
> 
> 
> On 3/20/21 15:17, Darrick J. Wong wrote:
> >>>> Below are the results of running xfstests for groups shutdown and log
> >>>> with the following configuration in local.config:
> >>>>
> >>>> export TEST_DEV=/dev/sda3
> >>>> export TEST_DIR=/mnt/test
> >>>> export SCRATCH_DEV=/dev/sda4
> >>>> export SCRATCH_MNT=/mnt/scratch
> >>>>
> >>>> The size for both partitions /dev/sda3 and /dev/sda4 is 25GB.
> >>>
> >>> Looks good to me, will toss it at my fstests cloud and see if anything
> >>> shakes out.  Thanks for cleaning up this goofy thorn-pile!
> >>
> >> Great. It's been fun to work on this. :p
> > 
> > Did you run the /entire/ fstests suite?  With this patch applied to
> > 5.12-rc2, I keep seeing list corruption assertions about an hour into
> 
> Nope; I run xfstests 'shutdown' and 'log' groups on 5.11.0, only.
> 
> How do you run the entire fstests?
> Could you give me some pointers?

./check -g all

(instead of "./check -g shutdown")

> > the test run, and usually on some test that heavily exercises allocating
> > and deleting file extents.  I'll try to look at this patch more closely
> > next week, but I figured I should let you know early, on the off chance
> > something sticks out to you.
> 
> OK. I'll go run my tests on 5.12-rc2.
> 
> Should I run the entire xfstests, too?

Yes, please.

--D

> Thanks
> --
> Gustavo
