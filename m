Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D8729415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688738; cv=none; b=rqQQjRC8bsFjOHtQ4sGQfgysmmf1HTTPbe0z+3P3b0vSlWo4cCDMPkPQDvAz26Mr2jZ3o9EG/0vSkLe6S58UJ3Dwumm45lAsHiPNoIr1MGLaq2TsM1woXbekZcmqpHqzo1aivw13huDrtJ4cdtk6v+eLYlczfnpx2axUpT46aRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688738; c=relaxed/simple;
	bh=wkOu/OjpGNRpHmsdGyDgsuU1iDkLeXtZC/kTTPFr8IE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFZ/iHu9L22NSd9HuZTIuk3td84IjyhB4JSNtnQdBsExOMnBviaG87anPcamH+49xu+f7NZ+9oJzw0TNBf1izAheTdpz+mYZ+IqX846dDd64l5LKoFpxGM3nSLgTmJAniMUU0lH31gkEV1VNEuBqknlj38lCgXLe91aWtI0TfEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VM0J0dN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VM0J0dN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042C4C4CED2;
	Tue, 31 Dec 2024 23:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688738;
	bh=wkOu/OjpGNRpHmsdGyDgsuU1iDkLeXtZC/kTTPFr8IE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VM0J0dN9tgWVDE6mjrQZ7bdN5DmmU4H6nut+81pxQleWtGzdIcidigcLGEVVIJBRn
	 CLrsnGWcOdjcYB6sbEmEvrt4iJ2MAwWZSppi8Gjejvx1JQsEtqjHFSZxVmc+2iKd+p
	 T2jGUt6UIWVyv+ti1U7jNA3Ta4IxyrMlGYDa/RmpW6a+qzMWavESXV++qPaPQDo62U
	 YBnrM6QC5iqutavyKk1o3HCw93v6aBfozJnBAAT4PmrUfODCrcRBXQUSFhUPLwJart
	 5DJ+O9D6Ov0IjFMQebW/UHUJQMjeAMkB2SbN7f8WSssC8akQ3gTy8jmdlMUNGHwDhr
	 xPfFJ36gJXYCg==
Date: Tue, 31 Dec 2024 15:45:37 -0800
Subject: [PATCH 03/11] xfs_io: support using XFS_IOC_MAP_FREESP to map free
 space
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777915.2709794.7308361997137954140.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/prealloc.c     |   35 +++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    8 +++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 8e968c9f2455d5..b7004697a045c5 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -41,6 +41,7 @@ static cmdinfo_t fcollapse_cmd;
 static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 static cmdinfo_t funshare_cmd;
+static cmdinfo_t fmapfree_cmd;
 
 static int
 offset_length(
@@ -377,6 +378,30 @@ funshare_f(
 	return 0;
 }
 
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
@@ -489,4 +514,14 @@ prealloc_init(void)
 	funshare_cmd.oneline =
 	_("unshares shared blocks within the range");
 	add_command(&funshare_cmd);
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
index 37ad497c771051..c4d09ce07f597b 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -519,8 +519,14 @@ .SH FILE I/O COMMANDS
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

