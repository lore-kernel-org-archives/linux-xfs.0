Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A60C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 23:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347979AbiBBXpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Feb 2022 18:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236839AbiBBXpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Feb 2022 18:45:46 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F86BC061714
        for <linux-xfs@vger.kernel.org>; Wed,  2 Feb 2022 15:45:46 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id w81so3468329ybg.12
        for <linux-xfs@vger.kernel.org>; Wed, 02 Feb 2022 15:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n2vNEXpyRuZImJO1htrdMufccmCQ3RyL8hWBR/EguT8=;
        b=SwAPWD6a0vW3tKHFdtAOkJktgaO/vitGVzvrr0HFeRL2H+AE77Jj/9xQzoaefIsR/X
         N8SWgUO2/uF/Tym4lGucUPyqDxuXm9RB273AvGh/aIlpmX3bxJBvNpdbS9v+cKPNX3Tq
         ybIVndg5XLzGwCw+LHnJWCdJM89pEqgyvOcyLAelZAornyVXyQ3TpGSkR4OH8ua5VWfX
         Ug1uUaYvCbDoV77MWXA7NRvUYgfU+vAvpsg/K6Yz9d5MLUhQYUY6CrHM5xgpcu6ar1Wg
         F9E1+9DoeeNR2O+ybfpS59L3jmS1T6dLzB2dUCa/QLvDZoU+VjB8Y+zNvuILNkl3ijzD
         ORMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n2vNEXpyRuZImJO1htrdMufccmCQ3RyL8hWBR/EguT8=;
        b=RVoJVOkPG2nHkssBOarSQD4mTY16PobdqU9T1f5m/3lx0pT3ZkwWURLSwSY9R2ecFj
         P1bRHrnY+Y1h2qjfnr8xcL/d2WG6rKvpM4Su2YbioFxzKH+UQ5Rw9qF1TGxKVvMrawPA
         1iKF3Am1nJG0aiJJCtjKkIZnrE4mvnYhWhQIFTSp8BxH0c0GnBdX6hUyuyrCz742MQfr
         eznxdUji/LqH0LkwLK0C+eqsu90qgGdc97iG0XUErDVvlaVf2m/L+DE7TL9RVLP6YVZq
         Ry1tJKfKbf+QH4KxWcmRAERLEyMJ1aNPUsm7d8MWOUNqKdjFx7nQAvYfg7F/jsM7kkoU
         4HcQ==
X-Gm-Message-State: AOAM531FtIgOzJk6Rv0T+06O/x9R0hCVbr23yIxYjdzCL9JW8I+e4WDq
        WYVzCyA1WgyYDlYEqWgrAw3REBJGUW2jrzFiQCWhxa8sztkgLA==
X-Google-Smtp-Source: ABdhPJxRynoP/HyFMez2GNs7x5f1sampxCFX1jEWen1TnOCscD+lFIOOIKIXN6UDFx+TKl1EagSbYji3nPJvzTNsND8=
X-Received: by 2002:a81:7c4:: with SMTP id 187mr2477734ywh.220.1643845545683;
 Wed, 02 Feb 2022 15:45:45 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area> <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area> <20220202074242.GA59729@dread.disaster.area>
 <CAA43vkXxyHmQdu-GqVukmeOqEh8g-xJDCDD6sx7t4f-MVn+BBA@mail.gmail.com>
 <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
 <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com> <20220202220559.GB59729@dread.disaster.area>
In-Reply-To: <20220202220559.GB59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Wed, 2 Feb 2022 18:45:34 -0500
Message-ID: <CAA43vkXsEydXtf8urxSBKo2WN4arbMDKw3+8mA7YSAJ9ZJwg9w@mail.gmail.com>
Subject: Re: [PATCH] metadump: handle corruption errors without aborting
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sure! Please see gdb backtrace output below.

(gdb) bt
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:51
#1  0x00007f289d5c7921 in __GI_abort () at abort.c:79
#2  0x00007f289d610967 in __libc_message (action=action@entry=do_abort,
    fmt=fmt@entry=0x7f289d73db0d "%s\n") at ../sysdeps/posix/libc_fatal.c:181
#3  0x00007f289d6179da in malloc_printerr (
    str=str@entry=0x7f289d73f368 "malloc_consolidate(): invalid chunk
size") at malloc.c:5342
#4  0x00007f289d617c7e in malloc_consolidate
(av=av@entry=0x7f289d972c40 <main_arena>)
    at malloc.c:4471
#5  0x00007f289d61b968 in _int_malloc (av=av@entry=0x7f289d972c40 <main_arena>,
    bytes=bytes@entry=33328) at malloc.c:3713
#6  0x00007f289d620275 in _int_memalign (bytes=32768, alignment=512,
av=0x7f289d972c40 <main_arena>)
    at malloc.c:4683
