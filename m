Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF686C001DE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 08:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjHDIHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjHDIHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 04:07:09 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBE44684
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 01:07:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-686c06b806cso1298506b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 04 Aug 2023 01:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691136428; x=1691741228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QV8xiLzpyRdogmF9Xy586z9SW9lMLBPYfXECh6abF2A=;
        b=HriQsqUmhwrVfoFj1dguYvQFMdfc/Coj113W77etdiPh+3/+6YozADM38/2AzwpxlT
         wFNFw1j/FIujvTINGTFneYG2xtzPH9Sy9C6e3cUflcTnK0pGaGd205OTGNWJG7t4fRPh
         XoW16i+B0y/6TCr3wp1TWzC4JIVfL6NIqoR4ZsofD3hFWKkBZ7LutuXiL1r8lKU5R4mb
         sLkvUNXXi3hAVv8KnQZ+NnFU3718r6wD2yJe1/bVgs1UNy9kLvwcdLAjiAskSwkjHrKe
         fItQI5wi00jEJyuLmLjcrT98h/LlwJx+UPBIpMw94W2Kmj1mlhg5bgeNbOmd0yIOZcT6
         e+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691136428; x=1691741228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QV8xiLzpyRdogmF9Xy586z9SW9lMLBPYfXECh6abF2A=;
        b=YGi8K0B5GwIrl7lFDZjKwRypBJ8z5CGM9BmQx54KNPqQXkJXMxzpwYmkBMLpnW2jGP
         V64iydHc+yHb5MAgewNYZJmNc3DK+srd3HEBXGSIgY5ngwgBNuPU5zeMM33EpjrfZoZP
         vYPBevngn+i26xwZuzs1QM6Zu5FIb3PUz05o/PhNRFR66osf5GZacPEN+oNjCmLdWRlP
         A7Pi7shzvc5fRa66GPHqJiKrRmhOTuwvyAIL4ljNWOXRMpY8w2R37ZePY0nRqEhDliEm
         81lr3jsSkOS6iGBD4GcsEoQFOi5IgvHzQNBLB0OGSImmkOU3+L8LJdH+I1FQCPsvIAIH
         AtsQ==
X-Gm-Message-State: AOJu0YwFE9eFmTw2SAvNxTBUr+Gk2wxLfp/LuKG3R5T5zuP7hU8R6HGK
        OQUG+Q/fbXRxyjjOoqZc7eN0uw==
X-Google-Smtp-Source: AGHT+IHZid3ZRzcpfrNJYMglE6GRQYrSTBUn/9yoLr0M67bxKXiocAkJLBHSTvZ1y2K3xRyQb6WJ2g==
X-Received: by 2002:a05:6a00:2495:b0:66c:9e97:aece with SMTP id c21-20020a056a00249500b0066c9e97aecemr900710pfv.10.1691136427646;
        Fri, 04 Aug 2023 01:07:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id e8-20020aa78248000000b00682a0184742sm1055376pfn.148.2023.08.04.01.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 01:07:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qRppv-000tCq-2G;
        Fri, 04 Aug 2023 18:07:03 +1000
Date:   Fri, 4 Aug 2023 18:07:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Corey Hickey <bugfood-ml@fatooh.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Message-ID: <ZMyxp/Udved6l9F/@dread.disaster.area>
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 03, 2023 at 10:44:31PM -0700, Corey Hickey wrote:
> Hello,
> 
> I am having a problem with write performance via direct I/O. My setup is:
> * Debian Sid
> * Linux 6.3.0-2 (Debian Kernel)
> * 3-disk MD RAID-5 of hard disks
> * XFS
> 
> When I do large sequential writes via direct I/O, sometimes the writes are
> fast, but sometimes the RAID ends up doing RMW and performance gets slow.
> 
> If I use regular buffered I/O, then performance is better, presumably due to
> the MD stripe cache. I could just use buffered writes, of course, but I am
> really trying to make sure I get the alignment correct to start with.
> 
> 
> I can reproduce the problem on a fresh RAID.
> -----------------------------------------------------------------------
> $ sudo mdadm --create /dev/md10 -n 3 -l 5 -z 30G /dev/sd[ghi]
> mdadm: largest drive (/dev/sdg) exceeds size (31457280K) by more than 1%
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md10 started.
> -----------------------------------------------------------------------
> For testing, I'm using "-z 30G" to limit the duration of the initial RAID
> resync.
> 
> 
> For XFS I can use default options:
> -----------------------------------------------------------------------
> $ sudo mkfs.xfs /dev/md10
> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
> log stripe unit adjusted to 32KiB
> meta-data=/dev/md10              isize=512    agcount=16, agsize=983040 blks

So an AG size of just under 2GB.

>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1
> nrext64=0
> data     =                       bsize=4096   blocks=15728640, imaxpct=25
>          =                       sunit=128    swidth=68352 blks
                                                ^^^^^^^^^^^^^^^^^

Something is badly broken in MD land.

.....

