Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4DEC6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCQLI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQLI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:27 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A5424733
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:25 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l15-20020a05600c4f0f00b003ed58a9a15eso3036003wmq.5
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051304;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YJKY1uYO1JL18tYFOMwLyaZ9VknxqKhB3PqioTyOcmQ=;
        b=iQRjkhj++QzM0THD0TVkkbdM9lokZ+xzgXnlFno8PO26zTZWynvIJmg99vqQstd28A
         8RDEvP7L2IGHu5ubRrROuQ0Gy2eTAoC5h6Gdk1m6U5ULrwniu78GLAAJWTRWV1PgtsIv
         tpGvQdP2no983pQC2/eLMbvshH8Dd6iZBTlcA+pR8+oaoh6lK8sC6YF5lD1lQLFQ9nvE
         jfCWMCq0b9mPVERY3qwUDEnYIH8Ge5AAQ5AIIDCcXydFccuUM8LkGdQZV5D7GsxTFQR9
         lvjqJq0s0NQgEk8icLlv2rD0NsvBwpkMa7D8CVnPHko3fqTA6MW7uKf+fpRZBbeHzV1V
         8sZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051304;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YJKY1uYO1JL18tYFOMwLyaZ9VknxqKhB3PqioTyOcmQ=;
        b=kqX/JRbXpbKA5VdKUK5thKI19gb7FWhOqqqHuzf6NtBngX2407MeFOXsFzpVTfGIUS
         pY3yogdjX9LL+ACItLE7HCAHuBUj9KGOCRi7SmuBQXVn3AAvRg+GQmcSBWEjxvE/c0TQ
         P6d5IeeCkodfNujYxOWHIxddNG4kCzeNpTBqyRrHktkl1DhAkJwvpFbHt5etkdnuXvk7
         kMP8LtFzwTBop3ii0RoTX//l9o93AHbkoSMX7l5ToM3hYv3jklfALtZN6BWTyiyHNc7s
         iotCgIQJh75E2TVEu0RcqrhAKhwyblCKr4xHpOhiwIMDvJ7MrwemXtfQjkuWXkmsC8sT
         lpVw==
X-Gm-Message-State: AO0yUKW0Lja1njXkfFTES1cvQAwIfnPAxa1ax6oHmElVUaD/MwvR0vD1
        TGM3Y1ISzx7246rYPO0bgLU=
X-Google-Smtp-Source: AK7set/bqacGXsj5DkqqPhhVPvjnEiUkHSz9TsXh15CSfC6ddWlPG77bVk+YdvEeDa7aoyqXR/+G7g==
X-Received: by 2002:a05:600c:5408:b0:3ea:ecc2:daab with SMTP id he8-20020a05600c540800b003eaecc2daabmr26898336wmb.3.1679051303743;
        Fri, 17 Mar 2023 04:08:23 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 00/15] xfs backports for 5.10.y (from v5.15.103)
Date:   Fri, 17 Mar 2023 13:08:02 +0200
Message-Id: <20230317110817.1226324-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

Following backports catch up with recent 5.15.y backports.

Patches 1-3 are the backports from the previous 5.15 round
that Chandan requested for 5.4 [1].

Patches 4-14 are the SGID fixes that I collaborated with Leah [2].
Christian has reviewed the backports of his vfs patches to 5.10.

Patch 15 is a fix for a build warning caused by one of the SGID fixes.

This series has gone through the usual kdevops testing routine.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/874jrtzlgp.fsf@debian-BULLSEYE-live-builder-AMD64/
[2] https://lore.kernel.org/linux-xfs/20230307185922.125907-1-leah.rumancik@gmail.com/

Amir Goldstein (4):
  attr: add in_group_or_capable()
  fs: move should_remove_suid()
  attr: add setattr_should_drop_sgid()
  attr: use consistent sgid stripping checks

Christian Brauner (1):
  fs: use consistent setgid checks in is_sxid()

Darrick J. Wong (3):
  xfs: purge dquots after inode walk fails during quotacheck
  xfs: don't leak btree cursor when insrec fails after a split
  xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (4):
  xfs: don't assert fail on perag references on teardown
  xfs: remove XFS_PREALLOC_SYNC
  xfs: fallocate() should call file_modified()
  xfs: set prealloc flag in xfs_alloc_file_space()

Gaosheng Cui (1):
  xfs: remove xfs_setattr_time() declaration

Yang Xu (2):
  fs: add mode_strip_sgid() helper
  fs: move S_ISGID stripping into the vfs_*() helpers

 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 70 ++++++++++++++++++++++++++---
 fs/inode.c                     | 80 +++++++++++++++++++---------------
 fs/internal.h                  |  6 +++
 fs/namei.c                     | 80 ++++++++++++++++++++++++++++------
 fs/ocfs2/file.c                |  4 +-
 fs/ocfs2/namei.c               |  1 +
 fs/open.c                      |  6 +--
 fs/xfs/libxfs/xfs_btree.c      |  8 ++--
 fs/xfs/xfs_bmap_util.c         |  9 ++--
 fs/xfs/xfs_file.c              | 24 +++++-----
 fs/xfs/xfs_iops.c              | 56 ++----------------------
 fs/xfs/xfs_iops.h              |  1 -
 fs/xfs/xfs_mount.c             |  3 +-
 fs/xfs/xfs_pnfs.c              |  9 ++--
 fs/xfs/xfs_qm.c                |  9 +++-
 include/linux/fs.h             |  5 ++-
 17 files changed, 229 insertions(+), 144 deletions(-)

-- 
2.34.1

