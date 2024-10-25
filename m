Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB9D1CF96
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838041; cv=none; b=ZWJQeDwjaQZVfTtLRqowozhfOiVyvaXeTQc3xI3EYQx+pM82CLYIgG4giKtU67t8Uv4Gkqu4McX59F135eYqzH76dJZETTXSXyjgwT82Ig17+mgN5GWKXg5/djrMQF1S8DE23h/oywT+llUAhJo68UmpRBAPXRTGq61sLjqcITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838041; c=relaxed/simple;
	bh=rXHBFprqFZ0S+yOqBS1KfHMnVEFYdReAsH5q7AKWnU0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GwU1Jdck9STUa2Vnlqg9uOSqE8X0lSej4HQa8e5GD00se3I0cFLD4YZEhRqDmN6IciKPRE7DkP+cymW3omhWrz9IFRqw70uJ8IeGB7i7qNeRALm9yZpceqB8MKvOUdac+rLdvMRjWcEHGU6bf3QwTn1jpnCoU7lS3CYG7viJefA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNGIqZBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNGIqZBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CD0C4CEC3;
	Fri, 25 Oct 2024 06:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838041;
	bh=rXHBFprqFZ0S+yOqBS1KfHMnVEFYdReAsH5q7AKWnU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pNGIqZByqLR5d2LeEaPUP8lCsBz47uEOTHq08tMkd64hptYwkL6YaAmtwjH7B+wOV
	 sUQ0mVSj8q4lTQ0CaLDlVGkcqmYJwGvHdhE7hbfLWYQl3k66ia9/lMuG+UpI0q/eiw
	 eHsUbfUdgoIFexCzdGRv8rYPh8fTcHghYbcZMewgx+WZ4QoItwA22NnK69P6HdD5pc
	 i1jQt1VSndO8jDCicHGdgeBfmfDy4fkA+rIl5rKGMh7MQNuew7JFOKlwoPAPJ0yaEY
	 +eZnK3LKQXSduBVDYMdF+Ijc47c12dbhTectfp8AzsXiPCJH4ZSAO8+j6FX5B8ogUO
	 k07q+HGaiJWTg==
Date: Thu, 24 Oct 2024 23:34:01 -0700
Subject: [PATCH 6/7] xfs_io: add a commitrange option to the exchangerange
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773420.3040944.255060526461776194.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_io exchangerange command to be able to use the commit
range functionality so that we can test it piece by piece.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/exchrange.c    |   26 ++++++++++++++++++++++----
 man/man8/xfs_io.8 |    3 +++
 2 files changed, 25 insertions(+), 4 deletions(-)


diff --git a/io/exchrange.c b/io/exchrange.c
index 016429280e2717..0a3750f1eb2607 100644
--- a/io/exchrange.c
+++ b/io/exchrange.c
@@ -19,6 +19,7 @@ exchangerange_help(void)
 "\n"
 " Exchange file data between the open file descriptor and the supplied filename.\n"
 " -C   -- Print timing information in a condensed format\n"
+" -c   -- Commit to the exchange only if file2 has not changed.\n"
 " -d N -- Start exchanging contents at this position in the open file\n"
 " -f   -- Flush changed file data and metadata to disk\n"
 " -l N -- Exchange this many bytes between the two files instead of to EOF\n"
@@ -34,9 +35,9 @@ exchangerange_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_exchange_range	fxr;
 	struct stat		stat;
 	struct timeval		t1, t2;
+	bool			use_commit = false;
 	uint64_t		flags = XFS_EXCHANGE_RANGE_TO_EOF;
 	int64_t			src_offset = 0;
 	int64_t			dest_offset = 0;
@@ -53,6 +54,9 @@ exchangerange_f(
 		case 'C':
 			condensed = 1;
 			break;
+		case 'c':
+			use_commit = true;
+			break;
 		case 'd':
 			dest_offset = cvtnum(fsblocksize, fssectsize, optarg);
 			if (dest_offset < 0) {
@@ -117,8 +121,22 @@ exchangerange_f(
 	if (length < 0)
 		length = stat.st_size;
 
-	xfrog_exchangerange_prep(&fxr, dest_offset, fd, src_offset, length);
-	ret = xfrog_exchangerange(file->fd, &fxr, flags);
+	if (use_commit) {
+		struct xfs_commit_range	xcr;
+
+		ret = xfrog_commitrange_prep(&xcr, file->fd, dest_offset, fd,
+				src_offset, length);
+		if (!ret) {
+			gettimeofday(&t1, NULL);
+			ret = xfrog_commitrange(file->fd, &xcr, flags);
+		}
+	} else {
+		struct xfs_exchange_range	fxr;
+
+		xfrog_exchangerange_prep(&fxr, dest_offset, fd, src_offset,
+				length);
+		ret = xfrog_exchangerange(file->fd, &fxr, flags);
+	}
 	if (ret) {
 		xfrog_perror(ret, "exchangerange");
 		exitcode = 1;
@@ -149,7 +167,7 @@ static struct cmdinfo exchangerange_cmd = {
 void
 exchangerange_init(void)
 {
-	exchangerange_cmd.args = _("[-Cfntw] [-d dest_offset] [-s src_offset] [-l length] <donorfile>");
+	exchangerange_cmd.args = _("[-Ccfntw] [-d dest_offset] [-s src_offset] [-l length] <donorfile>");
 	exchangerange_cmd.oneline = _("Exchange contents between files.");
 
 	add_command(&exchangerange_cmd);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 1e7901393ff4d4..49d4057bb069ed 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -732,6 +732,9 @@ .SH FILE I/O COMMANDS
 .B \-C
 Print timing information in a condensed format.
 .TP
+.B \-c
+Exchange contents only if file2 has not changed.
+.TP
 .BI \-d " dest_offset"
 Swap extents with open file beginning at
 .IR dest_offset .

