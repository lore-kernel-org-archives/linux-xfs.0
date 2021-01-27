Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438BAC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 06:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046492070A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 06:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhA0GDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:03:22 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56753 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232307AbhA0FVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 00:21:02 -0500
Received: from dread.disaster.area (pa49-180-243-77.pa.nsw.optusnet.com.au [49.180.243.77])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BE9CB3C33EB;
        Wed, 27 Jan 2021 16:20:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l4dFR-002s4R-9G; Wed, 27 Jan 2021 16:20:09 +1100
Date:   Wed, 27 Jan 2021 16:20:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: test message
Message-ID: <20210127052009.GL4662@dread.disaster.area>
References: <20210127033444.GG7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127033444.GG7698@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=juxvdbeFDU67v5YkIhU0sw==:117 a=juxvdbeFDU67v5YkIhU0sw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ccxrXydFMuOqjcuLF0cA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 07:34:44PM -0800, Darrick J. Wong wrote:
> Hm.  I'm missing a substantial amount of list traffic, and I can't tell
> if vger is still slow or if it's mail.kernel.org forwarding that's
> busted.

It took a minute to get to vger, half an hour to get through vger,
and then another minute to get to me. You can see that in the
headers here:

Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhA0FF0 (ORCPT <rfc822;david@fromorbit.com>);
        Wed, 27 Jan 2021 00:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhA0Df0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 22:35:26 -0500

> Hmm, a message I just sent to my oracle address works fine, so I guess
> it's vger that's broken?  Maybe?  I guess we'll see when this shows
> up; the vger queue doesn't seem to have anything for xfs right now.

yeah, vger still seems to be causing issues...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
