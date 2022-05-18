Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B404EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 22:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiERWgN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 18:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiERWgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 18:36:11 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A45A205FC
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 15:36:08 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 9E1C260FB5;
        Thu, 19 May 2022 08:36:06 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id 8wUWdEkO1d1n; Thu, 19 May 2022 08:36:06 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 7152360F6F;
        Thu, 19 May 2022 08:36:06 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 5CCF168026D; Thu, 19 May 2022 08:36:06 +1000 (AEST)
Date:   Thu, 19 May 2022 08:36:06 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: fstrim and strace considered harmful?
Message-ID: <20220518223606.GA1343027@onthe.net.au>
References: <20220518065949.GA1237408@onthe.net.au>
 <20220518070713.GA1238882@onthe.net.au>
 <YoUXxBe1d7b29wif@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YoUXxBe1d7b29wif@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 08:59:00AM -0700, Darrick J. Wong wrote:
> On Wed, May 18, 2022 at 05:07:13PM +1000, Chris Dunlop wrote:
>> Oh, sorry... on linux v5.15.34
>>
>> On Wed, May 18, 2022 at 04:59:49PM +1000, Chris Dunlop wrote:
>>> I have an fstrim that's been running for over 48 hours on a 256T thin
>>> provisioned XFS fs containing around 55T of actual data on a slow
>>> subsystem (ceph 8,3 erasure-encoded rbd). I don't think there would be
>>> an an enourmous amount of data to trim, maybe a few T, but I've no idea
>>> how long how long it might be expected to take. In an attempt to see
>>> what the what the fstrim was doing, I ran an strace on it. The strace
>>> has been sitting there without output and unkillable since then, now 5+
>>> hours ago.  Since the strace, on that same filesystem I now have 123 df
>>> processes and 615 rm processes -- and growing -- that are blocked in
>>> xfs_inodegc_flush, e.g.:
...
> It looks like the storage device is stalled on the discard, and most
> everything else is stuck waiting for buffer locks?  The statfs threads
> are the same symptom as last time.

Note: the box has been rebooted and it's back to normal after an anxious 
30 minutes waiting for the mount recovery. (Not an entirely wasted 30 
minutes - what a thrilling stage of the Giro d'Italia!)

I'm not sure if the fstrim was stalled, unless the strace had stalled it 
somehow: it had been running for ~48 hours without apparent issues before 
the strace was attached, and then it was another hour before the first 
process stuck on xfs_inodegc_flush appeared.

The open question is what caused the stuck processes? It's possible the 
strace was involved: the stuck process with the earliest start time, a 
"df", was started an hour after the strace and it's entirely plausible 
that was the very first df or rm issued after the strace. However it's 
also plausible that was a coincidence and the strace had nothing to do 
with it. Indeed it's even plausible the fstrim had nothing to do with the 
stuck processes and there's something else entirely going on: I don't know 
if there's a ticking time bomb somewhere in the system

It's now no mystery to me why the fstrim was taking so long, nor why the 
strace didn't produce any output: it turns out fstrim, without an explicit 
--offset --length range, issues a single ioctl() to trim from the start of 
the device to the end, and without an explicit --minimum, uses 
/sys/block/xxx/queue/discard_granularity as the minimum block size to 
discard, in this case 64kB. So it would have been issuing a metric 
shit-ton of discard requests to the underlying storage, something close 
to:

   (fs-size - fs-used) / discard-size
   256T - 26T / 64k
   3,858,759,680 requests

It was after figuring out all that that I hit the reset.

Note: it turns out the actual used space per the filesystem is 26T, whilst 
the underlying storage shows 55T used, i.e. there's 29T of real discards 
to process. With this ceph rbd storage I don't know if a "real" discard 
takes any more or less time than a discard to already-unoccupied storage. 

Next time I'll issue the fstrim in much smaller increments, e.g. starting 
with perhaps 128G (at least at first), and use a --minimum that matches 
the underlying object size (4MB). Then play around and monitor it to work 
out what parameters work best for this system.

Cheers,

Chris - older, wiser, a little more sleep deprived
