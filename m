Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA743859CB
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 06:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787989; cv=none; b=ns1i53/xub3wOlvt+IDxturwsZz63fWa+78UAy+LPEA3ODJUpiR8TU3BfNZxtWAx2fJDDHiUqkY+ExcqIuULMpSqV5I3QrCKSchhJsyfCZnnTldbY+Olw0pscaYXCEtSqEkUrXwevkvvIjZ8akVeat1VYIxTniFWvynCvK9HrJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787989; c=relaxed/simple;
	bh=pA0lLImSgJVRevmunC2Vpg+EibYOh+Ztt0tHkPfy2tc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AOQwk41Uhld1u/XpW8Pk5jGbGhahYoi6opJ1FLs7mYrXFflECBMYG0PzhpxuE34VLM9exhTCAk9MNiSkLhi5EnhEqsP0VpbpzUwcjohzfm5hdbjsUNJR0VtMvwp9y/zis3tEG0rkVPc+Nxi0/N4nVn15WFqrgf61VeljRyhIlLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HKHuJIjT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GHfw2l5Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HKHuJIjT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GHfw2l5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784787986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gsxqc3C17W6Vy4U8Xn5ssOEk0JR4LMMuxg4hsQ5Gx0Y=;
	b=HKHuJIjTzS6TFPMREn5VFDYgHb4UL9Kq1fd2nZD34fgW6HVdzHhg/wdujMNwWt38eP0SF0
	JhHRCosZ2+aClE/kBjc2ePBhlg8ojWpsDahwKPBRx4/GX9Bh814QPUiCjPost374eK1pBO
	K6F5YPqi8xatFa5DgP8mWumct1MfJlE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-suWPOkeNOdOcSmZd6YQqhg-1; Thu, 23 Jul 2026 02:26:25 -0400
X-MC-Unique: suWPOkeNOdOcSmZd6YQqhg-1
X-Mimecast-MFC-AGG-ID: suWPOkeNOdOcSmZd6YQqhg_1784787984
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84857446424so666309b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 23:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784787984; x=1785392784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gsxqc3C17W6Vy4U8Xn5ssOEk0JR4LMMuxg4hsQ5Gx0Y=;
        b=GHfw2l5QTPciDay9RtDTSK7L6F7ZLKJImjIfD1QVH8eKUObNwd+HCi4ZcH2/08bGJ+
         21snraYClnCCbvqbKIlKzn3pzYzj3/KifXs+WD5vSL/HPNGAYE7FO5cyI/m8L84YLu0G
         kwPPxA6T1vZabeaFd3zexkIRknaQtd4ynxslVeTh8CgEgSEBEEG4W1P4mxrM/lvP7KU7
         7Q9gxA2+qEfY3GJcJLAB4EpFPbzeq/toUQ0YEW4pF3YlZUu1xdw/qq945lERAxahfY3R
         697BUN6klyEgYRTWKrK6n6zJ6A+8RXa4Cd7Lywcwl82G85HoEjeFOtprv96TSWKzHZnb
         FZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784787984; x=1785392784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gsxqc3C17W6Vy4U8Xn5ssOEk0JR4LMMuxg4hsQ5Gx0Y=;
        b=WL4Hp+os+xxNGX/Y0zHkXXrLGviM+SAGhg5MFCrjgKxIeAYOnXdc9LJ2n4KOZat46Q
         bghNh8svdALP0qcA+cxzDM3ALxS78pX4H6ADus1nrbVgwEeuaJ7XX24r8Z+DnRJaFAsD
         14GO/V4VGxLH99yHjdubD0X3AGsfbdgFNSg/beAJjtiKypISPIWxo5zDdB6KfS4Na9Zr
         +LijVshpjDoUe31xBdCUGE1Q7rT3vcGi7Z9dT7CElbpcWcUd1FDofGLsJ8ELwj2EFNQ+
         nPAjFkSbm+7n1TljRx/MveWea0otK/BlpEG9304s6APy04O/6wQaSpVX/ZnGjwg9hoAK
         93lA==
X-Gm-Message-State: AOJu0Yw5MLoQ5xjlTblB0pbHk4ifilLkBPyv2qruoZECYCNCJQ/D9M08
	A7tIRKzGMcyXx7MqFIumcgaN9rV+TQQq40HSavujWLfe2yOt4GBuwZyxWx6XOtl2K+3v8ygafsl
	PdSSqGGhCpLiK1gMFl21nSCrUvztykZkLI5OStiNtXguyB2aqmStSitEhnAmScZgJR/bBm9jmRW
	aHy42Le3lLSQvb/sL7+mHnyoacj8wMKqBhmzg6YnJNlt367Q==
