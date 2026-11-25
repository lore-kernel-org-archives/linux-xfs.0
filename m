Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642127;
	b=N4kfUp0pPzEg8o72hGZ5avWVDWhC6VG/310pBavyFQ9aHjiPgBMJGpiepoNvjg1smISO
	 LM11QNDnfdDgxDbjiK8jdqH//PHz422VqNdgOJYLGENMADsk7INRbneVwyn3pW1hPAcoe
	 n6fgOdZG+wzFyskauV5kMpP7F/2UWkT9ImSoz/y0K+oDAbt4WWco1Nt/kxHrw1ggw2rjP
	 SfL4yZxkgrCmoWjMuNN7rG5EvPyEAv9+KGc1e0vlDpqOTfDRAdeK8okDbi7Sn9/BvfJ31
	 AA51DGaLfABbuNTgduxpyO/QjFRiU1RNo5k3sbAlRU84h8CJ74GPwdEHcrXQyF05Z0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dk5fd/veALDy/3gfJm+WD8aNXPmeT9CzfnrCojlXmOU=;
	b=nXVnCjXy4QpiNOiF0vB7l2vvGush4PXUXwbRi6mAi7xFe7VJH9W9vuBBV0iL4PN2mxuU
	 bdE5dsmdjHRSj7OaHWKZA6Y+rII/8Y/AcbZfhG/l1zDoQXYyTvj/zbGr60fUHURiR0t61
	 dfid3cgNzP+NWd32a1YTuKo1E5IY6zMa7kcvCgZisPYN3dcalGEdE2mf0ELcPwPEse0gu
	 BFJ1BBqrbneJQiJc1U9L3TEh4omfRoxzDyBy89lwSkqCSM1rhVhJglN6PKp+Xc8DIMlLw
	 dE6GYxJMXtjk1rebzT4mkDyQ80v13uWpeuFjm2Ht3CElb3XXkiD/MgDqNgz4BZo5RyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhxwrpzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD3606A68B;
	Wed, 25 Nov 2026 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhxwrpzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C061F000C0;
	Wed, 25 Nov 2026 21:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642127;
	bh=dk5fd/veALDy/3gfJm+WD8aNXPmeT9CzfnrCojlXmOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhxwrpzPmJ4snLsOXwWw4qNbLj3XXLRpRd1DxFu8M0p1CexGdoRgJdCDdGEU9/VZ8
	 q3fk+QasvJ+V1v/jtet4EgRIO1wKCk2CpPhAwKAvC3SC0Q1jlohlPXLQgCMUCk+8yj
	 dypjsr0XpVinITNrD1YeJEmKoc9Pmz0XiXpseXkQ3HlrefW5ds4n5gv3S1aSpBaoGb
	 RcBCXInT2qn0gYFGQMjLNhRbJ4U/Wj8CQlibLwOzxtlTir9H1lpYRcpaQDjxrjSatu
	 2KjrDfMuXwp56pb5bQayHZua2cfjXx6SdEPfWFd0lyOhUTt6G8Fy31H8WDEQPGHymg
	 7WgZ2br6oEBng==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 3/6] check: introduce pre-test hook and CLI option
Date: Thu, 26 Nov 2026 05:28:20 +0800
Message-ID: <20261125212823.3389430-4-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261125212823.3389430-1-zlang@kernel.org>
References: <20261125212823.3389430-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the --hook-pre-test option and run matching hooks right before
each test is executed. Hooks are validated during option parsing,
before any tests run.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/check b/check
index afe855bc..a90b2d6d 100755
--- a/check
+++ b/check
@@ -48,6 +48,7 @@ export DIFF_LENGTH=${DIFF_LENGTH:=10}
 timestamp=${TIMESTAMP:=false}
 . common/exit
 . common/test_names
+. common/hooks
 
 rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
 
@@ -75,6 +76,9 @@ General options:
     -T                      output timestamps
     -R fmt[,fmt]            generate report in formats specified. Supported
                               formats: xunit, xunit-quiet
+    --hook-pre-test path=script[,mode=in|out][,match=glob]...
+                            run a hook before each matching test; may be
+                              given multiple times
     --exact-order           run tests in the exact order specified
     --extra-space <size>    require minimum free space on scratch device
     --fs <type>             test the given FSTYP; valid types include:
@@ -388,7 +392,7 @@ process_remain_tests()
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,hook-pre-test:"
 
 	compat_old_option "$@"
 
@@ -489,6 +493,10 @@ parse_check_args()
 			do_report=true
 			shift
 			;;
+		--hook-pre-test)
+			_hook_parse_args pre-test "$2"
+			shift
+			;;
 		--large-fs)
 			export LARGE_SCRATCH_DEV=yes
 			;;
@@ -1054,7 +1062,7 @@ function run_section()
 		mkdir -p $RESULT_DIR
 		rm -f ${RESULT_DIR}/require_scratch*
 		rm -f ${RESULT_DIR}/require_test*
-		rm -f $seqres.out.bad $seqres.hints $seqres.out.good
+		rm -f $seqres.out.bad $seqres.hints $seqres.out.good $seqres.hooks
 
 		# check if we really should run it
 		if _expunge_test $seqnum; then
@@ -1092,6 +1100,7 @@ function run_section()
 		(echo 1 > $DEBUGFS_MNT/clear_warn_once) > /dev/null 2>&1
 
 		test_start_time="$(date +"%F %T")"
+		_hook_run_event pre-test "$seqnum"
 		if [ "$DUMP_OUTPUT" = true ]; then
 			_run_seq 2>&1 | tee $tmp.out
 			# Because $? would get tee's return code
-- 
2.56.0

