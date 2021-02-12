Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF09C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 01:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE9B64E42
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 01:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhBLB0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 20:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhBLB0s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 20:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D96364E3D;
        Fri, 12 Feb 2021 01:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613093168;
        bh=BbtJxggGZJzVseoZHyQLnVX6cc5Ir4n1QBkdBEzihLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qyPLPeKfpPMUnUw8gt/xo5Mv0PKzJpN6EyZEtZAG6VV+wMKKAWMFBNV+oL8RJOXSb
         isOvEFPPwTfHYwuZ3blgs66TjtYhwhjQCiEjW88+ipAHw+G5F7BUDKlv8u2xf9ltF4
         gO5CwCGJSsB/Pnjnz8DpWSrDdthR0cA8rRQWVzE2M6dhnSt7WM+u+wTFw7OjswJBgM
         RFqJNW0iObLUXD6WwZvNAuANj5wlkWlCxPQUvoxQvz/TSu/VkvJwpHpgGeCQ8lNDRI
         SutG8h/XzCBUF+898mXt5JMYC5peNUSxE23fGsfS8bJKYz1cBFow6CEh8ZDdno6F42
         83KfJ0M+/clvg==
Date:   Thu, 11 Feb 2021 17:26:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs_repair: allow setting the needsrepair flag
Message-ID: <20210212012607.GI7193@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308438691.3850286.3501696811159590596.stgit@magnolia>
 <2e135dfe-9be6-b5f9-7c06-a10e6e45e3da@sandeen.net>
 <20210212001731.GH7193@magnolia>
 <66984b2d-58d5-856d-5f5c-b0a22fe4c34e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66984b2d-58d5-856d-5f5c-b0a22fe4c34e@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 06:20:23PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/11/21 6:17 PM, Darrick J. Wong wrote:
> > On Thu, Feb 11, 2021 at 05:29:05PM -0600, Eric Sandeen wrote:
> >> On 2/11/21 4:59 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <djwong@kernel.org>
> >>>
> >>> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> >>> program start and (presumably) clear it by the end of the run.  This
> >>> code isn't terribly useful to users; it's mainly here so that fstests
> >>> can exercise the functionality.  We don't document this flag in the
> >>> manual pages at all because repair clears needsrepair at exit, which
> >>> means the knobs only exist for fstests to exercise the functionality.
> >>>
> >>> Note that we can't do any of these upgrades until we've at least done a
> >>> preliminary scan of the primary super and the log.
> >>>
> >>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> >>
> >>
> >> I'm still a little on the fence about the cmdline option for crashing
> >> repair at a certain point from the POV that Brian kind of pointed out
> >> that this doesn't exactly scale as we need more hooks.
> > 
> > (That's in the next patch.)
> 
> I. Am. Awesome.
>  
> ...
> 
> > Probably yes, but ... uh I don't want this to drag on into building a
> > generic error injection framework for userspace.
> > 
> > I would /really/ like to get inobtcount/bigtime tests into the kernel
> > without a giant detour they have nearly zero test coverage from the
> > wider community.
> 
> Yeah, I dont' want that either.
> 
> this (er, next patch) is s3kr1t and if we have something better later we
> can change it.  I'll just merge stuff as-is and move forward.

Er... TBH I actually /did/ want to hear Brian's response...

--D

> -Eric
