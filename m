Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED0CEE3F09
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 18:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjILSA5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjILSA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 14:00:57 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397DEE59
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:53 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68fb7fb537dso2474646b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694541652; x=1695146452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SiDkiCWRq3U60ltc5dimWBiNHPgl9jldadxA5Kw5Y0w=;
        b=KyqtFpelVUvXDCoRip0+f2hKftAFTZogHBZXnWgPLUCiwk+ELULkdimTbZj8WxesCo
         SMbtxHZRGOkK4vh2mxnCKaGV6QWc9kfnHFo3MgDAsQ1bvR6zt6pG1SedPY+PtPjP1V9b
         zLLL6QwhVIpguwLTORMAbEouJIqzK51ChsVFDh1lGf0MGdhRxLgGUZw6YKOPBBcxQvAq
         olVkW5mXbBmT5me/u0lhiitJi7o95LNtyv1mERFotqz4rq1f+qdZZuqtAI48iWLnhiit
         Wxxp+xt9tMcQO6n/LFmB3jwQa7xOz3X74tWZoozASXEysam0Y2Ojv6PdOeydVKhu+XnA
         vHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694541652; x=1695146452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SiDkiCWRq3U60ltc5dimWBiNHPgl9jldadxA5Kw5Y0w=;
        b=iiLDsslSWC1b1+VV10xiufzDeAxHaI+UszQBZ/LJKbmTxSH5gzqp+tbChScbXf1t12
         juW/BBzqgm5LffqySQAuSXXXsJVasXhtQlNxNIxJ/UmPjkJIWreZGCt3TmrxXsMIaDS7
         DUaTHHYDsRysfPHJvrATbMCXZweUtnujQXTuregd+ihJaKUrummx2xFfK2YbgWq0P5iL
         0r000MWvJ4PmZA4w06BrjAG/e7HemW9luAgcUra+ONjVL9CmJAbz+rnC3BHEvlPADnYD
         YP2DdicNodRdxsiswhi3CuHpcjkz1n5Qpaj25qlj+lfWpem3Bu2DTHKY98AqDxxj9iFw
         hJmw==
X-Gm-Message-State: AOJu0YzlgtkITuSzfKn1A6waGrcuCukiqv+G0ewCM3tyDY/UwxjZ7h7k
        zNUaBJKgckw/Yqa3cXPmDr+UwLgltr8=
X-Google-Smtp-Source: AGHT+IFHX544CKtoQTJJvw4MW/aY4N/V+FrVqGHh2pgJ6uz3lJ/AW2iIzuEOL4xVW3ETKs6t3QQeSw==
X-Received: by 2002:a05:6a21:196:b0:154:e7e6:85c8 with SMTP id le22-20020a056a21019600b00154e7e685c8mr114601pzb.31.1694541652353;
        Tue, 12 Sep 2023 11:00:52 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:e951:d95c:9c79:d1b])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0068be7119c70sm3412246pfn.186.2023.09.12.11.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:00:52 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 0/6] 5.15 inodegc fixes
Date:   Tue, 12 Sep 2023 11:00:34 -0700
Message-ID: <20230912180040.3149181-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I have tested the inodegc fixes for 5.15 and saw no regrssions on 20
runs x 14 configs. These patches are already in 6.1.y.

The patches included are the following:

-- [PATCH 0/2] xfs: non-blocking inodegc pushes --
(https://www.spinics.net/lists/linux-xfs/msg61813.html)

7cf2b0f9611b9971d663e1fc3206eeda3b902922
[1/2] xfs: bound maximum wait time for inodegc work

5e672cd69f0a534a445df4372141fd0d1d00901d
[2/2] xfs: introduce xfs_inodegc_push()


-- [PATCHSET v2 0/4] xfs: inodegc fixes for 6.4-rc1
(https://www.spinics.net/lists/linux-xfs/msg71066.html)

03e0add80f4cf3f7393edb574eeb3a89a1db7758
[1/4] xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
(fix for 7cf2b0f9611b)

b37c4c8339cd394ea6b8b415026603320a185651
[2/4] xfs: check that per-cpu inodegc workers actually run on that cpu

2d5f38a31980d7090f5bf91021488dc61a0ba8ee
[3/4] xfs: disable reaping in fscounters scrub

2254a7396a0ca6309854948ee1c0a33fa4268cec
[4/4] xfs: fix xfs_inodegc_stop racing with mod_delayed_work


Thanks,
Leah


Darrick J. Wong (4):
  xfs: explicitly specify cpu when forcing inodegc delayed work to run
    immediately
  xfs: check that per-cpu inodegc workers actually run on that cpu
  xfs: disable reaping in fscounters scrub
  xfs: fix xfs_inodegc_stop racing with mod_delayed_work

Dave Chinner (2):
  xfs: bound maximum wait time for inodegc work
  xfs: introduce xfs_inodegc_push()

 fs/xfs/scrub/common.c     | 25 -----------
 fs/xfs/scrub/common.h     |  2 -
 fs/xfs/scrub/fscounters.c | 13 +++---
 fs/xfs/scrub/scrub.c      |  2 -
 fs/xfs/scrub/scrub.h      |  1 -
 fs/xfs/xfs_icache.c       | 92 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_icache.h       |  1 +
 fs/xfs/xfs_mount.h        |  5 ++-
 fs/xfs/xfs_qm_syscalls.c  |  9 ++--
 fs/xfs/xfs_super.c        | 12 +++--
 fs/xfs/xfs_trace.h        |  1 +
 11 files changed, 95 insertions(+), 68 deletions(-)

-- 
2.42.0.283.g2d96d420d3-goog

