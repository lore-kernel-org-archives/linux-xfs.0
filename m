Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BD8C6FA8E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCBUfS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCBUfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:18 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08690303E2
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id b20so247100pfo.6
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jpC6qvm3z4xmjpkmYnEYFXhm0ukZhZ7VSpBo9i5esAs=;
        b=cEu2mdpe9f/rtKFOv44jprZDLO8QXOsdGZoYblvQaNadgEdRN2+0FxSqSrb/Efp/gz
         FlllYJhiYgYDTUo8x0DCtkNh+HCclpoe7w9W/NreFWIBab8UciOLMamwp6VdZuBrBa7i
         hKCbBb+DyQAoSAj9JiDDHkKSbuqkhnKperh4vpLzysuPuimUjhwxRzwHygdIptQCmlh/
         d9SlXeuSWGQWgcHcBauIiTa1iO3viqehr/AAELYZCiVeNq5dCGWL2AXiLyjhLD0WsDaT
         TzzFV7Q5uHGxIQslyhA9+6Lp4w3WOBnnBlZ1vGQVljR7oOjNrgc+73ZLjmrfeyvFA/Fc
         5Kcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpC6qvm3z4xmjpkmYnEYFXhm0ukZhZ7VSpBo9i5esAs=;
        b=1iQEyQmNeH/hFLW9Ow8dSA30vkpw8vclHo7EN4IUN1ShfvfQbn0711ZztIkA5ptnJg
         4BiYf+1L6K4/+jDDIhzXxj1bf2hZVEJrSDJm/5ixrQT9YVxSDihfOgE1Q/pEPWQt0iCc
         sQMQXTOTkMgoiP7zd7lr0TmTvXDNA8s8MlKbqWzkYPUcCE5PjxegKoFbRZevfZu0R3xF
         LCxDLHd7UH4w7urvfNyCPiCKco1Ku2fR6/BFsCuFtVg6G9tpt7jSdbdvIOfU7dEHFWgg
         QcnykTAUILmUgpa75c8DSwYPEIAiEp4vkKJHTq3zOChxLZD2sVDivX5AkjfqOx4BoCCo
         ozFA==
X-Gm-Message-State: AO0yUKXf71XrZJlbpY9P6Jkfu5RbP4gtwJqTz6YUWzbaXdetGpm0ysti
        z8JRPOMPveHyab/GgqhtGYHGKC73ErU=
X-Google-Smtp-Source: AK7set8NrkZ0vonCfAfTEIZEstWj8OfnLm5vh+LX6cEMNwIEClftC7ZPhOh/sPHTZOkoFUyiiVza+Q==
X-Received: by 2002:aa7:8ec5:0:b0:5de:7ef1:d03a with SMTP id b5-20020aa78ec5000000b005de7ef1d03amr9707160pfr.19.1677789316253;
        Thu, 02 Mar 2023 12:35:16 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:15 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 00/11] 5.15.y sgid fixes
Date:   Thu,  2 Mar 2023 12:34:53 -0800
Message-Id: <20230302203504.2998773-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I finished testing the sgid fixes which Amir graciously backported to
5.15. This series fixes the previously failing generic/673 and
generic/68[3-7]. No regressions were seen in the 25 runs of the auto
group x 8 configs. I also did some extra runs on the perms group and
no regressions there either. The corresponding fixes are already in
6.1.y.

- Leah

Christian Brauner (5):
  attr: add in_group_or_capable()
  fs: move should_remove_suid()
  attr: add setattr_should_drop_sgid()
  attr: use consistent sgid stripping checks
  fs: use consistent setgid checks in is_sxid()

Darrick J. Wong (1):
  xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (3):
  xfs: remove XFS_PREALLOC_SYNC
  xfs: fallocate() should call file_modified()
  xfs: set prealloc flag in xfs_alloc_file_space()

Yang Xu (2):
  fs: add mode_strip_sgid() helper
  fs: move S_ISGID stripping into the vfs_*() helpers

 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 72 +++++++++++++++++++++++++--
 fs/fuse/file.c                 |  2 +-
 fs/inode.c                     | 90 ++++++++++++++++++++--------------
 fs/internal.h                  | 10 +++-
 fs/namei.c                     | 82 ++++++++++++++++++++++++++-----
 fs/ocfs2/file.c                |  4 +-
 fs/ocfs2/namei.c               |  1 +
 fs/open.c                      |  8 +--
 fs/xfs/xfs_bmap_util.c         |  9 ++--
 fs/xfs/xfs_file.c              | 24 +++++----
 fs/xfs/xfs_iops.c              | 56 ++-------------------
 fs/xfs/xfs_pnfs.c              |  9 ++--
 include/linux/fs.h             |  6 ++-
 14 files changed, 235 insertions(+), 140 deletions(-)

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

