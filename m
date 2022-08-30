Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD1DC0502A
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 04:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiH3Eo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 00:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiH3Eo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 00:44:56 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843A7DEE2;
        Mon, 29 Aug 2022 21:44:52 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id r6so7728609qtx.6;
        Mon, 29 Aug 2022 21:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7um5tc2TqBsS5S6PFEgc8Tu0L28VgIvZFKguidRwRhQ=;
        b=GyXZ1J4NSdVkO+ZCtPNRgq3TXKI2Q+qUPkMAhxbfCi3qKuCs7aVu9yQCm1GiFQe2xY
         L9oi3j+Y+uMIukpiG54pQCEaG08lXWJQrZD1KfCYBWtPSbjZewbLPXsjPAjspeiS5usP
         Zvby/Izc5g4PIGpx1L2jCiFI6/pZw2kehBhdb84YPTYe8N/M3kg1L9T8XIENuzYSLPRF
         cIdpEwAnQ0se5H6X6YoOjCBJBPJibMltrSWJ1StEvxFCl3Jkdsa7UjGOWrFxBecRV27I
         Cimo5SvSHkP5qYnl6Azd3JzgA/Hke+LIYLlbolqdDgqpAIHasCFg3tWVCHQfXncYAc/b
         JroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7um5tc2TqBsS5S6PFEgc8Tu0L28VgIvZFKguidRwRhQ=;
        b=22P2sSbIfHmb19mNEHYcK7HeNW9yVICG2jBj4WnomOJ7iqU+A6HkwSYybC3co9fbsX
         T+KeZD/XEvE0i3pT37hnUHE8A6GV/B9Rb3Yd+65EcA9NzqlHqPWNn/sP8IuIEcp5vHrr
         35DO6hagOAVWbwCZqO3P0H8jPMdLxNLHcWGjVsuCLoGtHfyItQASWDgYfFAZqCo0gxUX
         oiUY5AmhOitkj6anxRyQPbfXE+zfJajx6/BcCcZCdkvBDQCw7aPtqxnt0WTLFbWl0vfA
         PJ4poygUNosMOtxiuYiWFfkd0Q4EqdQoBfXC39Jrb6pEcHct4Z0HI/5NjHRgL9MG6Hs2
         gw4w==
X-Gm-Message-State: ACgBeo1XaUYV1ErNisHeP9YSnotO0PYwbAApLeHOuH5RrzBJSTAzhIK2
        SyAHaducMBlPqXnnVQAHqXrj/mTaf6s=
X-Google-Smtp-Source: AA6agR73cCDGv4TbFGhiFhABPrciCBsmV59v8WPPg1BQmhoUMNjcbeewT9E/DJanJutePDueKXlq8g==
X-Received: by 2002:ac8:5f83:0:b0:344:6dad:90a3 with SMTP id j3-20020ac85f83000000b003446dad90a3mr12937314qta.9.1661834690919;
        Mon, 29 Aug 2022 21:44:50 -0700 (PDT)
Received: from xzhouw.hosts.qa.psi.rdu2.redhat.com ([66.187.232.127])
        by smtp.gmail.com with ESMTPSA id bj11-20020a05620a190b00b006b60d5a7205sm7478585qkb.51.2022.08.29.21.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 21:44:50 -0700 (PDT)
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/4] tests: increase xfs log size
Date:   Tue, 30 Aug 2022 12:44:31 +0800
Message-Id: <20220830044433.1719246-3-jencce.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220830044433.1719246-1-jencce.kernel@gmail.com>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since this xfsprogs commit:
	6e0ed3d19c54 mkfs: stop allowing tiny filesystems
XFS requires filesystem log size bigger then 64m(so does AG size).

Increase thoese numbers to 64m at least.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 common/log            |    8 +-
 common/xfs            |    4 +-
 tests/generic/054.out | 1410 -----------------------------------------
 tests/generic/055.out |  126 ----
 tests/xfs/078         |    2 +-
 tests/xfs/171         |   10 +-
 tests/xfs/171.out     |    8 +-
 tests/xfs/172         |    4 +-
 tests/xfs/172.out     |    4 +-
 tests/xfs/173         |   10 +-
 tests/xfs/173.out     |    8 +-
 tests/xfs/206         |    2 +-
 tests/xfs/250         |    6 +-
 tests/xfs/259         |    2 +-
 tests/xfs/445         |    2 +-
 15 files changed, 36 insertions(+), 1570 deletions(-)

