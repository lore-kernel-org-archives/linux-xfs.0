Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15718C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 02:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbiEKCRB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 22:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiEKCRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 22:17:00 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BDBC81644
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 19:16:59 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 09C0760F67;
        Wed, 11 May 2022 12:16:58 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id GCserL6vWiCe; Wed, 11 May 2022 12:16:57 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C1A5760E0B;
        Wed, 11 May 2022 12:16:57 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id B3036680319; Wed, 11 May 2022 12:16:57 +1000 (AEST)
Date:   Wed, 11 May 2022 12:16:57 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220511021657.GA333471@onthe.net.au>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
 <20220510191918.GD27195@magnolia>
 <20220510215411.GT1098723@dread.disaster.area>
 <20220511003708.GA27195@magnolia>
 <20220511013654.GC1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220511013654.GC1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 11:36:54AM +1000, Dave Chinner wrote:
> I think that's the thing that some people have missed in in this
> thread - I've know for a while now the scope of problems blocking
> flushes from statfs() can cause - any issue with background
> inodegc not making progress can deadlock the filesystem. I've lost
> count of the number of times I had inodegc go wrong or crash and the
> only possible recovery was to power cycle because nothing could be
> executed from the command line.
>
> That's because statfs() appears to be used in some commonly used
> library function and so many utility programs on the system will get
> stuck and be unable to run when inodegc dies, deadlocks, or takes a
> real long time to make progress.
>
> Hence I didn't need to do any analysis of Chris' system to know
> exactly what was going on - I've seen it many, many times myself and
> have work in progress that avoids those issues with inodegc work
> that never completes.
>
> IOWs, everything is understood, fixes are already written, and
> there's no actual threat of data loss or corruption from this issue.
> It's just lots of stuff getting stuck behind a long running
> operation...

Your patches are stuck behind other long running priorities, or the 
patches address an issue of stuff getting stuck? Or, of course, both? ;-)

Out of interest, would this work also reduce the time spent mounting in my 
case? I.e. would a lot of the work from my recovery mount be punted off 
to a background thread?

Cheers,

Chris
