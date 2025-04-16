Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD08228CA3
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744780972; cv=none; b=pLIb0sBjbo/wA0/Ktc/A3jD8h9EVogBxHUnyvUNBCv4F9pbNOL44PxXLpFEPhi+GclM5hIY7BzetQvnhlbiY22qYJymZHdBHzlSwFL4KMzdS4HQkOmY3rNpzFzIgJmx9GvjE9Vtoujern3bSK6rEDV9XTP5NWU1jYVuf7yD0vCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744780972; c=relaxed/simple;
	bh=dXZa/q3Pe5wtiv/8Io2NXxgh2yzpIobGU4yAoiJ9Q3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnkj8747hyNIL9A9MyFBCrKLKL0CmokOKxNCrcuyYOExrm/+r2pDStgQsHFqFdo+pspFw7EOzeXnKkSHW1YVS9RGb/OBVjgsVJq3pM70b2kWiKTN/9rvBUgIBK7GBrxRm7h1vpQX19f8BvC1uC+mPr2JHVGVslsN0pZrP18MCgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNvlAknC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNvlAknC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A776C4CEE2;
	Wed, 16 Apr 2025 05:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744780972;
	bh=dXZa/q3Pe5wtiv/8Io2NXxgh2yzpIobGU4yAoiJ9Q3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WNvlAknCf6tJesBZpH2YEfYtFtJlhTtxK4Krtzc4AT+kt2ten2BvZOWeqlAulZzGc
	 FDKo+p1EYnrLHlH8u0GjgURATPh03FkgzwQ09Vyf9uyYTiwMzwGR9CgF3v2EmnMpNs
	 5PvDM+G9fDya7S+2grxEDMT0W3i2ES2Ia06pxnJazjPrcLuDr9ju3xH6LUXq0rWYEQ
	 QTud4FAsmwteei57nExAlciPe60wPkiu4H1RX/JNoEh1Xmgqjy8ipdOnK6JbTmDt2I
	 QH2msuhyKZF5cu/Gv750gvaTGJUKjL0jNmVbL/PeB6pUhvMQYb6uKWr4XGcr6CYKm3
	 NL3rpauF2faCA==
Date: Tue, 15 Apr 2025 22:22:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs_io: make statx mask parsing more generally useful
Message-ID: <20250416052251.GC25675@frogsfrogsfrogs>
References: <20250416052134.GB25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416052134.GB25675@frogsfrogsfrogs>

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
index b37b1a12b8b2fd..ebc085845972c4 100644
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
+	{"all",			STATX_ALL},
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
@@ -333,9 +364,16 @@ statx_help(void)
 " -r -- Print raw statx structure fields\n"
 " -m mask -- Specify the field mask for the statx call\n"
 "            (can also be 'basic' or 'all'; default STATX_ALL)\n"
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
@@ -376,6 +414,68 @@ dump_raw_statx(struct statx *stx)
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
@@ -388,7 +488,6 @@ statx_f(
 	char		**argv)
 {
 	int		c, verbose = 0, raw = 0;
-	char		*p;
 	struct statx	stx;
 	int		atflag = 0;
 	unsigned int	mask = STATX_ALL;
@@ -396,18 +495,9 @@ statx_f(
 	while ((c = getopt(argc, argv, "m:rvFD")) != EOF) {
 		switch (c) {
 		case 'm':
-			if (strcmp(optarg, "basic") == 0)
-				mask = STATX_BASIC_STATS;
-			else if (strcmp(optarg, "all") == 0)
-				mask = STATX_ALL;
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
index 726e25af272242..0e8e69a1fe0c22 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -999,6 +999,17 @@ .SH FILE I/O COMMANDS
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
