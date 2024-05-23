Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A436AD31
	for <linux-xfs@vger.kernel.org>; Thu, 23 May 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716482048; cv=none; b=V7eETQpZeGbGEjpML3/TqJzUfK3kehKaLEUVSy68f/sW7kL/b4tAt7F/kJO7NuaMP8x8bZXsKrKgjCp/8BETXvlOZYT9/6i+vECA0kqciUYNqxOi1qhNGea0QImgrNflDmM1k6xBuE0T2osEvWz3227U/emIo1zIdPt0ZS0c+Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716482048; c=relaxed/simple;
	bh=43NmLk2ZppOxEntaOxHJLQBfybLBAxB5aeublWgWmJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=st3u0tYK5juv/sq67WZ7AAhS7yl/Wk/dm/NoCuXO/JkUnrY81XydXEDYLUoHBHS4/4LdDq3ZMOINad+SQcT9tUBL57FY3kVvcRZ1B1Jg6yojvVuZXH3b3X2eMWaKvEDO2cie3g/JuJyDJ0Qd+sBZHx8qu87PRsFgrb3SghwEh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTAHmvLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTAHmvLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC352C2BD10;
	Thu, 23 May 2024 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716482047;
	bh=43NmLk2ZppOxEntaOxHJLQBfybLBAxB5aeublWgWmJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTAHmvLI/K2MalR7SHC2jcW/yRW5lum211VbB1tzc2MSy17gOBROpMBorreHg3HvV
	 UAhK1r+Ne9Q3A8adSEGlNsf/KUbreB0q17iktraZVVge0W8MBTS5KpzzttYNts3WuJ
	 fm3fq8Qa1MVW+URAOPQfX06M1ViHlwfrHPSGaJHKR28v2plHmqAte4BM3bKL0plglP
	 ZLt8np/rPeqVHoFty5LZ++l8V7pQlHzBHtIB1Uure+UzzCmPSP8gmfLk6aGMNK3U0G
	 byyqxifVN7GSb/MdnuRxpw2nSPs/gtisi2m0TXcD6s3gYC2AyksxIBNF+Tt/jhfwQE
	 onlPAJZwmjVgg==
Date: Thu, 23 May 2024 09:34:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH 2/1] xfs_io: print sysfs paths of mounted filesystems
Message-ID: <20240523163407.GY25518@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
 <171634536154.2483724.11500970754963017164.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171634536154.2483724.11500970754963017164.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Enable users to print the sysfs or debugfs path for the filesystems
backing the open files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/fsuuid.c       |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    7 +++++
 2 files changed, 75 insertions(+)

diff --git a/io/fsuuid.c b/io/fsuuid.c
index af2f87a20209..8e50ec14c8fd 100644
--- a/io/fsuuid.c
+++ b/io/fsuuid.c
@@ -12,6 +12,7 @@
 #include "libfrog/logging.h"
 
 static cmdinfo_t fsuuid_cmd;
+static cmdinfo_t sysfspath_cmd;
 
 static int
 fsuuid_f(
@@ -35,6 +36,62 @@ fsuuid_f(
 	return 0;
 }
 
+#ifndef FS_IOC_GETFSSYSFSPATH
+struct fs_sysfs_path {
+	__u8			len;
+	__u8			name[128];
+};
+#define FS_IOC_GETFSSYSFSPATH		_IOR(0x15, 1, struct fs_sysfs_path)
+#endif
+
+static void
+sysfspath_help(void)
+{
+	printf(_(
+"\n"
+" print the sysfs path for the open file\n"
+"\n"
+" Prints the path in sysfs where one might find information about the\n"
+" filesystem backing the open files.  The path is not required to exist.\n"
+" -d	-- return the path in debugfs, if any\n"
+"\n"));
+}
+
+static int
+sysfspath_f(
+	int			argc,
+	char			**argv)
+{
+	struct fs_sysfs_path	path;
+	bool			debugfs = false;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "d")) != EOF) {
+		switch (c) {
+		case 'd':
+			debugfs = true;
+			break;
+		default:
+			exitcode = 1;
+			return command_usage(&sysfspath_cmd);
+		}
+	}
+
+	ret = ioctl(file->fd, FS_IOC_GETFSSYSFSPATH, &path);
+	if (ret) {
+		xfrog_perror(ret, "FS_IOC_GETSYSFSPATH");
+		exitcode = 1;
+		return 0;
+	}
+
+	if (debugfs)
+		printf("/sys/kernel/debug/%.*s\n", path.len, path.name);
+	else
+		printf("/sys/fs/%.*s\n", path.len, path.name);
+	return 0;
+}
+
 void
 fsuuid_init(void)
 {
@@ -46,4 +103,15 @@ fsuuid_init(void)
 	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
 
 	add_command(&fsuuid_cmd);
+
+	sysfspath_cmd.name = "sysfspath";
+	sysfspath_cmd.cfunc = sysfspath_f;
+	sysfspath_cmd.argmin = 0;
+	sysfspath_cmd.argmax = -1;
+	sysfspath_cmd.args = _("-d");
+	sysfspath_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_FOREIGN_OK;
+	sysfspath_cmd.oneline = _("get mounted filesystem sysfs path");
+	sysfspath_cmd.help = sysfspath_help;
+
+	add_command(&sysfspath_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 56abe000f235..3ce280a75b4a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1464,6 +1464,13 @@ flag.
 .TP
 .B fsuuid
 Print the mounted filesystem UUID.
+.TP
+.B sysfspath
+Print the sysfs or debugfs path for the mounted filesystem.
+
+The
+.B -d
+option selects debugfs instead of sysfs.
 
 
 .SH OTHER COMMANDS
