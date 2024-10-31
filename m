Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662CD19CC1D
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416857; cv=none; b=uiCZTRHbqoYpXkWFiqOrASDGLkmPuRYx2Mw8EovdMIeMRNC1Sb4Vwj+e0tmkfLen2B6FBiDgbrRRN/PBUvyeLljpyPVomR0mTqhKC2n0CrDrZwaAxt3fcmRv+iKgMNfx4fNkA/bDzM17zljm9qR2ddru6eoRG9GJKAM5BZ3uKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416857; c=relaxed/simple;
	bh=g8gDjylM/sRBAGbkp4JiaqYd51lX+Yyix5Vmjaj4Guo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKLImF8N3QVHQ0VNFtPzp5rre08/5ozPIm2JqkL7BNfGxzHZ+9CaB/WSziSXcy52yQ5J8a0aoRYCCnvanjT3vfrpbxVa/xMsiiyR1hDVQaqHBJJwrOXfVJGEbYzny+eo/+QCmbVXfO7w0zVm7z291JlqnVAja8nqk1Nzyk0oHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfmj4PbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfmj4PbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3194C4CED1;
	Thu, 31 Oct 2024 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416857;
	bh=g8gDjylM/sRBAGbkp4JiaqYd51lX+Yyix5Vmjaj4Guo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dfmj4PbNCrgLqgPz6ztZzxu78vsVMSRP0+aisb7ogKWUQaX3DJGEitiGZgnPEBLWf
	 sJFdtAyy9FoSNkZinOJziyV5LQhFNFRqLYPsrrQrfdh/ICjNUvaaY/FtCHlHHsKC8c
	 ZsKeJAQ2TD+slIhkG9yfNEghI4RqL1qQfG5fIwVRXjLqOAT2LkU384i3EcwjzPFZSI
	 CkXAzFn+Llw5+/oVbCMR48L44zK1+ql4x/6cg8GqY3Z/SUOR343r5STUkncoVnu9Tp
	 t76R0VR/dhWOvOUgP98/bmGnRYugQlMhgi6t7yxb4Rmg0mFsu0NGlsVMN4k/g8pRre
	 F0ScYIsdma4Qw==
Date: Thu, 31 Oct 2024 16:20:56 -0700
Subject: [PATCH 6/7] xfs_io: add a commitrange option to the exchangerange
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566997.963918.18116189770113184408.stgit@frogsfrogsfrogs>
In-Reply-To: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
References: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

