Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0EDC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 07:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25FAF60FD9
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 07:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbhH3HlJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 03:41:09 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:40010 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhH3HlI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 03:41:08 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 379FC61C3D;
        Mon, 30 Aug 2021 17:40:14 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id ABYVenMjZset; Mon, 30 Aug 2021 17:40:14 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 0157161C38;
        Mon, 30 Aug 2021 17:40:14 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id D63D6680468; Mon, 30 Aug 2021 17:40:13 +1000 (AEST)
Date:   Mon, 30 Aug 2021 17:40:13 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Mysterious ENOSPC [was: XFS fallocate implementation incorrectly
 reports ENOSPC]
Message-ID: <20210830074013.GB3763165@onthe.net.au>
References: <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
 <20210828002137.GA3642069@onthe.net.au>
 <20210828035824.GA3654894@onthe.net.au>
 <20210829220457.GR3657114@dread.disaster.area>
 <20210830042118.GQ12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210830042118.GQ12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 29, 2021 at 09:21:18PM -0700, Darrick J. Wong wrote:
> Since you've formatted with rmapbt enabled, you probably have a new
> enough xfsprogs that you can /also/ use this on a live fs:

Yep, I put on xfsprogs 5.12.0 to look into all of this.

> $ xfs_spaceman -c 'freesp -g'  /
...
> $ xfs_spaceman -c 'freesp -s -a 2'  /

Tks, that's useful.

Cheers,

Chris
