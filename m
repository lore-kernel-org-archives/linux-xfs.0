Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52321C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 15:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346648AbiBHPq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbiBHPq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 10:46:58 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E484BC061576
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 07:46:56 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c6so51088265ybk.3
        for <linux-xfs@vger.kernel.org>; Tue, 08 Feb 2022 07:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nql1wr3hBV1xjRylUf9XXjJ55gfM50M141EwYDxN6AQ=;
        b=WTZWii6fea1B3gRxXPy82xEMSdu5y5+EuuGfnAcrPtuqq5PX4TiFR6Scjx0arwqPkP
         lF3/CxLvX2J30heA4Z0v+zSokZYC+9cakgX1jQ74wdgBL2g4itE4biLLlwzuFaYdOLCp
         C8Ahyaznbb0CGlwnIwFHAr0oUrtmG1DVDqdiEdarfXwnFssxqX7fmWdsoCPiAjHEPO49
         PvN3KlRAPVHctCCsplxIQL43ylHCJNXggfPObcjBVZwWerEZ/O4DltVvZnURq7EUzf6J
         xaNpn3tl0SIPjFzYIuLOopupuXzZ4nZ7vbp4PZd4RWbCX4llVpPGgGkWZSWADZa8mqv6
         +w6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nql1wr3hBV1xjRylUf9XXjJ55gfM50M141EwYDxN6AQ=;
        b=Qn03Cjx/zrkNp9DBDtO5+b3ELyL0G0O20oU4uB1sDURhlvKbkB1JSMBkpx7kXPjDK6
         Ugky+Bf3j5nxMNOTp4BJafXmEgwADI4DJMmL4xOjKLUUctN9/PhUWCH6w6ucD0TCZEWf
         I+U1Hf7ua7y6Oc/ClPUm2oDABXx/Lzmv2v2neCQUtcsDNku+a7fzJpJGb0YvenqTr53R
         msxrIybSNcN1t4tGlvrV5mfH9cDHohs7pTpgj+zuns2J/jT2FSCogV9QPiB+/DyLG3m4
         AlgtCwH8+TKjl0nU89eG2m1tDrVAXfyCqE3xPvekIGj1fmShQYFClK/WrkgR268G064G
         56QA==
X-Gm-Message-State: AOAM533l2wdMepWdOi1xlGrcKhzvotCy1Iovmtj9kPMJnG89qLy52dvf
        kfoUjgA7ucekQksYfa1M4wtoH62PL2TB6jJBqGRmlQ==
X-Google-Smtp-Source: ABdhPJxo821ouaAG4upM2yY1qcjyYlYBMQbRgv9J0s2OBfcptiFG3byNCvq5RlbYMWiIT8/tmh7GdZm6CYEritIDn3Y=
X-Received: by 2002:a81:3795:: with SMTP id e143mr5377989ywa.514.1644335216068;
 Tue, 08 Feb 2022 07:46:56 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area> <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
 <20220207223352.GG59729@dread.disaster.area> <CAA43vkWz4ftLGuSvkUn3GFuc=Ca6vLqJ28Nc_CGuTyyNVtXszA@mail.gmail.com>
 <20220208015115.GI59729@dread.disaster.area>
In-Reply-To: <20220208015115.GI59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Tue, 8 Feb 2022 10:46:45 -0500
Message-ID: <CAA43vkXTkCJtM-kQO=GAX=TnAFkD_atygSw4scCwQ8Y-sJZsoQ@mail.gmail.com>
Subject: Re: XFS disaster recovery
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

I'm sorry for some imprecise language. The array is around 450 TB raw
and I will refer to it as roughly half a petabyte but factoring out
RAID parity disks and spare disks it should indeed be around 384 TB
formatted.

I checked over the metadump with xfs_db as you suggest and it looks
like it dumped all AGs that the filesystem had.

