Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03F7C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 01:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344312AbiBHBDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 20:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245357AbiBGW4f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 17:56:35 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3EDC061355
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 14:56:33 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id g14so44511213ybs.8
        for <linux-xfs@vger.kernel.org>; Mon, 07 Feb 2022 14:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aCdLH/0ampmBxuvuQuxR3ZwJ8b1+tHiZKyhFyAORHiY=;
        b=c7ayLlrZTWa8OuK06lCmfQp/X9c0Q8UULK01LMlJrvrzn1IG/S/CsrMR05v/j326s+
         kAvOSgUf0Ts7psQo/8WqC746YF62A4fkf4H3AvPQ4ldLKSB8Ob2OHlwp47v12QUQRKfk
         AdrO3zAUCVp7NjJxqMvq0xr37yE7SWElpCsYGkBQlHwOxyUDwmsPRpJ2X6uEF7bowd5k
         0BkMm3IcEmEgn6/sd2REgNlAwGYjn1xeqascuPP84ODopMgk5312vvH8bECswthNmuDl
         4vjRMevV8hjFYw48ZKTFxrhR4qWCI3H4mxHyYk+1JQKkt6lJyKZXNUAb2ZJihGVQo8FL
         Cozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aCdLH/0ampmBxuvuQuxR3ZwJ8b1+tHiZKyhFyAORHiY=;
        b=WlD09HoxJnOlxTSnTwnU6bcuKXE0/TckjS7uVEYExMy8t0fVYlBeiaUer8Xw+mw4hD
         /MMYB48pj485VbVd4DISp0BYSBLyJZeUk4HVCTtOGtgUk21AVthBCw9Fb435+sxbz6i1
         IRpSg2MDyhIiB4kKT2HFk+xNapxd61ldsFeb232wuDSsyfME+K+dojt0ZpqBGsTVBdb2
         DbYwy7JTxb5/FgKK2SyKHrf0QIhFkscFpLKPJMAD0C8y9gHXbZ0V+YNlVFFz8s4n1QdB
         kdQE8Ehv3maHUCd8q1oyNyCgdhGt8e/lUCl6CGhdr5uIn+TVMvX/ZaFsp0OHiQSvNLIk
         pWAA==
X-Gm-Message-State: AOAM530lYA8pgjskiECrui/1y531Y3yetUBfyY2G32VRwrVxyuWeHmd5
        3DmiHvPaKC1vUIykWJ8MqNBPjjRe96qU+2sG6vwLuA==
X-Google-Smtp-Source: ABdhPJxoELVsdNVqydliruSfYIm+5UD5sC5doFP+6g8L2d4UGhl2/wTMQ/rgaHjKu+mXg3UbnT1eGS5xAsUobAWu26w=
X-Received: by 2002:a81:611:: with SMTP id 17mr2198553ywg.511.1644274593161;
 Mon, 07 Feb 2022 14:56:33 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area> <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
 <20220207223352.GG59729@dread.disaster.area>
In-Reply-To: <20220207223352.GG59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Mon, 7 Feb 2022 17:56:21 -0500
Message-ID: <CAA43vkWz4ftLGuSvkUn3GFuc=Ca6vLqJ28Nc_CGuTyyNVtXszA@mail.gmail.com>
Subject: Re: XFS disaster recovery
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Got it. I ran an xfs_repair on the simulated metadata filesystem and
it seems like it almost finished but errored out with the message:

fatal error -- name create failed in lost+found (28), filesystem may
be out of space

However there is plenty of space on the underlying volume where the
metadata dump and sparse image are kept. Even if the sparse image was
actually 384 TB as it shows up in "ls", there's 425 TB free on the
volume where it's kept.

I wonder since this was a fairly large filesystem (~500 TB) it's
hitting some kind of limit somewhere with the loopback device?

Any thoughts on how I might be able to move past this? I guess I will
need to xfs_repair this filesystem one way or the other anyway to get
anything off of it, but it would be nice to run the simulation first
just to see what to expect.

Thanks,

Sean

On Mon, Feb 7, 2022 at 5:34 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Feb 07, 2022 at 05:03:03PM -0500, Sean Caron wrote:
> > Hi Dave,
> >
> > OK! With your patch and help on that other thread pertaining to
> > xfs_metadump I was able to get a full metadata dump of this
> > filesystem.
> >
> > I used xfs_mdrestore to set up a sparse image for this volume using my
> > dumped metadata:
> >
> > xfs_mdrestore /exports/home/work/md4.metadump /exports/home/work/md4.img
> >
> > Then set up a loopback device for it and tried to mount.
> >
> > losetup --show --find /exports/home/work/md4.img
> > mount /dev/loop0 /mnt
> >
> > When I do this, I get a "Structure needs cleaning" error and the
> > following in dmesg:
> >
> > [523615.874581] XFS (loop0): Corruption warning: Metadata has LSN
> > (7095:2330880) ahead of current LSN (7095:2328512). Please unmount and
> > run xfs_repair (>= v4.3) to resolve.
> > [523615.874637] XFS (loop0): Metadata corruption detected at
> > xfs_agi_verify+0xef/0x180 [xfs], xfs_agi block 0x10
> > [523615.874666] XFS (loop0): Unmount and run xfs_repair
> > [523615.874679] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > [523615.874695] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 0f ff ff
> > f8  XAGI............
> > [523615.874713] 00000010: 00 03 ba 40 00 04 ef 7e 00 00 00 02 00 00 00
> > 34  ...@...~.......4
> > [523615.874732] 00000020: 00 30 09 40 ff ff ff ff ff ff ff ff ff ff ff
> > ff  .0.@............
> > [523615.874750] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff  ................
> > [523615.874768] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff  ................
> > [523615.874787] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff  ................
> > [523615.874806] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff  ................
> > [523615.874824] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > ff  ................
> > [523615.874914] XFS (loop0): metadata I/O error in
> > "xfs_trans_read_buf_map" at daddr 0x10 len 8 error 117
> > [523615.874998] XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi()
> > returned error -117, agno 0
> > [523615.876866] XFS (loop0): Failed to read root inode 0x80, error 117
>
> Hmmm - I think this is after log recovery. The nature of the error
> (metadata LSN a few blocks larger than the current recovered LSN)
> implies that part of the log was lost during device failure/recovery
> and hence not recovered when mounting the filesystem.
>
> > Seems like the next step is to just run xfs_repair (with or without
> > log zeroing?) on this image and see what shakes out?
>
> Yup.
>
> You may be able to run it on the image file without log zeroing
> after the failed mount if there were no pending intents that needed
> replay.  But it doesn't matter if you do zero the log at this point,
> as it's already replayed everything it can replay back into the
> filesystem and it will be as consistent as it's going to get.
>
> Regardless, you are still likely to get a bunch of "unlinked but not
> freed" inode warnings and inconsistent free space because the mount
> failed between the initial recovery phase and the final recovery
> phase that runs intent replay and processes unlinked inodes.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
