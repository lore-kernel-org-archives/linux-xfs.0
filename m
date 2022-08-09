Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A82BC3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 11:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiHILRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 07:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiHILRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 07:17:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30096192A8;
        Tue,  9 Aug 2022 04:17:18 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bv3so13930906wrb.5;
        Tue, 09 Aug 2022 04:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=FZmITAqIsDdiBPzSCmaelu7mb1hKLsqxQu5syDC3GV4=;
        b=pcN423NALx3enA3jmy9bssKaAStqxzKFOz+EpTves8T8/9LwMwkiNVRo8EWF5Z5HYI
         g2hCx04jlp/OmrPYV1EF321GZESkFMIbCGXPb8NzwKR3kI2X0UmpzdVJ+kwyc/irmH24
         B3jteM63TAMPFjYpS2p4V2N2cpEHo/uT5prJMJ1SGtRJDv1CSF948HB8EKuRpwcXjdEn
         lR0ko+oP9FewAfwYoRGAYz8kL4oq46xKmh7SR+219QchjmaK2+Fa8ZAnnXeRInCxoLcA
         hNwbazZ9NE5IgVBe4ea+XY8JJOIsBe/z2HKNXU4OARHkA2R4J85Bbke4op2dALxCeHGh
         LkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=FZmITAqIsDdiBPzSCmaelu7mb1hKLsqxQu5syDC3GV4=;
        b=l+mgJjzux3RBZx8HQcR77Q7WTLjCPY//yjVZu/v2YKZgIGFXm//pXJCl2xxdh0DR67
         ZEHIi2FXQ4mTmBMmgaLiqVHzTUCer5NDOCCv4T4cQ8EW5R/oI3gU34malOul9wbO7SSn
         /F11PXWMkIX8+3K5RBlvj29ZML6jXxaapPwRc5YoIU4tUe8ZCvfQ/4AdFvDJFUY9UXCd
         6U70mNJWaHKWAbfdYND/HZdxt97nqUm9dQLy7mYN09eji6uC9Db+pHRai1K4lwU95Qsq
         u9HCwcTrDK1SmPdkIyyLrS7qjQC0Pl4BKshT9BTfw+F0pfmJVkgNZY5iVeFbc80Q4ABK
         vl7g==
X-Gm-Message-State: ACgBeo0U5Um7ny4xuysWZw/Xle0n3Nepudg9sQN/OEORu2PH94Ye1P2R
        fi8oaD3djZCnOSgkMvKuQMGTReNh+q8=
X-Google-Smtp-Source: AA6agR6zGPxqIC65hzImu8mupLJHNyLRGU/oOMaDy9ANO60mbj5ZQfgn9knbKxQ1xWf+/9rKnoRG6g==
X-Received: by 2002:adf:e283:0:b0:21e:26fe:14f3 with SMTP id v3-20020adfe283000000b0021e26fe14f3mr13844987wri.98.1660043836573;
        Tue, 09 Aug 2022 04:17:16 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id l2-20020a1ced02000000b003a3170a7af9sm15906169wmh.4.2022.08.09.04.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 04:17:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/4] xfs stable candidate patches for 5.10.y (from v5.15)
Date:   Tue,  9 Aug 2022 13:17:04 +0200
Message-Id: <20220809111708.92768-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This is a small update of simple backports from v5.15 that shouldn't be
too hard to review.

I rather take "remove support for disabling quota accounting" to 5.10.y
even though it is not a proper bug fix, as a defensive measure and in
order to match the expefctations of fstests from diabling quota.

These backports survived the standard auto group soak for over 40 runs
on the 5 test configs.

Please ACK.

Thanks,
Amir.

Christoph Hellwig (1):
  xfs: remove support for disabling quota accounting on a mounted file
    system

Darrick J. Wong (1):
  xfs: only set IOMAP_F_SHARED when providing a srcmap to a write

Dave Chinner (2):
  mm: Add kvrealloc()
  xfs: fix I_DONTCACHE

 fs/xfs/libxfs/xfs_trans_resv.c |  30 -----
 fs/xfs/libxfs/xfs_trans_resv.h |   2 -
 fs/xfs/xfs_dquot_item.c        | 134 ------------------
 fs/xfs/xfs_dquot_item.h        |  17 ---
 fs/xfs/xfs_icache.c            |   3 +-
 fs/xfs/xfs_iomap.c             |   8 +-
 fs/xfs/xfs_iops.c              |   2 +-
 fs/xfs/xfs_log_recover.c       |   4 +-
 fs/xfs/xfs_qm.c                |   2 +-
 fs/xfs/xfs_qm.h                |   1 -
 fs/xfs/xfs_qm_syscalls.c       | 240 ++-------------------------------
 fs/xfs/xfs_trans_dquot.c       |  38 ------
 include/linux/mm.h             |   2 +
 mm/util.c                      |  15 +++
 14 files changed, 40 insertions(+), 458 deletions(-)

-- 
2.25.1

