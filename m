Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBED329415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689020; cv=none; b=r0w0eK7uMpKsrfyopWesg8B4uQwuTQJpBjn72xPzGPI4aVTYoQ6uaObEJLAZmTOFQ0/bweGpbmYRCXCzQhT5ywyJlhbyFofeHbCMUlq/J4/HirnfH7yqjf6cIkkgbW9Uy3PuChw0Elp4PUEd9oOGX49FEThtUvqrbTlFgYB5wD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689020; c=relaxed/simple;
	bh=rZU3sfWXOrLhH/dqQXYbBROaOC2VE++wWxyn5quvnlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqQjnlhssC8AE+5DtKVGiUUtIjcvPNhDg3EiIoS92nK5l4x05DFfV1QXC+FPIbn4lC/cSZQn/AYPmSceOPw4Lkd+lTBjvg3KyN/17TZ6cVCOFihOLdhNRbKB9hqQAxrCIhFe6t5zbaYea743VjtUCqkHHBG+cF/+oyLXY2Regk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uu2VJLwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uu2VJLwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86236C4CED2;
	Tue, 31 Dec 2024 23:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689019;
	bh=rZU3sfWXOrLhH/dqQXYbBROaOC2VE++wWxyn5quvnlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uu2VJLwhzy5Yj5i5KRNG0htruHRWcwOPdVP7ZH0hA+GqmcY0/l4HmXVV5CGHm5Lz3
	 /iRpOJKqkP+YywJoo//PxumdKzVxqxaBcTQqsBA6BKSavLw1l8qeXhyBoV6klsxHX1
	 8t2PGYyfq6fvUQViolVpMR8mfw+lHD6wNxq+SMaisMItjxtMcahOFdr9ubHDa753cM
	 I5yyf3Y+98kdU0c6h15ECXxZ3qVca/3/CGwRc2l9WnHzYaU27tkKlivYPXkGiPhTpD
	 4AxDapHit/5vA8s1S3pWy+gnrnIcAIm9VFKBpynZJ+hZ5rPipwjO7+TykXdbKX2JRK
	 QetwLc9cZCJJQ==
Date: Tue, 31 Dec 2024 15:50:19 -0800
Subject: [PATCH 10/21] xfs_io: add a media error reporting command
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778614.2710211.18244860267862422858.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a subcommand to invoke the media error ioctl to make sure it works.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/shutdown.c     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   21 ++++++++++
 2 files changed, 133 insertions(+), 1 deletion(-)


diff --git a/io/shutdown.c b/io/shutdown.c
index 3c29ea790643f8..b4fba7d78ba83b 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -53,6 +53,115 @@ shutdown_help(void)
 "\n"));
 }
 
+static void
+mediaerror_help(void)
+{
+	printf(_(
+"\n"
+" Report a media error on the data device to the filesystem.\n"
+"\n"
+" -l -- Report against the log device.\n"
+" -r -- Report against the realtime device.\n"
+"\n"
+" offset is the byte offset of the start of the failed range.  If offset is\n"
+" specified, mapping length may (optionally) be specified as well."
+"\n"
+" length is the byte length of the failed range.\n"
+"\n"
+" If neither offset nor length are specified, the media error report will\n"
+" be made against the entire device."
+"\n"));
+}
+
+static int
+mediaerror_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_media_error	me = {
+		.daddr		= 0,
+		.bbcount	= -1ULL,
+		.flags		= XFS_MEDIA_ERROR_DATADEV,
+	};
+	long long		l;
+	size_t			fsblocksize, fssectsize;
+	int			c, ret;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "lr")) != EOF) {
+		switch (c) {
+		case 'l':
+			me.flags = (me.flags & ~XFS_MEDIA_ERROR_DEVMASK) |
+						XFS_MEDIA_ERROR_LOGDEV;
+			break;
+		case 'r':
+			me.flags = (me.flags & ~XFS_MEDIA_ERROR_DEVMASK) |
+						XFS_MEDIA_ERROR_RTDEV;
+			break;
+		default:
+			mediaerror_help();
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	/* Range start (optional) */
+	if (optind < argc) {
+		l = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (l < 0) {
+			printf("non-numeric offset argument -- %s\n",
+					argv[optind]);
+			exitcode = 1;
+			return 0;
+		}
+
+		me.daddr = l / 512;
+		optind++;
+	}
+
+	/* Range length (optional if range start was specified) */
+	if (optind < argc) {
+		l = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (l < 0) {
+			printf("non-numeric len argument -- %s\n",
+					argv[optind]);
+			exitcode = 1;
+			return 0;
+		}
+
+		me.bbcount = howmany(l, 512);
+		optind++;
+	}
+
+	if (optind < argc) {
+		printf("too many arguments -- %s\n", argv[optind]);
+		exitcode = 1;
+		return 0;
+	}
+
+	ret = ioctl(file->fd, XFS_IOC_MEDIA_ERROR, &me);
+	if (ret) {
+		fprintf(stderr,
+ "%s: ioctl(XFS_IOC_MEDIA_ERROR) [\"%s\"]: %s\n",
+				progname, file->name, strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	return 0;
+}
+
+static struct cmdinfo mediaerror_cmd = {
+	.name		= "mediaerror",
+	.cfunc		= mediaerror_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT | CMD_NOMAP_OK,
+	.args		= "[-lr] [offset [length]]",
+	.help		= mediaerror_help,
+};
+
 void
 shutdown_init(void)
 {
@@ -66,6 +175,8 @@ shutdown_init(void)
 	shutdown_cmd.oneline =
 		_("shuts down the filesystem where the current file resides");
 
-	if (expert)
+	if (expert) {
 		add_command(&shutdown_cmd);
+		add_command(&mediaerror_cmd);
+	}
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 632d07807f44f0..2ca74e6ab57d4e 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1452,6 +1452,27 @@ .SH FILESYSTEM COMMANDS
 argument, displays the list of error tags available.
 Only available in expert mode and requires privileges.
 
+.TP
+.BI "mediaerror [ \-lr ] [ " offset " [ " length " ]]"
+Report a media error against the data device of an XFS filesystem.
+The
+.I offset
+and
+.I length
+parameters are specified in units of bytes.
+If neither are specified, the entire device will be reported.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI \-l
+Report against the log device instead of the data device.
+.TP
+.BI \-r
+Report against the realtime device instead of the data device.
+.PD
+.RE
+
 .TP
 .BI "rginfo [ \-r " rgno " ]"
 Show information about or update the state of realtime allocation groups.

