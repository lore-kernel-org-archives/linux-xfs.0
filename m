Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF9FC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352368AbiFAKqF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352372AbiFAKp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:45:58 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F067E1F3;
        Wed,  1 Jun 2022 03:45:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e2so1785237wrc.1;
        Wed, 01 Jun 2022 03:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C7Jpet0hdXo8X//QPFYfddVJxAi84AMUAgkUSX7O5VE=;
        b=m7GtlVpz4QBmqcpmkVjr4mEN1djL8+zdxtS9tuIN4mAn3TelZYZ0EnveI5SF/N0Cn5
         HwdiUBtxEwqBmScN72SZTxGZtzc2YVU8+8DWxZ40ti46Bwq4q/VT6VXboMQlg28ZZOwE
         PQTH8su6oI9k7/luDh42mSxxlxbQQtbYzF3IXlNWGTQl7DzAIH2CtEn8N+7cUrFyhB0b
         LTtR6FEMjzLDBKAymDsImmOx5JqQIPpiaWPLDcODSoZwBg8BdWpZBC3iAtisRl+nDi3U
         YfW8AxPIUgnfXFkYvRrTH7IF+tvDUYRfUK3As60tvX3NaAH/1xv3W1dKr8JsrOcEQA11
         GQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C7Jpet0hdXo8X//QPFYfddVJxAi84AMUAgkUSX7O5VE=;
        b=QD+SYRhp74WqY7md4ns6OTrWib5Lhznp+Yc14j4BPduCnMf/vrX6+epkyoai65WTbU
         b8U0vI1mJCmgMM/O8bpvMk01wE8kMBP2svFrgfNwWpTWCsUMlShV3eKEfmJioR3DESsy
         CAKwvdqS/jvJVeaTcWDBTvlkQbnEJdYbklUMfEIiF1N8cE7z5nhYUh7UP/GWpZLabmo3
         ssPtVbOlj1S7eqC5iWOb3/M40Rbq1XvrJSbmlbUcSzX3kpWsPD4EwxEoVxbHh0qaHcZD
         TqtObBkMyf62dS6DnLDGpq0KUex3+ejMvfV1RsdiX7SSfAKLQQVJ08MBDRJ60Qmh4mPt
         jCoA==
X-Gm-Message-State: AOAM532VhjwLUyr23vFZZMLtuFZnwROgxzeTcLNFvCw0G60mEwFvk5Po
        GiwZ7D+96070003CQ9KdZ3k=
X-Google-Smtp-Source: ABdhPJwO+DDk8YunLkIoMcA4SL7SUlrXUUajgkWaRT3L9so/UVUc0sRof/jR4+8cJGv89eO8i6Qgiw==
X-Received: by 2002:a5d:650f:0:b0:20d:77b:702b with SMTP id x15-20020a5d650f000000b0020d077b702bmr53613547wru.78.1654080352829;
        Wed, 01 Jun 2022 03:45:52 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:45:52 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/8] xfs stable candidate patches for 5.10.y (part 2)
Date:   Wed,  1 Jun 2022 13:45:39 +0300
Message-Id: <20220601104547.260949-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all!

This is the 2nd part of a collection of stable patch candidates that
I collected from xfs releases v5.11..v5.18 [1][2].

The patches in this part are from circa v5.11..v5.12.
They have been through >30 auto group runs with the kdevops configs
reflink_normapbt, reflink, reflink_1024, nocrc, nocrc_512.
No regressions from baseline were observed.

At least three of the fixes have regression tests in fstests that were
used to verify the fix. I also annotated [3] the fix commits in the tests.

It is worth noting that one series and another patch from v5.12 were
removed from the stable candidates queue before this posting.

The "extent count overflow" series [4] was removed following feedback
from Dave Chinner that is it not practically relevant for LTS users.

The patch "xfs: don't reuse busy extents on extent trim" was removed
following a regression it caused in 5.10.y [5] that was discovered in
early stages of testing of this part.  The process works! :-)

I would like to thank Luis for his huge part in this still ongoing effort
and I would like to thank Samsung for contributing the hardware resources
to drive this effort.

Your inputs on these stable candidates are most welcome!

Thanks,
Amir.

[1] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-fixes.rst
[2] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.18-fixes.rst
[3] https://lore.kernel.org/fstests/20220520143249.2103631-1-amir73il@gmail.com/
[4] https://lore.kernel.org/linux-xfs/20220525083814.GH1098723@dread.disaster.area/
[5] https://lore.kernel.org/linux-xfs/YpY6hUknor2S1iMd@bfoster/T/#mf1add66b8309a75a8984f28ea08718f22033bce7

Brian Foster (3):
  xfs: sync lazy sb accounting on quiesce of read-only mounts
  xfs: restore shutdown check in mapped write fault path
  xfs: consider shutdown in bmapbt cursor delete assert

Christoph Hellwig (1):
  xfs: fix up non-directory creation in SGID directories

Darrick J. Wong (3):
  xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
  xfs: fix incorrect root dquot corruption error when switching
    group/project quota types
  xfs: force log and push AIL to clear pinned inodes when aborting mount

Jeffrey Mitchell (1):
  xfs: set inode size after creating symlink

 fs/xfs/libxfs/xfs_btree.c | 33 +++++---------
 fs/xfs/xfs_dquot.c        | 39 +++++++++++++++-
 fs/xfs/xfs_inode.c        | 14 +++---
 fs/xfs/xfs_iomap.c        |  3 ++
 fs/xfs/xfs_log.c          | 28 ++++++++----
 fs/xfs/xfs_log.h          |  1 +
 fs/xfs/xfs_mount.c        | 93 +++++++++++++++++++--------------------
 fs/xfs/xfs_qm.c           | 92 +++++++++++++++-----------------------
 fs/xfs/xfs_symlink.c      |  1 +
 9 files changed, 161 insertions(+), 143 deletions(-)

-- 
2.25.1

