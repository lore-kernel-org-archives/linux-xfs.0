Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9F4364A0
	for <linux-xfs@vger.kernel.org>; Sun,  2 Jun 2024 23:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717370991; cv=none; b=Q4KUFbCC1FWi+JLH+WFJvHjY1jl0Xngrdt6NhXdYseq/XFeulyu7+A5gKGILpqs+cLzO12CGONGZd2RA09XEodA44sXYtMbzHTrBSiT0UKkfyEEBVYoqy1rV0UJyBcYbejDmExC9GweL4HUtBWyJondRX15Bw5h+NxthK7YgNlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717370991; c=relaxed/simple;
	bh=43NmLk2ZppOxEntaOxHJLQBfybLBAxB5aeublWgWmJA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EqzVsmvqRDa7McKNF6UNpJ4gU9PMonBF1bvljUHoOQJVEQE9trYcwHWQt1jLQlVZ4Q1x4T6sOo8+K+JKFF3LzbKvsvUNpdfrYfZ+PK8CLrg/02T12B1UAXysQ2bxHWAxSWvlUHpofE0krX91Aos66asAzsVCl1r1OWaodCy83c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oxxaz7O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oxxaz7O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E73C2BBFC;
	Sun,  2 Jun 2024 23:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717370990;
	bh=43NmLk2ZppOxEntaOxHJLQBfybLBAxB5aeublWgWmJA=;
	h=Date:From:To:Cc:Subject:From;
	b=Oxxaz7O6yRng0RfUJStU9zPYJXuLQNwHrb+qDUCJeApFPz6bg04TZ3pzvz9VPODkd
	 HHOCOS2pV8RtJW5y24n+hKecs5uIBHw86OP6kGOabbUg9Ta+kcWKQJ9phIyzBpOKKg
	 kuCDWRX9hh1z/CN1KwVfB80iD9SQjYPc+xcYlOkx0wAofxEGzguMY1JSEsUD9VKNns
	 E8uCIbWTRSLeO2tCc8VithCb5fqftbINt6SWN0DJL4BygJAt3+YjYx7dMawJ9vsBFj
	 IlwQJrlqetOcpAgbICHeOKnQVn4JaeVf7FrO/kWe3pQXHmyazBB5V4U1+4TalrRkQo
	 dUyEKNWkW07og==
Date: Sun, 2 Jun 2024 16:29:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_io: print sysfs paths of mounted filesystems
Message-ID: <20240602232949.GZ52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
