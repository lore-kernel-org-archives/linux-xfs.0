Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF3EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 02:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiEJC7s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 22:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbiEJC7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 22:59:42 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BA66BE07
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 19:55:43 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C477660F66;
        Tue, 10 May 2022 12:55:41 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id l1w3ZpkSbIEQ; Tue, 10 May 2022 12:55:41 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 92E3160D15;
        Tue, 10 May 2022 12:55:41 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 7E2E5680319; Tue, 10 May 2022 12:55:41 +1000 (AEST)
Date:   Tue, 10 May 2022 12:55:41 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220510025541.GA192172@onthe.net.au>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220509230918.GP1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Tue, May 10, 2022 at 09:09:18AM +1000, Dave Chinner wrote:
> On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
>> Is it to be expected that removing 29TB of highly reflinked and fragmented
>> data could take days, the entire time blocking other tasks like "rm" and
>> "df" on the same filesystem?
...
> At some point, you have to pay the price of creating billions of
> random fine-grained cross references in tens of TBs of data spread
> across weeks and months of production. You don't notice the scale of
> the cross-reference because it's taken weeks and months of normal
> operations to get there. It's only when you finally have to perform
> an operation that needs to iterate all those references that the
> scale suddenly becomes apparent. XFS scales to really large numbers
> without significant degradation, so people don't notice things like
> object counts or cross references until something like this
> happens.
>
> I don't think there's much we can do at the filesystem level to help
> you at this point - the inode output in the transaction dump above
> indicates that you haven't been using extent size hints to limit
> fragmentation or extent share/COW sizes, so the damage is already
> present and we can't really do anything to fix that up.

Thanks for taking the time to provide a detailed and informative
exposition, it certainly helps me understand what I'm asking of the fs, 
the areas that deserve more attention, and how to approach analyzing the 
situation.

At this point I'm about 3 days from completing copying the data (from a 
snapshot of the troubled fs mounted with 'norecovery') over to a brand new 
fs. Unfortunately the new fs is also rmapbt=1 so I'll go through all the 
copying again (under more controlled circumstances) to get onto a rmapbt=0 
fs (losing the ability to do online repairs whenever that arrives - 
hopefully that won't come back to haunt me).

Out of interest:

>> - with a reboot/remount, does the log replay continue from where it left
>> off, or start again?

Sorry, if you provided an answer to this, I didn't understand it.

Basically the question is, if a recovery on mount were going to take 10 
hours, but the box rebooted and fs mounted again at 8 hours, would the 
recovery this time take 2 hours or once again 10 hours?

Cheers,

Chris
