Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602CF1B040B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531604; cv=none; b=S7u8dbgTJyssymwM22WtA3PCvsHuVmm9gAtPeKT4lwOWIn3fnQcB901e2vYkIsKrfTytlKvLiiDcnObqWD+dk4yShZdo8KR/Gg+6SvA0nnqCReuGOEVe0G52zjKKx5x30JBy8AtQQckc/QJY40nU4iwU1FaO4Cb5QBuRcjCRqe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531604; c=relaxed/simple;
	bh=BxrAZnLwrB9QiCaJ26ivd0AOaRRFeeOk98WQTDZXcdA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bVZJYGEzhvKdAmzCQ0er1nvceo2wsgbZBJDi9BAr2udWKCuORB19HIVhcMMDOgf5M+ATl4TCcDtc00Pt9sZkwbSCkWKPJGi/UVzI82snXScazNFcLxQn9g0HhBnVZ3sQ982x/xV1HZ0l50+dLMc4xVbXfmm+7J0V9mjQR2V6O9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stBQrQ5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stBQrQ5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C532C4CEE4;
	Thu, 24 Apr 2025 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531604;
	bh=BxrAZnLwrB9QiCaJ26ivd0AOaRRFeeOk98WQTDZXcdA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=stBQrQ5JkTYlmvMYepHsY1iA1mVIxqyY/xJbPR6XBbQOUNge6cZw7fIjlVMU2V5px
	 FFgW1N3VXRcDTaI40BUxm2uMVL3k450i4Nk3LRVsmb8cQcMPejd0Qay1MoyuaJIjNP
	 3q/N0jSJkQOPkQoC6ULec4EW8Vcr+Ev3GNejdIP3G8040zcwHdV4oRD1BC7ruMJ+rM
	 uVg4Q1ZHuE5NQZAMwhZD6v5sMlMeNMRrNSc87cUDy9Jrt7K9k4UlGoDxjoWvg9llo1
	 aOu7MEHYjtyAxJ+pwPmBQ6YhSK1f3ukDcxENM9GJwH8GM6WYBrjl/eYapZ7Tsm5HIm
	 3ZT9PEpZPOj7A==
Date: Thu, 24 Apr 2025 14:53:23 -0700
Subject: [PATCH 3/5] xfs_io: redefine what statx -m all does
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
In-Reply-To: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As of kernel commit 581701b7efd60b ("uapi: deprecate STATX_ALL"),
STATX_ALL is deprecated and has been withdrawn from the kernel codebase.
The symbol still exists for userspace to avoid compilation breakage, but
we're all suppose to stop using it.

Therefore, redefine statx -m all to set all the bits except for the
reserved bit since it's pretty silly that "all" doesn't actually get you
all the fields.

Update the STATX_ALL definition in io/statx.h so people stop using it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/statx.h        |    8 +++++++-
 io/stat.c         |    7 ++++---
 man/man8/xfs_io.8 |    3 ++-
 3 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/io/statx.h b/io/statx.h
index 273644f53cf1c4..f7ef1d2784a2a9 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -170,9 +170,15 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
-#define STATX_ALL		0x00000fffU	/* All currently supported flags */
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
+/*
+ * This is deprecated, and shall remain the same value in the future.  To avoid
+ * confusion please use the equivalent (STATX_BASIC_STATS | STATX_BTIME)
+ * instead.
+ */
+#define STATX_ALL		0x00000fffU
+
 /*
  * Attributes to be found in stx_attributes
  *
diff --git a/io/stat.c b/io/stat.c
index b37b1a12b8b2fd..52e2d33010a99a 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -332,7 +332,8 @@ statx_help(void)
 " -v -- More verbose output\n"
 " -r -- Print raw statx structure fields\n"
 " -m mask -- Specify the field mask for the statx call\n"
-"            (can also be 'basic' or 'all'; default STATX_ALL)\n"
+"            (can also be 'basic' or 'all'; defaults to\n"
+"             STATX_BASIC_STATS | STATX_BTIME)\n"
 " -D -- Don't sync attributes with the server\n"
 " -F -- Force the attributes to be sync'd with the server\n"
 "\n"));
@@ -391,7 +392,7 @@ statx_f(
 	char		*p;
 	struct statx	stx;
 	int		atflag = 0;
-	unsigned int	mask = STATX_ALL;
+	unsigned int	mask = STATX_BASIC_STATS | STATX_BTIME;
 
 	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
 		switch (c) {
@@ -399,7 +400,7 @@ statx_f(
 			if (strcmp(optarg, "basic") == 0)
 				mask = STATX_BASIC_STATS;
 			else if (strcmp(optarg, "all") == 0)
-				mask = STATX_ALL;
+				mask = ~STATX__RESERVED;
 			else {
 				mask = strtoul(optarg, &p, 0);
 				if (!p || p == optarg) {
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 726e25af272242..198215103812c6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -994,7 +994,8 @@ .SH FILE I/O COMMANDS
 Set the field mask for the statx call to STATX_BASIC_STATS.
 .TP
 .B \-m all
-Set the the field mask for the statx call to STATX_ALL (default).
+Set all bits in the field mask for the statx call except for STATX__RESERVED.
+The default is to set STATX_BASIC_STATS and STATX_BTIME.
 .TP
 .B \-m <mask>
 Specify a numeric field mask for the statx call.

