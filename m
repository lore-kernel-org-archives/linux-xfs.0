Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8569BC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 06:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BCB221F8
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Dec 2020 06:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgL3G3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Dec 2020 01:29:22 -0500
Received: from smtp1.onthe.net.au ([203.22.196.249]:43139 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgL3G3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Dec 2020 01:29:22 -0500
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 436FF6191C;
        Wed, 30 Dec 2020 17:28:38 +1100 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id y9ahFjfxspKE; Wed, 30 Dec 2020 17:28:38 +1100 (AEDT)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id CD6886189B;
        Wed, 30 Dec 2020 17:28:36 +1100 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 7459F682C8F; Wed, 30 Dec 2020 17:28:36 +1100 (AEDT)
Date:   Wed, 30 Dec 2020 17:28:36 +1100
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Extreme fragmentation ho!
Message-ID: <20201230062836.GA2695485@onthe.net.au>
References: <20201221215453.GA1886598@onthe.net.au>
 <20201228220622.GA164134@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201228220622.GA164134@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 29, 2020 at 09:06:22AM +1100, Dave Chinner wrote:
> On Tue, Dec 22, 2020 at 08:54:53AM +1100, Chris Dunlop wrote:
>> The file is sitting on XFS on LV on a raid6 comprising 6 x 5400 RPM HDD:
>
> ... probably not that unreasonable for pretty much the slowest
> storage configuration you can possibly come up with for small,
> metadata write intensive workloads.

[ Chris grimaces and glances over at the 8+3 erasure-encoded ceph rbd 
   sitting like a pitch drop experiment in the corner. ]

Speaking of slow storage and metadata write intensive workloads, what's 
the reason reflinks with a realtime device isn't supported? That was one 
approach I wanted to try, to get the metadata ops running on a small fast 
storage with the bulk data sitting on big slow bulk storage. But:

# mkfs.xfs -m reflink=1 -d rtinherit=1 -r rtdev=/dev/fast /dev/slow
reflink not supported with realtime devices

My naive thought was a reflink was probably "just" a block range 
referenced from multiple places, and probably a refcount somewhere. It 
seems like it should be possible to have the range, references and 
refcount sitting on the fast storage pointing to the actual data blocks on 
the slow storage.

>> What is the easiest way to recreate a similarly (or even better,
>> identically) fragmented file?
>
> Just script xfs_io to reflink random bits and bobs from other files
> into a larger file?

Thanks - that did it.

Cheers,

Chris
