Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8844AC71153
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Sep 2023 23:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349208AbjICX3f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjICX3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2023 19:29:35 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7BBF7
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 16:29:30 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-565334377d0so696289a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 03 Sep 2023 16:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693783770; x=1694388570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jKcB5ipH1kvsnpXPxiTrQVc5ipSfxPKz8V4+rnT7o9M=;
        b=rI6sAcwjRaF82kK/CY0KXfPCfAHKD5zQCH9/7CSD0WIcRxRGFVsF998zT0Pp46C6EP
         k1te6mH4g4+YZ/obwiOHVrzI2+CMVyOisXPxhOq806TxPZCTOZ67ztYKcVe74AjaZhya
         r7A0hZ1Ko+i7SP4VNv9qK2Tl9sUTlYG0bkj175fo6otNkfEYO0dsmWLJdR1aqzr9u7NC
         0E+ogjTlqcTgjzBsS/Rt8l8UWZKk1kjVDDZRRqNzA2j29AkOEn4LoIsKlQY4uMw4geLP
         D2QLPq/b5uocxHd3PholO3XfPCtvZJDT0rxiDsk8987dD7LR5/LF9hUdvYJbKcdChnJa
         zjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693783770; x=1694388570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKcB5ipH1kvsnpXPxiTrQVc5ipSfxPKz8V4+rnT7o9M=;
        b=g6v/cf2QwTkQeAjLE1FCm5b64eHS7DpIuPxwdQpIOkecsrhQ4Yts8vPfKaL41hK+Tn
         VcMYuxxZn6dwzLkuHbkgWa9ugismP/3lkQi/qyUQpzw0y6if9jUCVlVFuXPSfdMfVH/n
         peClDHVwyZinN1sqjfNaKursce/Lh6spM2kAS1bkb/SaUluV+hIPU/FBUsHL3gX6qo4Q
         FcjkG/w9QP3q+dMoRb26ppduLJLXjMgC/UAb46VpZBpAHl+Lw6jOU4fEkJlc1zQRa+8e
         4kf/rppr5KUuaKFiaJBTGU+bQKjwyYZvGd90Hv6Pz4Zp6HyV6f9kJvEhxsqHMnjIs7b5
         gRXA==
X-Gm-Message-State: AOJu0YwM2Gu+w77YjMozX1hneteo2Z8bGXP6Fk1ThACwPepLhvMQgBRB
        lr0E7dMpGXWXRLvR8qEmQKOOLEwAHMVyzX/cJ0E=
X-Google-Smtp-Source: AGHT+IHvjZ2mp3CZcMhlco7iSU8YoiLb7zG9rKn1+321uAgFFKjCCOanuAW6bAXDD14qGld1PdmBYw==
X-Received: by 2002:a05:6a20:7f8e:b0:12f:dc31:a71e with SMTP id d14-20020a056a207f8e00b0012fdc31a71emr11842687pzj.56.1693783769888;
        Sun, 03 Sep 2023 16:29:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id g16-20020aa78750000000b0068620bee456sm6148879pfo.209.2023.09.03.16.29.28
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 16:29:29 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qcwWz-00ATP6-1w
        for linux-xfs@vger.kernel.org;
        Mon, 04 Sep 2023 09:29:25 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qcwWz-000tmx-0p
        for linux-xfs@vger.kernel.org;
        Mon, 04 Sep 2023 09:29:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: reduce AGF hold times during fstrim operations
Date:   Mon,  4 Sep 2023 09:29:21 +1000
Message-Id: <20230903232923.211003-1-david@fromorbit.com>
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
trim' group several dozen times without any reported regressions.

-----
Version 2:
- fix various typos and formatting things
- move online discard code to fs/xfs/xfs_discard.c and make it
  generic (new patch)
- use xfs_alloc_rec_incore() as the iteration cursor
- remove hacky "keep gathering until size changes" batching code now
  that cursor can restart at an exact extent
- rework fstrim iteration to use new shared discard code

RFC:
- https://lore.kernel.org/linux-xfs/20230829065710.938039-1-david@fromorbit.com/

