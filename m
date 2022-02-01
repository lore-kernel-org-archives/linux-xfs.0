Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2EEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 23:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiBAXHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 18:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiBAXHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 18:07:31 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3888BC061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 15:07:31 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id c6so55632105ybk.3
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 15:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:from:date:message-id:subject:to;
        bh=HRPw0i521uhygDdsJX3nhe5xroYkicRWvS3qVHV8s8k=;
        b=HSbgUG3S4RMElrsrX1H8eB/JGZ/SZanzlESwX9jiEEQKSX/lob8fOR+dBnY8Hkt1dR
         tkJzn1Xkz1U3Db2PKzn0Hte7e4s5vYz/tvi32rmLwM6tp9q+Uh3N0R9pzSfhRxTHdlCT
         Mvv5yFzhwzw5LTlaGxvhZwKbz9v7fO7yBJjxeDIBfiZrCHcKZ3C4pN5d/pyKbMTUysjx
         jZ50fWv+pix52423SjBqGTWTx8xvb8e4PUUTJgYTpcYia8Te47PcUC9ZKTHGkUqZMqp9
         b2myYCSF5Y5Y1/B0Ol8rI2fqiPlwjWxoep9UnPADyEa2y2fy4wOOieOOuQIc23AXnR8Z
         Qxew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HRPw0i521uhygDdsJX3nhe5xroYkicRWvS3qVHV8s8k=;
        b=D8TFxeqReDkux8s6U+SuY/HkKuvIToPVHJKrOjnLGO9Sxe84GjiaO5LhGncVNDqZVq
         DmmL7JlqK3D1CsRkSREMUdSiQW6WwtkrEayj5I2T4zdUIKKgS/HRZ1ZuzSM7KbIWek0i
         DSsabbi6onhnhFd8tpeGEPBmNcbPRtpljWvnWuMr6hs4QTAaiWwKlIjGAkjukiLAUelj
         mNAnMEfFY0ALIevwDeKF83FqgpM2fcNQcyU5BVRY8+jcMWBiKbV/YiLT0ARk6T5ejWiC
         f7kfAhyl/YXO4GPGsjmDUhCYRtL4p4YcV7B0eanrTLcIQFzps2l2EpBh2Mazr4meu1Mu
         /4ow==
X-Gm-Message-State: AOAM530fB7dpzXmcLd1d57y7chydkkou7igES5m8vPdBW9bEWHTXoe7T
        dtHGh+16Yl8jcDgcqlQa5gyWkHogJmoUyLF8WKrh0nT+AVI=
X-Google-Smtp-Source: ABdhPJy/A8fdVklYcHjljkgTlW4F5Fw3W5TBiUQ07axdMGvPlrhksXku7+7rpW93nS9jFuo4FJIO4V+m8d012L2HHnk=
X-Received: by 2002:a25:4285:: with SMTP id p127mr36720686yba.558.1643756850194;
 Tue, 01 Feb 2022 15:07:30 -0800 (PST)
MIME-Version: 1.0
From:   Sean Caron <scaron@umich.edu>
Date:   Tue, 1 Feb 2022 18:07:18 -0500
Message-ID: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
Subject: XFS disaster recovery
To:     linux-xfs@vger.kernel.org, Sean Caron <scaron@umich.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Me again with another not-backed-up XFS filesystem that's in a little
trouble. Last time I stopped by to discuss my woes, I was told that I
could check in here and get some help reading the tea leaves before I
do anything drastic so I'm doing that :)

Brief backstory: This is a RAID 60 composed of three 18-drive RAID 6
strings of 8 TB disk drives, around 460 TB total capacity. Last week
we had a disk fail out of the array. We replaced the disk and the
recovery hung at around 70%.

We power cycled the machine and enclosure and got the recovery to run
to completion. Just as it finished up, the same string dropped another
drive.

We replaced that drive and started recovery again. It got a fair bit
into the recovery, then hung just as did the first drive recovery, at
around +/- 70%. We power cycled everything again, then started the
recovery. As the recovery was running again, a third disk started to
throw read errors.

At this point, I decided to just stop trying to recover this array so
it's up with two disks down but otherwise assembled. I figured I would
just try to mount ro,norecovery and try to salvage as much as possible
at this point before going any further.

Trying to mount ro,norecovery, I am getting an error:

metadata I/O error in "xfs_trans_read_buf_map at daddr ... len 8 error 74
Metadata CRC error detected at xfs_agf_read_verify+0xd0/0xf0 [xfs],
xfs_agf block ...

I ran an xfs_repair -L -n just to see what it would spit out. It
completes within 15-20 minutes (which I feel might be a good sign,
from my experience, outcomes are inversely proportional to run time),
but the output is implying that it would unlink over 100,000 files
(I'm not sure how many total files are on the filesystem, in terms of
what proportion of loss this would equate to) and it also says:

"Inode allocation btrees are too corrupted, skipping phases 6 and 7"

which sounds a little ominous.

It would be a huge help if someone could help me get a little insight
into this and determine the best way forward at this point to try and
salvage as much as possible.

Happy to provide any data, dmesg output, etc as needed. Please just
let me know what would be helpful for diagnosis.

Thanks so much,

Sean