#7  _mid_memalign (address=<optimized out>, bytes=32768,
alignment=<optimized out>) at malloc.c:3315
#8  __GI___libc_memalign (alignment=<optimized out>,
bytes=bytes@entry=32768) at malloc.c:3266
#9  0x000055fe39e2d7ec in __initbuf (bp=bp@entry=0x55fe3c781010,
btp=btp@entry=0x55fe3b88a080,
    bno=bno@entry=98799836480, bytes=bytes@entry=32768) at rdwr.c:239
#10 0x000055fe39e2d8a4 in libxfs_initbuf (bytes=32768,
bno=98799836480, btp=0x55fe3b88a080,
    bp=0x55fe3c781010) at rdwr.c:266
#11 libxfs_getbufr (btp=btp@entry=0x55fe3b88a080, blkno=blkno@entry=98799836480,
    bblen=<optimized out>) at rdwr.c:345
#12 0x000055fe39e2d9ab in libxfs_balloc (key=<optimized out>) at rdwr.c:554
#13 0x000055fe39e77bf8 in cache_node_allocate (key=0x7ffef716dcc0,
cache=0x55fe3b879a70)
    at cache.c:305
#14 cache_node_get (cache=0x55fe3b879a70, key=key@entry=0x7ffef716dcc0,
    nodep=nodep@entry=0x7ffef716dc60) at cache.c:451
#15 0x000055fe39e2d496 in __cache_lookup
(key=key@entry=0x7ffef716dcc0, flags=flags@entry=0,
    bpp=bpp@entry=0x7ffef716dcb8) at rdwr.c:388
#16 0x000055fe39e2e91f in libxfs_getbuf_flags (bpp=0x7ffef716dcb8,
flags=0, len=<optimized out>,
    blkno=98799836480, btp=<optimized out>) at rdwr.c:440
#17 libxfs_buf_read_map (btp=0x55fe3b88a080,
map=map@entry=0x7ffef716dd60, nmaps=nmaps@entry=1,
    flags=flags@entry=2, bpp=bpp@entry=0x7ffef716dd58,
    ops=ops@entry=0x55fe3a0adae0 <xfs_inode_buf_ops>) at rdwr.c:655
#18 0x000055fe39e1bc64 in libxfs_buf_read (ops=0x55fe3a0adae0
<xfs_inode_buf_ops>,
    bpp=0x7ffef716dd58, flags=2, numblks=64, blkno=98799836480,
target=<optimized out>)
    at ../libxfs/libxfs_io.h:173
#19 set_cur (type=0x55fe3a0b11a8 <__typtab_crc+840>, blknum=98799836480, len=64,
    ring_flag=ring_flag@entry=0, bbmap=bbmap@entry=0x0) at io.c:550
#20 0x000055fe39e2155f in copy_inode_chunk (rp=0x55fe420f42a8,
agno=<optimized out>)
    at metadump.c:2527
#21 scanfunc_ino (block=<optimized out>, agno=<optimized out>,
agbno=<optimized out>,
    level=<optimized out>, btype=<optimized out>, arg=<optimized out>)
at metadump.c:2604
#22 0x000055fe39e1d7df in scan_btree (agno=46, agbno=1553279,
level=level@entry=1,
    btype=btype@entry=TYP_INOBT, arg=arg@entry=0x7ffef716e030,
    func=func@entry=0x55fe39e210b0 <scanfunc_ino>) at metadump.c:403
#23 0x000055fe39e2133d in scanfunc_ino (block=<optimized out>,
agno=46, agbno=1197680, level=1,
    btype=TYP_INOBT, arg=0x7ffef716e030) at metadump.c:2627
#24 0x000055fe39e1d7df in scan_btree (agno=agno@entry=46,
agbno=1197680, level=2,
    btype=btype@entry=TYP_INOBT, arg=arg@entry=0x7ffef716e030,
    func=func@entry=0x55fe39e210b0 <scanfunc_ino>) at metadump.c:403
#25 0x000055fe39e20eca in copy_inodes (agi=0x55fe41ca9400, agno=46) at
metadump.c:2660
#26 scan_ag (agno=46) at metadump.c:2784
#27 metadump_f (argc=<optimized out>, argv=<optimized out>) at metadump.c:3086
#28 0x000055fe39e030d1 in main (argc=<optimized out>, argv=<optimized
out>) at init.c:190
(gdb)

Best,

Sean


On Wed, Feb 2, 2022 at 5:06 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Feb 02, 2022 at 03:18:34PM -0500, Sean Caron wrote:
> > Hi Dave,
> >
> > It counted up to inode 13555712 and then crashed with the error:
> >
> > malloc_consolidate(): invalid chunk size
>
> That sounds like heap corruption or something similar - that's a
> much more difficult problem to track down.
>
> Can you either run gdb on the core file it left and grab a stack
> trace of where it crashed, or run metadump again from gdb so that it
> can capture the crash and get a stack trace that way?
>
> > Immediately before that, it printed:
> >
> > xfs_metadump: invalid block number 4358190/50414336 (1169892770398976)
> > in bmap extent 0 in symlink ino 98799839421
>
> I don't think that would cause any problems - it just aborts
> processing the extent records in that block and moves on to the next
> valid one that is found.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
