Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0962417C6;
	Tue, 21 Oct 2025 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072141; cv=none; b=dPmgCybQm7TCt4bM0Qv6fRRRCuiXo2Zl3lGKebRRTqZJ106cHRKUzghh2mS+I94iEZEN4q7msLdvGnQvvzvEvPtBZOzSQ9p+6Sv5X62WxaJPmRSRj2cwSxaAqL3oWoNj4aU7EiUpny7fmPWWG8oK6fAAhCGwqtCzsfSTXGAp5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072141; c=relaxed/simple;
	bh=Pihly7YdU5ofmjaqDuBh+zrvg2rCyyVXvScrHposPiM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kt4Rj5DbuUZBaskCWrHl0tajDmcfLCZKLeU9RR8hpRn9jsAUuJ4BCjuu65ZRE18ObXeHHEa7AvSQTc9+yZ0xyWdU8OB0BRtgiQuF8YGsXP2lJokWDvXJMsaq/H9hlACdvsN3oIXRtl7efvUlRxFuweFQR8eXFYCQcVwjTzrXxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhP75kgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhP75kgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD8BC4CEF1;
	Tue, 21 Oct 2025 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072140;
	bh=Pihly7YdU5ofmjaqDuBh+zrvg2rCyyVXvScrHposPiM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jhP75kgvwa5p/4GFpussQ+jZ0PpN8skanNgHl+8+TRIVLX7ltmyUnsrkEDfzZwvHm
	 hVXrMtWoxpaqtohfFLs6TzqJzIZa3IM8jgYein5QpKoqTXTZyNFQowUeT7N53nUnLP
	 SpXMQ+zzl2JUnvtn8e1nEWvjdAdgojBpaVrDOMrsejDCzUyzc9iKuKkmQ3/fTeRXSI
	 Uz8OHH6Rx8cZXqYOyjnm1FNpBxO8+/z98wo5ST2sT8Qp6bvZYRv2MimzDyHe4QLtGP
	 9GMXM0h0wbvrG9QsY5/4OlQ/fVyDCSgwhG6HXsoPU0HHBEDSffwvrMHqxTvqjNFkw2
	 rxMq+tjZN4d0Q==
Date: Tue, 21 Oct 2025 11:42:20 -0700
Subject: [PATCH 1/2] fsstress: don't abort when stat(".") returns EIO
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107189054.4164152.5531016084628066127.stgit@frogsfrogsfrogs>
In-Reply-To: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
References: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

First, start with the premise that fstests is run with a nonzero limit
on the size of core dumps so that we can capture the state of
misbehaving fs utilities like fsck and scrub if they crash.

When fsstress is compiled with DEBUG defined (which is the default), it
will periodically call check_cwd to ensure that the current working
directory hasn't changed out from underneath it.

If the filesystem is XFS and it shuts down, the stat64() calls will
start returning EIO.  In this case, we follow the out: label and call
abort() to exit the program.  Historically this did not produce any core
dumps because $PWD is on the dead filesystem and the write fails.

However, modern systems are often configured to capture coredumps using
some external mechanism, e.g. abrt/systemd-coredump.   In this case, the
capture tool will succeeds in capturing every crashed process, which
fills the crash dump directory with a lot of useless junk.  Worse, if
the capture tool is configured to pass the dumps to fstests, it will
flag the test as failed because something dumped core.

This is really silly, because basic stat requests for the current
working directory can be satisfied from the inode cache without a disk
access.  In this narrow situation, EIO only happens when the fs has shut
down, so just exit the program.  Apply the same exit-on-EIO logic to
post-operation cleanup if we fail to go up one directory.

We really should have a way to query if a filesystem is shut down that
isn't conflated with (possibly transient) EIO errors.  But for now this
is what we have to do. :(

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 8dbfb81f95a538..ae31c6a22d4d93 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1049,8 +1049,21 @@ check_cwd(void)
 
 	ret = stat64(".", &statbuf);
 	if (ret != 0) {
+		int error = errno;
+
 		fprintf(stderr, "fsstress: check_cwd stat64() returned %d with errno: %d (%s)\n",
-			ret, errno, strerror(errno));
+			ret, error, strerror(error));
+
+		/*
+		 * The current working directory is pinned in memory, which
+		 * means that stat should not have had to do any disk accesses
+		 * to retrieve stat information.  Treat an EIO as an indication
+		 * that the filesystem shut down and exit instead of dumping
+		 * core like the abort() below does.
+		 */
+		if (error == EIO)
+			exit(1);
+
 		goto out;
 	}
 
@@ -1284,14 +1297,24 @@ doproc(void)
 		 */
 		if (errtag != 0 && opno % 100 == 0)  {
 			rval = stat64(".", &statbuf);
-			if (rval == EIO)  {
+			if (rval != 0 && errno == EIO)  {
 				fprintf(stderr, "Detected EIO\n");
 				goto errout;
 			}
 		}
 	}
 errout:
-	assert(chdir("..") == 0);
+	rval = chdir("..");
+	if (rval != 0 && errno == EIO) {
+		/*
+		 * If we can't go up a directory due to EIO, treat that as an
+		 * indication that the filesystem shut down and exit instead of
+		 * dumping core like the abort() below does.
+		 */
+		fprintf(stderr, "Detected EIO, cannot clean up\n");
+		exit(1);
+	}
+	assert(rval == 0);
 	free(homedir);
 	if (cleanup) {
 		int ret;

