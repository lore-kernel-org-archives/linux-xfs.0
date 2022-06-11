Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8C0C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 11:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiFKLJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 07:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiFKLJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 07:09:44 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B5713E1B
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 04:09:43 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id s12so2511867ejx.3
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 04:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ouA7tiVZsa7V0m64dT0YmFE/COj5v7kH0L+RtY9xOIg=;
        b=Jh6IC4BFW5wGH3MSrCTeyAiHGwPGnrWw7cC00L9XjQPtgWwPsPoWRnSjDv6j9E8Am0
         Y6Of3RCJhtGiunhTRyU87NUXeAg952hpSl0RHn9Ctkr9/Qu6N+ljOaMp0lAwjxIHRBrn
         aXsW4mzKC4cOJ6Ve9Hn57nKOSLHRS4EeBmSUIwQSFdzxInSL79epBIPZO6lh1HGkYhge
         Tp40W8v7nC9BGv6MRDjRCDcOY4qG9xVJDSthMQWPXj9kwLZabDnaURYJ8iIe+x4YqZzl
         YSIohBcCq86L+BLYUK2MisN69G3SVozSgmYWJhz18FugoQqBsPozuAjTjSOTjqDHRDc/
         oKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ouA7tiVZsa7V0m64dT0YmFE/COj5v7kH0L+RtY9xOIg=;
        b=vqIy/DbGXSxgr65pZ/+hpAOj6Ejk4Zb1cneDFz4tqXW1KWDFCWkA8xCsgBRcRQmxhK
         D/AzEH4drlkS+9WM7DAMACu2SQbobbhDZNdZ/y57EUTR5xa5WgiZyIJISVAiBBiosdbW
         H02dP+/cFwM9uv/drYrW8hhydlDmw5RbTBReJlZbG9DvN6DewGNcojixgFc69LGFGGaU
         fSzg6wIuBn2FU8MmSQF0OBXA24fhLGUQx6urkW1be/ttBiW9bRSBJr8vgXN+ODA29RsY
         2rRyNQcEJOr1wLI6YSaPOeSDLMMBrK6hByaks9d15py2FMqLB8V2fR0j1MWKQelbygds
         8o4Q==
X-Gm-Message-State: AOAM533o0NrVuswq2kccLOQFVjPZwn3ZuSxBoX5iIdQnigDIN5skS4bP
        yfHZoynCJgnR6cLTv79LJlPq1tc+V6Ma2hR5am29224lddI=
X-Google-Smtp-Source: ABdhPJy+LFEdrTVtC8zYJViXKVPq69gYayscPa6rtonn1jGl2mxG6TtKwq4kcTjNms2iYTSfw8O4gr0hCtaDh7rVgd0=
X-Received: by 2002:a17:906:1084:b0:712:2989:b630 with SMTP id
 u4-20020a170906108400b007122989b630mr5484505eju.344.1654945781613; Sat, 11
 Jun 2022 04:09:41 -0700 (PDT)
MIME-Version: 1.0
From:   GDD Media <ggdmedia1@gmail.com>
Date:   Sat, 11 Jun 2022 13:09:30 +0200
Message-ID: <CAAd6o_a1YF-5NWBc-kGLR9uAz2tQL_zoSi-ORi2S4Ttx6Jv6ZA@mail.gmail.com>
Subject: [xfs] rmap.c:696: mark_inode_rl: Assertion failed
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi

I'm running unRAID server and last night fs on one of my drives got
corrupted. I tried running xfs_repair (which usually worked) but this
time I got this error:

xfs_repair: rmap.c:696: mark_inode_rl: Assertion
`!(!!((rmap->rm_owner) & (1ULL << 63)))' failed.
Aborted

I'm using xfs_repair version 5.13.0

What can I do to fix this? I don't know much about Linux, I mostly use
web gui to manage my server and I can't find anything related to that
error on the internet so any help will be appreciated.

Also, here's the almost full log with some repeating lines deleted:

Phase 1 - find and verify superblock...
        - block cache size set to 305128 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 1124625 tail block 1124610
ALERT: The filesystem has valuable metadata changes in a log which is being
ignored because the -n option was used.  Expect spurious inconsistencies
which may be resolved by first mounting the filesystem to replay the log.
        - scan filesystem freespace and inode maps...
agf_freeblks 5759502, counted 5759493 in ag 0
agi_freecount 62, counted 61 in ag 0
agi_freecount 62, counted 61 in ag 0 finobt
sb_fdblocks 27013023, counted 40637666
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
1524704c7700: Badness in key lookup (length)
bp=(bno 0x2217a80, len 16384 bytes) key=(bno 0x2217a80, len 4096 bytes)
imap claims in-use inode 35748416 is free, correcting imap
data fork in ino 35748420 claims free block 4468551
imap claims in-use inode 35748420 is free, correcting imap
data fork in ino 35748426 claims free block 4468550
imap claims in-use inode 35748426 is free, correcting imap
data fork in ino 35748433 claims free block 4468549
imap claims in-use inode 35748433 is free, correcting imap
data fork in inode 35748440 claims metadata block 4468560
correcting nextents for inode 35748440
bad data fork in inode 35748440
would have cleared inode 35748440
        - agno = 1
data fork in ino 2147483777 claims free block 268435458
imap claims in-use inode 2147483777 is free, correcting imap
[...]
        - agno = 2
data fork in ino 4327071235 claims free block 540883903
imap claims in-use inode 4327071235 is free, correcting imap
[...]
        - agno = 3
data fork in ino 6453720963 claims free block 806715119
imap claims in-use inode 6453720963 is free, correcting imap
[...]
        - agno = 4
data fork in ino 8609098822 claims free block 1076137360
imap claims in-use inode 8609098822 is free, correcting imap
imap claims in-use inode 8609098829 is free, correcting imap
[...]
        - agno = 5
data fork in inode 10773946882 claims metadata block 1346743359
correcting nextents for inode 10773946882
bad data fork in inode 10773946882
would have cleared inode 10773946882
[...]
        - agno = 6
imap claims in-use inode 13657483776 is free, correcting imap
data fork in ino 13657483780 claims free block 1707185480
[...]
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
free space (0,4468567-4468567) only seen by one free space btree
free space (0,4468576-4468577) only seen by one free space btree
free space (0,4486063-4486063) only seen by one free space btree
        - check for inodes claiming duplicate blocks...
        - agno = 2
        - agno = 1
        - agno = 0
entry ".." at block 0 offset 80 in directory inode 2147483777
references free inode 13658521470
        - agno = 3
entry ".." at block 0 offset 80 in directory inode 2147483794
references free inode 13658521470
[...]
Metadata CRC error detected at 0x459c09, xfs_dir3_block block 0x2217a80/0x1000
bad directory block magic # 0x494e41ff in block 0 for directory inode 35748440
corrupt block 0 in directory inode 35748440
        would junk block
no . entry for directory 35748440
no .. entry for directory 35748440
problem with directory contents in inode 35748440
would have cleared inode 35748440
[...]
        - agno = 4
        - agno = 5
data fork in inode 10773946882 claims metadata block 1346743359
correcting nextents for inode 10773946882
bad data fork in inode 10773946882
would have cleared inode 10773946882
[...]
        - agno = 6
entry ".." at block 0 offset 80 in directory inode 13657483780
references free inode 13658521470
[...]
        - agno = 7
entry ".." at block 0 offset 80 in directory inode 13657483816
references free inode 13658521470
[...]
xfs_repair: rmap.c:696: mark_inode_rl: Assertion
`!(!!((rmap->rm_owner) & (1ULL << 63)))' failed.
Aborted
