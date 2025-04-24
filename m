Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD301B040B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531621; cv=none; b=Gc+/+p3Y25O2p4rCe79u509SP6X2IO2V6rmAhPzVMcWVtPzepkoa+rVe6UkvXraDb/+jtoHS9yzrk741RZuxGHCwGasE35u286M78nVjFy3Sxbk9Axh63HcAzF9HU3B0lvwzp12VXeC00vR7N6XGWEzmAM8FFCvUUYSPERnhyNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531621; c=relaxed/simple;
	bh=5syYQJn+51VEJRQX1CDU8tESBBlfTy8OFtBFkUGY4iU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/qoQTOo1WXv5bx4w1mHcUlQYxrtzC6yfq9tSO/f113ihwi9J+EMvnIGOkX2vJW8KC90Vh/aXFP9dvX1VRRa0zOuoM23BjtqRLBtpta4UOwH2iPebs6ActCIR0LOgZKtySAWIpXXul86eCmLsHiN+hzy8g2vl3GFz2PwOFMk0aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAKKdvNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAKKdvNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8936C4CEE3;
	Thu, 24 Apr 2025 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745531619;
	bh=5syYQJn+51VEJRQX1CDU8tESBBlfTy8OFtBFkUGY4iU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YAKKdvNlZ+6d53cuiUQ9mv1b0Vt3oZqoF2itjMB3oXxkFRv5cou7OsmZcKk8mbhfk
	 yI9jTlwDik5wkAMk7vgzTZ4YoCpysb/aqRpRsQhPv01QIRXWjvLADwRUnjdDtGpFzu
	 EDvNYLDw3YNHWdG/oKbrVwi+DOffSLmvZEO2mj3J0Mnp6VXnStrKL3TtJvQREFEfIc
	 VHGYQBoXxPH5ReRv8EGmoiZhNYqT91MFN3FfMYu/8xmO626OeYhM0m+anPrx5SC1Vc
	 w7JNCkJZzlTYIuZzGi+Dc345hRYDAOq2XVlTYKZLblDpahBxK3K2bRRqtFPY8uh0lA
	 PjecjmwSbQjgQ==
Date: Thu, 24 Apr 2025 14:53:39 -0700
Subject: [PATCH 4/5] xfs_io: make statx mask parsing more generally useful
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174553149393.1175632.5228793003628060330.stgit@frogsfrogsfrogs>
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

Enhance the statx -m parsing to be more useful:

Add words for all the new STATX_* field flags added in the previous
patch.

Allow "+" and "-" prefixes to add or remove flags from the mask.

Allow multiple arguments to be specified as a comma separated list.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/stat.c         |  120 ++++++++++++++++++++++++++++++++++++++++++++++-------
 man/man8/xfs_io.8 |   11 +++++
 2 files changed, 116 insertions(+), 15 deletions(-)


diff --git a/io/stat.c b/io/stat.c
index 52e2d33010a99a..c3a4bb15229ee5 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -321,10 +321,41 @@ _statx(
 #endif
 }
 
+struct statx_masks {
+	const char	*name;
+	unsigned int	mask;
+};
+
+static const struct statx_masks statx_masks[] = {
+	{"basic",		STATX_BASIC_STATS},
+	{"all",			~STATX__RESERVED},
+
+	{"type",		STATX_TYPE},
+	{"mode",		STATX_MODE},
+	{"nlink",		STATX_NLINK},
+	{"uid",			STATX_UID},
+	{"gid",			STATX_GID},
+	{"atime",		STATX_ATIME},
+	{"mtime",		STATX_MTIME},
+	{"ctime",		STATX_CTIME},
+	{"ino",			STATX_INO},
+	{"size",		STATX_SIZE},
+	{"blocks",		STATX_BLOCKS},
+	{"btime",		STATX_BTIME},
+	{"mnt_id",		STATX_MNT_ID},
+	{"dioalign",		STATX_DIOALIGN},
+	{"mnt_id_unique",	STATX_MNT_ID_UNIQUE},
+	{"subvol",		STATX_SUBVOL},
+	{"write_atomic",	STATX_WRITE_ATOMIC},
+	{"dio_read_align",	STATX_DIO_READ_ALIGN},
+};
+
 static void
 statx_help(void)
 {
-        printf(_(
+	unsigned int	i;
+
+	printf(_(
 "\n"
 " Display extended file status.\n"
 "\n"
@@ -334,9 +365,16 @@ statx_help(void)
 " -m mask -- Specify the field mask for the statx call\n"
 "            (can also be 'basic' or 'all'; defaults to\n"
 "             STATX_BASIC_STATS | STATX_BTIME)\n"
+" -m +mask -- Add this to the field mask for the statx call\n"
+" -m -mask -- Remove this from the field mask for the statx call\n"
 " -D -- Don't sync attributes with the server\n"
 " -F -- Force the attributes to be sync'd with the server\n"
-"\n"));
+"\n"
+"statx mask values: "));
+
+	for (i = 0; i < ARRAY_SIZE(statx_masks); i++)
+		printf("%s%s", i == 0 ? "" : ", ", statx_masks[i].name);
+	printf("\n");
 }
 
 /* statx helper */
