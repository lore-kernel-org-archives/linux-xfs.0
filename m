Return-Path: <SRS0=DzrB=EM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F691C55178
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 21:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D59820735
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 21:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgKFVc7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 16:32:59 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39787 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728096AbgKFVc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Nov 2020 16:32:58 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5CA4F3AB09F;
        Sat,  7 Nov 2020 08:32:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kb9Lq-008Qc8-Dc; Sat, 07 Nov 2020 08:32:54 +1100
Date:   Sat, 7 Nov 2020 08:32:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     liang bai <darkagainst@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: About material on old xfs wiki
Message-ID: <20201106213254.GG7391@dread.disaster.area>
References: <CA+Kr39MGk=mj0Mx7idzUvkEOxw5qzwfqzWuxN0mgzTGSHLsK5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Kr39MGk=mj0Mx7idzUvkEOxw5qzwfqzWuxN0mgzTGSHLsK5Q@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=xDvEBrSEsUZi0YHBj7wA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 06, 2020 at 04:14:05PM +0800, liang bai wrote:
> Hi,
> I am doing some research about how SSD can better cooperate with XFS.
> So I need to know much about the design of the XFS.

https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/

Though your best resource is going to be asking questions on this
list.

I'd be interested to know what sort of SSD optimisations you are
thinking of, because largely SSD optimisations are similar to the
layout optimisations that we do for RAID (alignment, cross-file
packing, locality groupings, etc) and as such we don't actually have
any specific SSD-only optimisations in XFS at all.

Most of this knowledge isn't documented anywhere, so the only way
you will understand what we already know works and doesn't work is
to discuss the topic directly here on this list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
