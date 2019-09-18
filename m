Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8020BC4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 11:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DE8121929
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 11:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMPGTnBM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbfIRLru (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 07:47:50 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:44147 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730363AbfIRLru (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 07:47:50 -0400
Received: by mail-pg1-f180.google.com with SMTP id i18so3905169pgl.11;
        Wed, 18 Sep 2019 04:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cDeeeIU+8nxtTOe/K/XrvhVEeZwl4u6JRjr2w2dDRW8=;
        b=kMPGTnBM+JvEti92UddaXcYWzT7/wB0q7wiUxoS3JcP5hUG6f7HotsiVlSWVpDa6tG
         rIiIsNiB0JkZ8UAgwcG8xj+eXhDvaikSUD2Yot2oskPuROLKRtsv9hHuWFb5Uz5H+jtJ
         ILzUXgt5Evqb/HB5Y4ZKzxfK6JrGuMr3zmUqmDEVVgIodBZq6PUSlaeN678BDi6TDDzG
         NKGVQg1xI2abSe1HDGxh2TUQqXETrqrntbMqaGKhMFvLVqB7RXGiNEubl0LLIrhe6ybM
         yhXaYRdaf1iLV2MJaMk9rmOqgN/DsHbXeTgY/ki0+gvSF+2q2NTR93JhvdYWFknC9uQa
         3g5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cDeeeIU+8nxtTOe/K/XrvhVEeZwl4u6JRjr2w2dDRW8=;
        b=shuv0GKfqZ76ZGroFzdrqftUnTKQwm1D89t5/8a2i50h9RuVNAeLb277acjAHAHi0a
         EeA0Jwplj0iP1zxudrtlwcWjl4oqfrMrxlE7cH9DZ875qAUo7wz33S/UUuPSZckkn+pV
         m2gB2fdMrc1axNHKO+FZTH/5azIbfXEeidoZcUN2T0PjSVKMzZsl7ZWSilzlylo3pgb8
         eTEN8VBluNVHHAcTm2HuVCaSYmbqUdin+KR8ZW0EvOtaGtNhcfWOdwubu9DUyBFpKBW5
         CFYZ12u4Y6KUBJeeNgWYGawv3FitJDqluVyV+l/4/mpDqwN9ft4YtrdLCt0hFghgNLFC
         r27g==
X-Gm-Message-State: APjAAAVc0InxzdsENL0+4WlKn5np76mXc1bmj/sDUcdG8WRkxAQxG7Kl
        0ZvctQht1dtqdc+s/N7ZsQ==
X-Google-Smtp-Source: APXvYqzfP34H92UIFKsUiDUaysP2vq/KGnFO99mpJJfhPNN8MKaImIfQvIHaNVZqkOrqBhMFAGXtUA==
X-Received: by 2002:a62:d445:: with SMTP id u5mr3747711pfl.92.1568807269860;
        Wed, 18 Sep 2019 04:47:49 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id r187sm7402111pfc.105.2019.09.18.04.47.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:47:49 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v3 1/2] common: check if a given rename flag is supported in
 _requires_renameat2
Message-ID: <7d4b6a1d-98a1-1fcb-5ccf-991e537df77c@gmail.com>
Date:   Wed, 18 Sep 2019 19:47:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some testcases may require a special rename flag, such as RENAME_WHITEOUT,
so add support check for if a given rename flag is supported in
_requires_renameat2.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 common/renameat2  | 30 +++++++++++++++++++++++++++++-
 tests/generic/024 | 13 +++----------
 tests/generic/025 | 13 +++----------
 tests/generic/078 | 13 +++----------
 4 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/common/renameat2 b/common/renameat2
index f8d6d4f..9625d8c 100644
--- a/common/renameat2
+++ b/common/renameat2
@@ -103,10 +103,38 @@ _rename_tests()
 #
 _requires_renameat2()
 {
+	local flags=$1
+	local rename_dir=$TEST_DIR/$$
+	local cmd=""
+
 	if test ! -x src/renameat2; then
 		_notrun "renameat2 binary not found"
 	fi
-	if ! src/renameat2 -t; then
+
+	mkdir $rename_dir
+	touch $rename_dir/foo
+	case $flags in
+	"noreplace")
+		cmd="-n $rename_dir/foo $rename_dir/bar"
+		;;
+	"exchange")
+		touch $rename_dir/bar
+		cmd="-x $rename_dir/foo $rename_dir/bar"
+		;;
+	"whiteout")
+		touch $rename_dir/bar
+		cmd="-w $rename_dir/foo $rename_dir/bar"
+		;;
+	"")
+		;;
+	*)
+		rm -rf $rename_dir
+		_notrun "only support noreplace,exchange,whiteout rename flags, please check."
+		;;
+	esac
+	if ! src/renameat2 -t $cmd; then
+		rm -rf $rename_dir
 		_notrun "kernel doesn't support renameat2 syscall"
 	fi
+	rm -rf $rename_dir
 }
diff --git a/tests/generic/024 b/tests/generic/024
index 2888c66..9c1161a 100755
--- a/tests/generic/024
+++ b/tests/generic/024
@@ -29,20 +29,13 @@ _supported_fs generic
 _supported_os Linux
 
 _require_test
-_requires_renameat2
+_requires_renameat2 noreplace
 _require_test_symlinks
 
-rename_dir=$TEST_DIR/$$
-mkdir $rename_dir
-touch $rename_dir/foo
-if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
-    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
-    _notrun "fs doesn't support RENAME_NOREPLACE"
-fi
-rm -f $rename_dir/foo $rename_dir/bar
-
 # real QA test starts here
 
+rename_dir=$TEST_DIR/$$
+mkdir $rename_dir
 _rename_tests $rename_dir -n
 rmdir $rename_dir
 
diff --git a/tests/generic/025 b/tests/generic/025
index 0310efa..1ee9ad6 100755
--- a/tests/generic/025
+++ b/tests/generic/025
@@ -29,20 +29,13 @@ _supported_fs generic
 _supported_os Linux
 
 _require_test
-_requires_renameat2
+_requires_renameat2 exchange
 _require_test_symlinks
 
-rename_dir=$TEST_DIR/$$
-mkdir $rename_dir
-touch $rename_dir/foo $rename_dir/bar
-if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
-    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
-    _notrun "fs doesn't support RENAME_EXCHANGE"
-fi
-rm -f $rename_dir/foo $rename_dir/bar
-
 # real QA test starts here
 
+rename_dir=$TEST_DIR/$$
+mkdir $rename_dir
 _rename_tests $rename_dir -x
 rmdir $rename_dir
 
diff --git a/tests/generic/078 b/tests/generic/078
index 9608574..37f3201 100755
--- a/tests/generic/078
+++ b/tests/generic/078
@@ -29,20 +29,13 @@ _supported_fs generic
 _supported_os Linux
 
 _require_test
-_requires_renameat2
+_requires_renameat2 whiteout
 _require_test_symlinks
 
-rename_dir=$TEST_DIR/$$
-mkdir $rename_dir
-touch $rename_dir/foo $rename_dir/bar
-if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
-    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
-    _notrun "fs doesn't support RENAME_WHITEOUT"
-fi
-rm -f $rename_dir/foo $rename_dir/bar
-
 # real QA test starts here
 
+rename_dir=$TEST_DIR/$$
+mkdir $rename_dir
 _rename_tests $rename_dir -w
 rmdir $rename_dir
 
-- 
1.8.3.1

-- 
kaixuxia
