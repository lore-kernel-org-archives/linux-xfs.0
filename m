Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BBBE8FDC0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 23:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjJCXQD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 19:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjJCXQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 19:16:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCC4A6
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 16:15:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c5bf7871dcso11930475ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 16:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696374957; x=1696979757; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5rokGTjJfgEdROuwYwV4PfiTYbXXrRCNCYQgZjymxJY=;
        b=m2syeaI6ZuggPTVY1YSlQEMxTPOKDsq9LmnK0QRHWMybSv2D0adx7xuf8wY2TaV3LX
         Gyo95vWUjAyDm7o5GFqXNr2zeleS6X6GNJeLhBDNEc0bz4CMHlUqrsExcrwf4RJis+Mm
         4ZQE4qde++Qyz39g/+MA/l5jvq8O5anwT0zs3vOpQ6o17BWTyLyXg4UyNnwVwPNduYUm
         f2huEE4uqowc6D9XNPYkk5P1/6ENLK241tUNLCAG2eKpKnItRoIi2c8pxsj3spRN+US7
         v+H0RX1DIGf1LIbb+MSKrwCSj4WC0y6aFGvQiSUdyxvpKDrBrxRIo7XmcyuGuTiFW9Z2
         4ztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696374957; x=1696979757;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rokGTjJfgEdROuwYwV4PfiTYbXXrRCNCYQgZjymxJY=;
        b=OemJbJMqAkNaWIsY2f/5Gcw1Z4ic/aNRapQWTsZpo4AbP8I8ZPlW8mLDZRbzVGKAU+
         iNtJFqjX7CUiQ1KIZ4XktZiyZpcvLH/EJX34QY3iR2dpHfIft15XEKkWSEQmWom0xLeR
         CnfxHs79mnepE4Bw6+dSpZa3Iop75ONTRkeMPV470c+W6xuDIpAizrITXrLauZtT+h2f
         ZMzfCVOybxJ3fkuMC6WhQ8fKg/1Gwewj9N/kLbwz5z21lNCDGiCutxKWpF1t3ijLFQTG
         Aei+XupxUSnhkASjsJtoTGZZu+/QjM5BBvkW/h538zZohWvdAYoBXSrfZAHf2XKDY2zV
         a4Qw==
X-Gm-Message-State: AOJu0YyqEaFM4Jdj2mOo8YL3kTHvG5HbBkiU3CBRVoq4c3E27/44siN4
        Xwi3jcUxAYtIV9b68VdGZc3ExWO+WoW781HbRns=
X-Google-Smtp-Source: AGHT+IHYLfNxyX4NczKutNgvbFWzl6+1cNeIPittYrBA/TMiB8lPUAluIDMlSd1xvM+HSE2HEbSEfg==
X-Received: by 2002:a17:903:22cd:b0:1bf:3c10:1d70 with SMTP id y13-20020a17090322cd00b001bf3c101d70mr1195685plg.6.1696374957064;
        Tue, 03 Oct 2023 16:15:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b001c44dbc92a2sm2165623plb.184.2023.10.03.16.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 16:15:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qnocM-0096Cd-0c;
        Wed, 04 Oct 2023 10:15:54 +1100
Date:   Wed, 4 Oct 2023 10:15:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: use busy extents for fstrim
Message-ID: <ZRygqkCkbH32I+x9@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Can you please pull the changes to fstrim behaviour from the signed
tag below? This has been rebased on 6.6-rc4 so should merge cleanly
into a current tree.

Thanks,

Dave.

----------------------------------------------------------------
The following changes since commit 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa:

  Linux 6.6-rc4 (2023-10-01 14:15:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-fstrim-busy-tag

for you to fetch changes up to e78a40b851712b422d7d4ae345f25511d47a9a38:

  xfs: abort fstrim if kernel is suspending (2023-10-04 09:25:04 +1100)

----------------------------------------------------------------
xfs: reduce AGF hold times during fstrim operations

A recent log space overflow and recovery failure was root caused to
a long running truncate blocking on the AGF and ending up pinning
the tail of the log. The filesystem then hung, the machine was
rebooted, and log recoery then refused to run because there wasn't
enough space in the log for EFI transaction reservation.

The reason the long running truncate got blocked on the AGF for so
long was that an fstrim was being run. THe underlying block device
was large and very slow (10TB ceph rbd volume) and so discarding all
the free space in the AG took a really long time.

The current fstrim implementation holds the AGF across the entire
operations - both the freee space scan and the issuing of all the
discards. The discards are synchronous and single depth, so if there
are millions of free spaces, we hold the AGF lock across millions of
discard operations.

It doesn't really need to be said that this is a Bad Thing.

This series reworks the fstrim discard path to use the same
mechanisms as online discard. This allows discards to be issued
asynchronously without holding the AGF locked, enabling higher
discard queue depths (much faster on fast devices) and only
requiring the AGF lock to be held whilst we are scanning free space.

To do this, we make use of busy extents - we lock the AGF, mark all
the extents we want to discard as "busy under discard" so that
nothing will be allowed to allocate them, and then drop the AGF
lock. We then issue discards on the gathered busy extents and on
discard completion remove them from the busy list.

This results in AGF lock holds times for fstrim dropping to a few
milliseconds each batch of free extents we scan, and so the hours
long hold times that can currently occur on large, slow, badly
fragmented device no longer occur.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

----------------------------------------------------------------
Dave Chinner (3):
      xfs: move log discard work to xfs_discard.c
      xfs: reduce AGF hold times during fstrim operations
      xfs: abort fstrim if kernel is suspending

 fs/xfs/xfs_discard.c     | 266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_discard.h     |   6 +-
 fs/xfs/xfs_extent_busy.c |  34 ++++++++--
 fs/xfs/xfs_extent_busy.h |  24 ++++++-
 fs/xfs/xfs_log_cil.c     |  93 ++++-----------------------
 fs/xfs/xfs_log_priv.h    |   5 +-
 6 files changed, 311 insertions(+), 117 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