@@ -377,6 +415,68 @@ dump_raw_statx(struct statx *stx)
 	return 0;
 }
 
+enum statx_mask_op {
+	SET,
+	REMOVE,
+	ADD,
+};
+
+static bool
+parse_statx_masks(
+	char			*optarg,
+	unsigned int		*caller_mask)
+{
+	char			*arg = optarg;
+	char			*word;
+	unsigned int		i;
+
+	while ((word = strtok(arg, ",")) != NULL) {
+		enum statx_mask_op op;
+		unsigned int	mask;
+		char		*p;
+
+		arg = NULL;
+
+		if (*word == '+') {
+			op = ADD;
+			word++;
+		} else if (*word == '-') {
+			op = REMOVE;
+			word++;
+		} else {
+			op = SET;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(statx_masks); i++) {
+			if (!strcmp(statx_masks[i].name, word)) {
+				mask = statx_masks[i].mask;
+				goto process_op;
+			}
+		}
+
+		mask = strtoul(word, &p, 0);
+		if (!p || p == word) {
+			printf( _("non-numeric mask -- %s\n"), word);
+			return false;
+		}
+
+process_op:
+		switch (op) {
+		case ADD:
+			*caller_mask |= mask;
+			continue;
+		case REMOVE:
+			*caller_mask &= ~mask;
+			continue;
+		case SET:
+			*caller_mask = mask;
+			continue;
+		}
+	}
+
+	return true;
+}
+
 /*
  * options:
  * 	- input flags - query type
@@ -389,7 +489,6 @@ statx_f(
 	char		**argv)
 {
 	int		c, verbose = 0, raw = 0;
-	char		*p;
 	struct statx	stx;
 	int		atflag = 0;
 	unsigned int	mask = STATX_BASIC_STATS | STATX_BTIME;
@@ -397,18 +496,9 @@ statx_f(
 	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
 		switch (c) {
 		case 'm':
-			if (strcmp(optarg, "basic") == 0)
-				mask = STATX_BASIC_STATS;
-			else if (strcmp(optarg, "all") == 0)
-				mask = ~STATX__RESERVED;
-			else {
-				mask = strtoul(optarg, &p, 0);
-				if (!p || p == optarg) {
-					printf(
-				_("non-numeric mask -- %s\n"), optarg);
-					exitcode = 1;
-					return 0;
-				}
+			if (!parse_statx_masks(optarg, &mask)) {
+				exitcode = 1;
+				return 0;
 			}
 			break;
 		case 'r':
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 198215103812c6..64b3e907553f48 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1000,6 +1000,17 @@ .SH FILE I/O COMMANDS
 .B \-m <mask>
 Specify a numeric field mask for the statx call.
 .TP
+.BI "\-m +" value
+Add this value to the statx field value.
+Values can be numeric, or they can be words describing the desired fields.
+See the help command output for a list of recognized words.
+.TP
+.BI "\-m -" value
+Remove this value from the statx field value.
+.TP
+.BI "\-m +" value ",-" value
+Add and remove multiple values from the statx field value.
+.TP
 .B \-F
 Force the attributes to be synced with the server.
 .TP

