Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D3AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 22:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbiGGWii (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiGGWih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 18:38:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C015175B7
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 15:38:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 73so5447083pgb.10
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jul 2022 15:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x7Y6mKdV5Bb6UGg+YNI/f4dhnbjYh+Ja5cTyIy71eTE=;
        b=bpVE2AYQ4G1jVdDAIE7n3dAYD+vMIYmoPfUrQ3O67HA62xJQNh06qepFcIr2+Jg/em
         30/0KGX1CoTUHuweqwTQoGQC2+QUJggwoDF2AZUxTgaR0nRZaGHjVpLw+Z4ThUE0BPGc
         3Nyy+u3dB3AkEaP9RqxK4DBCIyvf7cbDGxSGTPDFmZAj7WRZ3RDx/UZWsSU8At/KcbPB
         FiHKmq1vwXFAO4mvnQEVLVQ+NoK+183FyeFsddGPx5SIQ10ymvHxSJeA5RYGUHDaI/99
         r3q+mQhmIvoVUsEg4bFrC2wlzHQKbBjzpgrkte/R1ZneFq95UBzUB2rjJ7dfpiolNn/g
         96uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x7Y6mKdV5Bb6UGg+YNI/f4dhnbjYh+Ja5cTyIy71eTE=;
        b=k5OTqDSLV/93wObYsU6dMl30IBiORhYzMUmJo05U+Di3yoW5fWdQdnfRGqe8Po+zxA
         atDL/geRTEa3e2/HC6wOna3zNpvgd/04gTI11NgS0dZuUgJo+5BuZ0C1nK7bX8THZz8e
         cfj07BIpyB1Y2mE/sETe0/e/DNOKRnliq5N4sXBlfaBr4dHc2jfpW+UxhuygmVB8wCf+
         zWQZl+7Nz2oaxiENeOBHVck+yFgczjOBRYuvgnLnGQwyazHgYxlSsy1RW8ZsZWOiCuUE
         gn4vxVZvCNRvDlwrUFIcGT7opQnIRjRHKZL3IoOHl1U0ThpwT5YImNQQUyor0vO/n+A7
         9G/A==
X-Gm-Message-State: AJIora9ok8cIfDTCC9B7f/DNY+5roRbTR6Z3EPy44Lk07lTxb0BUy+3C
        NcAZe0PZgRXJglA17nYL61JIfVtUim8=
X-Google-Smtp-Source: AGRyM1uY1ZGxrgBlu8lsHofz8YnFxevBCfeycOxTLPtXYXe8ZHACrNnq2qzbr+ty8LmPF03hc6QZ0A==
X-Received: by 2002:a63:8148:0:b0:415:6fba:af3f with SMTP id t69-20020a638148000000b004156fbaaf3fmr340590pgd.277.1657233516520;
        Thu, 07 Jul 2022 15:38:36 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:26db:8a38:cdca:57b5])
        by smtp.gmail.com with ESMTPSA id j15-20020a056a00234f00b0052542cbff9dsm28776889pfj.99.2022.07.07.15.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:38:36 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 0/4] xfs stable candidates for 5.15.y (part 2)
Date:   Thu,  7 Jul 2022 15:38:24 -0700
Message-Id: <20220707223828.599185-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello again,

These are a subset of the patches from the v1 5.15 part 1 which are
not applicable to 5.10.y. These patches were rebased and applied on top
of the accepted part 1 patches. 100 runs of each test on mulitple configs
were completed and no regressions found.

Additional testing:
c8c568259772 "xfs: don't include bnobt blocks when reserving free block pool"
    Observed the hang before the patches but not after

919edbadebe1 "xfs: drop async cache flushes from CIL commits."
    Ran dbench as in the commit and confirmed performance improved

clients   before      after
1         220.493     260.359
8         732.807     1068.64
16        749.677     1293.06
32        737.9       1247.17
128       680.674     1077.0
512       602.674     884.48

Thanks,
Leah


Darrick J. Wong (2):
  xfs: only run COW extent recovery when there are no live extents
  xfs: don't include bnobt blocks when reserving free block pool

Dave Chinner (2):
  xfs: run callbacks before waking waiters in
    xlog_state_shutdown_callbacks
  xfs: drop async cache flushes from CIL commits.

 fs/xfs/xfs_bio_io.c      | 35 ------------------------
 fs/xfs/xfs_fsops.c       |  2 +-
 fs/xfs/xfs_linux.h       |  2 --
 fs/xfs/xfs_log.c         | 58 +++++++++++++++++-----------------------
 fs/xfs/xfs_log_cil.c     | 42 +++++++++--------------------
 fs/xfs/xfs_log_priv.h    |  3 +--
 fs/xfs/xfs_log_recover.c | 24 ++++++++++++++++-
 fs/xfs/xfs_mount.c       | 12 +--------
 fs/xfs/xfs_mount.h       | 15 +++++++++++
 fs/xfs/xfs_reflink.c     |  5 +++-
 fs/xfs/xfs_super.c       |  9 -------
 11 files changed, 82 insertions(+), 125 deletions(-)

-- 
2.37.0.rc0.161.g10f37bed90-goog

