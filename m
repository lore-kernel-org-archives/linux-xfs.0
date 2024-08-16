Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F38280045
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 19:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837208; cv=none; b=Xo3OGlQREP4I43FKFOacUOOn61U3QXSRQnPUg+0b/Jp07tmyLN2VzpOoobg+8fP9W7mS9oIXiDewI7AKe+TW4Enqfk9tgvvx6ySBZ4VcFufC/O1NuL447XNC89UjjUpzK7XscITtlkFySqI4H37O+yCnhihg/XHI6RSxG0qx4S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837208; c=relaxed/simple;
	bh=mPropUM+eFiGbbX32pCOLNyyfBDgTnVctH/GTPG5Rkk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y2Lrruy4+EuOI3g0dvBXx4aApn0bFmIGbdoE650UgtWl/OlP/V13xzKvOM2bUP5xelbyizMSUWNkYr5Liq5fJbLnZ/YZSYJ1/jPQvO7ZxQq2eCiINFVHQDoPzzUjECdTj+rLpZGq7mmmsz1st5rEwmj3fPidNm0qSJ6DQV6537E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVgV/mo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVgV/mo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D52C32782;
	Fri, 16 Aug 2024 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723837207;
	bh=mPropUM+eFiGbbX32pCOLNyyfBDgTnVctH/GTPG5Rkk=;
	h=From:To:Cc:Subject:Date:From;
	b=qVgV/mo1rufqIXeqlIPCDjBIHWVMDFuuLG7npEpPLOTSD9mQrVsJcKD2r7TVEbzx/
	 OjGtoqL/bJs65+wxUnlmz4I6CjzcyvfTctf3hyi/FGAW9EvA6aNkjCxot0r6KG2h7Y
	 n/bP1n6qtdnwj05xHYvqMRm5+BZaOv80H2a4U+5RBaoUO/QJcF6eJieOxMYZCFi2A1
	 AkRyHJzy63TBNM4/iXTjn4/q+Gph60dkY+9KmV5dlxYI5+xsqUt4Iu6q8LmODJHSmd
	 9YWeBCdnPMc8Jn6S40cXP3jayJAkECQ2ph1AsfRWJbruuKjHh+5v2RK9l/EidUYeCd
	 Q/CayYgAJBN5A==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: ebiggers@google.com,
	wbx@openadk.org
Subject: [PATCH] xfs_io: Fix fscrypt macros ordering
Date: Fri, 16 Aug 2024 21:39:38 +0200
Message-ID: <20240816193957.42626-1-cem@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

We've been reported a failure to build xfsprogs within buildroot's
environment when they tried to upgrade xfsprogs from 6.4 to 6.9:

encrypt.c:53:36: error: 'FSCRYPT_KEY_IDENTIFIER_SIZE' undeclared
here (not in a function)
        53 |         __u8
master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
           |
^~~~~~~~~~~~~~~~~~~~~~~~~~~
     encrypt.c:61:42: error: field 'v1' has incomplete type
        61 |                 struct fscrypt_policy_v1 v1;
           |                                          ^~

They were using a kernel version without FS_IOC_GET_ENCRYPTION_POLICY_EX
set and OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2 was unset.
This combination caused xfsprogs to attempt to define fscrypt_policy_v2
locally, which uses:
	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];

The problem is FSCRYPT_KEY_IDENTIFIER_SIZE is only after this block of
code, so we need to define it earlier.

This also attempts to use fscrypt_policy_v1, which is defined only
later.

To fix this, just reorder both ifdef blocks, but we need to move the
definition of FS_IOC_GET_ENCRYPTION_POLICY_EX to the later, otherwise,
the later definitions won't be enabled causing havoc.

Fixes: e97caf714697a ("xfs_io/encrypt: support specifying crypto data unit size")
Reported-by: Waldemar Brodkorb <wbx@openadk.org>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/encrypt.c | 64 ++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 79061b07c..97abb964e 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -35,35 +35,6 @@
 #define FS_IOC_GET_ENCRYPTION_POLICY		_IOW('f', 21, struct fscrypt_policy)
 #endif
 
-/*
- * Since the log2_data_unit_size field was added later than fscrypt_policy_v2
- * itself, we may need to override the system definition to get that field.
- * And also fscrypt_get_policy_ex_arg since it contains fscrypt_policy_v2.
- */
-#if !defined(FS_IOC_GET_ENCRYPTION_POLICY_EX) || \
-	defined(OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2)
-#undef fscrypt_policy_v2
-struct fscrypt_policy_v2 {
-	__u8 version;
-	__u8 contents_encryption_mode;
-	__u8 filenames_encryption_mode;
-	__u8 flags;
-	__u8 log2_data_unit_size;
-	__u8 __reserved[3];
-	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
-};
-
-#undef fscrypt_get_policy_ex_arg
-struct fscrypt_get_policy_ex_arg {
-	__u64 policy_size; /* input/output */
-	union {
-		__u8 version;
-		struct fscrypt_policy_v1 v1;
-		struct fscrypt_policy_v2 v2;
-	} policy; /* output */
-};
-#endif
-
 /*
  * Second batch of ioctls (Linux headers v5.4+), plus some renamings from FS_ to
  * FSCRYPT_.  We don't bother defining the old names here.
@@ -106,9 +77,6 @@ struct fscrypt_policy_v1 {
 
 #define FSCRYPT_MAX_KEY_SIZE		64
 
-#define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
-/* struct fscrypt_get_policy_ex_arg was defined earlier */
-
 #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
 #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER	2
 struct fscrypt_key_specifier {
@@ -152,6 +120,38 @@ struct fscrypt_get_key_status_arg {
 
 #endif /* !FS_IOC_GET_ENCRYPTION_POLICY_EX */
 
+/*
+ * Since the log2_data_unit_size field was added later than fscrypt_policy_v2
+ * itself, we may need to override the system definition to get that field.
+ * And also fscrypt_get_policy_ex_arg since it contains fscrypt_policy_v2.
+ */
+#if !defined(FS_IOC_GET_ENCRYPTION_POLICY_EX) || \
+	defined(OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2)
+#undef fscrypt_policy_v2
+struct fscrypt_policy_v2 {
+	__u8 version;
+	__u8 contents_encryption_mode;
+	__u8 filenames_encryption_mode;
+	__u8 flags;
+	__u8 log2_data_unit_size;
+	__u8 __reserved[3];
+	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+};
+
+#undef fscrypt_get_policy_ex_arg
+struct fscrypt_get_policy_ex_arg {
+	__u64 policy_size; /* input/output */
+	union {
+		__u8 version;
+		struct fscrypt_policy_v1 v1;
+		struct fscrypt_policy_v2 v2;
+	} policy; /* output */
+};
+
+#define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
+
+#endif
+
 /*
  * Since the key_id field was added later than struct fscrypt_add_key_arg
  * itself, we may need to override the system definition to get that field.
-- 
2.46.0

