Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFD6C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 07:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F3A961398
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 07:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhDEHpE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 03:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhDEHpD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 03:45:03 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794E3C061756;
        Mon,  5 Apr 2021 00:44:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x126so2666302pfc.13;
        Mon, 05 Apr 2021 00:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XTBBScorhbEftP8fVZLn78ePqEjCyMTCnCUOdrrkRy4=;
        b=fB00XGgc0nyWJGSN9ZdaKIRrFpbMkjL+RZsVmN6jNRLtxQt+KOmn/AauqMWKl+Lfhp
         yZ8VPer8MIsZBBrW1KKtLfSKcyJEAFGoAQlgK0EnHjSE2ffFqOCucvOuR7tT7aw0hchv
         NUjaz4LVaGRDtE411aHZOXnkLoZ9U+AHohJDmSmGyLYjVxaMBkt8cp75hS2USOagEYKf
         IIifK9uh4ENp6eTgQR09jhCgicUixNYQ+Ty8inEkr1udScwY2pPUSlB6LQXF2tn1xZTM
         ZMsV4KBYUfrmy5ihlOlwZojFdqMZ/a01fzpMJDME0dO36yq254MwCmfWqCNgyHi1n4Lq
         nwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XTBBScorhbEftP8fVZLn78ePqEjCyMTCnCUOdrrkRy4=;
        b=eQ3sTy4/A3AYkmdH9ZlT6EnTiDK9M49iqvydMICbmPBCV9hY49jEzCFy7tX3e70XD3
         PoAkG19Cl2W49ZlLVQcvbj5Y5OOXXdnz5z3d/S58rYNo4UPc5cUGmzl6tbku7UhaXSAq
         X5OMCin6PRnd7JZ01lr5Wr5r05FjyKK6zCeJxtlnRBRV6IQcQLXg0OzbfU55TtXX3NSF
         uEwIjefYSUsIQ45Bj0nkifAknXxWSPSWSvcXUacgOF0sjD9BE8ElpJ9gYnyetH4CCHEf
         GbsbmtY2V4AvYwJPNhhXi3mdo1iP+nEsJZW0x8i7xDKck/jZ9SBWe5Pu6WoLVpojQsMm
         ySdQ==
X-Gm-Message-State: AOAM532GnjlBPABMaMUB7vSZtyQUh/CQ02Kbj+gY49wg9eHNwTbd47x3
        L+st5Mn/+tzBIN52mLg3esiRMYifIxA=
X-Google-Smtp-Source: ABdhPJwZtkN2lOHJxStxxWYltwOOan0thJCFlTHx5bEJcyys+WcdkhP0ORNtC4VdZlnfaF+aM99mCg==
X-Received: by 2002:a05:6a00:b86:b029:207:8ac9:85de with SMTP id g6-20020a056a000b86b02902078ac985demr21745145pfj.66.1617608697905;
        Mon, 05 Apr 2021 00:44:57 -0700 (PDT)
Received: from localhost.localdomain ([122.171.183.71])
        by smtp.gmail.com with ESMTPSA id y2sm8023067pji.22.2021.04.05.00.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 00:44:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH] fstests: Do not execute xfs/{532,533,538} when realtime feature is enabled
Date:   Mon,  5 Apr 2021 13:14:47 +0530
Message-Id: <20210405074447.22222-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The minimum length space allocator (i.e. xfs_bmap_exact_minlen_extent_alloc())
depends on the underlying filesystem to be fragmented so that there are enough
one block sized extents available to satify space allocation requests.

xfs/{532,533,538} tests issue space allocation requests for metadata (e.g. for
blocks holding directory and xattr information). With realtime filesystem
instances, these tests would end up fragmenting the space on realtime
device. Hence minimum length space allocator fails since the regular
filesystem space is not fragmented and hence there are no one block sized
extents available.

Thus, this commit disables execution of xfs/{532,533,538} when realtime
feature is enabled on the filesystem instance.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/532 | 1 +
 tests/xfs/533 | 1 +
 tests/xfs/538 | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tests/xfs/532 b/tests/xfs/532
index 2bed574a..5359add5 100755
--- a/tests/xfs/532
+++ b/tests/xfs/532
@@ -37,6 +37,7 @@ _supported_fs xfs
 _require_scratch
 _require_attrs
 _require_xfs_debug
+_require_no_realtime
 _require_test_program "punch-alternating"
 _require_xfs_io_error_injection "reduce_max_iextents"
 _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
diff --git a/tests/xfs/533 b/tests/xfs/533
index be909fcc..4826cccc 100755
--- a/tests/xfs/533
+++ b/tests/xfs/533
@@ -35,6 +35,7 @@ rm -f $seqres.full
 _supported_fs xfs
 _require_scratch
 _require_xfs_debug
+_require_no_realtime
 _require_test_program "punch-alternating"
 _require_xfs_io_error_injection "reduce_max_iextents"
 _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
diff --git a/tests/xfs/538 b/tests/xfs/538
index 90eb1637..53a2c060 100755
--- a/tests/xfs/538
+++ b/tests/xfs/538
@@ -35,6 +35,7 @@ rm -f $seqres.full
 _supported_fs xfs
 _require_scratch
 _require_xfs_debug
+_require_no_realtime
 _require_test_program "punch-alternating"
 _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
 
-- 
2.29.2

