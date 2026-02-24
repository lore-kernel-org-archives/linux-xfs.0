Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41528364037
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 07:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917471; cv=none; b=F0aisFT1Tq/t7logcwhHVoeGKxVbZiMkLfHMewnyCYFDBPpm8GPY+nw3TcrlUUBxmLzSvkZ1hQ9i4c4vqqzjszf9j+W1Lk79rxzwgDV5Hf2EC5dJ+pqUcsl45vZXAgCcvJOzAOwa8kjEODEVt0GtBeHPDhsCdFB14qjVCYcielE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917471; c=relaxed/simple;
	bh=Y10MlmEnL18gs/3BlP+DiM13RpnwsstC5GVGRiG/iog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi/gRTT2Ul89cqEA6v0DjCkKJAZItx2RO5d5KaCuf75w9v/2Vvkezq6wuo72/dhByHMONhCNud/W8PmWpT62W0nRczrSdMl3Rzcjd7zhYEoY3swJUHVTPMNAJ5If/3xrMnLuaI7KhrJvHMmRqP0QBi1bP6LVr1xneQJmVetDBOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SE6ZjTi3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=flr8cXUx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SE6ZjTi3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="flr8cXUx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771917468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5isKmXgAILP097e6PnIqZmAg9AjJ89JDiBe8rJxSWig=;
	b=SE6ZjTi3GU46YItfyKLAMSPvUlqKOcXYY9/TkHJUn4V82Lb0sCNzHG0SvWCwbBeJuD6nco
	uwpUMnXuiINHFUcntlkdxuLquXuhrXgCYEEMcHuAlwnxXodSu+honD0M3X8rP7bgISu/7t
	NK2uib2LpfcH+N2p4F84OBm7Sx8sJkM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-dnYKRCvRNnaEnWsnmGIrwg-1; Tue, 24 Feb 2026 02:17:46 -0500
X-MC-Unique: dnYKRCvRNnaEnWsnmGIrwg-1
X-Mimecast-MFC-AGG-ID: dnYKRCvRNnaEnWsnmGIrwg_1771917465
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a79164b686so66141655ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771917465; x=1772522265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5isKmXgAILP097e6PnIqZmAg9AjJ89JDiBe8rJxSWig=;
        b=flr8cXUxh7Lu74uiGyOSyfuYTADyOYKnet74VdrgrRyTGzZIw98l8VzyZdmau7xNTS
         7WoCEQsGSl/yrHoU1fMorz2doir0i0h9RXK/bG3Nyv359CTrwYTgQLSNmlywLIJtGA2D
         lu9lt61P/iNvD3jPaH0W9+AR/el527XixEYYTmgGr5YVdJ5pYs39rXphEIXG0wdOx9Nz
         W/iz4QiOLhJtSz6IBE67NpRwYSd4ALzYJ8rA1js+S4kjwdyA+XUT2rVEUUhps96myD3Q
         0GvX2a3mHMKmkdwpSy7H6GVfLKFTmOqIDDH87TbZwf2wv6w9G1w0G1rFLRx4ywfAxm0V
         O8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917465; x=1772522265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5isKmXgAILP097e6PnIqZmAg9AjJ89JDiBe8rJxSWig=;
        b=d7md5iwTFg6nCTJQrUzpbvhpr0zLhlyNKn5HDjrRmd6sdF7OX5fEw0u92XqYYZHT+N
         iKDnudgwqnmxzFEDSDC91f2WUZkxrn8iw1OVcnf97BVNa6IT51G7bmYDsctRRht2utP+
         AGMtK3asGw0QRpEDcKYHeS9pfCGlHPNmBg0SClyInuW/5AOyMCLLr0aHjlvC5yDael8P
         4Yr98+uADZFE+wahxEEgiNQeRMYgDFEKi2d6XaL9gMpb0dHrBh7zJ4Y+/IRJyILMeode
         enRHCTr4BBP5lI9WQkWIU3VMmCt/1zdw6bCMsd6bS64azh9TyJ7K9MK+AsH/FiE57epr
         DT2A==
