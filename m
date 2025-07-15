Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22442D374E
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556692; cv=none; b=ggFAmAoYghlQTaGVw47ehFR3dXvLUvu3MTkm5wwW/bJ3nD9qCsdxjhfdu9crcJ0C6ptoyeC8QwI2Tno90cDILn8NtBOMDT4UwGqRAZkb5LyfeHJD87qNUp/S9tz9unmfB8I4iDQHBJjL3tgdwF2fsmlP/iulMnJoWWAwhUmUsxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556692; c=relaxed/simple;
	bh=Eh+cVlPC3iyKlWp3eHMXpk/uoUbGSLHnEhewrcm55c0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPunqKxDHZr/rsuwu5vQIeiaAGYs2akVHxc7irM/wApxTWKAXdhszwo8ZVknOL86k/0jybLsqDL2aVLlieMPYxuPU3s/asdXyZh0I1M02rutGEzE7BRT0JwtyLp2bQZA57nvqw5dDGi17yn3wEK+ePpsfV2bEMArQ7w0+DG85CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmqC7+nD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmqC7+nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BD2C4CEE3;
	Tue, 15 Jul 2025 05:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556692;
	bh=Eh+cVlPC3iyKlWp3eHMXpk/uoUbGSLHnEhewrcm55c0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lmqC7+nDs+aCofrV3ui6LmDQj0WyM0O/Wk3Ffxd0ahwzk4CSc7LSZ4nRow9T4CbyQ
	 nHVo5njEewlZ8Q2GKw1b7+A+SqvfsWn46Ld4nN1xbf2JcyvcRv4lSAgRfhNji7MaM+
	 QtFsLGl7diYnSBpk7G4tEjF2aZHNKH/DYsDiwDmU7vDwcKG1rDviSrpUroIOybk/uT
	 1sgr+KCfP6It/RXmECgG/BfUJ6CdDMa/vkZb8gSfuBPxLJFZ1gvLj7UZbqyoc4SWS7
	 qAnsCImdAFfQnGoTe7KvC5qm58dff/gFoOp0v5Ub8qTYLgA7bGalb7WYtl0W2lT/Hb
	 hNdURe8V2YgzQ==
Date: Mon, 14 Jul 2025 22:18:11 -0700
Subject: [PATCH 1/7] libfrog: move statx.h from io/ to libfrog/
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652472.1831001.17737248807808394626.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move this header file so we can use the declaration and wrappers
in other parts of xfsprogs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 libfrog/statx.h  |   17 +++++++++++++++++
 io/stat.c        |   20 ++------------------
 libfrog/Makefile |    1 +
 3 files changed, 20 insertions(+), 18 deletions(-)
 rename io/statx.h => libfrog/statx.h (96%)


diff --git a/io/statx.h b/libfrog/statx.h
similarity index 96%
rename from io/statx.h
rename to libfrog/statx.h
index f7ef1d2784a2a9..b76dfae21e7092 100644
--- a/io/statx.h
+++ b/libfrog/statx.h
@@ -146,7 +146,24 @@ struct statx {
 	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
 };
+
+static inline ssize_t
+statx(
+	int		dfd,
+	const char	*filename,
+	unsigned int	flags,
+	unsigned int	mask,
+	struct statx	*buffer)
+{
+#ifdef __NR_statx
+	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
+#else
+	errno = ENOSYS;
+	return -1;
 #endif
+}
+
+#endif /* OVERRIDE_SYSTEM_STATX */
 
 #ifndef STATX_TYPE
 /*
diff --git a/io/stat.c b/io/stat.c
index c3a4bb15229ee5..46475df343470c 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -14,7 +14,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
-#include "statx.h"
+#include "libfrog/statx.h"
 #include "libxfs.h"
 #include "libfrog/logging.h"
 #include "libfrog/fsgeom.h"
@@ -305,22 +305,6 @@ statfs_f(
 	return 0;
 }
 
-static ssize_t
-_statx(
-	int		dfd,
-	const char	*filename,
-	unsigned int	flags,
-	unsigned int	mask,
-	struct statx	*buffer)
-{
-#ifdef __NR_statx
-	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
-#else
-	errno = ENOSYS;
-	return -1;
-#endif
-}
-
 struct statx_masks {
 	const char	*name;
 	unsigned int	mask;
@@ -525,7 +509,7 @@ statx_f(
 		return command_usage(&statx_cmd);
 
 	memset(&stx, 0xbf, sizeof(stx));
-	if (_statx(file->fd, "", atflag | AT_EMPTY_PATH, mask, &stx) < 0) {
+	if (statx(file->fd, "", atflag | AT_EMPTY_PATH, mask, &stx) < 0) {
 		perror("statx");
 		exitcode = 1;
 		return 0;
diff --git a/libfrog/Makefile b/libfrog/Makefile
index b64ca4597f4ea9..560bad417ee434 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -62,6 +62,7 @@ ptvar.h \
 radix-tree.h \
 randbytes.h \
 scrub.h \
+statx.h \
 workqueue.h
 
 GETTEXT_PY = \

