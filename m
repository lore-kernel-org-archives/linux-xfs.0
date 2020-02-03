Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AAFC35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7680E21582
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahtaGr9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgBCR7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728278AbgBCR7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IOU+E+i/6GByzKomTOCcRp1Re3thOfIEFcg4mphDK8I=;
        b=ahtaGr9S6mmFJ0d3+Gpu7zPZTIXjS1nD+Gk3kVenCf1cAfv5sk7PhKzZU28ggL1XzbNWNM
        wbSuyVJI1a8VKN7o9gGh2GdGgdIG/WVfg8izPkf7tFAClq6ZYsXioL2P88VA5uUzsbRRPz
        N1ngJSsV5HvuxJ/NKXVz0/bCo5sOYwo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-nwIKaZ-hOiOizC87SvwYBQ-1; Mon, 03 Feb 2020 12:58:58 -0500
X-MC-Unique: nwIKaZ-hOiOizC87SvwYBQ-1
Received: by mail-wr1-f72.google.com with SMTP id u18so8607709wrn.11
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IOU+E+i/6GByzKomTOCcRp1Re3thOfIEFcg4mphDK8I=;
        b=kro0S/sAHclxBmUiFkGRLdXUfvtjcxd8IMpWEXIqCmSnY0L1kX2wlasFyxMouEoGAA
         1bKKVfIv/dYoF4+st9LshkiXOUJ4dt5yS8UlJgnHf0fNfyMWsR54idVPyk3rkmwS6niJ
         4jMzkSB583pnCxz6eJyI/lCJYVl7D1TbbhdQoPjYBr4IYKQRdJgZ3kXqSE/wM3kHJgM1
         +Di2h7IreChjO8SgzJHSJ25KJQ47g+UiJ2CIa+R+dgf+46Aad9hmO2J9U1hPd7oRdUSE
         OIkP5ib/1SkTdk2wn/tc107UKutPNQfqBiBtWznQA4jM6ZrfV2SjK4CM7OENjQLk+Dj0
         A/8A==
X-Gm-Message-State: APjAAAVkqdZNv8ZuJutXudKvj9fw6BPNzOcXDJ83olRtH3VIwuk7ZOrR
        rOTI8hXuXMYXXhvNhIyScGdEHxTdSli5f9iDODeYLROR9qKEBJoKiMEwTKeWq8TSHQm0JYvgcRz
        WMeKZucM1ODqiSmUcjF90
X-Received: by 2002:a1c:7717:: with SMTP id t23mr244423wmi.17.1580752737339;
        Mon, 03 Feb 2020 09:58:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqxv/GjpTFVZKpph9Aa22h8JBJkI8kYqeG0j35j6s7ealjczUZnM3HZHI+1jGA7SaslFglk47A==
X-Received: by 2002:a1c:7717:: with SMTP id t23mr244414wmi.17.1580752737131;
        Mon, 03 Feb 2020 09:58:57 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:58:56 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v2 0/7] xfs: Remove wrappers for some semaphores
Date:   Mon,  3 Feb 2020 18:58:43 +0100
Message-Id: <20200203175850.171689-1-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove some wrappers that we have in XFS around the read-write semaphore
locks.

The goal of cleanup is to remove mrlock_t structure and its mr*()
wrapper functions and replace it with native rw_semaphore type and its
native calls.

Pavel Reichl (7):
  xfs: Add xfs_is_{i,io,mmap}locked functions
  xfs: Update checking excl. locks for ilock
  xfs: Update checking read or write locks for ilock
  xfs: Update checking for iolock
  xfs: Update checking for mmaplock
  xfs: update excl. lock check for IOLOCK and ILOCK
  xfs: Replace mrlock_t by rw_semaphore

 fs/xfs/libxfs/xfs_attr.c        |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
 fs/xfs/libxfs/xfs_bmap.c        |  22 +++---
 fs/xfs/libxfs/xfs_inode_fork.c  |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c    |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |   6 +-
 fs/xfs/mrlock.h                 |  78 ----------------------
 fs/xfs/xfs_attr_list.c          |   2 +-
 fs/xfs/xfs_bmap_util.c          |   8 +--
 fs/xfs/xfs_dquot.c              |   4 +-
 fs/xfs/xfs_file.c               |   5 +-
 fs/xfs/xfs_inode.c              | 114 ++++++++++++++++++++------------
 fs/xfs/xfs_inode.h              |  10 ++-
 fs/xfs/xfs_inode_item.c         |   4 +-
 fs/xfs/xfs_iops.c               |  12 ++--
 fs/xfs/xfs_linux.h              |   1 -
 fs/xfs/xfs_qm.c                 |  12 ++--
 fs/xfs/xfs_reflink.c            |   2 +-
 fs/xfs/xfs_rtalloc.c            |   4 +-
 fs/xfs/xfs_super.c              |   6 +-
 fs/xfs/xfs_symlink.c            |   2 +-
 fs/xfs/xfs_trans_dquot.c        |   2 +-
 22 files changed, 127 insertions(+), 175 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.24.1

