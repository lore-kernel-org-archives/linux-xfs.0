Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC93C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbiLaAXZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:23:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2665D104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D19261D23
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A763CC433D2;
        Sat, 31 Dec 2022 00:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446202;
        bh=a1dqEJZM8cGdaH2UZLZpKrPRni6fPYDEtgzyDigUdOg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ss2Ae+n9z8kNzaGHGJzfWBuY1Jy2KZkkcnQXfjrd+aj1Uyll4Ywg832pk8ICtSmxR
         w63hyE07ShMkWHpVsMGbO6CKrSkBjjbAqev9Cf6FecqVpfuWuMn5NuGIkqGrxOG+X7
         QVPYSXtYAA1STKSbPGjqI1ZIwzyFY4QBJoHYa7gtI00g2w7SJzpilIuwH5uwXm4VTb
         e260EgZAxoCANT7KDitlB3kMcEBafRmpxyJx6+i21WGwNwKFo+6/Gx8rRQ4hl0iWW0
         lkONqyCe2T2OmcZPWc6amKh4wKmqg73KJ7NIgQ3dDsReVpns+PeS8skwlD7Orw2oBV
         6e0xU59rEquXw==
Subject: [PATCH 18/19] xfs_io: enhance swapext to take advantage of new api
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:01 -0800
Message-ID: <167243868175.713817.3286221506577825368.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enhance the swapext command so that we can take advantage of the new
API's features and print some timing information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/swapext.c      |  156 +++++++++++++++++++++++++++++++++++++++++++++++++----
 man/man8/xfs_io.8 |   54 ++++++++++++++++++
 2 files changed, 197 insertions(+), 13 deletions(-)


diff --git a/io/swapext.c b/io/swapext.c
index 3f8a5c7b4d4..620ce4770a4 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -21,7 +21,36 @@ swapext_help(void)
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
+" -h   -- Do not swap ranges that correspond to holes in the supplied file\n"
+" -l N -- Swap this many bytes between the two files\n"
+" -n   -- Dry run; do all the parameter validation but do not change anything.\n"
+" -s N -- Start swapping extents at this offset in the supplied file\n"
+" -t   -- Print timing information\n"
+" -u   -- Do not compare the open file's timestamps\n"
+" -v   -- 'xfs' for XFS_IOC_SWAPEXT, or 'vfs' for FIEXCHANGE_RANGE\n"));
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
+		xfd->flags |= XFROG_FLAG_FORCE_FIEXCHANGE;
+		break;
+	default:
+		break;
+	}
 }
 
 static int
@@ -32,13 +61,101 @@ swapext_f(
 	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
 	struct file_xchg_range	fxr;
 	struct stat		stat;
-	uint64_t		flags = FILE_XCHG_RANGE_FILE2_FRESH |
+	struct timeval		t1, t2;
+	uint64_t		flags = FILE_XCHG_RANGE_NONATOMIC |
+					FILE_XCHG_RANGE_FILE2_FRESH |
 					FILE_XCHG_RANGE_FULL_FILES;
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
+			flags &= ~FILE_XCHG_RANGE_NONATOMIC;
+			break;
+		case 'd':
+			dest_offset = cvtnum(fsblocksize, fssectsize, optarg);
+			if (dest_offset < 0) {
+				printf(
+			_("non-numeric open file offset argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~FILE_XCHG_RANGE_FULL_FILES;
+			break;
+		case 'e':
+			flags |= FILE_XCHG_RANGE_TO_EOF;
+			flags &= ~FILE_XCHG_RANGE_FULL_FILES;
+			break;
+		case 'f':
+			flags |= FILE_XCHG_RANGE_FSYNC;
+			break;
+		case 'h':
+			flags |= FILE_XCHG_RANGE_SKIP_FILE1_HOLES;
+			break;
+		case 'l':
+			length = cvtnum(fsblocksize, fssectsize, optarg);
+			if (length < 0) {
+				printf(
+			_("non-numeric length argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~FILE_XCHG_RANGE_FULL_FILES;
+			break;
+		case 'n':
+			flags |= FILE_XCHG_RANGE_DRY_RUN;
+			break;
+		case 's':
+			src_offset = cvtnum(fsblocksize, fssectsize, optarg);
+			if (src_offset < 0) {
+				printf(
+			_("non-numeric supplied file offset argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~FILE_XCHG_RANGE_FULL_FILES;
+			break;
+		case 't':
+			quiet_flag = 0;
+			break;
+		case 'u':
+			flags &= ~FILE_XCHG_RANGE_FILE2_FRESH;
+			break;
+		case 'v':
+			if (!strcmp(optarg, "xfs"))
+				api_ver = 0;
+			else if (!strcmp(optarg, "vfs"))
+				api_ver = 1;
+			else {
+				fprintf(stderr,
+			_("version must be 'xfs' or 'vfs'.\n"));
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
 
@@ -49,27 +166,42 @@ swapext_f(
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
@@ -81,9 +213,9 @@ swapext_init(void)
 	swapext_cmd.name = "swapext";
 	swapext_cmd.cfunc = swapext_f;
 	swapext_cmd.argmin = 1;
-	swapext_cmd.argmax = 1;
+	swapext_cmd.argmax = -1;
 	swapext_cmd.flags = CMD_NOMAP_OK;
-	swapext_cmd.args = _("<donorfile>");
+	swapext_cmd.args = _("[-a] [-e] [-f] [-u] [-d dest_offset] [-s src_offset] [-l length] [-v xfs|vfs] <donorfile>");
 	swapext_cmd.oneline = _("Swap extents between files.");
 	swapext_cmd.help = swapext_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ae8d0245d87..9a155aaa02c 100644
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
+Do not swap ranges that correspond to holes in the donor file.
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
+for the new FIEXCHANGE_RANGE VFS interface.
+.RE
+.PD
 .TP
 .BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keyspec " ]"
 On filesystems that support encryption, assign an encryption policy to the

