Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F3C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B751A60E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhHFVXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232048AbhHFVXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CxFv8XpxhdcSzNmiBXBwtmCiTdyHO1HNJxrZjcX5Ecs=;
        b=AQRGqSI4ma4eoc46qsFoIb8jR4SVy+bUidAKOaDbYxTUoqDUI5Z15aO8wSH6goPitmZpKa
        mlIhuwjSX3AZFSyUdPXoep3iceaFMawyMPr6U4dzNlwyMS5Dq1uwRChQAwBFSMezNmgSXd
        ioVRjXxmuXBtYA5chZ7TEhvsterxcFY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-ldoGNklqNXWrK-9gO2vf6g-1; Fri, 06 Aug 2021 17:23:22 -0400
X-MC-Unique: ldoGNklqNXWrK-9gO2vf6g-1
Received: by mail-ed1-f71.google.com with SMTP id dh21-20020a0564021d35b02903be0aa37025so3316305edb.7
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CxFv8XpxhdcSzNmiBXBwtmCiTdyHO1HNJxrZjcX5Ecs=;
        b=rELlAMzbLMnW/BWmPt4rgn4zFwwfeQ7TCuDC1OcwwA42UGyktsz2bN2cmfUvkK6d7b
         kyV/PtOgX/eJ/glGsxXO5gxrlQZlWo33XaeN5P9vNezUbFptWlXBbcr4a24i3+otpGVL
         Y6QPU01FI9GY+oEEuURqqrdL12WoUL2MfR/3mKqbNT0cOB6Z9jZekYO3Cm8rknagMXZu
         B6sDhB+9hVw6+NeWzx27YKOUj1UswY0PH2VAA2mh81iRzVPlPEUi5okd8wvAIgYtHdac
         AXhQEAZ4a8x7XEw8itNQzKeV5m5swSEiA8blrhxYU9anY4073qpcvImhCBtBZiTaApeW
         Ly7g==
X-Gm-Message-State: AOAM532Imj8NSi/iRF2g23VOy+mdZRVOluDOoieAWf4ENIRVZ+1ZBwCO
        67ACaKszRt59Tt2WP+mruUGlPlw8ROvXoS4R2hUx0Hh80BCqR7PQk4h7nMY7J4dczP6C6E9nwzZ
        hd7mSrWHPHYFk4GcafuoKGJL72sXZP2m1XTbAEb52yWBOpqxNigZzzh9aaIYuQDOgfMGe8Sk=
X-Received: by 2002:a17:907:364:: with SMTP id rs4mr11914905ejb.56.1628285001260;
        Fri, 06 Aug 2021 14:23:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNcVWfR1wLQiK3Oz/2Ib9HkyHqDJCHd7hPNXfgFsfbTOowsVBFYiHHdiSITCj4ES8g1UIjlQ==
X-Received: by 2002:a17:907:364:: with SMTP id rs4mr11914894ejb.56.1628285001058;
        Fri, 06 Aug 2021 14:23:21 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:19 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/29] xfsprogs: Drop the 'platform_' prefix
Date:   Fri,  6 Aug 2021 23:22:49 +0200
Message-Id: <20210806212318.440144-1-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Stop using commands with 'platform_' prefix. Either use directly linux
standard command or drop the prefix from the function name.

Publicly visible commands with "platform_" prefix are kept for now, but
will be deprecated soon. 


