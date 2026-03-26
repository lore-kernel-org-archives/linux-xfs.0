Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB903921C8
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 03:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774494038; cv=none; b=Th4NkZAIZUoqiBvv/xXsu/G1nKbJ089P2RR2rYKS39IPy7jf8G5cI15kCK5BOWGDt84X3ddskLS05AnH0qgbWd+MHL/5XWrcH/bTeTW6W642I9bRnJGrGNuCYYibN8BtehXbcSy74eV6B0G8bnb7lvlatMoEweqYAwz5mnGDAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774494038; c=relaxed/simple;
	bh=cRO9tHVLeTHoPpJM2dWk/XZPaU4lj890l/QXxf2vBtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxM3DcKKowKysVRr9/Pi+QYHPH2VcwZsGnz3Nviw4Wc3pnpdI/C/sv8zx8/fXBmybiAZBw/yM6/CquNeLDF3mCgILQagMgDKzHbCJvPbh5+znoB+5tZWIeo1hOBAevTtTdYLH7BXdwl0mtP7vNBi9vcQBMn9EAFsoRY6efB5jbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TV8PsKX6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kYr+WH03; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TV8PsKX6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kYr+WH03"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774494034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TJxezbxWj0PgcgjNJGiWGoZdsZpmfcJTEi2ZEavz7K0=;
	b=TV8PsKX6YMn/LwVLK6f36RI1kpqnLt9xaSKBuxkjnjRE4kKQG4GS9n0x80iabfv1W82pb5
	+FoLz4Ab8h4YuP9z/a/K8CYEXZKZhPjQmYS8aFsQtENb0+PTYPK68IWT9OPZFuSxE5APdT
	CggMKMEbVV2kXNdxPlP5DqpUAVZiESA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-vaSGm72JMJGUx5uths_2kQ-1; Wed, 25 Mar 2026 23:00:32 -0400
X-MC-Unique: vaSGm72JMJGUx5uths_2kQ-1
X-Mimecast-MFC-AGG-ID: vaSGm72JMJGUx5uths_2kQ_1774494031
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35b96fbfc64so946461a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 20:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774494031; x=1775098831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJxezbxWj0PgcgjNJGiWGoZdsZpmfcJTEi2ZEavz7K0=;
        b=kYr+WH03UWaTwRLeKAkUxhJ4tc1zZtHPXe0s+p5ZYxT9asoOk+YIloa9kKyAAnr2ZJ
         +xT2g7hSNwAPwRPA0U2DtuVfMKHmCdfrtAB6nb/epBavcnGvPoyxmOM9W6J/E560zSUM
         GcYHC23aB05aAyS5Ib9ul96aNCEd4W11OGPGCcMEKgwrrkVgr1865TKo6XqxdqfVBw5j
         l2rd3Ac0aKgg/+J0rLgKxfzOSl1JxooJ85C8qPWbI5WYMvoNKMFu5RNHJej8K0gIkT8k
         E82e+BUZpYp/T4FDIQT2KnIFdSsbJKJv8PYMgfBpGU39g9Bv3F2J/9s+V2YHihtJPOqe
         fXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774494031; x=1775098831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TJxezbxWj0PgcgjNJGiWGoZdsZpmfcJTEi2ZEavz7K0=;
        b=g5GStIsoZal8j2oNNs8lWEDSSvlg/t+6cC5Q/gXrGO/S+lO77/KITpIw91IWKdg/Sn
         PthZbfiFimUgaf0ECf/mpj68HPCkwAMq0uuQ8h9rJ9tySLV55qllgGQidDb133TQ1VQG
         Jwk6Rra+wu9A6ZnejxHP/hkrmB8vT8iriRqKnvog2DQLeXvkr1w/XDwvyJLLZhUWckHw
         muVZp1tXelSfvSInxiMG1hNv0dIqf75/VHmEpo4DpQBhAweThOCIwTPRwO/nOdsDasw8
         NCotxkemOu8+hvWrj4lBhg6uphkpts85y9Jj5Lgth7sLiWTgMIi9fxqgyrwP/wYhMRf4
         h/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzNMH/+S/EIn4ylyH3UgqdNKpsjhMlyRQHBNktO84K5jbjVgr/Wgmmx8j2DWcG8E3hJi52al3R56M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGvFgK7Azh1pb/vWQomuYM7sXzJpfk+X2ostdyxwuH68bpo4xO
	9uFobZz5EmE4ySbWCOtmNu6BQljV9gbnNaU0n1hLxqKupVTPDorharYvtVd9o+A9R8jEr+cpVKD
	lYjOKIaYbtONyi8mhSu3xsI6WHI+6Co8dB/qkMtWWIudqwW2eQIINPbRzTGrNpZ0eAONcKQ==
