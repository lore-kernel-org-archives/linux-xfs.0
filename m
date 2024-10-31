Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6989319F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416169; cv=none; b=mIC/AUai28OBn+M78kqiFI5pkZjx3V5TRmKvMKCB6BILaOGNCM8vZz9gR7QzzZbr5QQ9bAgkMHdoEIJWrHzxDJDKoUwPUtXcKuqb8A27NfDNZAxR+zLlPN+CtRNO9axemyAjwn42L+7wGWSC43lWfrlszN9HiohAVusypc2a+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416169; c=relaxed/simple;
	bh=AvupfvqBbEXm1z2RTQKpSV1aNaAUhwyInA6IbhkHULo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GUaclJxp6JwimQvpatQRT6MoubFE3g5NngUx9o1Nk3sUM9cvHX6KO9EZyn7JnA0LiCgYlBNH+g1YNrxEcalCfXJQd749mEmqLhRCG4JHkjg8raBBHlZrcy2LJBsW2AFA531qnVr9tDnOLXnt16wcJ7aIWieCGsjZvSiimC56jeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRvxaor1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRvxaor1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5B5C4CEC3;
	Thu, 31 Oct 2024 23:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416169;
	bh=AvupfvqBbEXm1z2RTQKpSV1aNaAUhwyInA6IbhkHULo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mRvxaor1QfIwbNAjWnHUCNRFEVG4zXFzm7CUJOCzjHNzb2ZG/AoZRYMzV46Vy2959
	 5HOivlL0CPc5OtO5uHdHMJHvIlGAkOPAhbqOJ+4aJUs5Z/7C1bEAcfgFOMrY055PMf
	 03FAFHXtefUXg7LEC9kthUuKJciY2xh5mPEpU3IjJdpyLCm7IbDH0A6x/WWGDRJzd6
	 FtbDicLWjsUamRThfLVD65oEYoctLmV2JeyRvS5WYNEoQC9fqdJqKJbywp2QdiQiHI
	 VnMBcA898zWdRV1hsChtmEv3UNOdV1LqrXzoIfmqdLyZCbQdZe8EgZY+ry9wibKFd6
	 Oq0PyzdtJ5dIA==
Date: Thu, 31 Oct 2024 16:09:28 -0700
Subject: [PATCH 03/41] libxfs: port IS_ENABLED from the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041565966.962545.15186064957543201505.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port the IS_ENABLED macro from the kernel so that it can be used in
libxfs.  This requires a bit of hygiene on our part -- any CONFIG_XFS_*
define in userspace that have counterparts in the kernel must be defined
to 1 (and not simply define'd) so that the macro works, because the
kernel translates CONFIG_FOO=y in .config to #define CONFIG_FOO 1.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h        |    6 +++-
 include/platform_defs.h |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h    |    5 ++--
 3 files changed, 70 insertions(+), 4 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 17cf619f0544aa..fe8e6584f1caca 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -7,10 +7,12 @@
 #ifndef __LIBXFS_H__
 #define __LIBXFS_H__
 
+/* CONFIG_XFS_* must be defined to 1 to work with IS_ENABLED() */
+
 /* For userspace XFS_RT is always defined */
-#define CONFIG_XFS_RT
+#define CONFIG_XFS_RT 1
 /* Ditto in-memory btrees */
-#define CONFIG_XFS_BTREE_IN_MEM
+#define CONFIG_XFS_BTREE_IN_MEM 1
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
diff --git a/include/platform_defs.h b/include/platform_defs.h
index c01d4c42674669..a3644dea41cdef 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -165,4 +165,67 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
 # define barrier() __memory_barrier()
 #endif
 
+/* stuff from include/linux/kconfig.h */
+#define __ARG_PLACEHOLDER_1 0,
+#define __take_second_arg(__ignored, val, ...) val
+
+/*
+ * The use of "&&" / "||" is limited in certain expressions.
+ * The following enable to calculate "and" / "or" with macro expansion only.
+ */
+#define __and(x, y)			___and(x, y)
+#define ___and(x, y)			____and(__ARG_PLACEHOLDER_##x, y)
+#define ____and(arg1_or_junk, y)	__take_second_arg(arg1_or_junk y, 0)
+
+#define __or(x, y)			___or(x, y)
+#define ___or(x, y)			____or(__ARG_PLACEHOLDER_##x, y)
+#define ____or(arg1_or_junk, y)		__take_second_arg(arg1_or_junk 1, y)
+
+/*
+ * Helper macros to use CONFIG_ options in C/CPP expressions. Note that
+ * these only work with boolean and tristate options.
+ */
+
+/*
+ * Getting something that works in C and CPP for an arg that may or may
+ * not be defined is tricky.  Here, if we have "#define CONFIG_BOOGER 1"
+ * we match on the placeholder define, insert the "0," for arg1 and generate
+ * the triplet (0, 1, 0).  Then the last step cherry picks the 2nd arg (a one).
+ * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
+ * the last step cherry picks the 2nd arg, we get a zero.
+ */
+#define __is_defined(x)			___is_defined(x)
+#define ___is_defined(val)		____is_defined(__ARG_PLACEHOLDER_##val)
+#define ____is_defined(arg1_or_junk)	__take_second_arg(arg1_or_junk 1, 0)
+
+/*
+ * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
+ * otherwise. For boolean options, this is equivalent to
+ * IS_ENABLED(CONFIG_FOO).
+ */
+#define IS_BUILTIN(option) __is_defined(option)
+
+/*
+ * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
+ * otherwise.  CONFIG_FOO=m results in "#define CONFIG_FOO_MODULE 1" in
+ * autoconf.h.
+ */
+#define IS_MODULE(option) __is_defined(option##_MODULE)
+
+/*
+ * IS_REACHABLE(CONFIG_FOO) evaluates to 1 if the currently compiled
+ * code can call a function defined in code compiled based on CONFIG_FOO.
+ * This is similar to IS_ENABLED(), but returns false when invoked from
+ * built-in code when CONFIG_FOO is set to 'm'.
+ */
+#define IS_REACHABLE(option) __or(IS_BUILTIN(option), \
+				__and(IS_MODULE(option), __is_defined(MODULE)))
+
+/*
+ * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
+ * 0 otherwise.  Note that CONFIG_FOO=y results in "#define CONFIG_FOO 1" in
+ * autoconf.h, while CONFIG_FOO=m results in "#define CONFIG_FOO_MODULE 1".
+ */
+#define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b720cc5fac94ff..fa025aeb09712b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -37,8 +37,9 @@
 #ifndef __LIBXFS_INTERNAL_XFS_H__
 #define __LIBXFS_INTERNAL_XFS_H__
 
-#define CONFIG_XFS_RT
-#define CONFIG_XFS_BTREE_IN_MEM
+/* CONFIG_XFS_* must be defined to 1 to work with IS_ENABLED() */
+#define CONFIG_XFS_RT 1
+#define CONFIG_XFS_BTREE_IN_MEM 1
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"

