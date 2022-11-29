Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BC6C4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbiK2Ven (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK2Vem (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:34:42 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CF45C75D
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:34:41 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so3491pjm.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w2LoJHDH0WJgsHqf4eErgeVgUuUlLkPkgirXXlHMuqM=;
        b=HIPLIiyooIwuVm5/AX/B92CpxNms6IYc26s63XA+L6uJwV4J/DrysRPuxqOA7vhG6H
         RTB91Q5XnKTZG1D8Z/fsBm5U+vpx/SolvQkOacbphPRTozocyBgCszjerdgm/xDSYHPN
         CgekKi/0+2ai0RdwnPZ6lGYeWTbV/BbK8TsbGB0nJ/NxdKpuvGu/GvAoDSV19fywYKAl
         pu7dkttFeE4St7HQKtbTOJT0HhURmjWHAHc7FQeguom0+di6nMXEXFbcXnKHoY0bKASG
         qioP+DbReKzifbBNu3NapZIv8Etr28u38gTNXBCmlCa5O4TxcThka8VpbOVuV9s1wcYy
         wuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2LoJHDH0WJgsHqf4eErgeVgUuUlLkPkgirXXlHMuqM=;
        b=Hbw+O/0mQ/SfHrEJ+lHSd7AR7OOxddIsPNKFtb0ycBntVR1W2z2nbd9UXT325v12lq
         Qw+0hq7xUGFK3m4iFPc4kD5LWYIU3QYQ6w5Za0Xq9TmfCWC7NALBsvMG8hLe3eqFEfhz
         n8y/1r1mjlMgbfDkcjMWCyudvLLQQmcJvy1OEs+RS/DXmUfDVpvabZXJVppI+6IWxqiE
         BY2P8eK5SYM4gzBnAVuTLq9eAKpiZCj7/4mb7TJtfVyE1gG58lRgC4in9MH7O0P3BDnn
         ImKqBYJA9+b/9SkMssDDTyiZOqNjwooCRViiF7zhKCxsXzD4V+tfVVKXyJPQ2Ygbo6Sz
         GRag==
X-Gm-Message-State: ANoB5plLQTTcdFRFxgyYqNBJfzsHMJsuMsMLb4jszmQKSl5JSGoMDt1w
        rdWcFshs4frVogSs07LjmcR1BQ==
X-Google-Smtp-Source: AA0mqf44eO0bIdqIfePC6giT8cKIZJiU2hABpbacDBWu+ZgN9OLtqEdIS+YmG0qK6S8oq3XANwuDiQ==
X-Received: by 2002:a17:902:9695:b0:189:93d4:db5 with SMTP id n21-20020a170902969500b0018993d40db5mr8374065plp.44.1669757680571;
        Tue, 29 Nov 2022 13:34:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902bf4b00b0017f7c4e260fsm11377534pls.150.2022.11.29.13.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 13:34:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p08FQ-002ZzR-Uv; Wed, 30 Nov 2022 08:34:37 +1100
Date:   Wed, 30 Nov 2022 08:34:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Shawn <neutronsharc@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
Message-ID: <20221129213436.GG3600936@dread.disaster.area>
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 11:20:05AM -0800, Shawn wrote:
> Hello all,
> I implemented a write workload by sequentially appending to the file
> end using libaio aio_write in O_DIRECT mode (with proper offset and
> buffer address alignment).  When I reach a 1MB boundary I call
> fallocate() to extend the file.

Ah, yet another fallocate anti-pattern.

Firstly, friends don't let friends use fallocate() with AIO+DIO.

fallocate() serialises all IO to that file - it waits for existing
IO to complete, and prevents new IO from being issued until the
the fallocate() operation completes. It is a completely synchronous
operation and it does not play well with non-blocking IO paths (AIO
or io_uring). Put simply: fallocate() is an IO performance and
scalability killer.

If you need to *allocate* in aligned 1MB chunks, then use extent
size hints to tell the filesystem to allocate 1MB aligned chunks
when it does IO. This does not serialise all IO to the file like
fallocate does, it acheives exactly the same result as using
fallocate to extend the file, yet the application doesn't need to
know anything about controlling file layout.

Further, using DIO write()s call to extend the file rather than
fallocate() or ftruncate() also means that there will always be data
right up to the end of the file.  That's because XFS will not update
the file size on extension until the IO has completed, and making
the file size extension persistent (i.e. journalling it) doesn't
happen until the data has been made persistent via device cache
flushes.

IOWs, if the file has been extended by a write IO, then XFS has
*guaranteed* that the data written to thatextended region has been
persisted to disk before the size extension is persisted.

> I need to protect the write from various failures such as disk unplug
> / power failure.  The bottom line is,  once I ack a write-complete,
> the user must be able to read it back later after a disk/power failure
> and recovery.

Fallocate() does not provide data integrity guarantees. The
application needs to use O_DSYNC/RWF_DSYNC IO controls to tell the
filesystem to provide data integrity guarnatees.

> In my understanding,  fallocate() will preallocate disk space for the
> file,  and I can call fsync to make sure the file metadata about this
> new space is persisted when fallocate returns.

Yes, but as it just contains zeros so if it is missing after a
crash, what does it matter? It just looks like the file wasn't
extended, and the application has to be able to recover from that
situation already, yes?

> Once aio_write returns
> the data is in the disk.  So it seems I don't need fsync after
> aio-write completion, because (1) the data is in disk,  and (2) the
> file metadata to address the disk blocks is in disk.

Wrong. Direct IO does not guarantee persistence when the
write()/aio_write() completes. Even with direct IO, the data can be
held in volatile caches in the storage stack and the data is not
guaranteed to be persistent until directed by the application to be
made persistent.

> On the other hand, it seems XFS always does a delayed allocation
> which might break my assumption that file=>disk space mapping is
> persisted by fallocate.

Wrong on many levels. The first is the same as above - fallocate()
does not provide any data persistence guarantees.

Secondly, DIO writes do not use delayed allocation because they
can't - we have to issue the IO immediately, so there's nothign that
can be delayed. IOWs, delayed allocation is only done for buffered
IO. This is true for delayed allocation on both ext4 and btrfs as
well.

Further, on XFS buffered writes into preallocated space from
fallocate() do not use delayed allocation either - the space is
already allocated, so there's nothing to allocate and hence nothing
to delay!

To drive the point home even further: if you use extent size
hints with buffered writes, then this also turns off delayed
allocation and instead uses immediate allocation just like DIO
writes to preallocate the aligned extent around the range being
written.

Lastly, if you write an fallocate() based algorithm that works
"well" on XFS, there's every chance it's going to absolutely suck on
a different filesystem (e.g. btrfs) because different filesystems
have very different allocation policies and interact with
preallocation very differently.

IOWs, there's a major step between knowing what concepts like
delayed allocation and preallocation do versus understanding the
complex policies that filesystems weave around these concepts to
make general purpose workloads perform optimally in most
situations....

> I can improve the data-in-disk format to carry proper header/footer to
> detect a broken write when scanning the file after a disk/power
> failure.
>
> Given all those above,  do I still need a fsync() after aio_write
> completion in XFS to protect data persistence?

Regardless of the filesystem, applications *always* need to use
fsync/fdatasync/O_SYNC/O_DSYNC/RWF_DSYNC to guarantee data
persistence. The filesystem doesn't provide any persistence
guarantees in the absence of these application directives -
guaranteeing user data integrity is the responsibility of the
application manipulating the user data, not the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