X-Gm-Gg: ATEYQzwuP0CXaU6mJHiTL2W/Tvsy5CnPqnZvH/mcVuxuc+nfbTXOmYe60prFy+GFPb/
	XXBtvKXZFXyNskZ4omwjMWJ8Ux5mDZeBR/BABbPXO2+ZlTqhIc7ocfFRKh1BM2SK6luoK74xNUd
	7LctApZl9ZDNE9uuGeFLm0a+Z3YodV/bpKy2YYq8PJAAF7gdxjMPmYgFo09axreRhHsfpgj6HQG
	MrynR93bGTEO76KteCnXMN9+h6cc6IEPCSJaL1BQOUN0ASqjngpTaDovap7ik6cLc+2YI7lRy0k
	sYRCOUsFJBozm7KHJG68hpcOGPk3ycsi7P0BScqQt9QN5908BHkl+0L42YuB/uyAyikhf18idIs
	gtaAdwCiOvnsYKKizdUdKzUbTzfiL5o9log==
X-Received: by 2002:a17:90b:518e:b0:34c:904a:d92 with SMTP id 98e67ed59e1d1-35c0dd7a69cmr5050751a91.26.1774494030198;
        Wed, 25 Mar 2026 20:00:30 -0700 (PDT)
X-Received: by 2002:a17:90b:518e:b0:34c:904a:d92 with SMTP id 98e67ed59e1d1-35c0dd7a69cmr5050691a91.26.1774494029481;
        Wed, 25 Mar 2026 20:00:29 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c1dd4da95sm667932a91.6.2026.03.25.20.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 20:00:29 -0700 (PDT)
From: Donald Douwsma <ddouwsma@redhat.com>
To: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfs: test xfsdump subtree restores
Date: Thu, 26 Mar 2026 14:00:12 +1100
Message-ID: <20260326030012.1571545-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326025443.1569874-1-ddouwsma@redhat.com>
References: <20260326025443.1569874-1-ddouwsma@redhat.com>
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
 tests/xfs/995     | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/995.out |  2 ++
 2 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/995
 create mode 100644 tests/xfs/995.out

diff --git a/tests/xfs/995 b/tests/xfs/995
new file mode 100755
index 00000000..54172572
--- /dev/null
+++ b/tests/xfs/995
@@ -0,0 +1,51 @@
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
+
+_fixed_by_git_commit xfsdump XXXXXXX \
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
+_do "$XFSDUMP_PROG -L "lab_l0" -M "test" -l0 -f $tmp.dump.l0 $SCRATCH_MNT"
+
+mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/1
+
+_do "$XFSDUMP_PROG -L "lab_l2" -M "test" -l2 -f $tmp.dump.l2 $SCRATCH_MNT"
+
+dir=$(mktemp -d $SCRATCH_MNT/restore_XXX)
+_do "$XFSRESTORE_PROG -f $tmp.dump.l0 -r -s restore_me $dir"
+_do "$XFSRESTORE_PROG -f $tmp.dump.l2 -r $dir"
+
+test $? -ne 0 && exit
+
+echo Silence is golden
+# success, all done
+_exit 0
diff --git a/tests/xfs/995.out b/tests/xfs/995.out
new file mode 100644
index 00000000..776fa6f2
--- /dev/null
+++ b/tests/xfs/995.out
@@ -0,0 +1,2 @@
+QA output created by 995
+Silence is golden
-- 
2.47.3

