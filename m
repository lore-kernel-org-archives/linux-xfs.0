Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA89C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhYALYnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF27CC433C7;
	Sun, 31 Dec 2023 22:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061921;
	bh=oCOg6QfsFByCYHOQkqnLHyQjSSY3wS050n/cHbDwxrY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WhYALYnREN8gBL0J20PT0n7oyvlOxtriHL3G886RUvM4JQH0E1z+r2G8sY5lIZ+tv
	 ol4kmpw30sYRbIUiv6otxsAqS27yKO+hXvOlL/ICSI5nal+np/A8+Q6rpKpObNk02b
	 Oj3zYODW7RtpTtc64hDyWOhZ9ki8GPwX6fIYyKN7Yx/iPutGqlp8dERT16bk5IIBC/
	 MorsT+vQQqqXhuAW32hNQM2QZOdFvwnzjH9kqp5ATWcLziaGQI8ZxvB2MXr5Vgq7t5
	 PfSZxiKWyEUO+IJUyNxlOPkP+rULZhw0B1hrtypFZJqU0ZHEshJ3fIQSLBawyBda59
	 pyiDpaH1HtC8Q==
Date: Sun, 31 Dec 2023 14:32:00 -0800
Subject: [PATCH 19/20] xfs_io: enhance swapext to take advantage of new api
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996528.1796128.648560765928226673.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

Enhance the swapext command so that we can take advantage of the new
API's features and print some timing information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/swapext.c      |  156 +++++++++++++++++++++++++++++++++++++++++++++++++----
 man/man8/xfs_io.8 |   54 ++++++++++++++++++
 2 files changed, 197 insertions(+), 13 deletions(-)


diff --git a/io/swapext.c b/io/swapext.c
index 15ed3559398..22476ec7563 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -20,7 +20,36 @@ swapext_help(void)
 	printf(_(
 "\n"
 " Swaps extents between the open file descriptor and the supplied filename.\n"
-"\n"));
+"\n"
+" -a   -- Use atomic extent swapping\n"
+" -C   -- Print timing information in a condensed format\n"
+" -d N -- Start swapping extents at this offset in the open file\n"
+" -e   -- Swap extents to the ends of both files, including the file sizes\n"
+" -f   -- Flush changed file data and metadata to disk\n"
+" -h   -- Only swap written ranges in the supplied file\n"
+" -l N -- Swap this many bytes between the two files\n"
+" -n   -- Dry run; do all the parameter validation but do not change anything.\n"
+" -s N -- Start swapping extents at this offset in the supplied file\n"
+" -t   -- Print timing information\n"
+" -u   -- Do not compare the open file's timestamps\n"
+" -v   -- 'swapext' for XFS_IOC_SWAPEXT, or 'exchrange' for XFS_IOC_EXCHANGE_RANGE\n"));
+}
+
+static void
+set_xfd_flags(
+	struct xfs_fd	*xfd,
+	int		api_ver)
+{
+	switch (api_ver) {
+	case 0:
+		xfd->flags |= XFROG_FLAG_FORCE_SWAPEXT;
+		break;
+	case 1:
+		xfd->flags |= XFROG_FLAG_FORCE_EXCH_RANGE;
+		break;
+	default:
+		break;
+	}
 }
 
 static int
