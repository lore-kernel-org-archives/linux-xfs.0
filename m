Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2FC9441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882970; cv=none; b=TFbdKpatCcvzgW6kEmOQjFd9kvr3T+MMjTf+Cmpe+q8mJpPXx+pu00BYDXoWHiYp3bOf3gbHEJ+ev96SL14VqHrkk9jma3Bh6/x1lu1uA1IwEkErt4iQumZq0OaLf1eV7jG/7/0QL3vzral05WYowYGTfU8lwVnT9VKL0B5gV7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882970; c=relaxed/simple;
	bh=RBQUdUhWy29PogdMIHQtpJ/shXdCchrRX6Acj6Bas2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vlq3NQRSwRdBee13qaOch3H40+uL71VCgdpi1IM/I4uurfERKcCHv1udy0vLedQZwwlpJsF46IjPTM0rQjI80cn0tBCQ6jFrp2ATEL7XljCc+Z9NYxGwisBc+XIAathlIO3OTFsUfSybFZ3Bm7EF9fbFnMdRVGfBQba+F0PcWps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fyxu+scv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fyxu+scv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767A9C116B1;
	Tue,  2 Jul 2024 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882970;
	bh=RBQUdUhWy29PogdMIHQtpJ/shXdCchrRX6Acj6Bas2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fyxu+scvWlFXCssF8nooA+rDT0FODyOKBGXyl7oO1q/L8054rbl1mzUDgOl6h7wnN
	 26T0y0rI0Nx5YdIvbmlJbCdF7o/vKvFNO9cSvL1OVOXC+zdEi3qly0KhoiAr4HHSFC
	 gaimAZdVgPmJ6KYzb9fBkNYBXMhwTJNsODk5KvLYwa1n2BSv7gjY2bYXzUzGa3byB2
	 QHQbV450kaCuiOBkgvjSzsY4NPPuAT8CjVwIDXmq1prEOFsznQu5/ASVwVOYl5bsnX
	 kPNFteC5ZusSrO/Pw6LJ5VJ9QF00R+OqXdVhNQd5GJSlYtUq7b0gqHQaD1j5jhkx+w
	 OifmhT6FrSJ0g==
Date: Mon, 01 Jul 2024 18:16:09 -0700
Subject: [PATCH 21/24] xfs_db: compute hashes of parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121387.2009260.17240012773714059969.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enhance the hash command to compute the hashes of parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/hash.c                |   36 ++++++++++++++++++++++++++++++------
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    9 ++++++++-
 3 files changed, 39 insertions(+), 7 deletions(-)


diff --git a/db/hash.c b/db/hash.c
index 1500a6032fd7..50f6da0b1a20 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -36,26 +36,42 @@ hash_help(void)
 " 'hash' prints out the calculated hash value for a string using the\n"
 "directory/attribute code hash function.\n"
 "\n"
-" Usage:  \"hash <string>\"\n"
+" Usage:  \"hash [-d|-p parent_ino] <string>\"\n"
 "\n"
 ));
 
 }
 
+enum hash_what {
+	ATTR,
+	DIRECTORY,
+	PPTR,
+};
+
 /* ARGSUSED */
 static int
 hash_f(
 	int		argc,
 	char		**argv)
 {
+	xfs_ino_t	p_ino = 0;
 	xfs_dahash_t	hashval;
-	bool		use_dir2_hash = false;
+	enum hash_what	what = ATTR;
 	int		c;
 
-	while ((c = getopt(argc, argv, "d")) != EOF) {
+	while ((c = getopt(argc, argv, "dp:")) != EOF) {
 		switch (c) {
 		case 'd':
-			use_dir2_hash = true;
+			what = DIRECTORY;
+			break;
+		case 'p':
+			errno = 0;
+			p_ino = strtoull(optarg, NULL, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			what = PPTR;
 			break;
 		default:
 			exitcode = 1;
@@ -70,10 +86,18 @@ hash_f(
 			.len	= strlen(argv[c]),
 		};
 
-		if (use_dir2_hash)
+		switch (what) {
+		case DIRECTORY:
 			hashval = libxfs_dir2_hashname(mp, &xname);
-		else
+			break;
+		case PPTR:
+			hashval = libxfs_parent_hashval(mp, xname.name,
+					xname.len, p_ino);
+			break;
+		case ATTR:
 			hashval = libxfs_attr_hashname(xname.name, xname.len);
+			break;
+		}
 		dbprintf("0x%x\n", hashval);
 	}
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b7edaf788051..df83aabdc13d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -203,6 +203,7 @@
 #define xfs_mkdir_space_res		libxfs_mkdir_space_res
 #define xfs_parent_addname		libxfs_parent_addname
 #define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_hashval		libxfs_parent_hashval
 #define xfs_parent_removename		libxfs_parent_removename
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_from_attr		libxfs_parent_from_attr
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index f8db6c36f40a..9f6fea5748d4 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -822,7 +822,7 @@ Skip write verifiers but perform CRC recalculation; allows invalid data to be
 written to disk to test detection of invalid data.
 .RE
 .TP
-.BI hash [-d]" strings
+.BI hash [-d|-p parent_ino]" strings
 Prints the hash value of
 .I string
 using the hash function of the XFS directory and attribute implementation.
@@ -832,6 +832,13 @@ If the
 option is specified, the directory-specific hash function is used.
 This only makes a difference on filesystems with ascii case-insensitive
 lookups enabled.
+
+If the
+.B \-p
+option is specified, the parent pointer-specific hash function is used.
+The parent directory inumber must be specified as an argument.
+This only makes a difference on filesystems with ascii case-insensitive
+lookups enabled.
 .TP
 .BI "hashcoll [-a] [-s seed] [-n " nr "] [-p " path "] -i | " names...
 Create directory entries or extended attributes names that all have the same

