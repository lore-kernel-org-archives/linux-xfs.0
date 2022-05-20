Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C72FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 14:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350281AbiETOdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 10:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350361AbiETOc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 10:32:59 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C11A170659;
        Fri, 20 May 2022 07:32:55 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id i20-20020a05600c355400b0039456976dcaso4864706wmq.1;
        Fri, 20 May 2022 07:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yq5RXe94JIHfebnLPUEyPS0aNju0UZzYUXV+ieuqFxU=;
        b=AQYlKzLhIh01G2Qo+vTdQkBnNwokxEGqvsDmyOgs53pmajhFdIHXTmVd1I6C8EKBNk
         WfV86r1etloaXC+522k+8Qv22NeTB7KXoiyz96GT9XX1noXjGIdzT+1gC2N3lyfUNqL5
         aAN6/CUOUW5QhBSMrLWxqbakLcSWLZtBKxXQJWlrFE/xQNaZtsSP9pB9xP9DAassgTmc
         TjWiXX7Vw9b9FfRqeiPGrutBcbS+oW/XfrIWDi1piiTxXxhkHerKnc/GD/llRlzuv6JQ
         cH9hVxTaw9StCYCYemwDT6DJcuDzw5mGc+T/k0N/eBtb338Cbd8KOBoyMMPlh2aBBP94
         fMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yq5RXe94JIHfebnLPUEyPS0aNju0UZzYUXV+ieuqFxU=;
        b=pOx9m6H2iEyagrUzHH0k0AOngSN56N9rm6BzfUgmlaJypJO8j56SEpRNtoCJhxTFpi
         0BKq76guii1uo0cY1fiaBss9hjnHn8Ufpd8EO8pbTH19p2PN26CkQ2Netb0hnNc+9UeI
         Fm4bplqiu0u5SiiSGJcrx1uL7ZQ4HM8WwdwutccHBxxGsi8mAUhuoTdjMYGrFn8IMsvK
         uO/LTwcFjVrSvaO7t84v1GK7iPWEriGPxsqvtXvbEx0+7z/le59Xup3ke65g6LPxTCBJ
         OAbAHZkJcpORwpaXReTA6BQXhcYw+DscMgta2wQRJSOnjEMuBoMgpWr4hZAqNBuxAHzo
         afQw==
X-Gm-Message-State: AOAM532SIaJNAbn61K7+EDjyzyuIAGMye1KdW69w0CAOliQE7z1HZA9/
        ja44umQO/+wP2/8LY5kyQvk=
X-Google-Smtp-Source: ABdhPJyOskkfzjY7b8KkFqNbmbMrWfoJDhADZgpbnpRV0JXoUZQnFya6KLTlcnwXCS61TT3tM0yQcg==
X-Received: by 2002:a05:600c:4889:b0:397:3d4c:e098 with SMTP id j9-20020a05600c488900b003973d4ce098mr1401274wmp.106.1653057173618;
        Fri, 20 May 2022 07:32:53 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c1d9000b003973435c517sm2243641wms.0.2022.05.20.07.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:32:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: annotate fix commits for upcoming 5.10.y backports
Date:   Fri, 20 May 2022 17:32:49 +0300
Message-Id: <20220520143249.2103631-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for backporting xfs fixes to stable kernel 5.10.y,
annotate some of the tests that pass after applying the backports.

Most of the annotated tests have the fix commit documented either
in comment or in commit message already.

All tests have been verified to pass with fix commits apply, but
for a few tests, a failure was observed when running on kernel without
the documented fix commit. That is probably because failure happens
only on a specific setup.

Generic tests have also been annotated with xfs fix commits.
That may produce wrong hints if the test fails on another fs, but
that is what hints are for - to give tester a hint, so if tester is
not testing xfs, it's easy to figure out that the hint is irrelevant.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Zorro,

Here are a bunch of fixed_by annotations for xfs bug fixes,
which I am in the process of testing for stable kernel v5.10.y [1].

There are a lot more tests with fix commits documented in comments
and/or commit message, but I did not annotate any test that I did not
verify myself to pass with the fix commit.

If tests were not documented in kernel commit message nor mentioned
in the mailing list correspondance and if kernel commit or subject were
not mentioned in fstests commit message or comments, then I may have
missed those secret tests.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/xfs-5.10.y

 tests/generic/623 | 3 +++
 tests/generic/631 | 2 ++
 tests/generic/646 | 3 +++
 tests/generic/649 | 3 +++
 tests/xfs/145     | 3 +++
 tests/xfs/177     | 2 ++
 tests/xfs/513     | 3 +++
 tests/xfs/539     | 7 +++++--
 tests/xfs/542     | 3 +++
 9 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/tests/generic/623 b/tests/generic/623
