Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCFEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 03:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiEKD6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 23:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiEKD6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 23:58:18 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D913D219C0D
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:58:16 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 73F0960F60;
        Wed, 11 May 2022 13:58:14 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id tMKU3FsGbSpj; Wed, 11 May 2022 13:58:14 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 20D8B60E0B;
        Wed, 11 May 2022 13:58:14 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 0A014680319; Wed, 11 May 2022 13:58:14 +1000 (AEST)
Date:   Wed, 11 May 2022 13:58:13 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220511035813.GA342362@onthe.net.au>
References: <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
 <20220510191918.GD27195@magnolia>
 <20220510215411.GT1098723@dread.disaster.area>
 <20220511003708.GA27195@magnolia>
 <20220511013654.GC1098723@dread.disaster.area>
 <20220511021657.GA333471@onthe.net.au>
 <20220511025235.GG1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220511025235.GG1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 12:52:35PM +1000, Dave Chinner wrote:
> On Wed, May 11, 2022 at 12:16:57PM +1000, Chris Dunlop wrote:
>> Out of interest, would this work also reduce the time spent mounting in 
>> my case? I.e. would a lot of the work from my recovery mount be punted 
>> off to a background thread?
>
> No. log recovery will punt the remaining inodegc work to background
> threads so it might get slightly parallelised, but we have a hard
> barrier between completing log recovery work and completing the
> mount process at the moment. Hence we wait for inodegc to complete
> before log recovery is marked as complete.
>
> In theory we could allow background inodegc to bleed into active
> duty once log recovery has processed all the unlinked lists, but
> that's a change of behaviour that would require a careful audit of
> the last part of the mount path to ensure that it is safe to be
> running concurrent background operations whilst complete mount state
> updates.
>
> This hasn't been on my radar at all up until now, but I'll have a
> think about it next time I look at those bits of recovery. I suspect
> that probably won't be far away - I have a set of unlinked inode
> list optimisations that rework the log recovery infrastructure near
> the top of my current work queue, so I will be in that general
> vicinity over the next few weeks...

I'll keep an eye out.

> Regardless, the inodegc work is going to be slow on your system no
> matter what we do because of the underlying storage layout. What we
> need to do is try to remove all the places where stuff can get
> blocked on inodegc completion, but that is somewhat complex because
> we still need to be able to throttle queue depths in various
> situations.

That reminds of a something I've been wondering about for obvious reasons: 
for workloads where metadata operations are dominant, do you have any 
ponderings on allowing AGs to be put on fast storage whilst the bulk data 
is on molasses storage?

Cheers,

Chris
