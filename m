Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E57F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+XrR94k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA9C433C8;
	Mon,  1 Jan 2024 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069630;
	bh=ytI1yiozzpMvl5cxYBwwexdPS8/X1qnNlJV0hyfluow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r+XrR94k+rTTF5dC46rqQ9V38ikuMil48AOtgY3AjZGIpDDgsFkn2xcpbs2lWGqo9
	 alhsL4bDYbsCpx6F7MI8zrnOsWNrs34zyfHUhOwlTC3Y7UtUFJVHbH0BO0rKo43tjJ
	 26z+UxHz1Y4AG116mLbApbi8KdMvrf4WtXP2L0y6M1K0+viw+tCZNhTcRawuNtvjMj
	 pXu5cZG69bYq0IM/lqXY3EiPbpJ820kSrBeuqqN1pXOk1/OP5s3AgQ6BRsI7zQnQKE
	 BD64XLpY6OlNpaSobaPiTDIUxvTsgps3XK0OOdS16lcQ3ETqdBsEKDsW0/Eg1i/gXs
	 GLdscxgl0SkvA==
Date: Sun, 31 Dec 2023 16:40:30 +9900
Subject: [PATCH 02/10] xfs_io: support using XFS_IOC_MAP_FREESP to map free
 space
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405020351.1820796.4340744744634500451.stgit@frogsfrogsfrogs>
In-Reply-To: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
References: <170405020316.1820796.451112156000559887.stgit@frogsfrogsfrogs>
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

Add a command to call XFS_IOC_MAP_FREESP.  This is experimental code to
see if we can build a free space defragmenter out of this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/prealloc.c     |   35 +++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    8 +++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 5805897a4a0..0de3e142de1 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -45,6 +45,7 @@ static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 static cmdinfo_t funshare_cmd;
 #endif
+static cmdinfo_t fmapfree_cmd;
 
 static int
 offset_length(
@@ -383,6 +384,30 @@ funshare_f(
 }
 #endif	/* HAVE_FALLOCATE */
 
+static int
+fmapfree_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_flock64	segment;
+	struct xfs_map_freesp	args = { };
+
+	if (!offset_length(argv[1], argv[2], &segment)) {
+		exitcode = 1;
+		return 0;
+	}
+
+	args.offset = segment.l_start;
+	args.len = segment.l_len;
+
+	if (ioctl(file->fd, XFS_IOC_MAP_FREESP, &args)) {
+		perror("XFS_IOC_MAP_FREESP");
+		exitcode = 1;
+		return 0;
+	}
+	return 0;
+}
+
 void
 prealloc_init(void)
 {
@@ -497,4 +522,14 @@ prealloc_init(void)
 	_("unshares shared blocks within the range");
 	add_command(&funshare_cmd);
 #endif	/* HAVE_FALLOCATE */
+
+	fmapfree_cmd.name = "fmapfree";
+	fmapfree_cmd.cfunc = fmapfree_f;
+	fmapfree_cmd.argmin = 2;
+	fmapfree_cmd.argmax = 2;
+	fmapfree_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fmapfree_cmd.args = _("off len");
+	fmapfree_cmd.oneline =
+	_("maps free space into a file");
+	add_command(&fmapfree_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 411144151a1..e360d22dc38 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -513,8 +513,14 @@ Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
 .BR fallocate (2)
 manual page to create the hole by shifting data blocks.
 .TP
+.BI fmapfree " offset length"
+Maps free physical space into the file by calling XFS_IOC_MAP_FREESP as
+described in the
+.BR XFS_IOC_MAP_FREESP (2)
+manual page.
+.TP
 .BI fpunch " offset length"
-Punches (de-allocates) blocks in the file by calling fallocate with 
+Punches (de-allocates) blocks in the file by calling fallocate with
 the FALLOC_FL_PUNCH_HOLE flag as described in the
 .BR fallocate (2)
 manual page.

