Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F39EE4993
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Aug 2023 19:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjHUTCe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjHUTCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2023 15:02:32 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA5E1B0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Aug 2023 12:02:04 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-79216d8e2cfso92069939f.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Aug 2023 12:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692644524; x=1693249324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vf2Uah1xRsrfkQQ7V2FnsfZygGJyCncUBRDL6B2o6s=;
        b=O1fCHjOsqVfSzLXSBlVDAoadKOHCfJimv1F/DCLrNTX8TM6e/SIPC++JE8G51OOl4d
         AOoUXojV+eofBXBCU9V6ovnYz6a5soMzMaSYdH9fQgANCJDYyVXDWnMSUhOEltnPzva/
         ynphkVeAoWaN6bN1DMrSySuBCvVq3O4BMMJcbosQG6tDfbV5Bwg6MTxcky5gMTGZw68P
         3i2qI/7JC5qc1cQZg+/2rgbrgvoKbLz2HvKYxlabxEon0Ok6L0uwEdtOZXcKUQd/b6Rs
         pak3bLSi/CRPAzTo0yKeb5/jb1kkNFpnDwBG5smsQhCTFcMDuD210ODgxe2+r/0eVeWw
         o2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692644524; x=1693249324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9vf2Uah1xRsrfkQQ7V2FnsfZygGJyCncUBRDL6B2o6s=;
        b=ewxEL0UlvI/cZvAsrl4tSnS8zMb9Cu2qIdsdKJmxwFWDbal4tlPd3iFA1GNuifm/Ap
         FtR0jgGgPVidHnacSlExgHi4Y2KQBdfIbr/xNHp5lR8ZWuQiAOjZwiAhq6hcBNNBaYe3
         QQwOqWPct8hShwmR4YSRbxtwfRuD1/M0cvns3eXwYAT95wdYIrkbbW1Au+cOUEFPACRK
         rs+zONzfU4+hvA5d4/rFrXEJfF0skisiVqiYYnjziXJC5jHvFa2rYbSF/nEPSMkVZgVk
         QHqCTSpDV5vIye3F18omcxhJo4Kc5mIz41aG6CTqUvOI//WL6AYeJNZybtfeIWnHQn+v
         6Yow==
X-Gm-Message-State: AOJu0YwttXnMWnhah79cVQ42+sL8d0FJ7+ZPN/Ranwbb3xX0UI6qx11L
        v2GqOWTyY75+z610vHcAhtDo+uKBmf+kmcIGNzlkJGfMjxQ=
X-Google-Smtp-Source: AGHT+IGLScX7sCPb+1thhNkYVAe+g/P1BjIM05fafjUcIpfORI8k8DLWcG/bQjFzWU1aw1wlHfmYbgLecptCONshn4g=
X-Received: by 2002:a05:6602:49:b0:787:1a8f:1d08 with SMTP id
 z9-20020a056602004900b007871a8f1d08mr9038925ioz.15.1692644523767; Mon, 21 Aug
 2023 12:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area>
In-Reply-To: <20221129213436.GG3600936@dread.disaster.area>
From:   Shawn <neutronsharc@gmail.com>
Date:   Mon, 21 Aug 2023 12:01:27 -0700
Message-ID: <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Dave,
Thank you for your detailed reply.  That fallocate() thing makes a lot of s=
ense.

I want to figure out the default extent size in my evn.  But
"xfs_info" doesn't seem to output it? (See below output)

Also, I want to use this cmd to set the default extent size hint, is
this correct?
$ sudo mkfs.xfs -d extszinherit=3D256    <=3D=3D the data block is 4KB,  so
256 is 1MB.


$ sudo xfs_info  /dev/nvme3n1
meta-data=3D/dev/nvme3n1           isize=3D512    agcount=3D4, agsize=3D117=
210902 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D468843606, imaxp=
ct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D228927, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0



regards,
Shawn


