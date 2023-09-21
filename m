Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71557CD493A
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjIUBj6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIUBj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:39:57 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D13AF
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:39:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-68c576d35feso358369b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260391; x=1695865191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QaDNa1V31M/3LYC9YApIzZS/NJvMQDZkdNGH1jbPzZs=;
        b=VF6rgm6sq/4IEnv30zcTMCH4OK3a5DOCkhBRnZOoEdQjmEqy4Qd0clHH9Q6L3ZFJbp
         5GZk+Sc3+W0y158fpYJ4dRRG1vt+7i7JyilJuYJhZCF7T0nw23Muevh0jtp4s4T4BqYD
         s+SAnLn2N6dxvOMGpF9Jfa7NuFr1uPhAZ++wT/59B1E9k2sj+9Tjpo0cWyML+Yt5iecv
         p+xeMBB66IRGu1P5bMiKdOZ2femPOxUZlNgM112xU+1mLdjZ1DiBFJZ1c56KQbHqag7C
         WFmGvn5Bj9N61PGUI5VbgJbu5LPWgbNITK/g6XX6lsywkS8nt2DXFkB3f3kmgeMER9n+
         Z73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260391; x=1695865191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QaDNa1V31M/3LYC9YApIzZS/NJvMQDZkdNGH1jbPzZs=;
        b=c/AXgiYK3EesA4dm7V/H/SYMpL7lyDrj+sNUvBpu/oyAFeIBB07/c0G1e3CgglCdcJ
         HA22274Pju7l4+3zuvuyK/XgmwvwGMdyDNS4Y8l4X5kLdyCBE/kCwGd9kfr6yuWaT5Tv
         TQUQWgHQo4P/zBmSoz5iMfJAXVOexzqd0Vl8G3pA1sKOXjpm9Zlf702KCpiYdiY5eUzV
         9IlrFhJndXr27SKLLit08IAa6tVZQh5JQq578BsDKhl0RxWvQjid5bwGDwJrxjDuzfBm
         I0WnxN5MUtlWpUIWlb9RXZ9qprxkS44wFubZFr2fqgyWBbiuephLqS3TRdCNDHMH37kV
         hb1A==
X-Gm-Message-State: AOJu0YxgYFEt+Ile5LwtjsKBp/0/fnJdwczLirm1UYUgfCY4x8XjVNWo
        KsNsR9ti/x1y4tP0eWSjHj4LOpgmddKSN1kI0OU=
X-Google-Smtp-Source: AGHT+IEK/xiI0VffyqzfrUGlafApryQkCDcZ1ty+RoXtjDzkADni+OYm9Xbrc1ZMSL/ExQBz0NOb6A==
X-Received: by 2002:a05:6a20:a127:b0:140:6d68:ce07 with SMTP id q39-20020a056a20a12700b001406d68ce07mr4656357pzk.52.1695260391608;
        Wed, 20 Sep 2023 18:39:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id d18-20020aa78692000000b00690fb385ea9sm159517pfo.47.2023.09.20.18.39.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:39:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8fT-003Sux-15
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:39:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8fT-00000002MHF-09eh
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:39:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: reduce AGF hold times during fstrim operations
Date:   Thu, 21 Sep 2023 11:39:42 +1000
Message-Id: <20230921013945.559634-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

THis series reworks the fstrim discard path to use the same
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

This passes fstests with '-o discard' enabled, and has run the '-g
trim' group many, many times without any reported regressions.

-----
Version 2:
- fix various typos and formatting things
- move online discard code to fs/xfs/xfs_discard.c and make it
  generic (new patch)
- use xfs_alloc_rec_incore() as the iteration cursor
- remove hacky "keep gathering until size changes" batching code now
  that cursor can restart at an exact extent
- rework fstrim iteration to use new shared discard code
- added fstrim-vs-suspend holdoff fix (new patch)

RFC:
- https://lore.kernel.org/linux-xfs/20230829065710.938039-1-david@fromorbit.com/

