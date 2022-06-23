Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF971C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiFWUDf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiFWUDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34FE2D1E5
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B8361D59
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 20:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB0AC341C7;
        Thu, 23 Jun 2022 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656014579;
        bh=Aq7uHmK13BygEEQNIJPGDztkSJbDW1ugGmhwLzpuDwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJZbb1MEiRiogijRnjgd/Os0odUe6+PsBWIfRdNk+iCdd0vlNCODfMkjjg3n6wMTs
         Jhm+6jBil4Ug2hxOqTgvhzhTceRLRt0N0Pid5xRsvrwdC5ep0u4QSoDv98KNmAD/e7
         sg4pMjbNCh1pOqEWkzHzFh6ibAFGZ/Q+rsKqbG3WEDUo924KLEsfVicFyfLMl/QbAQ
         fzb+uzs/K0lAjuQw0FPrf0F/wTvHYe9JdtUgRidCmS6aqn7ZFucJa+Fw/eY8dZZ+jC
         CN8aBLvkBEIJwwsTzc7KlX5kjqmSaua5qPCveyLzezi7mUW+PHUsVKCd3gXO7q/d2l
         M0aaTFfM1zM9g==
Date:   Thu, 23 Jun 2022 13:02:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     GDD Media <ggdmedia1@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [xfs] rmap.c:696: mark_inode_rl: Assertion failed
Message-ID: <YrTG8qC24oJa3KFP@magnolia>
References: <CAAd6o_a1YF-5NWBc-kGLR9uAz2tQL_zoSi-ORi2S4Ttx6Jv6ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd6o_a1YF-5NWBc-kGLR9uAz2tQL_zoSi-ORi2S4Ttx6Jv6ZA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 01:09:30PM +0200, GDD Media wrote:
> Hi
> 
> I'm running unRAID server and last night fs on one of my drives got
> corrupted. I tried running xfs_repair (which usually worked) but this
> time I got this error:
> 
> xfs_repair: rmap.c:696: mark_inode_rl: Assertion
> `!(!!((rmap->rm_owner) & (1ULL << 63)))' failed.
> Aborted
> 
> I'm using xfs_repair version 5.13.0
> 
> What can I do to fix this? I don't know much about Linux, I mostly use
> web gui to manage my server and I can't find anything related to that
> error on the internet so any help will be appreciated.
> 
> Also, here's the almost full log with some repeating lines deleted:
> 
> Phase 1 - find and verify superblock...
>         - block cache size set to 305128 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 1124625 tail block 1124610
> ALERT: The filesystem has valuable metadata changes in a log which is being
> ignored because the -n option was used.  Expect spurious inconsistencies
> which may be resolved by first mounting the filesystem to replay the log.

The fs is dirty and needs to have the log recovered.  Did mounting the
fs (which recovers the log) fail?

--D

>         - scan filesystem freespace and inode maps...
> agf_freeblks 5759502, counted 5759493 in ag 0
> agi_freecount 62, counted 61 in ag 0
> agi_freecount 62, counted 61 in ag 0 finobt
> sb_fdblocks 27013023, counted 40637666
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> 1524704c7700: Badness in key lookup (length)
> bp=(bno 0x2217a80, len 16384 bytes) key=(bno 0x2217a80, len 4096 bytes)
> imap claims in-use inode 35748416 is free, correcting imap
> data fork in ino 35748420 claims free block 4468551
> imap claims in-use inode 35748420 is free, correcting imap
> data fork in ino 35748426 claims free block 4468550
> imap claims in-use inode 35748426 is free, correcting imap
> data fork in ino 35748433 claims free block 4468549
> imap claims in-use inode 35748433 is free, correcting imap
> data fork in inode 35748440 claims metadata block 4468560
> correcting nextents for inode 35748440
> bad data fork in inode 35748440
> would have cleared inode 35748440
>         - agno = 1
> data fork in ino 2147483777 claims free block 268435458
> imap claims in-use inode 2147483777 is free, correcting imap
> [...]
>         - agno = 2
> data fork in ino 4327071235 claims free block 540883903
> imap claims in-use inode 4327071235 is free, correcting imap
> [...]
>         - agno = 3
> data fork in ino 6453720963 claims free block 806715119
> imap claims in-use inode 6453720963 is free, correcting imap
> [...]
>         - agno = 4
> data fork in ino 8609098822 claims free block 1076137360
> imap claims in-use inode 8609098822 is free, correcting imap
> imap claims in-use inode 8609098829 is free, correcting imap
> [...]
>         - agno = 5
> data fork in inode 10773946882 claims metadata block 1346743359
> correcting nextents for inode 10773946882
> bad data fork in inode 10773946882
> would have cleared inode 10773946882
> [...]
>         - agno = 6
> imap claims in-use inode 13657483776 is free, correcting imap
> data fork in ino 13657483780 claims free block 1707185480
> [...]
>         - agno = 7
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
> free space (0,4468567-4468567) only seen by one free space btree
> free space (0,4468576-4468577) only seen by one free space btree
> free space (0,4486063-4486063) only seen by one free space btree
>         - check for inodes claiming duplicate blocks...
>         - agno = 2
>         - agno = 1
>         - agno = 0
> entry ".." at block 0 offset 80 in directory inode 2147483777
> references free inode 13658521470
>         - agno = 3
> entry ".." at block 0 offset 80 in directory inode 2147483794
> references free inode 13658521470
> [...]
> Metadata CRC error detected at 0x459c09, xfs_dir3_block block 0x2217a80/0x1000
> bad directory block magic # 0x494e41ff in block 0 for directory inode 35748440
> corrupt block 0 in directory inode 35748440
>         would junk block
> no . entry for directory 35748440
> no .. entry for directory 35748440
> problem with directory contents in inode 35748440
> would have cleared inode 35748440
> [...]
>         - agno = 4
>         - agno = 5
> data fork in inode 10773946882 claims metadata block 1346743359
> correcting nextents for inode 10773946882
> bad data fork in inode 10773946882
> would have cleared inode 10773946882
> [...]
>         - agno = 6
> entry ".." at block 0 offset 80 in directory inode 13657483780
> references free inode 13658521470
> [...]
>         - agno = 7
> entry ".." at block 0 offset 80 in directory inode 13657483816
> references free inode 13658521470
> [...]
> xfs_repair: rmap.c:696: mark_inode_rl: Assertion
> `!(!!((rmap->rm_owner) & (1ULL << 63)))' failed.
> Aborted
