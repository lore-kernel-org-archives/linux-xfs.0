Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287D5C77B73
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 01:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjFABrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 21:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFABra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 21:47:30 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB84121
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 18:47:29 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6af8127031cso281162a34.2
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 18:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685584048; x=1688176048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pqKX5wCIEjMJxSbcbMQ4WHF24GK6QiJJCQrXsTAw+zE=;
        b=4jNq9ImQ1gvUzFNTC13ceN7PCgHtiFyEt8N8Vcezwj+72L6DEWiZubI+VSuyBIvquL
         eZ+Gb36vzWOl59Cg+puqYb7Zs2+0IhrxKt6ASxGbSBNfiKSmXtQjXd4b5NAFDUlv26hM
         ET7ipscDqYf4I7zMeGAC+b0Nj3FqDEhCyqjQfTZyk8zbkAQiYl4l3bczUmxddX2+oq27
         XQpYEKsMAJ7Vv4ZvHdT1WawTxgtIrr+LJ8/FzBb7Pwf4CjtZSRYNJp8bhHDmHEbIIC/Q
         DtS6v71HF6Qr7peH9EmtumYj2oEK7cvJ85oPr/qfZqKTeC4U8l2LYTOdTGdTQ7CNQYIC
         sDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685584048; x=1688176048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqKX5wCIEjMJxSbcbMQ4WHF24GK6QiJJCQrXsTAw+zE=;
        b=SZMF6Zv6A8xHybTclhHgWkNFxY/cozpQzTzmbPu2rN6jNLJxWQQ7pQu9Fs0993M9Xk
         H3ADUBOO/l3XasTtv8pF9PT/8HQkLsIOTnkr8fyH//O9HZGjvsSaYoJ1eiMJEhiCnmOC
         z5YOWxqGczN5dEIfrdNn3pkdQMGXw6GzizMf5l/ARbd78XQTxjIiHTPLXsznAgbHYE/p
         CJ41wRAAgjEZ6DNfKPDT30QeWtw2blZmfsDI7vnvFkWNjeORU01dKTgZWFq9VomRHSWo
         mOYPZy11kfjKrI5enorHOFuHw8mXGGY+CjQRriO8qHNcBRHFPFA1j/y0fb69jrHhozOX
         FVog==
X-Gm-Message-State: AC+VfDw4BZLYuGTczp8E8UKszebq8h7deIJzC9O8PrksGulKKGRc0WLe
        KBoiYFxmTcKyuRnDAMHSfbY1RA==
X-Google-Smtp-Source: ACHHUZ5l/WsyT48oxUwlQsR8DUt/dq1XW5lKe5VMfcvjJKfeXOOWEoHwC6rSSRaI8DfYvJr3hxr4/w==
X-Received: by 2002:a05:6830:14d5:b0:697:ef66:e7f4 with SMTP id t21-20020a05683014d500b00697ef66e7f4mr3163542otq.24.1685584048325;
        Wed, 31 May 2023 18:47:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id t16-20020a62ea10000000b0065014c15a57sm1430983pfh.35.2023.05.31.18.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 18:47:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q4XPR-006KR7-0o;
        Thu, 01 Jun 2023 11:47:25 +1000
Date:   Thu, 1 Jun 2023 11:47:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS_AG_MIN_BLOCKS vs XFS_MIN_AG_BLOCKS
Message-ID: <ZHf4rTFe3uAcr5jF@dread.disaster.area>
References: <2777daf5-42e0-4350-9e0e-96a1fe68a039@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2777daf5-42e0-4350-9e0e-96a1fe68a039@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 30, 2023 at 12:02:04PM -0500, Eric Sandeen wrote:
> I got a bug report that REAR was trying to recreate an xfs filesystem
> geometry by looking at the xfs_info from the original filesystem.
> 
> In this case, the original fs was:
> 
> meta-data=/dev/mapper/vg-lv_srv  isize=512    agcount=400, agsize=6144 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1
> data     =                       bsize=4096   blocks=2453504, imaxpct=25
>          =                       sunit=16     swidth=16 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=1872, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> (horribly pessimal, almost certainly the result of xfs_growfs)
> 
> But the point is, the last AG is only 8MB. However, mkfs.xfs refuses to make
> an AG less than 16MB. So, this fails, because agcount was specified and mkfs
> won't reduce it to fix the too-small AG:
> 
> # truncate --size=10049552384 fsfile
> # mkfs.xfs -f -m uuid=23ce7347-fce3-48b4-9854-60a6db155b16 -i size=512 -d
> agcount=400 -s size=512 -i attr=2 -i projid32bit=1 -m crc=1 -m finobt=1 -b
> size=4096 -i maxpct=25 -d sunit=128 -d swidth=128 -l version=2 -l sunit=128
> -l lazy-count=1 -n size=4096 -n version=2 -r extsize=4096 fsfile
> mkfs.xfs: xfs_mkfs.c:3016: align_ag_geometry: Assertion
> `!cli_opt_set(&dopts, D_AGCOUNT)' failed.

/me finally catches up and reads bug report and Oh My What In The
World.... :)

> I think this is the result of mkfs.xfs using 16MB as a limit on last AG
> size:
> 
> #define XFS_AG_MIN_BYTES                ((XFS_AG_BYTES(15)))    /* 16 MB */
> #define XFS_AG_MIN_BLOCKS(blog)         (XFS_AG_MIN_BYTES >> (blog))
> 
> But growfs uses this:
> 
> #define XFS_MIN_AG_BLOCKS       64
> 
> (which is much smaller than 16MB).
> 
> This should almost certainly be consistent between mkfs and growfs, and my
> guess is that growfs should start using the larger XFS_AG_MIN_BLOCKS
> requirement that mkfs.xfs uses?

Yeah, that seems reasonable, but we can't get rid of
XFS_MIN_AG_BLOCKS unfortunately. There are clearly filesystems out
there that depend on AGs this small existing, so we can't just
replace one with the other. e.g. XFS_MIN_DBLOCKS() uses it and
that's part of the superblock size verification checks....

That said, the same superblock verifier asserts this is a failure:

	XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES

So now I'm guessing that the AGF verifier doesn't have the same
agf->agf_length verification against either XFS_MIN_AG_BYTES or
sbp->sb_agblocks.

Yup, the agf verifier does not check miniumum AGF length, it does
not even check that the agf length is the same as (or smaller than
for the last ag) sbp->sb_agblocks, either.

Worse is that we use agf->agf_length as if it was fully validated
and correct for other runtime block and extent range corruption
checks. Ugh.

I guess that's what the rest of my day is going to be spent
unravelling, starting with trying to work out why I never validated
this AGF field in the first place more than a decade ago....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