X-Gm-Message-State: AOJu0YxS0TXyz1MAvLtfLbj+zSwOiEQ3GNjYcbuIIts1i9VxVjXQBdlo
	b0e+sYwo7SghJv1O1edIBM2dfr/Nr49QnHLnRfS+gUAdn+5DB64MlcsNlZlA1SBF0BJlZ2voqYK
	OGqVq7zBuzIJ2LsATKSVkypk0GqU1B8XyikQTZT4q2eqiBMSyTFp78F2vAtZlZyy//xojz9K0tw
	td4Bm1soF7hxcTvDGEe1BGpinjn/YQ4Z4x0XCgqXozteLXlg==
X-Gm-Gg: ATEYQzykapsjSmvt/T3nyj1oTjBpo/RcsjsAJHrD85pGmdfJKraO+FuxqofLY9b0qXc
	Pd0x4T1wc06dDu6EV7W+sFaF2SAK/J0GGkZyrXq1rAYOKnjnreG26oITxSbSaBwsNnm17Acb8wY
	r/I3iKdUDwkuTylLLJaVfrRTOq0FcTo5wQmVDnS0OMzyzPYn5bhrRORveSFNmbSAaumiByBT7xR
	HswZDRnYoFeeJvSJWlTfGXxDCCwbMn1NgbslH93BMGhCCkhIejk8ORllJ8tORHwXIsJVf8OR3PW
	0YizvYsHcZde/W6EpT/L7WVAQdbO4HZTyZPYILOnNoHuEdfTany8P+Plzg8Raa+2rgucZ7smQRj
	Krqw7j1s0s90lm3nxbDIATiUzD9tZO7dJgQ==
X-Received: by 2002:a17:903:1212:b0:295:99f0:6c66 with SMTP id d9443c01a7336-2ad744edbf3mr122387525ad.36.1771917465263;
        Mon, 23 Feb 2026 23:17:45 -0800 (PST)
X-Received: by 2002:a17:903:1212:b0:295:99f0:6c66 with SMTP id d9443c01a7336-2ad744edbf3mr122387275ad.36.1771917464726;
        Mon, 23 Feb 2026 23:17:44 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad80907b4csm58720515ad.78.2026.02.23.23.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 23:17:43 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 5/5] xfsrestore: assert suppression workaround
Date: Tue, 24 Feb 2026 18:17:12 +1100
Message-ID: <20260224071712.1014075-6-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224071712.1014075-1-ddouwsma@redhat.com>
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow users to workaround assertions encountered during a restore by
suppressing them using 'xfsrestore -z ...`.

This is not the right approach for ongoing upstream development, but it
may be useful as a workaround for downstream maintenance releases built
without NDEBUG, even then I'm hesitant.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 include/config.h.in      |  4 ++++
 man/man8/xfsrestore.8    |  4 ++++
 restore/Makefile         |  6 ++++--
 restore/content.c        |  5 ++++-
 restore/getopt.h         |  4 ++--
 restore/restore_assert.c | 39 +++++++++++++++++++++++++++++++++++++++
 restore/restore_assert.h | 18 ++++++++++++++++++
 7 files changed, 75 insertions(+), 5 deletions(-)
 create mode 100644 restore/restore_assert.c
 create mode 100644 restore/restore_assert.h

diff --git a/include/config.h.in b/include/config.h.in
index 3b35d83..9cc6628 100644
--- a/include/config.h.in
+++ b/include/config.h.in
@@ -50,4 +50,8 @@ typedef unsigned short umode_t;
 #define NBBY 8
 #endif
 
+#if !defined(NDEBUG) && defined(RESTORE)
+#include "../restore/restore_assert.h"
+#endif
+
 #endif	/* __CONFIG_H__ */
diff --git a/man/man8/xfsrestore.8 b/man/man8/xfsrestore.8
index df7dde0..84e1b12 100644
--- a/man/man8/xfsrestore.8
+++ b/man/man8/xfsrestore.8
@@ -254,6 +254,10 @@ the dump without this option.
 In the cumulative mode, this option is required only for a base (level 0)
 dump. You no longer need this option for level 1+ dumps.
 .TP 5
+.B \-z
+If xfsrestore fails due to an assertion this option can be used to ignore it for
+the purpose of debugging or to recover data from a problematic archive.
+.TP 5
 \f3\-v\f1 \f2verbosity\f1
 .\" set inter-paragraph distance to 0
 .PD 0