On Tue, Nov 29, 2022 at 1:34=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Tue, Nov 29, 2022 at 11:20:05AM -0800, Shawn wrote:
> > Hello all,
> > I implemented a write workload by sequentially appending to the file
> > end using libaio aio_write in O_DIRECT mode (with proper offset and
> > buffer address alignment).  When I reach a 1MB boundary I call
> > fallocate() to extend the file.
>
> Ah, yet another fallocate anti-pattern.
>
> Firstly, friends don't let friends use fallocate() with AIO+DIO.
>
> fallocate() serialises all IO to that file - it waits for existing
> IO to complete, and prevents new IO from being issued until the
> the fallocate() operation completes. It is a completely synchronous
> operation and it does not play well with non-blocking IO paths (AIO
> or io_uring). Put simply: fallocate() is an IO performance and
> scalability killer.
>
> If you need to *allocate* in aligned 1MB chunks, then use extent
> size hints to tell the filesystem to allocate 1MB aligned chunks
> when it does IO. This does not serialise all IO to the file like
> fallocate does, it acheives exactly the same result as using
> fallocate to extend the file, yet the application doesn't need to
> know anything about controlling file layout.
>
> Further, using DIO write()s call to extend the file rather than
> fallocate() or ftruncate() also means that there will always be data
> right up to the end of the file.  That's because XFS will not update
> the file size on extension until the IO has completed, and making
> the file size extension persistent (i.e. journalling it) doesn't
> happen until the data has been made persistent via device cache
> flushes.
>
> IOWs, if the file has been extended by a write IO, then XFS has
> *guaranteed* that the data written to thatextended region has been
> persisted to disk before the size extension is persisted.
>
> > I need to protect the write from various failures such as disk unplug
> > / power failure.  The bottom line is,  once I ack a write-complete,
> > the user must be able to read it back later after a disk/power failure
> > and recovery.
>
> Fallocate() does not provide data integrity guarantees. The
> application needs to use O_DSYNC/RWF_DSYNC IO controls to tell the
> filesystem to provide data integrity guarnatees.
>
> > In my understanding,  fallocate() will preallocate disk space for the
> > file,  and I can call fsync to make sure the file metadata about this
> > new space is persisted when fallocate returns.
>
> Yes, but as it just contains zeros so if it is missing after a
> crash, what does it matter? It just looks like the file wasn't
> extended, and the application has to be able to recover from that
> situation already, yes?
>
> > Once aio_write returns
> > the data is in the disk.  So it seems I don't need fsync after
> > aio-write completion, because (1) the data is in disk,  and (2) the
> > file metadata to address the disk blocks is in disk.
>
> Wrong. Direct IO does not guarantee persistence when the
> write()/aio_write() completes. Even with direct IO, the data can be
> held in volatile caches in the storage stack and the data is not
> guaranteed to be persistent until directed by the application to be
> made persistent.
>
> > On the other hand, it seems XFS always does a delayed allocation
> > which might break my assumption that file=3D>disk space mapping is
> > persisted by fallocate.
>
> Wrong on many levels. The first is the same as above - fallocate()
> does not provide any data persistence guarantees.
>
> Secondly, DIO writes do not use delayed allocation because they
> can't - we have to issue the IO immediately, so there's nothign that
> can be delayed. IOWs, delayed allocation is only done for buffered
> IO. This is true for delayed allocation on both ext4 and btrfs as
> well.
>
> Further, on XFS buffered writes into preallocated space from
> fallocate() do not use delayed allocation either - the space is
> already allocated, so there's nothing to allocate and hence nothing
> to delay!
>
> To drive the point home even further: if you use extent size
> hints with buffered writes, then this also turns off delayed
> allocation and instead uses immediate allocation just like DIO
> writes to preallocate the aligned extent around the range being
> written.
>
> Lastly, if you write an fallocate() based algorithm that works
> "well" on XFS, there's every chance it's going to absolutely suck on
> a different filesystem (e.g. btrfs) because different filesystems
> have very different allocation policies and interact with
> preallocation very differently.
>
> IOWs, there's a major step between knowing what concepts like
> delayed allocation and preallocation do versus understanding the
> complex policies that filesystems weave around these concepts to
> make general purpose workloads perform optimally in most
> situations....
>
> > I can improve the data-in-disk format to carry proper header/footer to
> > detect a broken write when scanning the file after a disk/power
> > failure.
> >
> > Given all those above,  do I still need a fsync() after aio_write
> > completion in XFS to protect data persistence?
>
> Regardless of the filesystem, applications *always* need to use
> fsync/fdatasync/O_SYNC/O_DSYNC/RWF_DSYNC to guarantee data
> persistence. The filesystem doesn't provide any persistence
> guarantees in the absence of these application directives -
> guaranteeing user data integrity is the responsibility of the
> application manipulating the user data, not the filesystem.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