> The default chunk size is 512K
> -----------------------------------------------------------------------
> $ sudo mdadm --detail /dev/md10 | grep Chunk
>         Chunk Size : 512K
> $ sudo blkid -i /dev/md10
> /dev/md10: MINIMUM_IO_SIZE="524288" OPTIMAL_IO_SIZE="279969792"
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^

Yup, that's definitely broken.

> PHYSICAL_SECTOR_SIZE="512" LOGICAL_SECTOR_SIZE="512"
> -----------------------------------------------------------------------
> I don't know why blkid is reporting such a large OPTIMAL_IO_SIZE. I would
> expect this to be 1024K (due to two data disks in a three-disk RAID-5).

Yup, it's broken. :/

> Translating into 512-byte sectors, I think the topology should be:
> chunk size (sunit): 1024 sectors
> stripe size (swidth): 2048 sectors

Yup, or as it reports from mkfs, sunit=128 fsbs, swidth=256 fsbs.

> -----------------------------------------------------------------------
> $ sudo blktrace -d /dev/md10 -o - | blkparse -i - | grep ' Q '
>   9,10  15        1     0.000000000 186548  Q  WS 3829760 + 2048 [dd]
>   9,10  15        3     0.021087119 186548  Q  WS 3831808 + 2048 [dd]
>   9,10  15        5     0.023605705 186548  Q  WS 3833856 + 2048 [dd]
>   9,10  15        7     0.026093572 186548  Q  WS 3835904 + 2048 [dd]
>   9,10  15        9     0.028595887 186548  Q  WS 3837952 + 2048 [dd]
>   9,10  15       11     0.031171221 186548  Q  WS 3840000 + 2048 [dd]
> [...]
>   9,10   5      441    14.601942400 186608  Q  WS 8082432 + 2048 [dd]
>   9,10   5      443    14.620316654 186608  Q  WS 8084480 + 2048 [dd]
>   9,10   5      445    14.646707430 186608  Q  WS 8086528 + 2048 [dd]
>   9,10   5      447    14.654519976 186608  Q  WS 8088576 + 2048 [dd]
>   9,10   5      449    14.680901605 186608  Q  WS 8090624 + 2048 [dd]
>   9,10   5      451    14.689156421 186608  Q  WS 8092672 + 2048 [dd]
>   9,10   5      453    14.706529362 186608  Q  WS 8094720 + 2048 [dd]
>   9,10   5      455    14.732451407 186608  Q  WS 8096768 + 2048 [dd]
> -----------------------------------------------------------------------
> In the beginning, writes queued are stripe-aligned. For example:
> 3829760 / 2048 == 1870
> 
> Later on, writes end up getting misaligned by half a stripe. For example:
> 8082432 / 2048 == 3946.5

So it's aligned to sunit, not swidth. That will match up with a
discontiguity in the file layout. i.e. an extent boundary.

And given this is at just under 4GB written, and the AG size is 
just under 2GB, this discontiguity is going to occur as writing
fills AG 1 and allocation switches to AG 2.

> I tried manually specifying '-d sunit=1024,swidth=2048' for mkfs.xfs, but
> that had pretty much the same behavior when writing (the RMW starts later,
> but it still starts).

It won't change anything, actually. The first allocation in an AG
will determine which stripe unit the new extent starts on, and then
for the entire AG the write will be aligned to that choice.

If you do IOs much larger than the stripe width (e.g. 16MB at a
time) the impact of the head/tail RMW will largely go away. The
problem is that you are doing exactly stripe width sized IOs and so
is the worse case for any allocation misalignment that might occur.

> Am I doing something wrong, or is there a bug, or are my expectations
> incorrect? I had expected that large sequential writes would be aligned with
> swidth.

Expectations are wrong. Large allocations are aligned to stripe unit
in XFS by default.

THis is because XFS was tuned for *large* multi-layer RAID setups
like RAID-50 that had hardware RAID 5 luns stripe together via
RAID-0 in the volume manager.

In these setups, the stripe unit is the hardware RAID-5 lun stripe
width (the minimum size that avoids RMW) and the stripe width is the
RAID-0 width.

Hence for performance, it didn't matter which sunit allocation
aligned to as long as writes spanned the entire stripe width. That
way they would hit every lun.

In general, we don't want stripe width aligned allocation, because
that hot-spots the first stripe unit in the stripe as all file data
first writes to that unit. A raid stripe is only as fast as it's
slowest disk, and so having a hot stripe unit slows everything down.
Hence by default we move the initial allocation around the stripe
units, and that largely removes the hotspots in the RAID luns...

So, yeah, there are good reasons for stripe unit aligned allocation
rather than stripe width aligned.

The problem is that MD has never behaved this way - it has always
exposed it's individual disk chunk size as the minimum IO size (i.e.
the stripe unit) and the stripe width as the optimal IO size to
avoid RMW cycles.

If you want to force XFS to do stripe width aligned allocation for
large files to match with how MD exposes it's topology to
filesytsems, use the 'swalloc' mount option. The down side is that
you'll hotspot the first disk in the MD array....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
