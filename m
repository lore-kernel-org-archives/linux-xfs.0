Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BAF1AAE1B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868889; cv=none; b=ATUWwB4WJeYMyNoqB5FYCIgJybdRs0N3Ujp4d1BRmncmVjH0kQyCtlhlqqYMCH5zvNt6nPCj54mjq2z7koSeglk29o/LX2WjDF6TAp5EwDeGEOFCgrkIu2qH9FCzQQKkqBOUjv11qOvgS2WyvogEKiuM+YsZEV7TNtm5BDhVSTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868889; c=relaxed/simple;
	bh=R3hqRfCMpX7OqFN6uEnn9Yf+wKQefpGk6wmFFsLIcTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJxqBWOJwvw0eP2nQAJXfZDh6wIvKuN4bbiX9mYFyzxV5+Qc+S7mGP+KeAu223bg3B1iUXLPYQSArSZ43FsamC9FzskIiYYGrRzDrr3LIRKRNgz/ctTIxsIUYAjgF7J3lj37FG/ARGYsLH0wUoSr/Lt3uWLjzQxIXJHmYlkskmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5xhVzh8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5xhVzh8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724868887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJ2WVQQS48DTokQsHCpdP25vC+/ADYzTlUK9GifS8go=;
	b=D5xhVzh8OtWW1m/z8Ri4wXhzkxicmHWBgGuofVI3O/sKeU6qFijDI57rypxRZQQ2K0Xz3e
	xTitk/20YgYHotuNLwOEvG/HIWv9/d5/mDY7iJyQcHmQa8jJVi4DCfk6uzyZ6m8QkiGAzA
	keX4Y4SV+Rifa5baovWrNOsN4heq6N0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-_l8IlOuBPlmE8VlH19CA2g-1; Wed,
 28 Aug 2024 14:14:41 -0400
X-MC-Unique: _l8IlOuBPlmE8VlH19CA2g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1201E1955D53;
	Wed, 28 Aug 2024 18:14:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC40319560AD;
	Wed, 28 Aug 2024 18:14:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v2 4/4] generic: test to run fsx eof pollution
Date: Wed, 28 Aug 2024 14:15:34 -0400
Message-ID: <20240828181534.41054-5-bfoster@redhat.com>
In-Reply-To: <20240828181534.41054-1-bfoster@redhat.com>
References: <20240828181534.41054-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Filesystem regressions related to partial page zeroing can go
unnoticed for a decent amount of time. A recent example is the issue
of iomap zero range not handling dirty pagecache over unwritten
extents, which leads to wrong behavior on certain file extending
operations (i.e. truncate, write extension, etc.).

fsx does occasionally uncover these sorts of problems, but failures
can be rare and/or require longer running tests outside what is
typically run via full fstests regression runs. fsx now supports a
mode that injects post-eof data in order to explicitly test partial
eof zeroing behavior. This uncovers certain problems more quickly
and applies coverage more broadly across size changing operations.

Add a new test that runs an fsx instance (modeled after generic/127)
with eof pollution mode enabled. While the test is generic, it is
currently limited to XFS as that is currently the only known major
fs that does enough zeroing to satisfy the strict semantics expected
by fsx. The long term goal is to uncover and fix issues so more
filesystems can enable this test.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/363     | 23 +++++++++++++++++++++++
 tests/generic/363.out |  2 ++
 2 files changed, 25 insertions(+)
 create mode 100755 tests/generic/363
 create mode 100644 tests/generic/363.out

diff --git a/tests/generic/363 b/tests/generic/363
new file mode 100755
index 00000000..477c111c
--- /dev/null
+++ b/tests/generic/363
@@ -0,0 +1,23 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
+#
+# FSQA Test No. 363
+#
+# Run fsx with EOF pollution enabled. This provides test coverage for partial
+# EOF page/block zeroing for operations that change file size.
+#
+
+. ./common/preamble
+_begin_fstest rw auto
+
+_require_test
+
+# currently only xfs performs enough zeroing to satisfy fsx
+_supported_fs xfs
+
+# on failure, replace -q with -d to see post-eof writes in the dump output
+run_fsx "-q -S 0 -e 1 -N 100000"
+
+status=0
+exit
diff --git a/tests/generic/363.out b/tests/generic/363.out
new file mode 100644
index 00000000..3d219cd0
--- /dev/null
+++ b/tests/generic/363.out
@@ -0,0 +1,2 @@
+QA output created by 363
+fsx -q -S 0 -e 1 -N 100000
-- 
2.45.0

