Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D52C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 05:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D039E22268
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 05:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgKBFMQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 00:12:16 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57937 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgKBFMQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 00:12:16 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1851D3A9D08;
        Mon,  2 Nov 2020 16:12:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kZS8Z-006pD8-Os; Mon, 02 Nov 2020 16:12:11 +1100
Date:   Mon, 2 Nov 2020 16:12:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 209981] Unable to boot with kernel 5.10-r1
Message-ID: <20201102051211.GC7391@dread.disaster.area>
References: <bug-209981-201763@https.bugzilla.kernel.org/>
 <bug-209981-201763-tzBjyBEau6@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-209981-201763-tzBjyBEau6@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=fwrJ4jrpvKTI88FifqwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 02, 2020 at 05:02:06AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=209981
> 
> --- Comment #4 from Aaron Dominick (aaron.zakhrov@gmail.com) ---
> (In reply to Eric Sandeen from comment #2)
> > Why do you feel this is an xfs bug?  I don't see any indication of xfs
> > problems in your logs.
> 
> I dont think the logs are being captured. Basically after I boot and enter my
> lvm password, the system locks up with a bunch of pending in flight requests.
> Among them are the xfs_buf_ioend_work

Your kernel oopsed trying to load firmware for the iwl driver.
Everything after that is colateral damage. Sort out the firmware
loading problem first because once that problem goes away all the
others should, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