index 324251b7..ea016d91 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -12,6 +12,9 @@ _begin_fstest auto quick shutdown
 . ./common/filter
 
 _supported_fs generic
+_fixed_by_kernel_commit e4826691cc7e \
+	"xfs: restore shutdown check in mapped write fault path"
+
 _require_scratch_nocheck
 _require_scratch_shutdown
 
diff --git a/tests/generic/631 b/tests/generic/631
index 219f7a05..ff1bb113 100755
--- a/tests/generic/631
+++ b/tests/generic/631
@@ -40,6 +40,8 @@ _require_scratch
 _require_attrs trusted
 _supported_fs ^overlay
 _require_extra_fs overlay
+_fixed_by_kernel_commit 6da1b4b1ab36 \
+	"xfs: fix an ABBA deadlock in xfs_rename"
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
diff --git a/tests/generic/646 b/tests/generic/646
index 79d3f17c..027df557 100755
--- a/tests/generic/646
+++ b/tests/generic/646
@@ -15,6 +15,9 @@
 _begin_fstest auto quick recoveryloop shutdown
 
 # real QA test starts here
+_supported_fs generic
+_fixed_by_kernel_commit 50d25484bebe \
+	"xfs: sync lazy sb accounting on quiesce of read-only mounts"
 
 _require_scratch
 _require_scratch_shutdown
diff --git a/tests/generic/649 b/tests/generic/649
index a6aabfaf..d6727765 100755
--- a/tests/generic/649
+++ b/tests/generic/649
@@ -33,6 +33,9 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs generic
+_fixed_by_kernel_commit 72a048c1056a \
+	"xfs: only set IOMAP_F_SHARED when providing a srcmap to a write"
+
 _require_cp_reflink
 _require_test_reflink
 _require_test_program "punch-alternating"
diff --git a/tests/xfs/145 b/tests/xfs/145
index d32e726e..5fd8dcad 100755
--- a/tests/xfs/145
+++ b/tests/xfs/145
@@ -18,6 +18,9 @@ _begin_fstest auto quick quota
 
 # real QA test starts here
 _supported_fs xfs
+_fixed_by_kernel_commit 1aecf3734a95 \
+	"xfs: fix chown leaking delalloc quota blocks when fssetxattr fails"
+
 _require_command "$FILEFRAG_PROG" filefrag
 _require_test_program "chprojid_fail"
 _require_quota
diff --git a/tests/xfs/177 b/tests/xfs/177
index 10891550..1e59bd6c 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -39,6 +39,8 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
+_fixed_by_kernel_commit f38a032b165d "xfs: fix I_DONTCACHE"
+
 _require_xfs_io_command "bulkstat"
 _require_scratch
 
diff --git a/tests/xfs/513 b/tests/xfs/513
index bfdfd4f6..85500af0 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -31,6 +31,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_fixed_by_kernel_commit 237d7887ae72 \
+	"xfs: show the proper user quota options"
+
 _require_test
 _require_loop
 _require_xfs_io_command "falloc"
diff --git a/tests/xfs/539 b/tests/xfs/539
index 4bc52c1a..77b44c89 100755
--- a/tests/xfs/539
+++ b/tests/xfs/539
@@ -9,15 +9,18 @@
 # the same value as during the mount
 #
 # Regression test for commit:
-# xfs: Skip repetitive warnings about mount options
+# 92cf7d36384b xfs: Skip repetitive warnings about mount options
 
 . ./common/preamble
 _begin_fstest auto quick mount
 
 # Import common functions.
 
-_require_check_dmesg
 _supported_fs xfs
+_fixed_by_kernel_commit 92cf7d36384b \
+	"xfs: Skip repetitive warnings about mount options"
+
+_require_check_dmesg
 _require_scratch
 
 log_tag()
diff --git a/tests/xfs/542 b/tests/xfs/542
index 5c45eed7..1540541e 100755
--- a/tests/xfs/542
+++ b/tests/xfs/542
@@ -26,6 +26,9 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
+_fixed_by_kernel_commit 5ca5916b6bc9 \
+	"xfs: punch out data fork delalloc blocks on COW writeback failure"
+
 _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "cowextsize"
-- 
2.25.1

