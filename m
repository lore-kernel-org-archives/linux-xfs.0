Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9723C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381677AbiFQKH1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381620AbiFQKHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF406A408;
        Fri, 17 Jun 2022 03:06:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g4so5090550wrh.11;
        Fri, 17 Jun 2022 03:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lm9N1K0ErOqhgBIL+mM7oT0VHmXD9vMxUQ+f4k7wYOY=;
        b=HqwZBaiKSrAImMdKVXfTjpe6OJPZGGUSOYNAIqiVqgdC5GhWngXRVWydaZ2GBwsEiF
         +Po9ZMq+Iq2Q6xodIpenWuExXN0N//0OpEje60dBgh173EB7kCSQ7OVjcqgubk+fOu8i
         H6hqaGf0wikH3YmA6PD8zsPXWRCoobDMWM6fZvJUeUgnywaE/IoKxp/OB61I9Pr6rSQa
         flMSWSa7vcA2lLqnQoE+ll0Wf7hNkkGcOg3rHk4nB4G2ddNMM1Xess6a4mtp+MsAfpkY
         r9rJGjo/uhsuNv0JwDLjPggrdsddU3LqdSGqv8nxx2U8w3cooX8KBNoAsa6aztVi0wr+
         ciDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lm9N1K0ErOqhgBIL+mM7oT0VHmXD9vMxUQ+f4k7wYOY=;
        b=ccvUSJ25w8NSgigivkJ25O/QzyDo3r25Mt14hGQPp8rIXDCugn9nn2Y0Puds3dfdj9
         IOpbEYt4TkQldQVMZYOeJS/HHFvc2Mfs40jV/UDnAs5IkoWky7g7d/CNfWEmPSxHBXot
         KWNY4lCOyUzXsTsNe/PwdS6eh9qvCz4ecjX07qQZptOvMu8GVVX7Xd0Chv5eoby42TTh
         S3SC4Bmlo/EWsG1tnHtWddaGhOemafdmjUTCYLVQFUC4zE5uqSGKuJDjhf0KEipffFJl
         3pbYA6jxOukEb36SdbJv0X0vyE41+70lI2K9CHpGyJtQBFv+zqLu29ByHqswFWAd2IEl
         31QQ==
X-Gm-Message-State: AJIora/e6lbIbvyo/iECNM5M4gt6/iA/1nd4VMzJ/Iy6wGX6KmuHkq9Q
        fQwYyiK3Ji9yFqszqUa0SyTasxbKctFCTw==
X-Google-Smtp-Source: AGRyM1vHFKW3wLeL/sPoeN2eqNfSkWZMfMbTJ/LdPEWelNdZ7gC8HS2dLjVzUub/bFebD0K38Da6wg==
X-Received: by 2002:a5d:4ed1:0:b0:219:ea8d:c07e with SMTP id s17-20020a5d4ed1000000b00219ea8dc07emr8521271wrv.174.1655460406406;
        Fri, 17 Jun 2022 03:06:46 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 00/11] xfs stable candidate patches for 5.10.y (v5.15+)
Date:   Fri, 17 Jun 2022 13:06:30 +0300
Message-Id: <20220617100641.1653164-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Previously posted candidates for 5.10.y followed chronological release
order.

Parts 1 and 2 of fixes from v5.10..v5.12 have already been applied to
v5.10.121.

Part 3 (from 5.13) has already been posted for review [3] on June 6,
but following feedback from Dave, I changed my focus to get the same
set of patches tested and reviewed for 5.10.y/5.15.y.

I do want to ask you guys to also find time to review part 3, because
we have a lot of catching up to do for 5.10.y, so we need to chew at
this debt at a reasonable rate.

This post has the matching set of patches for 5.10.y that goes with
Leah's first set of candidates for 5.15.y [1].

Most of the fixes are from v5.15..v5.17 except for patch 11 (v5.18-rc1).
All fix patches have been tagged with Fixes: by the author.

The patches have been soaking in kdepops since Sunday. They passed more
than 30 auto group runs with several different versions of xfsprogs.

The differences from Leah's 5.15.y:
- It is 11 patches and not 8 because of dependencies
- Patches 6,7 are non-fixes backported as dependency to patch 8 -
  they have "backported .* for dependency" in their commit message
- Patches 3,4,11 needed changes to apply to 5.10.y - they have a
  "backport" related comment in their commit message to explain what
  changes were needed
- Patch 10 is a fix from v5.12 that is re-posted as a dependency for
  patch 11

Darrick,

As the author patches 4,11 and sole reviewer of patch 3 (a.k.a
the non-cleanly applied patches), please take a closer look at those.

Patch 10 has been dropped from my part 2 candidates following concerns
raised by Dave and is now being re-posted following feedback from
Christian and Christoph [2].

If there are still concerns about patches 10 or 11, please raise a flag.
I can drop either of these patches before posting to stable if anyone
feels that they need more time to soak in master.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220616182749.1200971-1-leah.rumancik@gmail.com/
[2] https://lore.kernel.org/linux-xfs/CAOQ4uxg4=m9zEFbDAKXx7CP7HYiMwtsYSJvq076oKpy-OhK1uw@mail.gmail.com/
[3] https://lore.kernel.org/linux-xfs/20220606160537.689915-1-amir73il@gmail.com/

Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Christoph Hellwig (2):
  xfs: refactor xfs_file_fsync
  xfs: fix up non-directory creation in SGID directories

Darrick J. Wong (4):
  xfs: remove all COW fork extents when remounting readonly
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: only bother with sync_filesystem during readonly remount
  xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (2):
  xfs: check sb_meta_uuid for dabuf buffer recovery
  xfs: xfs_log_force_lsn isn't passed a LSN

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 13 +++---
 fs/xfs/libxfs/xfs_types.h     |  1 +
 fs/xfs/xfs_aops.c             | 15 +++++--
 fs/xfs/xfs_buf_item.c         |  2 +-
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_dquot_item.c       |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 +--
 fs/xfs/xfs_file.c             | 81 +++++++++++++++++++++--------------
 fs/xfs/xfs_inode.c            | 24 +++++------
 fs/xfs/xfs_inode_item.c       |  4 +-
 fs/xfs/xfs_inode_item.h       |  2 +-
 fs/xfs/xfs_iops.c             | 56 ++----------------------
 fs/xfs/xfs_log.c              | 27 ++++++------
 fs/xfs/xfs_log.h              |  4 +-
 fs/xfs/xfs_log_cil.c          | 32 ++++++--------
 fs/xfs/xfs_log_priv.h         | 15 +++----
 fs/xfs/xfs_pnfs.c             |  3 +-
 fs/xfs/xfs_super.c            | 21 ++++++---
 fs/xfs/xfs_trans.c            |  6 +--
 fs/xfs/xfs_trans.h            |  4 +-
 20 files changed, 149 insertions(+), 171 deletions(-)

-- 
2.25.1

