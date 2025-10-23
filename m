Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1E0F9C0
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178106; cv=none; b=AwiJQcGEVAgfUFqQCR8D5j1xmBStkftmx/UWurxmn7Vu7vZ/tmaQxEukeyv4bnfdzJ+PXC9KYa9G/tVivIg8ELU/PHmR7Ks3749fkEukfY9lxuav39VV+5id17Wm9amVofcStdeJedv4m3S9TT/AsF9ZzdJ5pVW6FCM9y6MOhy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178106; c=relaxed/simple;
	bh=Wf5y1gKHYRBslRz9aq0EvcSyk1/IevUyj7700qkVbdo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcmIE0pcBfIerVag7Q1gh8DLtyPajf9L2J2vCAN5xchsZ+7vySh2qUY19y5aAfWBrML8CB/nUDLrpqgvFzD48TAAIredhyBZfjdFeN8eCS2gD91RnfssLkOR4mPkhUrDyJzqs1phueqN63AQIdV7taQ2nSt2N1PX6+lo2ZdB2f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJvZJWeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJvZJWeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A73AC4CEE7;
	Thu, 23 Oct 2025 00:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178106;
	bh=Wf5y1gKHYRBslRz9aq0EvcSyk1/IevUyj7700qkVbdo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AJvZJWeIebR+kVl9cMzfomLTnqlrOlP0Et/xrmf313bXKDfbXNKZsBcI8vjLVMM8/
	 7AologwdiPokYVPJWz3fRvBtCpaRJ63Ar8RSuT+T2r67q7hJbk4Oq0GoZn9hulWopz
	 1LZpXqkekgJiZYNrCL/Bqzfu4Eyfmm+6jx146MH4LZlybXyjFUGXVnaLJTDpqTTrN8
	 hcgZ1aikGoNJMlSuiimE2Vt7M2S556y04U5pkUHQbe2vMP7Z/rYZ/UKVR422v5bwhP
	 FKl2exOvhRcxgIGaW3NZ7y5KUfCskRE3U5rNP+YqsWD9YJ1uDGKs0nm4cZBUBH6R7l
	 srh7J5noVx3oQ==
Date: Wed, 22 Oct 2025 17:08:25 -0700
Subject: [PATCH 11/26] xfs_io: add a media error reporting command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747674.1028044.2734509508475149155.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
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
index f7f2956a54a7aa..aa22db4150ac24 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1389,6 +1389,27 @@ .SH FILESYSTEM COMMANDS
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

