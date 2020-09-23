Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF58C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47622221E8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihnpiWyi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgIWG70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWG70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97169C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so6325163plt.9
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NRmp7nbJT2O4JysLc0P9ko5RUJ5SY3EO+NukZBRj9G8=;
        b=ihnpiWyiM96jPgrYRS/FIbBmRILpcsG7HgNFEtXRv9iTkrRDwsOzlv4H6ceJNFjnhm
         lqLX1jYFPLwUKVx9vM4/aygknNaQGN7nPUUqOsCWQQIwJl6psPQc6lS0cgqjp/muQrXX
         JUVgNRqq2fVX7pwwDGhGzsSSygtccur7QPF4PBxtGk1JshInm/DT4gF2G6AuM5h4PFME
         tkdHkwT2APVrEahK5KEWeMGQXB0hJFN9x1XX1H8uLVNTxKDFRw3YPTaBxzFOk+hY40Yv
         vySxPYbzbrjJbQSHcDNzbxZ0OywpG+unDDQ/iOirG/eVQh1Q9mHi+2mEsQgYgDb5tFDa
         Qlng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NRmp7nbJT2O4JysLc0P9ko5RUJ5SY3EO+NukZBRj9G8=;
        b=ePA91G29b63ebIKEyaf/YFznVi3g74cH85aNLCTySymanqJyWcWQUIwL32QoSac+2t
         D74tnK/EhwsbITTcKCWGdfNlAZjshZ5zo6I7gbBDgg/0acvIhs6KE8l9XSwiYRlinxDG
         gHRECbbipKuwCb1YQPTQFAVmtkhkiUPVdkaG9D+xh3Hk2TkKT9lUrAKwqACOLf+nFVmN
         ayDNj9EtVhyc7lAkRzE0HJhdD/KnE81QWlsKWXfpkDRg1d9/waCHHt7f/4Ts8i8Kf+Oi
         Q1/TCxmcz6o4Ofl1SLCc/QU+f31hM0Bo9lywiRbx0CmwOT7iHTrlZdTflv90IVNAXyit
         KK0g==
X-Gm-Message-State: AOAM533VHOCqCTAA0yGzYPwBhUuanMzwGDAS8FqAvWH5iVor6rNyglDh
        +ea7qfkx9ipVn6Jdf95bPqp0AghtgUlJ
X-Google-Smtp-Source: ABdhPJxt5qHZxNFeRvmPz/ptAxgEVR7JVSZ7dv6QF9ieixYvg7UbBLgjqnEnVMhZiLdD12amUeeoKw==
X-Received: by 2002:a17:902:c404:b029:d2:564a:e41d with SMTP id k4-20020a170902c404b02900d2564ae41dmr503611plk.23.1600844365759;
        Tue, 22 Sep 2020 23:59:25 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:25 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 0/7] xfs: random fixes and code cleanup
Date:   Wed, 23 Sep 2020 14:59:11 +0800
Message-Id: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups, and there are no
connections among these patches. In order to make it easier to track,
I bundle them up and put all the scattered patches into a single patchset.

Changes for v3:
 -move the log intent/intent-done items detection helpers
  to xfs_trans.h.
 -fix the overly long line.

Changes for v2: 
 -detect intent-done items by their item ops.
 -update the commit messages.
 -code cleanup for xfs_attr_leaf_entsize_{remote,local}.

Kaixu Xia (7):
  xfs: remove the unused SYNCHRONIZE macro
  xfs: use the existing type definition for di_projid
  xfs: remove the unnecessary xfs_dqid_t type cast
  xfs: do the assert for all the log done items in xfs_trans_cancel
  xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
  xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}
  xfs: fix some comments

 fs/xfs/libxfs/xfs_attr_remote.c |  2 --
 fs/xfs/libxfs/xfs_da_format.h   | 12 ++++++------
 fs/xfs/libxfs/xfs_inode_buf.h   |  2 +-
 fs/xfs/xfs_dquot.c              |  4 ++--
 fs/xfs/xfs_linux.h              |  1 -
 fs/xfs/xfs_log_recover.c        |  7 -------
 fs/xfs/xfs_qm.c                 |  2 +-
 fs/xfs/xfs_trans.c              |  2 +-
 fs/xfs/xfs_trans.h              | 16 ++++++++++++++++
 9 files changed, 27 insertions(+), 21 deletions(-)

-- 
2.20.0

