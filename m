Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B247944E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302660; cv=none; b=PinTeXcKgNyWefrr1FE7Dqmn2TTB6rvwD3qTH22dSr6h10uCd+rL0qvcuRODpzL6IygLxsxcy0Xe2okgRYMJh8kWqof27ZOLIDlZzCJvXFpbMjmUGdXVI+Y3BBKfPcXCQkdzvU8tjBfTlPBIS7UmliKXxzbq+Mwyzbyvx7QA980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302660; c=relaxed/simple;
	bh=Zuf+qXcJe0VgAKkzTzqTHPQwQo6CzxgXZD0f430J6Xc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=coYdbrRRKms6zli6n+5ATH4XH2Cd2uzPF9q8NeF2lojVUylvmAtk6pcaiQY9BvG1GkKTWOw4gOr7MIT22ExYvTopAIOcE86zY2/xDGth7CS65oCOEgPJxTXjnsNtZwRAX+X1dwAewx8TZhe/3IMaHdm0GXRjAo1V4MERdtY7rCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXZqcmPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXZqcmPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6712DC4AF0A;
	Tue, 30 Jul 2024 01:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302660;
	bh=Zuf+qXcJe0VgAKkzTzqTHPQwQo6CzxgXZD0f430J6Xc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sXZqcmPnJg8NWEregy6nmcX20uTfxWISs0DG88z8XMTPAh/jeHtFDQhKema1dKXqd
	 Dma6t5CTO481RdkCoRSZ+99W/CaC3HXgWzmpADEvOydmwOPa2AITtBY2APeOsAMk0z
	 koox7nnbghVVlLTzuZE/jbdLTAfAPleQUI2GfwqvR/e2VAGzpuljyVC3jbXXm6m5ia
	 0m9NcxQaMsQO4ck7RpCYEhP2H5UII4w1FLQzHfj6RxwoOS/9M8pqkCFsY3qVxjaZdv
	 4CD7fHEHNRL0BEZcrQ9tgbvI9QiOR27+/rhnL9Pd/E6TmPYrafeMZoB9n8UYhrfryQ
	 UYQPjQJlsHtxA==
Date: Mon, 29 Jul 2024 18:24:19 -0700
Subject: [PATCH 21/24] xfs_db: compute hashes of parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850791.1350924.16089433323314096941.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/hash.c                |   36 ++++++++++++++++++++++++++++++------
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    9 ++++++++-
 3 files changed, 39 insertions(+), 7 deletions(-)


diff --git a/db/hash.c b/db/hash.c
index 1500a6032..50f6da0b1 100644
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
index b7edaf788..df83aabdc 100644
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
index f8db6c36f..9f6fea574 100644
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

