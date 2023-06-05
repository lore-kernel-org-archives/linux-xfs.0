Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E42FC7EE23
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 00:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjFEAtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 20:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFEAtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 20:49:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56978AB
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 17:49:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6513e7e5d44so2369482b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 04 Jun 2023 17:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685926179; x=1688518179;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lTbyaE+a1ou4Ce2D09mEdWFdtKJzO22LtWJ0Il2/wq0=;
        b=ivXw3tKkp/NxYAPaF6hjqHHe6oHzpoNsKcmSEUXvDXFfTZvemVYg9dqZsuFO5/gG7A
         Hz4VpIKLS6eqPK+++3gNJqFY7AyVFZ4gkbeje80Oft7+xE+E2ONRtxiRrywPCYaiv8iL
         vXvfWcFhpEdvSszzid6H1aBuClKwrP4F4m+kfDxN6foB3ThIJLX9ubWjtc906MifrRaY
         QeT2Tp8xVu5HlAH44sb2fU1pVO21grcBmEjtR82rmTDA50r7UftE1tH7PUjZmd+Y8PAC
         RaJ00XpZPGvcXHYMi1jXfnDcmTI65/vzc+LmMwEuLTri/lPsXkyQr9fiZeIdlvph5lql
         tdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685926179; x=1688518179;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTbyaE+a1ou4Ce2D09mEdWFdtKJzO22LtWJ0Il2/wq0=;
        b=AXTbYugsCfGHJAEyOwuhw77gC4Z0vxAN4Lx/waQH8QdUn2GbPilZJGJvYsx0eH9qAK
         TnBxtSbsxdufR/kgaaUj3x6lWZ1F9I4fOAFHzPs3q9C3FweW8Aurhh0ODS8YZ5nBoYzn
         6f0x9JYT+blCrC3Gx4k4hCqNluoqhmADJOIjycuvECq8SnCio9RF4b+hU/bfXT7EAL8j
         AvyKtO3shkxEi46SJn5xIb4PfXwZwY66/9bnD3HunP6Ki6LfGTD/qagMMhUrWjI/o1lK
         PiV7t6CUmADiP04yq6KRIb4Gzg87m5Eq0RfBJmk2YCkyXPFQS1wdOGZdwr1xS/JYMD71
         YOFg==
X-Gm-Message-State: AC+VfDyRu8xcxScI4tqYrTalO5vzyCH+L0NjwRudLPvCLo7dr5+6CVro
        8TSKud+6l6w9iNoLjn65XuywR6KIztNpb74KL3g=
X-Google-Smtp-Source: ACHHUZ5bsP5r0vFqG8HelqlITmLL/aDT191hNwFtzTBM/dX6gPEPn7ImmG24W6lQj8uP/gKojoi7Wg==
X-Received: by 2002:aa7:88c3:0:b0:64c:aa98:a69f with SMTP id k3-20020aa788c3000000b0064caa98a69fmr15789317pff.1.1685926179245;
        Sun, 04 Jun 2023 17:49:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id f18-20020aa78b12000000b0064d32771fa8sm4083435pfd.134.2023.06.04.17.49.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 17:49:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q5yPf-007tgV-0Y
        for linux-xfs@vger.kernel.org;
        Mon, 05 Jun 2023 10:49:35 +1000
Date:   Mon, 5 Jun 2023 10:49:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next updated to 5c004b2fa9894
Message-ID: <ZH0xH8PC1xm+s9pA@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the for-next tree with a bunch of bug fixes that
I'm hoping to get to Linus later in the week. I was hoping that I'd
have got this done early last week, but that did not happen because
of more bugs/regressions being reported. Updating you test trees to
this branch would be appreciated.

Note that I also updated the master branch to v6.4-rc5 at the same
time.

-Dave.

----------------------------------------------------------------

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

  Head Commit: 5c004b2fa98945f0d2418bbfedd5d2b000807717

  xfs: collect errors from inodegc for unlinked inode recovery (2023-06-05 04:15:27 +1000)

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix broken logic when detecting mergeable bmap records

Dave Chinner (9):
      xfs: buffer pins need to hold a buffer reference
      xfs: restore allocation trylock iteration
      xfs: defered work could create precommits
      xfs: fix AGF vs inode cluster buffer deadlock
      xfs: fix double xfs_perag_rele() in xfs_filestream_pick_ag()
      xfs: fix agf/agfl verification on v4 filesystems
      xfs: validity check agbnos on the AGFL
      xfs: validate block number being freed before adding to xefi
      xfs: collect errors from inodegc for unlinked inode recovery

Geert Uytterhoeven (1):
      xfs: Fix undefined behavior of shift into sign bit

 fs/xfs/libxfs/xfs_ag.c          |   5 +++-
 fs/xfs/libxfs/xfs_alloc.c       |  91 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_alloc.h       |   6 ++---
 fs/xfs/libxfs/xfs_bmap.c        |  10 ++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c  |   7 ++++--
 fs/xfs/libxfs/xfs_ialloc.c      |  24 ++++++++++++-------
 fs/xfs/libxfs/xfs_log_format.h  |   9 ++++++-
 fs/xfs/libxfs/xfs_refcount.c    |  13 ++++++++---
 fs/xfs/libxfs/xfs_trans_inode.c | 113 +++++++---------------------------------------------------------------------------------
 fs/xfs/scrub/bmap.c             |  25 ++++++++++----------
 fs/xfs/scrub/scrub.h            |   8 +++----
 fs/xfs/xfs_buf_item.c           |  88 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_filestream.c         |   1 -
 fs/xfs/xfs_icache.c             |  46 +++++++++++++++++++++++++++++-------
 fs/xfs/xfs_icache.h             |   4 ++--
 fs/xfs/xfs_inode.c              |  20 +++++-----------
 fs/xfs/xfs_inode.h              |   2 +-
 fs/xfs/xfs_inode_item.c         | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.h         |   1 +
 fs/xfs/xfs_log_recover.c        |  19 +++++++--------
 fs/xfs/xfs_mount.h              |   1 +
 fs/xfs/xfs_reflink.c            |   4 +++-
 fs/xfs/xfs_super.c              |   1 +
 fs/xfs/xfs_trans.c              |   9 ++++++-
 24 files changed, 427 insertions(+), 229 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
