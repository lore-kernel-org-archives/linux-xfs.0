Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED63FC4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB412224F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TG8qrYzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgKMMFP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKML1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:43 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4CBC0617A6;
        Fri, 13 Nov 2020 03:27:31 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id k7so4424967plk.3;
        Fri, 13 Nov 2020 03:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wk24sFTpITneolZ7W0PLgni+mXlk+++AB9quPVkpd20=;
        b=TG8qrYzvWRHM7siOoCJH4fsXuTShxU4cV5Q6A3F/LCkhihxzPWReVsXoEfGUifl4ew
         V1E3uz2Atg8cnMWNMWuTriXQ70Ak6VB0K1BigTE1/SowMupffeUCcSGtyaU0m+3DCcK0
         1arhvHMWlWkykn7XpnM3LiQ+9Dz5ir8d5j0tzgDTtKJDzFEuRsRZ+x0vY7bJpex3lrPu
         jQY5pRvNzBnbBn9LEO1fRGZOu18CURZdw55ntn8DHNKmYZj3GaLvFY7Nm/XQFiGFZkc8
         AW7AmUOb972mNUq0e0asSn+Vz3QUgHctn7i21cbRc54C+6aw45diaFAoZKGAUocM5lYc
         cCuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wk24sFTpITneolZ7W0PLgni+mXlk+++AB9quPVkpd20=;
        b=JVJ8Z6o0E9IIoQvdE3LjUYGNhoz5u+e+nyzIfyKnc+2dSxjuF0uTrTTcDcnv5oTUBl
         DhkUrTZ04ZEWESLlxAJw10/S734U2IqCa3zbZ3w4XDPIaVRc1RwnZNjOez9p1FCJ+CaU
         /4mLdl1/RHoQ0rnHEnBLIWAbuBlL7cBBDAxpY52WRdhmUAAU8M/hOPeXJM0sGHtE9rBg
         oV2aLvfeC9ZpQqqmvB1gWez4z8/MKD4alCwmaPVHggWhDR3ezI14RwN0nn8w6/tqA4qX
         1zQ/4/SxHNRE/frtXqyITiPsH9cE0IL5hOZieOnSP8JPHz+bIeZavMNCR6UykjdMa2Ux
         UA/g==
X-Gm-Message-State: AOAM531al2Pxtfo7rlsG6ou/9onI4GZWYXWhHJUv5NVwG6imZ0KPrA0T
        cFSjbnKss1iHVnLUKgu2eIft1Nm8mG4=
X-Google-Smtp-Source: ABdhPJzX9PD4+2hhnyk8yaAZHebBTeYM1ryCxZnE5IEtO4BMRVl8YbAOo0NPL8DKXsIBDSpjNDzMZQ==
X-Received: by 2002:a17:902:6b04:b029:d8:d392:7791 with SMTP id o4-20020a1709026b04b02900d8d3927791mr1867000plk.47.1605266850428;
        Fri, 13 Nov 2020 03:27:30 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:29 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 00/11] xfs: Tests to check for inode fork extent count overflow detection
Date:   Fri, 13 Nov 2020 16:56:52 +0530
Message-Id: <20201113112704.28798-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patchset at
https://lore.kernel.org/linux-xfs/20201103150642.2032284-1-chandanrlinux@gmail.com/T/#m90a8754df516bbd0c36830904a2e31c37983792c  
added support to XFS to detect inode extent count overflow when
performing various filesystem operations. The patchset also added
new error injection tags for,
1. Reducing maximum extent count to 10.
2. Allocating only single block sized extents.

The corresponding code for xfsprogs can be obtained from
https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/.

The patches posted along with this cover letter add tests to verify if
the in-kernel inode extent count overflow detection mechanism works
correctly.

These patches can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
extent-overflow-tests.

Chandan Babu R (11):
  common/xfs: Add a helper to get an inode fork's extent count
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents
  xfs: Stress test with with bmap_alloc_minlen_extent error tag enabled

 common/xfs        |  22 +++
 tests/xfs/522     | 214 +++++++++++++++++++++++++++
 tests/xfs/522.out |  24 ++++
 tests/xfs/523     | 176 +++++++++++++++++++++++
 tests/xfs/523.out |  18 +++
 tests/xfs/524     | 210 +++++++++++++++++++++++++++
 tests/xfs/524.out |  25 ++++
 tests/xfs/525     | 154 ++++++++++++++++++++
 tests/xfs/525.out |  16 +++
 tests/xfs/526     | 360 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/526.out |  47 ++++++
 tests/xfs/527     | 125 ++++++++++++++++
 tests/xfs/527.out |  13 ++
 tests/xfs/528     |  87 +++++++++++
 tests/xfs/528.out |   8 ++
 tests/xfs/529     |  86 +++++++++++
 tests/xfs/529.out |   8 ++
 tests/xfs/530     | 115 +++++++++++++++
 tests/xfs/530.out |  13 ++
 tests/xfs/531     |  85 +++++++++++
 tests/xfs/531.out |   6 +
 tests/xfs/group   |  10 ++
 22 files changed, 1822 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out
 create mode 100755 tests/xfs/523
 create mode 100644 tests/xfs/523.out
 create mode 100755 tests/xfs/524
 create mode 100644 tests/xfs/524.out
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out
 create mode 100755 tests/xfs/526
 create mode 100644 tests/xfs/526.out
 create mode 100755 tests/xfs/527
 create mode 100644 tests/xfs/527.out
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

-- 
2.28.0