X-Gm-Gg: AR+sD11fTms6A9clGU9x+lt4nmrRz4H3eu8DyJcE+vbZMHFx3vIgb8ZlK4vuhD+W7sI
	/jr9bbb7+2nvuBx4wCXggsescgHqYhMr6eJQk6XEdgGlYOdCnoZzXcGUViS9AKHmxgEO5fh4552
	FVCvpZa5F47jPJuhuy9+GKbkPzXICPlPJluf0XJ6K4/w4bwlwoN1CE74l3T5bIpORwuqsqGEzQT
	FULrGP4hXQvOJjX92JPHtbLNVQ8jZyimJCXaPalFE4Jk2b++MjTN+3QVUs5ruZIbd4hzoJC5RR9
	I+MBYE08VZ3RLfVQiktoXOsYX4hjFcUK8dlipZRajEpBqvibZhlQSxG5pI8rxlNDQqCHssK0S72
	GXLPw2iZ/udk=
X-Received: by 2002:a05:6a00:2388:b0:846:7fb0:4ca2 with SMTP id d2e1a72fcca58-84e2bb462e4mr2122055b3a.61.1784787984242;
        Wed, 22 Jul 2026 23:26:24 -0700 (PDT)
X-Received: by 2002:a05:6a00:2388:b0:846:7fb0:4ca2 with SMTP id d2e1a72fcca58-84e2bb462e4mr2122023b3a.61.1784787983547;
        Wed, 22 Jul 2026 23:26:23 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b1b:d900:266e:8be8:569:ffa6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e175cf946sm2489965b3a.49.2026.07.22.23.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 23:26:22 -0700 (PDT)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v2] xfs: test xfsdump subtree restores
Date: Thu, 23 Jul 2026 16:26:17 +1000
Message-ID: <20260723062617.424905-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regression test for cumulative restores where a directory has been
renamed outside of the subtree being restored triggering the assert:

  xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
Changes since v1
- Fix use of _do, including label quoting
- Update test output
- Add tests for additional edge cases
---
 tests/xfs/995     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/995.out |  8 +++++++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/xfs/995
 create mode 100644 tests/xfs/995.out

diff --git a/tests/xfs/995 b/tests/xfs/995
new file mode 100755
index 000000000..bba0bcd52
--- /dev/null
+++ b/tests/xfs/995
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Red Hat.  All Rights Reserved.
+#
+# FS QA Test 995
+#
+# Regression test for cumulative restores where a directory has been
+# renamed outside of the subtree being restored resulting in
+#
+#   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
+#
+. ./common/preamble
+_begin_fstest auto dump
+_do_die_on_error="always"
+
+_fixed_by_git_commit xfsdump dd63de5 \
+	"xfsrestore: only process subtrees that are selected"
+
+# Override the default cleanup function.
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/dump
+
+# Modify as appropriate.
+_require_scratch
+_scratch_mkfs_xfs >>$seqres.full
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/a/b/c/d/e/f/g
+mkdir -p $SCRATCH_MNT/restore_me/B/C/D/E/F/G
+
+_do "Creating l0 dump" "$XFSDUMP_PROG -L lab_l0 -M test -l0 -f $tmp.dump.l0 $SCRATCH_MNT"
+
+mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/1
+
+_do "Creating l2 dump" "$XFSDUMP_PROG -L lab_l2.0 -M test -l2 -f $tmp.dump.l2.0 $SCRATCH_MNT"
+
+dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
+_do "Cumulative restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r $dir"
+_do "Cumulative restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
+
+dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
+_do "Cumulative subtree restore l0" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
+# The next command core dumps prior to xfsdump v3.3.0 when noref_elim_recurse attempts to
+# rename directories outside of the subtree when their parent has not been created.
+_do "Cumulative subtree restore l2" "$XFSRESTORE_PROG -f $tmp.dump.l2.0 -r $dir"
+
+dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
+_do "Restore l2 on its own" "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
+
+# success, all done
+_exit 0
diff --git a/tests/xfs/995.out b/tests/xfs/995.out
new file mode 100644
index 000000000..9a620eb31
--- /dev/null
+++ b/tests/xfs/995.out
@@ -0,0 +1,8 @@
+QA output created by 995
+Creating l0 dump... done
+Creating l2 dump... done
+Cumulative restore l0... done
+Cumulative restore l2... done
+Cumulative subtree restore l0... done
+Cumulative subtree restore l2... done
+Restore l2 on its own... done
-- 
2.52.0

