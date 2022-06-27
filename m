Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E1EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 07:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbiF0HdS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiF0HdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 03:33:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D945FA5;
        Mon, 27 Jun 2022 00:33:16 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r20so11735447wra.1;
        Mon, 27 Jun 2022 00:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IjCAYcZiyzmXKNidCoE+ZXPBYYITRg7RBpp+SdwMpOU=;
        b=GSiHmMA9vbyGudgEWh9Y1AFUwYBXPmugBbu/9bK401UeuUYnBmF/OA585uARG6izBd
         XxVh5qAT5ckqUpRwpiNNM5vTGDPZjHxi3JhZn+Wa97t0l4FdyzHQydJTdR+XNvol6666
         Y2eTkEeIjJev/6qMBkLYVhdPxuio0HS67m8Ca1onueI5GIUrlEOQlwTn9B3Tz7r6LloX
         stk1RLwl6pOy9+jZoo6jXhg7JxMtcMQMyPD7xU5fGMjKchOHr/J/N+t7nhfcIIShjpVC
         bpdrunh+j5OW8BiVI1c/9FHt3rImU+uer3XBbIjFJzhSCkLchLumtHcX8NsAJiD7EAgV
         ERhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IjCAYcZiyzmXKNidCoE+ZXPBYYITRg7RBpp+SdwMpOU=;
        b=xLyupm8Cm68t9FNSnZ0vs6AXiqNHr1dwGoOzz+qS1iEj/0wkFQXXVMXOFkoKy6FJt1
         qnc+HB6o9lsKmwAvJDx1W8dEfc32Vw/UYqsuA1m2/aS6O+OQWN+EgI7vKir9OGm+7ash
         l2S+T6t1KeVY6YxmeCt5QK5KvkgF5ia9visGqvp4zWwFJwjuBrufpvZsLZvOLHQlh792
         3d0a2paDFG3rHXgaivWPryZw/FASjDYMbeylO7Pa9wXcup9p0l3lefRgQTqDzleutl5u
         Z0hkh4IsvpMTY9/+ydNzDgDOZ7CHv3yYIF73L9sUn5ksXMG22Mu0U1JrLCed+nbYtaAM
         QMqg==
X-Gm-Message-State: AJIora+50jOBCaJtabQor73U9aCCHPSp/SXn+JcK3KJ0VKSFNivmZpg3
        12wLERVIO9tnXCLKB5OOcy8=
X-Google-Smtp-Source: AGRyM1tg7erOZgdACKLItuDRGcnUIRnFvY/H8ul5M1uy00pES3EfD0Ry7w2NUsiQp8TxCeGxKYmECQ==
X-Received: by 2002:a05:6000:1885:b0:21b:ad25:8ae6 with SMTP id a5-20020a056000188500b0021bad258ae6mr10663203wri.183.1656315195496;
        Mon, 27 Jun 2022 00:33:15 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c2b9400b00397623ff335sm12070070wmc.10.2022.06.27.00.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:33:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE v2 0/7] xfs stable candidate patches for 5.10.y (from v5.13)
Date:   Mon, 27 Jun 2022 10:33:04 +0300
Message-Id: <20220627073311.2800330-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a resend of the series that was posted 3 weeks ago [v1].
The backports in this series are from circa v5.12..v5.13.
The remaining queue of tested 5.10 backports [1] contains 25 more patches
from v5.13..v5.19-rc1.

There have been no comments on the first post except for Dave's request
to collaborate the backports review process with Leah who had earlier
sent out another series of backports for 5.15.y.

Following Dave's request, I had put this series a side to collaborate
the shared review of 5.15/5.10 series with Leah and now that the shared
series has been posted to stable, I am re-posting to request ACKs on this
5.10.y specific series.

There are four user visible fixes in this series, one patch for dependency
("rename variable mp") and two patches to improve testability of LTS.

Specifically, I selected the fix ("use current->journal_info for
detecting transaction recursion") after I got a false positive assert
while testing LTS kernel with XFS_DEBUG and at another incident, it
helped me triage a regression that would have been harder to trace
back to the offending code otherwise.

This series has been looping in kdevops for a long while, with and
without the shared 5.15 backport with no regressions observed.

Thanks,
Amir.

Changes since [v1]:
- Rebased and tested on top of the v5.15+ ACKed backports [2]

[1] https://github.com/amir73il/linux/commits/xfs-5.10.y
[2] https://lore.kernel.org/linux-xfs/20220624063702.2380990-1-amir73il@gmail.com/
[v1] https://lore.kernel.org/linux-xfs/20220606160537.689915-1-amir73il@gmail.com/

Anthony Iliopoulos (1):
  xfs: fix xfs_trans slab cache name

Darrick J. Wong (1):
  xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range

Dave Chinner (2):
  xfs: use current->journal_info for detecting transaction recursion
  xfs: update superblock counters correctly for !lazysbcount

Gao Xiang (1):
  xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX

Pavel Reichl (2):
  xfs: rename variable mp to parsing_mp
  xfs: Skip repetitive warnings about mount options

 fs/iomap/buffered-io.c    |   7 ---
 fs/xfs/libxfs/xfs_btree.c |  12 +++-
 fs/xfs/libxfs/xfs_sb.c    |  16 ++++-
 fs/xfs/xfs_aops.c         |  17 +++++-
 fs/xfs/xfs_error.c        |   2 +
 fs/xfs/xfs_reflink.c      |   3 +-
 fs/xfs/xfs_super.c        | 120 +++++++++++++++++++++-----------------
 fs/xfs/xfs_trans.c        |  23 +++-----
 fs/xfs/xfs_trans.h        |  30 ++++++++++
 9 files changed, 148 insertions(+), 82 deletions(-)

-- 
2.25.1

