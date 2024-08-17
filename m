Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652181373
	for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2024 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723887182; cv=none; b=YLbWZ6Cvme8FkZNihYtSBVJBfpgvIQ6EyDz9trdigZBslbYqL/PyLoJoeLFgcpeONAm3A/cptg1W557gooBomn1ksUfJZ8rZsgaga0xZE4U3A0b2u1DrWytRJuMCnSuhLPXrD7X6a5azeDyNlAQwpoAS4eUcoJXAJ6AM0ESAnoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723887182; c=relaxed/simple;
	bh=kqcRdApRcmkgT097SQCc71oZXNEsvXvHTlAHlyCbiRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VX8RxJ5oKrA87ooVzh3IFvu08mHbiJfZDtdt4DsloBFdaG96d/60auS7DjXoNkqR8ravXPjCbSU97JJKD6WsD8xoYYmeAS5CgL1yaL8M0iCUKekcCDA+V8p0bmrwToJE9dO42sAQOzwdLiPemNqUHpBc4VRblj7btFkTe9+pM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REV8u+Cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REV8u+Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0340AC116B1;
	Sat, 17 Aug 2024 09:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723887181;
	bh=kqcRdApRcmkgT097SQCc71oZXNEsvXvHTlAHlyCbiRo=;
	h=From:To:Cc:Subject:Date:From;
	b=REV8u+CuqnG0mr6FujjGCidT0M/yIpigYrzjzvCggilhrmujgsNdaaaEcaxy09nQz
	 3y05sXMoFpA7+4MvDzsN0lRL7u5esesR2wPxN3nCvFmrqaL5FRHKBmw+jmmf4Mg0vW
	 OcL4gqFEMZCR++g6SZB50DXYKhQj7LF7hxwulBfT8X4yGQ5CA5tahMC+e9nth7jsX1
	 wYEzwr6Qpd9oY5CmoHRUuCarjaDVNK61dV7PKQsNBAO7tquI+CHvJ4UPreaGnp32KZ
	 IhZvFxvo+dX4u58KqWtbOYqcbDAp2BM5wTf10pQPYH19n/8GxI5PnZTEu+vA+Qf3NZ
	 x+lJu1tbBpz+Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: ebiggers@google.com,
	wbx@openadk.org
Subject: [PATCH V2] xfs_io: Fix fscrypt macros ordering
Date: Sat, 17 Aug 2024 11:32:48 +0200
Message-ID: <20240817093256.222226-1-cem@kernel.org>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Remove dangling leftover comment
	- define FS_IOC_GET_ENCRYPTION_POLICY_EX on it's own block.

Bill, as the updates for the V2 are trivial, I'm keeping your RwB,
hopefuly you agree :)

 io/encrypt.c | 67 ++++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 79061b07c..333ec03df 100644
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
@@ -102,13 +73,9 @@ struct fscrypt_policy_v1 {
 
 #define FSCRYPT_POLICY_V2		2
 #define FSCRYPT_KEY_IDENTIFIER_SIZE	16
-/* struct fscrypt_policy_v2 was defined earlier */
 
 #define FSCRYPT_MAX_KEY_SIZE		64
 
-#define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
-/* struct fscrypt_get_policy_ex_arg was defined earlier */
-
 #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
 #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER	2
 struct fscrypt_key_specifier {
@@ -152,6 +119,40 @@ struct fscrypt_get_key_status_arg {
 
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
+#endif
+
+#ifndef FS_IOC_GET_ENCRYPTION_POLICY_EX
+#  define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
+#endif
+
 /*
  * Since the key_id field was added later than struct fscrypt_add_key_arg
  * itself, we may need to override the system definition to get that field.
-- 
2.46.0

