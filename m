Return-Path: <SRS0=7YMi=XG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A579BC5ACAE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Sep 2019 13:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF9E21D79
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Sep 2019 13:15:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lK4+07D4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfIKNP0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 09:15:26 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:46360 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfIKNPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Sep 2019 09:15:23 -0400
Received: by mail-pg1-f171.google.com with SMTP id m3so11477610pgv.13;
        Wed, 11 Sep 2019 06:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Zl47yPfH6Kr1EkOq5zkhn2geLdB2W2XZBg+b14i8BaI=;
        b=lK4+07D4HLclYc6K+rIPH98Jp7NOWEEDtlBhNKrVCPU3iTLUlSNfL//7qqN+ORHmA1
         Q2/xWvRIG/oTJfCq64vB+O3XKSYWukbl9y6L73Xk6u9Wm64Qh6ESizJSMQcg7sOYkXAN
         eP2uf6r3p5ZEDA8V10TxZXTlrYYljFSD8bDyD3pHze4acH2CpRqkNw9fbgkKf0cE4lWm
         5ekgUhJ+/RTaO3s+5lVCZ/phgqDPwg8paFOnBCtg6XWhlF0EWEDm6vRiANDEiZbKWkvx
         TeKY7/VgxEem8jRJSoWsm4t74eqaJ/ElptfKacmiGAPZZhOZLNC2t8Eu68D1PDCMa9/J
         ySOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Zl47yPfH6Kr1EkOq5zkhn2geLdB2W2XZBg+b14i8BaI=;
        b=L01sBVY4nsAWUQm2WDNdnNa6PTzhOhAVNaQrk2Vmw8RfdJEmE1qkZ1uf1K57AHsLD9
         4awosMJCMFKTskSrrIyHPmpd9YOGlH4BbOvUCOABIoYUtD2rfzo1p8WIYglxMTx3CHB9
         80xtcvomSnOzLCF3zq96XMkSEskSyBgev/8bWsSMeX8ET9rKkUPjldA863uydMbOjfRf
         nvgPdWqbU0od5jURBlzvqvHOdLBOWiqQcpP2ghQlOMxZaxH6bUWkNnOwr+MmAPvf5Rwh
         La5KNgHkUrJg6y2fPUqYeQcKmeY40PuuTf9pNBw+MrQktf8Lc70cAVWX/+2MJTSVdWD4
         cAUw==
X-Gm-Message-State: APjAAAWouW82Q/CVRNFL1mj1j5oi4Vi9ggzsM5PVzWvm5tYBrDJXN3DK
        eRZ0r0VdHMs4/S4zpI+N3Q==
X-Google-Smtp-Source: APXvYqyBzr/77EVk89VRsZoRnsDqDe8KmT7Ns0dDL87RbdGPS86b3te4ZiaDbvNMppOn8jpus8J0Xg==
X-Received: by 2002:aa7:8c56:: with SMTP id e22mr979004pfd.255.1568207720742;
        Wed, 11 Sep 2019 06:15:20 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id w26sm23706249pfi.140.2019.09.11.06.15.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:15:20 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH 1/2] common: check if a given rename flag is supported in
 _requires_renameat2
Message-ID: <719f7bb3-96db-7563-56d8-56ed765fabc4@gmail.com>
Date:   Wed, 11 Sep 2019 21:15:16 +0800
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
 common/renameat2  | 41 +++++++++++++++++++++++++++++++++++++++--
 tests/generic/024 | 13 +++----------
 tests/generic/025 | 13 +++----------
 tests/generic/078 | 13 +++----------
 4 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/common/renameat2 b/common/renameat2
index f8d6d4f..7bb81e0 100644
--- a/common/renameat2
+++ b/common/renameat2
@@ -103,10 +103,47 @@ _rename_tests()
 #
 _requires_renameat2()
 {
+	local flags=$1
+	local rename_dir=$TEST_DIR/$$
+
 	if test ! -x src/renameat2; then
 		_notrun "renameat2 binary not found"
 	fi
-	if ! src/renameat2 -t; then
-		_notrun "kernel doesn't support renameat2 syscall"
+
+	if test -z "$flags"; then
+		src/renameat2 -t
+		[ $? -eq 0 ] || _notrun "kernel doesn't support renameat2 syscall"
+		return
 	fi
+
+	case $flags in
+	"noreplace")
+		mkdir $rename_dir
+		touch $rename_dir/foo
+		if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
+			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
+			_notrun "fs doesn't support RENAME_NOREPLACE"
+		fi
+		;;
+	"exchange")
+		mkdir $rename_dir
+		touch $rename_dir/foo $rename_dir/bar
+		if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
+			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
+			_notrun "fs doesn't support RENAME_EXCHANGE"
+		fi
+		;;
+	"whiteout")
+		mkdir $rename_dir
+		touch $rename_dir/foo $rename_dir/bar
+		if ! src/renameat2 -t -w $rename_dir/foo $rename_dir/bar; then
+			rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
+			_notrun "fs doesn't support RENAME_WHITEOUT"
+		fi
+		;;
+	*)
+		_notrun "only support noreplace,exchange,whiteout rename flags, please check."
+		;;
+	esac
+	rm -fr $rename_dir
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