diff --git a/restore/Makefile b/restore/Makefile
index ac3f8c8..5a5ee62 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -76,7 +76,8 @@ LOCALS = \
 	namreg.c \
 	node.c \
 	tree.c \
-	win.c
+	win.c \
+	restore_assert.c
 
 LOCALINCL = \
 	bag.h \
@@ -87,7 +88,8 @@ LOCALINCL = \
 	namreg.h \
 	node.h \
 	tree.h \
-	win.h
+	win.h \
+	restore_assert.h
 
 LTCOMMAND = xfsrestore
 
diff --git a/restore/content.c b/restore/content.c
index b91e5f0..71de87a 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -864,7 +864,7 @@ bool_t restore_rootdir_permissions;
 bool_t need_fixrootdir;
 char *media_change_alert_program = NULL;
 size_t perssz;
-
+int workaround_assert;
 
 /* definition of locally defined static variables *****************************/
 
@@ -1191,6 +1191,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		case GETOPT_FIXROOTDIR:
 			need_fixrootdir = BOOL_TRUE;
 			break;
+		case GETOPT_WORKAROUND:
+			workaround_assert = 1;
+			break;
 		}
 	}
 
diff --git a/restore/getopt.h b/restore/getopt.h
index b0c0c7d..4c4c2b2 100644
--- a/restore/getopt.h
+++ b/restore/getopt.h
@@ -26,7 +26,7 @@
  * purpose is to contain that command string.
  */
 
-#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wxABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
+#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wxzABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
 
 #define GETOPT_WORKSPACE	'a'	/* workspace dir (content.c) */
 #define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
@@ -53,7 +53,7 @@
 #define	GETOPT_SMALLWINDOW	'w'	/* use a small window for dir entries */
 #define GETOPT_FIXROOTDIR	'x'	/* try to fix rootdir due to bulkstat misuse */
 /*				'y' */
-/*				'z' */
+#define GETOPT_WORKAROUND	'z'	/* enable workaroundz */
 #define	GETOPT_NOEXTATTR	'A'	/* do not restore ext. file attr. */
 #define GETOPT_ROOTPERM		'B'	/* restore ownership and permissions for root directory */
 #define GETOPT_RECCHKSUM	'C'	/* use record checksums */
diff --git a/restore/restore_assert.c b/restore/restore_assert.c
new file mode 100644
index 0000000..e2f3054
--- /dev/null
+++ b/restore/restore_assert.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Red Hat, Inc. All Rights Reserved.
+ */
+
+#include <stddef.h>
+#include <stdlib.h>
+
+#include "config.h"
+
+#include "mlog.h"
+
+/*
+ * Override glibc __assert_fail to allow users to optionally ignore assertions.
+ *
+ * We could optionally require a number of assertions to skip, allowing the user
+ * to consider each problem and continue only if a specified number is not
+ * exceeded
+ */
+
+extern int workaround_assert;
+
+void __xfsrestore_assert_fail(const char *__assertion, const char *__file,
+			      unsigned int __line, const char *__function)
+{
+	static int assert_count;
+	assert_count++;
+
+	mlog(MLOG_ERROR|MLOG_NOLOCK, _("%s:%d: %s: Assertion %s failed\n"),
+			__file, __line, __function, __assertion);
+
+	if(!workaround_assert) {
+		mlog(MLOG_ERROR|MLOG_NOLOCK, _("Recovery may be possible using the `-z` option\n"));
+		abort();
+	}
+}
+
+
+
diff --git a/restore/restore_assert.h b/restore/restore_assert.h
new file mode 100644
index 0000000..8eb22e6
--- /dev/null
+++ b/restore/restore_assert.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Red Hat, Inc. All Rights Reserved.
+ */
+
+#ifndef _XFS_RESTORE_ASSERT_H_
+#define _XFS_RESTORE_ASSERT_H_
+
+#if defined(assert)
+#undef assert
+extern void __xfsrestore_assert_fail(const char *__assertion, const char *__file,
+				     unsigned int __line, const char *__function);
+#define assert(expr) \
+	((expr) ? (void)0 : \
+	__xfsrestore_assert_fail(#expr, __FILE__, __LINE__, __func__))
+#endif
+
+#endif /* _XFS_RESTORE_ASSERT_H_ */
-- 
2.47.3

