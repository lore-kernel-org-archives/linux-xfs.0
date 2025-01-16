Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759CC25533D;
	Thu, 16 Jan 2025 23:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070161; cv=none; b=El/blULUJEHR8O38xh53jwYlggneyBa5iAfYpU1G0uDXtC5rtAdWAc9Niu0Y2iOc9Prq936kMqkwCWPUL3lLFvKHPHTd77+VhrQs6rVdF/LoWbUaBakFqg50DexwmpHauewivIUB6qcILMYC7UMc6R3rvka6LK4E8mX/cok9rHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070161; c=relaxed/simple;
	bh=BRT6MpGEu6+R7PprLQVjGH6LqRHDWm5ghc05XcM6aos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkrI6sBL/yONC2gwOA+ETNetmZMpUpYUitMeFresKTqJ6pIoPWDqTukxcJd+613O+2AwbWqeb2IPr6/jPDuDMQFMCO5GyBNgnPFoPOTjv+oAGh0247O09Ex8ocozSEz1I+3YTJpQ7tX8D+BPGzixUmkSZbdVU+Aq81fIebejnlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m54PYWYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m54PYWYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C53C4CEDD;
	Thu, 16 Jan 2025 23:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070161;
	bh=BRT6MpGEu6+R7PprLQVjGH6LqRHDWm5ghc05XcM6aos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m54PYWYbElwTSlkyOlqpJQ5MAphnZUxKZcDBdvzwXMDe3EFsbhxdcDD7vC6fS35Gy
	 dPtQIZoFuNVObmfGxpl+F9iRrVHLV7FknMZRLDeFmWJq7DTPMS/PizkHx+olVaFZIb
	 7gEWxO1AyFMCbQz3AlR6kYKqdUaY4RtjyjAn3wV74TY9OLeVKAlpUJxJbREmkJbH+3
	 txdaCr0yL93eVs6FzF5a91miAs8rbVbfVZf4TsMVUjUK/Pcz49Ix26ScVyvZMB7A5d
	 FBrsGglYo6g92e9qqUfjcfdh4X6+UX2c/igDjlItVcbnUkxnOzPBdQOM1enyZyFV1v
	 GEFS9iiogrlVA==
Date: Thu, 16 Jan 2025 15:29:20 -0800
Subject: [PATCH 16/23] fuzzy: don't use readarray for xfsfind output
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974318.1927324.15556508804317088041.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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
index 46771b1d117106..f97c92340ba9ae 100644
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

