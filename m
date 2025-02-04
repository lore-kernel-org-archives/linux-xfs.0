Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E7C25A62C;
	Tue,  4 Feb 2025 21:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704530; cv=none; b=Snu8sa9yIdFZ+iYUFoVwR7e4wXjNkzcQ2XCg+b/t/gf0zh+BkiUnffekfREBnZJ9wecVHD3BolhsrNSTypFue882/BdsIEswkqX6DigwE4fU6cC2e/0gSmT7jRn5EhhywvTOetEzlxf9kRwYHc1KT5TKjPevSx3ojIBeyVmC/C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704530; c=relaxed/simple;
	bh=BlrJdqEN8OTCIHIAF5hwfqQqvYbGc101v8hqFaKziIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urCiEOhC8gBTdaYu0iz6uRVgjFTl9RXfbkAa/XjbbHA5nrKg2yerdBqal+vQfluB3YvFz4pZMKdqR39o7FDEJUdYEvRrUBTNqpmmdCnu0O9r1AQke2bBOHOCHCMndukkHUbmOXMDn7hlqH2YUqJHsjsWxGL+wsYwxrboA7PxNng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lh8FB2pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh8FB2pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322B4C4CEDF;
	Tue,  4 Feb 2025 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704530;
	bh=BlrJdqEN8OTCIHIAF5hwfqQqvYbGc101v8hqFaKziIs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lh8FB2pN53TTPbHKElgZmeRYvO61pMeEEJAc2bABGOef2ycU/VHjgRJkmn4LPCYnP
	 5lSUDAggt3mwLgpQDYIISwWMWaW48Si6qlzrIB/4aHZNSPcSV+w2GkU1Gg3uqnz0Hq
	 Rww1xYSOUoxT4kJM+6FbIu0mdlvSTIXIQbTTkchVTpyQABAsnlhE3UnInRn0Ze0Hte
	 g3PVWQa05SaLmyUOS7dxdnpG4nwcvKn9ffcgFrCq4JdhaKyjLC3RPNqpkH/Yqrtew8
	 56Op6p4H0FbcEQDvyhatIAPol3Ck/hWh9kvdoUWWNC2vWMz+5YpBpI662klAmUU90J
	 KI7/SbCBrWKsQ==
Date: Tue, 04 Feb 2025 13:28:49 -0800
Subject: [PATCH 25/34] fuzzy: don't use readarray for xfsfind output
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406488.546134.5095358124083664557.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Some of the scrub stress tests (e.g. xfs/796) walk the directory tree to
find filepaths to scrub, and load the entire list of paths into a bash
array.  On a large filesystem or a long-running test this is hugely
wasteful of memory because we use each path exactly once.

Fix __stress_one_scrub_loop to avoid this by reading lines directly from
the output of the xfsfind utility.  However, we play some games with fd
77 so that the processes in the loop body will use the same stdin as the
test and /not/ the piped stdout of xfsfind.

To avoid read(1) becoming confused by newlines in the file paths, adapt
xfsfind to print nulls between pathnames, and the bash code to recognize
them.

This was a debugging patch while I was trying to figure out why xfs/286
and other scrub soak tests started OOMing after the v2024.12.08 changes,
though in the end the OOMs were the result of memory leaks in fsstress.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy  |   22 +++++++++++++---------
 src/xfsfind.c |   14 +++++++++++---
 2 files changed, 24 insertions(+), 12 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 9d5f01fb087033..41547add83121a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -861,14 +861,14 @@ __stress_one_scrub_loop() {
 		;;
 	esac
 
-	local target_cmd=(echo "$scrub_tgt")
+	local target_cmd=(echo -en "$scrub_tgt\0")
 	case "$scrub_tgt" in
-	"%file%")	target_cmd=($here/src/xfsfind -q  "$SCRATCH_MNT");;
-	"%attrfile%")	target_cmd=($here/src/xfsfind -qa "$SCRATCH_MNT");;
-	"%datafile%")	target_cmd=($here/src/xfsfind -qb "$SCRATCH_MNT");;
-	"%dir%")	target_cmd=($here/src/xfsfind -qd "$SCRATCH_MNT");;
-	"%regfile%")	target_cmd=($here/src/xfsfind -qr "$SCRATCH_MNT");;
-	"%cowfile%")	target_cmd=($here/src/xfsfind -qs "$SCRATCH_MNT");;
+	"%file%")	target_cmd=($here/src/xfsfind -0q  "$SCRATCH_MNT");;
+	"%attrfile%")	target_cmd=($here/src/xfsfind -0qa "$SCRATCH_MNT");;
+	"%datafile%")	target_cmd=($here/src/xfsfind -0qb "$SCRATCH_MNT");;
+	"%dir%")	target_cmd=($here/src/xfsfind -0qd "$SCRATCH_MNT");;
+	"%regfile%")	target_cmd=($here/src/xfsfind -0qr "$SCRATCH_MNT");;
+	"%cowfile%")	target_cmd=($here/src/xfsfind -0qs "$SCRATCH_MNT");;
 	esac
 
 	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
@@ -876,12 +876,16 @@ __stress_one_scrub_loop() {
 	done
 
 	while __stress_scrub_running "$end" "$runningfile"; do
-		readarray -t fnames < <("${target_cmd[@]}" 2>> $seqres.full)
-		for fname in "${fnames[@]}"; do
+		# Attach the stdout of xfsfind to fd 77 so that we can read
+		# pathnames from that file descriptor without passing the pipe
+		# to the loop body as stdin.
+		exec 77< <("${target_cmd[@]}" 2>> $seqres.full)
+		while read -u 77 -d '' fname; do
 			$XFS_IO_PROG -x "${xfs_io_args[@]}" "$fname" 2>&1 | \
 				__stress_scrub_filter_output "${extra_filters[@]}"
 			__stress_scrub_running "$end" "$runningfile" || break
 		done
+		exec 77<&-
 	done
 }
 
diff --git a/src/xfsfind.c b/src/xfsfind.c
index c81deaf64f57e9..2043d01ded3210 100644
--- a/src/xfsfind.c
+++ b/src/xfsfind.c
@@ -20,6 +20,7 @@ static int want_dir;
 static int want_regfile;
 static int want_sharedfile;
 static int report_errors = 1;
+static int print0;
 
 static int
 check_datafile(
@@ -115,6 +116,7 @@ print_help(
 	printf("\n");
 	printf("Print all file paths matching any of the given predicates.\n");
 	printf("\n");
+	printf("-0	Print nulls between paths instead of newlines.\n");
 	printf("-a	Match files with xattrs.\n");
 	printf("-b	Match files with data blocks.\n");
 	printf("-d	Match directories.\n");
@@ -208,8 +210,13 @@ visit(
 out_fd:
 	close(fd);
 out:
-	if (printme)
-		printf("%s\n", path);
+	if (printme) {
+		if (print0)
+			printf("%s%c", path, 0);
+		else
+			printf("%s\n", path);
+		fflush(stdout);
+	}
 	return retval;
 }
 
@@ -236,8 +243,9 @@ main(
 	int			c;
 	int			ret;
 
-	while ((c = getopt(argc, argv, "abdqrs")) >= 0) {
+	while ((c = getopt(argc, argv, "0abdqrs")) >= 0) {
 		switch (c) {
+		case '0':	print0 = 1;          break;
 		case 'a':	want_attrfile = 1;   break;
 		case 'b':	want_datafile = 1;   break;
 		case 'd':	want_dir = 1;        break;