# ./xfs_db -r /exports/home/work/md4.img
Metadata CRC error detected at 0x555a5c9dc8fe, xfs_agf block 0x4d7fffd948/0x1000
xfs_db: cannot init perag data (74). Continuing anyway.
xfs_db> sb 0
xfs_db> p agcount
agcount = 350
xfs_db> agf 349
xfs_db> p
magicnum = 0x58414746
versionnum = 1
seqno = 349
length = 82676200
bnoroot = 11
cntroot = 9
rmaproot =
refcntroot =
bnolevel = 2
cntlevel = 2
rmaplevel = 0
refcntlevel = 0
rmapblocks = 0
refcntblocks = 0
flfirst = 576
fllast = 581
flcount = 6
freeblks = 12229503
longest = 55037
btreeblks = 545
uuid = 4f39a900-91fa-4c5d-ba34-b56e77720db3
lsn = 0x1bb700239100
crc = 0xd329ccfc (correct)
xfs_db>

And looking at the image the size is roughly what it should be with
the actual size of the filesystem and the size of the sparse file
image looks sane.

# ls -l /exports/home/work/
total 157159048
-rw-r--r-- 1 root root 384068188372992 Feb  7 22:02 md4.img
-rw-r--r-- 1 root root     53912722432 Feb  7 21:59 md4.metadump
-rw-r--r-- 1 root root     53912722432 Feb  7 16:50 md4.metadump.save
# du -sh /exports/home/work/md4.img
50G     /exports/home/work/md4.img
#

I also apologize, in my last email I accidentally ran the copy of
xfs_repair that was installed from the Ubuntu package manager (old -
4.9.0) instead of the copy that I built from the dev tree.

I took advantage of this test environment to just run a bunch of
experiments and see what happened.

I found that if I ran the dev tree xfs_repair with the -P option, I
could get xfs_repair to complete a run. It exits with return code 130
but the resulting loopback image filesystem is mountable and I see
around 27 TB in lost+found which would represent around 9% loss in
terms of what was actually on the filesystem.

Given where we started I think this is acceptable (more than
acceptable, IMO, I was getting to the point of expecting to have to
write off the majority of the filesystem) and it seems like a way
forward to get the majority of the data off this old filesystem.

Is there anything further I should check or any caveats that I should
bear in mind applying this xfs_repair to the real filesystem? Or does
it seem reasonable to go ahead, repair this and start copying off?

Thanks so much for all your help so far,

Sean

On Mon, Feb 7, 2022 at 8:51 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Feb 07, 2022 at 05:56:21PM -0500, Sean Caron wrote:
> > Got it. I ran an xfs_repair on the simulated metadata filesystem and
> > it seems like it almost finished but errored out with the message:
> >
> > fatal error -- name create failed in lost+found (28), filesystem may
> > be out of space
>
> Not a lot to go on there - can you send me the entire reapir output?
>
> > However there is plenty of space on the underlying volume where the
> > metadata dump and sparse image are kept. Even if the sparse image was
> > actually 384 TB as it shows up in "ls", there's 425 TB free on the
> > volume where it's kept.
>
> Hmmm - the sparse image should be the same size as the filesystem
> itself. If it's only 384TB and not 500TB, then either the metadump
> or the restore may not have completed fully.
>
> > I wonder since this was a fairly large filesystem (~500 TB) it's
> > hitting some kind of limit somewhere with the loopback device?
>
> Shouldn't - I've used larger loopback files hostsed on XFS
> filesystems in the past.
>
> > Any thoughts on how I might be able to move past this? I guess I will
> > need to xfs_repair this filesystem one way or the other anyway to get
> > anything off of it, but it would be nice to run the simulation first
> > just to see what to expect.
>
> I think that first we need to make sure that the metadump and
> restore process was completed successfully (did you check the exit
> value was zero?). xfs_db can be used to do that:
>
> # xfs_db -r <image-file>
> xfs_db> sb 0
> xfs_db> p agcount
> <val>
> xfs_db> agf <val - 1>
> xfs_db> p
> .....
> (should dump the last AGF in the filesystem)
>
> If that works, then the metadump/restore should have been complete,
> and the size of the image file should match the size of the
> filesystem that was dumped...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