Pavel Reichl (29):
  xfsprogs: Stop using platform_uuid_compare()
  xfsprogs: Stop using platform_test_xfs_fd()
  xfsprogs: Stop using platform_test_xfs_path()
  xfsprogs: Stop using platform_fstatfs()
  xfsprogs: Stop using platform_getoptreset()
  xfsprogs: Stop using platform_uuid_copy()
  xfsprogs: Stop using platform_uuid_generate()
  xfsprogs: Stop using platform_uuid_unparse()
  xfsprogs: Stop using platform_uuid_clear()
  xfsprogs: Stop using platform_uuid_parse()
  xfsprogs: Stop using platform_uuid_is_null()
  xfsprogs: Stop using platform_check_mount()
  xfsprogs: Stop using platform_check_ismounted()
  xfsprogs: Stop using platform_flush_device()
  xfsprogs: Stop using platform_mntent_open()
  xfsprogs: Stop using platform_mntent_next()
  xfsprogs: Stop using platform_mntent_close()
  xfsprogs: Stop using platform_findsizes()
  xfsprogs: Stop using platform_discard_blocks
  xfsprogs: Stop using platform_zero_range()
  xfsprogs: Stop using platform_crash()
  xfsprogs: Stop using platform_nproc()
  xfsprogs: Stop using platform_check_iswritable()
  xfsprogs: Stop using platform_set_blocksize()
  xfsprogs: Stop using platform_findrawpath()
  xfsprogs: Stop using platform_findblockpath()
  xfsprogs: Stop using platform_direct_blockdev()
  xfsprogs: Stop using platform_align_blockdev()
  xfsprogs: Stop using platform_physmem()

 copy/xfs_copy.c             | 24 ++++-----
 db/command.c                |  2 +-
 db/fprint.c                 |  2 +-
 db/sb.c                     | 14 +++---
 fsr/xfs_fsr.c               |  8 +--
 growfs/xfs_growfs.c         |  2 +-
 include/linux.h             | 71 ++++++++++++++++++++++----
 include/platform_defs.h.in  |  1 +
 io/init.c                   |  2 +-
 io/open.c                   |  4 +-
 io/stat.c                   |  2 +-
 libfrog/linux.c             | 99 ++++++++++++++++++++++++++++++++-----
 libfrog/paths.c             |  2 +-
 libfrog/platform.h          | 11 ++++-
 libfrog/topology.c          |  6 +--
 libxcmd/command.c           |  2 +-
 libxfs/init.c               | 32 ++++++------
 libxfs/libxfs_io.h          |  2 +-
 libxfs/libxfs_priv.h        |  3 +-
 libxfs/rdwr.c               |  4 +-
 libxfs/xfs_ag.c             |  6 +--
 libxfs/xfs_attr_leaf.c      |  2 +-
 libxfs/xfs_attr_remote.c    |  2 +-
 libxfs/xfs_btree.c          |  4 +-
 libxfs/xfs_da_btree.c       |  2 +-
 libxfs/xfs_dir2_block.c     |  2 +-
 libxfs/xfs_dir2_data.c      |  2 +-
 libxfs/xfs_dir2_leaf.c      |  2 +-
 libxfs/xfs_dir2_node.c      |  2 +-
 libxfs/xfs_dquot_buf.c      |  2 +-
 libxfs/xfs_ialloc.c         |  4 +-
 libxfs/xfs_inode_buf.c      |  2 +-
 libxfs/xfs_sb.c             |  6 +--
 libxfs/xfs_symlink_remote.c |  2 +-
 libxlog/util.c              |  8 +--
 logprint/log_misc.c         |  2 +-
 mdrestore/xfs_mdrestore.c   |  4 +-
 mkfs/xfs_mkfs.c             | 22 ++++-----
 quota/free.c                |  2 +-
 repair/agheader.c           | 16 +++---
 repair/attr_repair.c        |  2 +-
 repair/dinode.c             |  8 +--
 repair/phase4.c             |  6 +--
 repair/phase5.c             |  6 +--
 repair/phase6.c             |  2 +-
 repair/prefetch.c           |  2 +-
 repair/scan.c               |  4 +-
 repair/slab.c               |  2 +-
 repair/xfs_repair.c         |  6 +--
 scrub/disk.c                |  8 +--
 spaceman/init.c             |  2 +-
 51 files changed, 284 insertions(+), 151 deletions(-)

-- 
2.31.1

