Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3E4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 04:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbiDNELE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 00:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiDNELD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 00:11:03 -0400
X-Greylist: delayed 492 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Apr 2022 21:08:40 PDT
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 060D51FCCC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 21:08:39 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id CECCE60E33
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 14:00:24 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id Er1aO6MhHdqu for <linux-xfs@vger.kernel.org>;
        Thu, 14 Apr 2022 14:00:24 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 95DB760E26
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 14:00:24 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 827BB6802DC; Thu, 14 Apr 2022 14:00:24 +1000 (AEST)
Date:   Thu, 14 Apr 2022 14:00:24 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: Limits to growth
Message-ID: <20220414040024.GA550443@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I have a nearly full 30T xfs filesystem that I need to grow significantly, 
e.g. to, say, 256T, and potentially further in future, e.g. up to, say, 
1PB. Alternatively at some point I'll need to copy a LOT of data from the 
existing fs to a newly-provisioned much larger fs. If I'm going to need to 
copy data around I guess it's better to do it now, before there's a whole 
lot more data to copy.

According to Dave Chinner:

   https://www.spinics.net/lists/linux-xfs/msg20084.html
   Rule of thumb we've stated every time it's been asked in the past 10-15 
   years is "try not to grow by more than 10x the original size".

It's also explained the issue is the number of AGs.

Is it ONLY the number of AGs that's a concern when growing a fs?

E.g. for a fs starting in the 10s of TB that may need to grow 
substantially (e.g. >=10x), is it advisable to simply create it with the 
maximum available agsize, and you can then grow to whatever multiple 
without worrying about XFS getting ornery?

Of course as Dave explains further in the thread it would probably be 
better to just start with XFS on a large thin provisioned volume in the 
first place, but that's not where I am currently. Sigh.

Looking my fs and just considering the number of AGs (agcount)...

My original fs has:

meta-data=xxxx           isize=512    agcount=32, agsize=244184192 blks
          =               sectsz=4096  attr=2, projid32bit=1
          =               crc=1        finobt=1, sparse=1, rmapbt=1
          =               reflink=1    bigtime=0 inobtcount=0
data     =               bsize=4096   blocks=7813893120, imaxpct=5
          =               sunit=128    swidth=512 blks
naming   =version 2      bsize=4096   ascii-ci=0, ftype=1
log      =internal log   bsize=4096   blocks=521728, version=2
          =               sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none           extsz=4096   blocks=0, rtextents=0

If I do a test xfs_grow to 256T, it shows:

metadata=xxxxx           isize=512    agcount=282, agsize=244184192 blks

Creating a new fs on 256T, I get:

metadata=xxxxx           isize=512    agcount=257, agsize=268435328 blks

So growing the fs from 30T to 256T I end up with an agcount ~10% larger 
(and agsize ~10% smaller) than creating a 256T fs from scratch.

Just for the exercise, creating a new FS on 1P (i.e. 33x the current fs) 
gives:

metadata=xxxxx           isize=512    agcount=1025, agsize=268435328 blks

I.e. it looks like for this case the max agsize is 268435328 blocks. So 
even if the current fs were to grow to a 1P or more, e.g. 30x - 60x 
original, I'm still only going to be ~10% worse off in terms of agcount 
than creating a large fs from scratch and copying all the data over.

Is that really going to make a significant difference?

Cheers,

Chris