@@ -31,13 +60,101 @@ swapext_f(
 	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
 	struct xfs_exch_range	fxr;
 	struct stat		stat;
-	uint64_t		flags = XFS_EXCH_RANGE_FILE2_FRESH |
+	struct timeval		t1, t2;
+	uint64_t		flags = XFS_EXCH_RANGE_NONATOMIC |
+					XFS_EXCH_RANGE_FILE2_FRESH |
 					XFS_EXCH_RANGE_FULL_FILES;
+	int64_t			src_offset = 0;
+	int64_t			dest_offset = 0;
+	int64_t			length = -1;
+	size_t			fsblocksize, fssectsize;
+	int			condensed = 0, quiet_flag = 1;
+	int			api_ver = -1;
+	int			c;
 	int			fd;
 	int			ret;
 
+	init_cvtnum(&fsblocksize, &fssectsize);
+	while ((c = getopt(argc, argv, "Cad:efhl:ns:tuv:")) != -1) {
+		switch (c) {
+		case 'C':
+			condensed = 1;
+			break;
+		case 'a':
+			flags &= ~XFS_EXCH_RANGE_NONATOMIC;
+			break;
+		case 'd':
+			dest_offset = cvtnum(fsblocksize, fssectsize, optarg);
+			if (dest_offset < 0) {
+				printf(
+			_("non-numeric open file offset argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~XFS_EXCH_RANGE_FULL_FILES;
+			break;
+		case 'e':
+			flags |= XFS_EXCH_RANGE_TO_EOF;
+			flags &= ~XFS_EXCH_RANGE_FULL_FILES;
+			break;
+		case 'f':
+			flags |= XFS_EXCH_RANGE_FSYNC;
+			break;
+		case 'h':
+			flags |= XFS_EXCH_RANGE_FILE1_WRITTEN;
+			break;
+		case 'l':
+			length = cvtnum(fsblocksize, fssectsize, optarg);
+			if (length < 0) {
+				printf(
+			_("non-numeric length argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~XFS_EXCH_RANGE_FULL_FILES;
+			break;
+		case 'n':
+			flags |= XFS_EXCH_RANGE_DRY_RUN;
+			break;
+		case 's':
+			src_offset = cvtnum(fsblocksize, fssectsize, optarg);
+			if (src_offset < 0) {
+				printf(
+			_("non-numeric supplied file offset argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~XFS_EXCH_RANGE_FULL_FILES;
+			break;
+		case 't':
+			quiet_flag = 0;
+			break;
+		case 'u':
+			flags &= ~XFS_EXCH_RANGE_FILE2_FRESH;
+			break;
+		case 'v':
+			if (!strcmp(optarg, "swapext"))
+				api_ver = 0;
+			else if (!strcmp(optarg, "exchrange"))
+				api_ver = 1;
+			else {
+				fprintf(stderr,
+			_("version must be 'swapext' or 'exchrange'.\n"));
+				return 1;
+			}
+			break;
+		default:
+			swapext_help();
+			return 0;
+		}
+	}
+	if (optind != argc - 1) {
+		swapext_help();
+		return 0;
+	}
+
 	/* open the donor file */
-	fd = openfile(argv[1], NULL, 0, 0, NULL);
+	fd = openfile(argv[optind], NULL, 0, 0, NULL);
 	if (fd < 0)
 		return 0;
 
@@ -48,27 +165,42 @@ swapext_f(
 		goto out;
 	}
 
-	ret = fstat(file->fd, &stat);
-	if (ret) {
-		perror("fstat");
-		exitcode = 1;
-		goto out;
+	if (length < 0) {
+		ret = fstat(file->fd, &stat);
+		if (ret) {
+			perror("fstat");
+			exitcode = 1;
+			goto out;
+		}
+
+		length = stat.st_size;
 	}
 
-	ret = xfrog_file_exchange_prep(&xfd, flags, 0, fd, 0, stat.st_size,
-			&fxr);
+	ret = xfrog_file_exchange_prep(&xfd, flags, dest_offset, fd, src_offset,
+			length, &fxr);
 	if (ret) {
 		xfrog_perror(ret, "xfrog_file_exchange_prep");
 		exitcode = 1;
 		goto out;
 	}
 
+	set_xfd_flags(&xfd, api_ver);
+
+	gettimeofday(&t1, NULL);
 	ret = xfrog_file_exchange(&xfd, &fxr);
 	if (ret) {
 		xfrog_perror(ret, "swapext");
 		exitcode = 1;
 		goto out;
 	}
+	if (quiet_flag)
+		goto out;
+
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	report_io_times("swapext", &t2, dest_offset, length, length, 1,
+			condensed);
 out:
 	close(fd);
 	return 0;
@@ -80,9 +212,9 @@ swapext_init(void)
 	swapext_cmd.name = "swapext";
 	swapext_cmd.cfunc = swapext_f;
 	swapext_cmd.argmin = 1;
-	swapext_cmd.argmax = 1;
+	swapext_cmd.argmax = -1;
 	swapext_cmd.flags = CMD_NOMAP_OK;
-	swapext_cmd.args = _("<donorfile>");
+	swapext_cmd.args = _("[-a] [-e] [-f] [-u] [-d dest_offset] [-s src_offset] [-l length] [-v swapext|exchrange] <donorfile>");
 	swapext_cmd.oneline = _("Swap extents between files.");
 	swapext_cmd.help = swapext_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 56abe000f23..34f9ffe9433 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -708,10 +708,62 @@ bytes of data.
 .RE
 .PD
 .TP
-.BI swapext " donor_file "
+.BI "swapext [OPTIONS]" " donor_file "
 Swaps extent forks between files. The current open file is the target. The donor
 file is specified by path. Note that file data is not copied (file content moves
 with the fork(s)).
+Options include:
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-a
+Swap extent forks atomically.
+The filesystem must be able to complete the operation even if the system goes
+down.
+.TP
+.B \-C
+Print timing information in a condensed format.
+.TP
+.BI \-d " dest_offset"
+Swap extents with open file beginning at
+.IR dest_offset .
+.TP
+.B \-e
+Swap extents to the ends of both files, including the file sizes.
+.TP
+.B \-f
+Flush changed file data and file metadata to disk.
+.TP
+.B \-h
+Only swap written ranges in the supplied file.
+.TP
+.BI \-l " length"
+Swap up to
+.I length
+bytes of data.
+.TP
+.B \-n
+Perform all the parameter validation checks but don't change anything.
+.TP
+.BI \-s " src_offset"
+Swap extents with donor file beginning at
+.IR src_offset .
+.TP
+.B \-t
+Print timing information.
+.TP
+.B \-u
+Do not snapshot and compare the open file's timestamps.
+.TP
+.B \-v
+Use a particular version of the kernel interface.
+Currently supported values are
+.I xfs
+for the old XFS_IOC_SWAPEXT ioctl, and
+.I vfs
+for the new XFS_IOC_EXCHANGE_RANGE ioctl.
+.RE
+.PD
 .TP
 .BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-s " log2_dusize " ] [ \-v " version " ] [ " keyspec " ]"
 On filesystems that support encryption, assign an encryption policy to the

