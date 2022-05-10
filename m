Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A060C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 06:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiEJGex (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 02:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiEJGew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 02:34:52 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FC5326AEC
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 23:30:54 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 34D5660F7E;
        Tue, 10 May 2022 16:30:52 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id nRHn0IUnlcUh; Tue, 10 May 2022 16:30:52 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 3739860F66;
        Tue, 10 May 2022 16:30:51 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 1A8EA680319; Tue, 10 May 2022 16:30:51 +1000 (AEST)
Date:   Tue, 10 May 2022 16:30:51 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220510063051.GA215522@onthe.net.au>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220510051057.GY27195@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:10:57PM -0700, Darrick J. Wong wrote:
> On Tue, May 10, 2022 at 07:07:35AM +0300, Amir Goldstein wrote:
>> On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
>>> Is it to be expected that removing 29TB of highly reflinked and fragmented
>>> data could take days, the entire time blocking other tasks like "rm" and
>>> "df" on the same filesystem?
...
>> From a product POV, I think what should have happened here is that
>> freeing up the space would have taken 10 days in the background, but
>> otherwise, filesystem should not have been blocking other processes
>> for long periods of time.
>
> Indeed.  Chris, do you happen to have the sysrq-w output handy?  I'm
> curious if the stall warning backtraces all had xfs_inodegc_flush() in
> them, or were there other parts of the system stalling elsewhere too?
> 50 billion updates is a lot, but there shouldn't be stall warnings.

Sure: https://file.io/25za5BNBlnU8  (6.8M)

Of the 3677 tasks in there, only 38 do NOT show xfs_inodegc_flush().

> I bet, however, that you and everyone else would rather have somewhat
> inaccurate results than a load average of 4700 and a dead machine.

Yes, that would have been a nicer result.

Chris
