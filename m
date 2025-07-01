Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD891B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393233; cv=none; b=dYxhqGU0z/lWevz+pL8RIzR4ajm3JADOcYWkVxKyTIbAQC+yYecAsHUrJsy5gedtGWhNVx457b5/98/J75mVixV/hJRthBY5/Es0e/0jSgw9E2xNfXvYwd6D/C9xsZRZ0knx4GSqcXEKCK3NplWswRsEBhnnlH7yeyGP57i31wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393233; c=relaxed/simple;
	bh=rkO3IdsTZGGpPJ0V+SzxXTvpr5v+aS4MTJKccwM8WKk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JHZ8jfQgdrxdGbEZ1Rj/SzUC4EMIPWkjqjxz3LDPJoZabFLkCTe/ddfx1HfXNONjWn1fItiZLEnveRZogLGcq10ljBX8smEfpn5ARqTMCYyXcdyejRO/a1Gd+ajmaLD/UqoBo30PVbJE+dHVtx5AT2r78h+oHdj+VKszC7DEAMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kr8NldBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kr8NldBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86B4C4CEEB;
	Tue,  1 Jul 2025 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393232;
	bh=rkO3IdsTZGGpPJ0V+SzxXTvpr5v+aS4MTJKccwM8WKk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kr8NldBWXYzLn/OTPCJzyRnnNBfErtfANrqEFvDt/axUO4GWDKrFnF9sQlApmP0Ca
	 9SFhAYKG8UXGoU1XB5SgTGOW3uvs6UwusTkK+3X7qSiTBnvtcYGbUOiBVz/Kxb2IKB
	 FNLl8JaG0N4RuMTjW3bgRqotaK+Ro9sPxx5snma4ATMNEEqzEngpfIP82AKkgCRPco
	 8ObT6wK07dA99jHWpPC7rKforjUxmDF+tI/V6ZyMajodbptxVXyQNi+Z/LYiqCcVqv
	 eQuthRRftxUl+xWX0fik8DPCeNr+KnmdF6tBxvj2gwIL2vXJb1PTLvIUFz0b2Ue9cp
	 OXx6Y4Vd3L69Q==
Date: Tue, 01 Jul 2025 11:07:12 -0700
Subject: [PATCH 1/7] libfrog: move statx.h from io/ to libfrog/
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, john.g.garry@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <175139303856.916168.6082463372853489931.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move this header file so we can use it elsewhere.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

