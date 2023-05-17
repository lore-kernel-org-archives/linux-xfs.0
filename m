Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F94C77B7F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 00:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjEQAFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 20:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjEQAFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 20:05:00 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2225275
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:04:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64ab2a37812so9291677b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684281896; x=1686873896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qwsYPsGiHknKHowBgKk1f0GMlLr2dzYbDdrFuDPCLP4=;
        b=gpZuYJdBssPp26S7OA2023iuEMZbKpe8/14mDSh4D7WMoB7P+v46VWPV3eK91j93dj
         p+Fm4qFx7o8GkwJXN/GtwHXoQVBs6U/xqBOUkwzjTKVERNiZ7UWojyfoOk0WI/fvDLb2
         vKHaea9rTIvJFHACeL1wdFY1fPivXpehMBKTt4Fc+XKIeiIiBEPNdChLpetmKfPlHVhc
         LHyewBlSj3ZJY3xNJN8vUX8oFoaHRUubkiR8/2X7IzvRM3urhE+tT/FPc8z8Vz21vMqn
         QUV+aXg5rxfHV7DZgShA/GEsBHiMwGIXv1OUqlZJTibOwwrDlE+RyUHi5+TTH9L2rxit
         aj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684281896; x=1686873896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qwsYPsGiHknKHowBgKk1f0GMlLr2dzYbDdrFuDPCLP4=;
        b=TIfLhW3PaYkbzIUiRdFNcJh+boi5qYE5xDPhq27LkeHmg+K1cRZSmmR1BOEtCfLb9l
         f5wLvrZeqH7/WEHzCZCOmZqWhcjexcHggDKIEYxL8q3ZFlpqJZmOmKX7BYmtTuAGHAga
         8cXgyI/rpAdZjDBLo0RBpGtAoLjZaobiL3zBs3OEOR/9WPje6G6VYez2PfbPV24OB+mi
         s8zE+mTLXR/FJUpJZ0KG71z7nMrtfpyNwY9pXSGMt01I2hAnv29GLH+ze0EPhwt0kxv+
         etUZOtkufPc2ydd7pTocpnsnrcEOJ41YRwzGrLFu0riDHU6Ny7PAgH1lVLFz+ATJWfvH
         YOkg==
X-Gm-Message-State: AC+VfDzuMsE5z7F35P1vgCVZgLQ/gXGgcJdmZX5XMXB5eohvnkCEYRXY
        bXu7xcEeDHTCa45ATC7Hp+mbjGkAh56rtcmvjbs=
X-Google-Smtp-Source: ACHHUZ6aU5apDmEu/Gd/wY/rsqFL7S861Ysg91pVUQuxCJ4k1j82c7jYGT/Mqv8UhkBFniwH7B70FA==
X-Received: by 2002:a17:902:ab93:b0:1a9:581b:fbb1 with SMTP id f19-20020a170902ab9300b001a9581bfbb1mr372555plr.32.1684281896258;
        Tue, 16 May 2023 17:04:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902820100b0019e60c645b1sm16126619pln.305.2023.05.16.17.04.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 17:04:55 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1pz4ey-000Lbm-2t
        for linux-xfs@vger.kernel.org;
        Wed, 17 May 2023 10:04:52 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pz4ey-00Gu82-1D
        for linux-xfs@vger.kernel.org;
        Wed, 17 May 2023 10:04:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: xfs: bug fixes for 6.4-rcX
Date:   Wed, 17 May 2023 10:04:45 +1000
Message-Id: <20230517000449.3997582-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The following patches are fixes for recently discovered problems.
I'd like to consider them all for a 6.4-rc merge, though really only
patch 2 is a necessary recent regression fix.

The first patch addresses a long standing buffer UAF during shutdown
situations, where shutdown log item completions can race with CIL
abort and iclog log item completions.

The second patch addresses a small performance regression from the
6.3 allocator rewrite which is also a potential AGF-AGF deadlock
vector as it allows out-of-order locking.

The third patch is a change needed by patch 4, which I split out for
clarity. By itself it does nothing.

The fourth patch is a fix for a AGI->AGF->inode cluster buffer lock
ordering deadlock. This was introduced when we started pinning inode
cluster buffers in xfs_trans_log_inode() in 5.8 to fix long-standing
inode reclaim blocking issues, but I've only seen it in the wild
once on a system making heavy use of OVL and hence O_TMPFILE based
operations.

This has all passed through fstests without any issues being
detected, but wider testing would be appreciated along with review.

-Dave.