diff --git a/common/log b/common/log
index 154f3959..1b420046 100644
--- a/common/log
+++ b/common/log
@@ -334,7 +334,7 @@ _mkfs_log()
 {
     # create the FS
     # mkfs options to append to log size otion can be specified ($*)
-    export MKFS_OPTIONS="-l size=2000b -l lazy-count=1 $*"
+    export MKFS_OPTIONS="-l size=64m -l lazy-count=1 $*"
     _full "mkfs"
     _scratch_mkfs_xfs >>$seqres.full 2>&1
     if [ $? -ne 0 ] ; then 
@@ -542,17 +542,17 @@ _require_logstate()
     esac
 }
 
+# Due to minimum log size increased to 64m, small bugsize without bigger
+# su value causes mount to fail with:
+#    "logbuf size must be greater than or equal to log stripe size"
 _xfs_log_config()
 {
     echo "# mkfs-opt             mount-opt"
     echo "# ------------------------------"
-    echo "  version=2            logbsize=32k"
     echo "  version=2,su=4096    logbsize=32k"
     echo "  version=2,su=32768   logbsize=32k"
     echo "  version=2,su=32768   logbsize=64k"
-    echo "  version=2            logbsize=64k"
     echo "  version=2,su=64k     logbsize=64k"
-    echo "  version=2            logbsize=128k"
     echo "  version=2,su=128k    logbsize=128k"
     echo "  version=2            logbsize=256k"
     echo "  version=2,su=256k    logbsize=256k"
diff --git a/common/xfs b/common/xfs
index efabb0ad..8f0a4057 100644
--- a/common/xfs
+++ b/common/xfs
@@ -82,10 +82,10 @@ _scratch_find_xfs_min_logblocks()
 {
 	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
 
-	# The smallest log size we can specify is 2M (XFS_MIN_LOG_BYTES) so
+	# The smallest log size we can specify is 64M (XFS_MIN_LOG_BYTES) so
 	# pass that in and see if mkfs succeeds or tells us what is the
 	# minimum log size.
-	local XFS_MIN_LOG_BYTES=2097152
+	local XFS_MIN_LOG_BYTES=67108864
 
 	# Try formatting the filesystem with all the options given and the
 	# minimum log size.  We hope either that this succeeds or that mkfs
diff --git a/tests/generic/054.out b/tests/generic/054.out
index 4654bde7..d2b498f1 100644
--- a/tests/generic/054.out
+++ b/tests/generic/054.out
@@ -3290,1413 +3290,3 @@ clean log
 
 *** filesystem is checked ok ***
 
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls SCRATCH_MNT ***
-
-00
-01
-02
-03
-04
-05
-06
-07
-08
-09
-10
-11
-12
-13
-14
-15
-16
-17
-18
-19
-20
-21
-22
-23
-24
-25
-26
-27
-28
-29
-30
-31
-32
-33
-34
-35
-36
-37
-38
-39
-40
-41
-42
-43
-44
-45
-46
-47
-48
-49
-50
-51
-52
-53
-54
-55
-56
-57
-58
-59
-60
-61
-62
-63
-64
-65
-66
-67
-68
-69
-70
-71
-72
-73
-74
-75
-76
-77
-78
-79
-80
-81
-82
-83
-84
-85
-86
-87
-88
-89
-90
-91
-92
-93
-94
-95
-96
-97
-98
-99
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
diff --git a/tests/generic/055.out b/tests/generic/055.out
index 048ef1e1..06aa6e5b 100644
--- a/tests/generic/055.out
+++ b/tests/generic/055.out
@@ -294,129 +294,3 @@ clean log
 
 *** filesystem is checked ok ***
 
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** calling fsstress -p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10            -f rename=30 -f stat=30 -f unlink=30 -f truncate=20 -m8 -n 10000 ***
-
-
-*** ls -RF SCRATCH_MNT ***
-
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls -RF SCRATCH_MNT ***
-
-
-*** diff ls before and after ***
-
-Files TMP.ls1 and TMP.ls2 are identical
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** calling fsstress -p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10            -f rename=30 -f stat=30 -f unlink=30 -f truncate=20 -m8 -n 10000 ***
-
-
-*** ls -RF SCRATCH_MNT ***
-
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls -RF SCRATCH_MNT ***
-
-
-*** diff ls before and after ***
-
-Files TMP.ls1 and TMP.ls2 are identical
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
-
-*** mkfs ***
-
-
-*** mount ***
-
-
-*** calling fsstress -p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10            -f rename=30 -f stat=30 -f unlink=30 -f truncate=20 -m8 -n 10000 ***
-
-
-*** ls -RF SCRATCH_MNT ***
-
-
-*** godown ***
-
-
-*** unmount ***
-
-
-*** logprint after going down... ***
-
-dirty log
-
-*** mount with replay ***
-
-
-*** ls -RF SCRATCH_MNT ***
-
-
-*** diff ls before and after ***
-
-Files TMP.ls1 and TMP.ls2 are identical
-
-*** unmount ***
-
-
-*** logprint after mount and replay... ***
-
-clean log
-
-*** filesystem is checked ok ***
-
diff --git a/tests/xfs/078 b/tests/xfs/078
index 9a24086e..0ee07755 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -104,7 +104,7 @@ _grow_loop $((168024*4096)) 1376452608 4096 1
 
 # Some other blocksize cases...
 _grow_loop $((168024*4096)) 1376452608 2048 1
-_grow_loop $((168024*4096)) 1376452608 512 1 16m
+_grow_loop $((168024*4096)) 1376452608 512 1 70m
 _grow_loop $((168024*4096)) 688230400 1024 1
 
 # Other corner cases suggested by dgc
diff --git a/tests/xfs/171 b/tests/xfs/171
index f93b6011..8e622251 100755
--- a/tests/xfs/171
+++ b/tests/xfs/171
@@ -35,12 +35,12 @@ _set_stream_timeout_centisecs 12000
 # for small filesystems, so we make sure there's one more AG than filestreams
 # to encourage the allocator to skip whichever AG owns the log.
 #
-# This test exercises 64x 16MB AGs, 8 filestreams, 100 files per stream, and
+# This test exercises 64x 68MB AGs, 32 filestreams, 100 files per stream, and
 # 1MB per file.
-_test_streams 65 16 8 100 1 1 0
-_test_streams 65 16 8 100 1 1 1
-_test_streams 65 16 8 100 1 0 0
-_test_streams 65 16 8 100 1 0 1
+_test_streams 65 68 32 100 1 1 0
+_test_streams 65 68 32 100 1 1 1
+_test_streams 65 68 32 100 1 0 0
+_test_streams 65 68 32 100 1 0 1
 
 status=0
 exit
diff --git a/tests/xfs/171.out b/tests/xfs/171.out
index 73f73c90..e902e900 100644
--- a/tests/xfs/171.out
+++ b/tests/xfs/171.out
@@ -1,20 +1,20 @@
 QA output created by 171
-# testing 65 16 8 100 1 1 0 ....
+# testing 65 68 32 100 1 1 0 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + passed, streams are in seperate AGs
-# testing 65 16 8 100 1 1 1 ....
+# testing 65 68 32 100 1 1 1 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + passed, streams are in seperate AGs
-# testing 65 16 8 100 1 0 0 ....
+# testing 65 68 32 100 1 0 0 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + passed, streams are in seperate AGs
-# testing 65 16 8 100 1 0 1 ....
+# testing 65 68 32 100 1 0 1 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
diff --git a/tests/xfs/172 b/tests/xfs/172
index 56c2583b..1176f8c6 100755
--- a/tests/xfs/172
+++ b/tests/xfs/172
@@ -43,8 +43,8 @@ _check_filestreams_support || _notrun "filestreams not available"
 # for buffered, succeed for direct I/O.
 _set_stream_timeout_centisecs 50
 
-_test_streams 8 16 4 8 3 1 0 fail
-_test_streams 64 16 20 10 1 0 1
+_test_streams 8 68 4 8 12 1 0 fail
+_test_streams 64 68 20 10 4 0 1
 
 status=0
 exit
diff --git a/tests/xfs/172.out b/tests/xfs/172.out
index ec2bcf67..894200fd 100644
--- a/tests/xfs/172.out
+++ b/tests/xfs/172.out
@@ -1,10 +1,10 @@
 QA output created by 172
-# testing 8 16 4 8 3 1 0 fail ....
+# testing 8 68 4 8 12 1 0 fail ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + expected failure, matching AGs
-# testing 64 16 20 10 1 0 1 ....
+# testing 64 68 20 10 4 0 1 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
diff --git a/tests/xfs/173 b/tests/xfs/173
index 6b18d919..62416d62 100755
--- a/tests/xfs/173
+++ b/tests/xfs/173
@@ -32,12 +32,12 @@ _set_stream_timeout_centisecs 12000
 # filesystems, so we make sure there's one more AG than filestreams to
 # encourage the allocator to skip whichever AG owns the log.
 #
-# Exercise 65x 16MB AGs, 32/33 filestreams, 8 files per stream, and 2MB per
+# Exercise 65x 68MB AGs, 32/33 filestreams, 8 files per stream, and 9MB per
 # file.
-_test_streams 65 16 34 8 2 1 1 fail
-_test_streams 65 16 32 8 2 0 1
-_test_streams 65 16 34 8 2 0 0 fail
-_test_streams 65 16 32 8 2 1 0
+_test_streams 65 68 34 8 9 1 1 fail
+_test_streams 65 68 32 8 9 0 1
+_test_streams 65 68 34 8 9 0 0 fail
+_test_streams 65 68 32 8 9 1 0
 
 status=0
 exit
diff --git a/tests/xfs/173.out b/tests/xfs/173.out
index 705c352a..accbb010 100644
--- a/tests/xfs/173.out
+++ b/tests/xfs/173.out
@@ -1,20 +1,20 @@
 QA output created by 173
-# testing 65 16 34 8 2 1 1 fail ....
+# testing 65 68 34 8 9 1 1 fail ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + expected failure, matching AGs
-# testing 65 16 32 8 2 0 1 ....
+# testing 65 68 32 8 9 0 1 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + passed, streams are in seperate AGs
-# testing 65 16 34 8 2 0 0 fail ....
+# testing 65 68 34 8 9 0 0 fail ....
 # streaming
 # sync AGs...
 # checking stream AGs...
 + expected failure, matching AGs
-# testing 65 16 32 8 2 1 0 ....
+# testing 65 68 32 8 9 1 0 ....
 # streaming
 # sync AGs...
 # checking stream AGs...
diff --git a/tests/xfs/206 b/tests/xfs/206
index cb346b6d..a813ac44 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -69,7 +69,7 @@ mkfs_filter()
 
 # mkfs slightly smaller than that, small log for speed.
 echo "=== mkfs.xfs ==="
-mkfs.xfs -f -bsize=4096 -l size=32m -dagsize=76288719b,size=3905982455b \
+mkfs.xfs -f -bsize=4096 -l size=64m -dagsize=76288719b,size=3905982455b \
 	 $tmpfile  | mkfs_filter
 
 mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
diff --git a/tests/xfs/250 b/tests/xfs/250
index 8af32711..48a1eb19 100755
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -56,8 +56,10 @@ _test_loop()
 	$MKFS_XFS_PROG -d $dparam \
 		| _filter_mkfs 2>/dev/null
 
+	# _fail to avoid writing $TEST_DIR
 	echo "*** mount loop filesystem"
-	mount -t xfs -o loop $LOOP_DEV $LOOP_MNT
+	mount -t xfs -o loop $LOOP_DEV $LOOP_MNT ||
+		_fail "failed to mount loopback mount point"
 
 	echo "*** preallocate large file"
 	$XFS_IO_PROG -f -c "resvsp 0 $fsize" $LOOP_MNT/foo | _filter_io
@@ -69,7 +71,7 @@ _test_loop()
 	 _check_xfs_filesystem $LOOP_DEV none none
 }
 
-_test_loop 50g 16m 40G
+_test_loop 50g 68m 40G
 echo "*** done"
 status=0
 exit
diff --git a/tests/xfs/259 b/tests/xfs/259
index 88e2f3ee..8829e76b 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -49,7 +49,7 @@ for del in $sizes_to_check; do
 			>/dev/null 2>&1 || echo "dd failed"
 		lofile=$(losetup -f)
 		losetup $lofile "$testfile"
-		$MKFS_XFS_PROG -l size=32m -b size=$bs $lofile |  _filter_mkfs \
+		$MKFS_XFS_PROG -l size=64m -b size=$bs $lofile |  _filter_mkfs \
 			>/dev/null 2> $tmp.mkfs || echo "mkfs failed!"
 		. $tmp.mkfs
 		sync
diff --git a/tests/xfs/445 b/tests/xfs/445
index 9c55cac7..238d6514 100755
--- a/tests/xfs/445
+++ b/tests/xfs/445
@@ -47,7 +47,7 @@ _check_filestreams_support || _notrun "filestreams not available"
 unset SCRATCH_RTDEV
 
 # use small AGs for frequent stream switching
-_scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1 ||
+_scratch_mkfs_xfs -d agsize=68m,size=2g >> $seqres.full 2>&1 ||
 	_fail "mkfs failed"
 _scratch_mount "-o filestreams"
 
-- 
2.31.1

