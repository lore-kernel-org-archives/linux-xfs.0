Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C16188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992391; cv=none; b=hIi3FiEP/fBy7o1Fx8YofuCgT5Ebp7PGpx/Bhq5VDq16hyfaInHUQm5BvpwoJlN361khF/LnApplLCHyqmWaf8DIanIxMdtRm+p0I5Ltqjs+3JX6up5TxK/gcubE1/Z7pmfZe7MY8F2EFAseI8rfe9gYFd+GWTATR483y/9Y43k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992391; c=relaxed/simple;
	bh=g8/r9OlKFurHj39yWAEyAJbL0q8YdLIRk3inqBdBzMs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijVfQdBvwbgdW4hh52h2hbejyUB+cc9JaSCkJIUpvZLqgIGB+V4B7aRphI0/sPdKIKzAjSDFFEKeuJn1unx23rW6NzZR64QadInYTBcQ7K8iodfLvfe8ofOpu8FOx0cO4PfL6dIkjlp3L/zusk5G7B6JAzXEEbz7i7glnppPNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQ7gpkwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQ7gpkwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D70C4CED3;
	Mon, 23 Dec 2024 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992391;
	bh=g8/r9OlKFurHj39yWAEyAJbL0q8YdLIRk3inqBdBzMs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DQ7gpkwkMYLsBMuUCkmaX7uzchQEKUdW0DWA5lG0Pwe8JM9wvWvUk8Q8nkdggTZ7G
	 /g3UD4wTbsHNKSSz3Xdt0UnxuFF5m73tew9zZ5bZtKlTYQL8sVreNIX0lPTG/XVp6G
	 CjqdsE3B6rDseEUurJd+zvs20aZPUXc3nWxN4qJLEaUxW/8Ih58xihSiQxCK2snzcn
	 ZtWsS03Zl8EUOGd2UlogJpiHLxDQavZdBkTWtN7DRCZE+kLsB0LxG6ASeTmE9gM2cd
	 Z7Cyeorc6IEpf0ZOkfpxM45PBUUYi1Y3AbB/cDzrBNRY+OpTWwBmSEwH0lyNmGROJf
	 Q7qsjuBIXYaiw==
Date: Mon, 23 Dec 2024 14:19:50 -0800
Subject: [PATCH 31/51] xfs_db: metadump realtime devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944278.2297565.16551495246381084206.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the metadump device to dump the filesystem metadata of a realtime
device to the metadump file.  Currently, this is limited to the realtime
superblock.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/metadump.c             |   53 +++++++++++++++++++++++++++++++++++++++++++++
 db/xfs_metadump.sh        |    5 +++-
 include/xfs_metadump.h    |    8 +++++++
 man/man8/xfs_metadump.8   |   11 +++++++++
 mdrestore/xfs_mdrestore.c |    5 +++-
 5 files changed, 79 insertions(+), 3 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 8eb4b8eb69e45c..4f4b4f8a39a551 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -85,6 +85,7 @@ static struct metadump {
 	bool			dirty_log;
 	bool			external_log;
 	bool			stdout_metadump;
+	bool			realtime_data;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
@@ -3027,6 +3028,7 @@ init_metadump_v2(void)
 {
 	struct xfs_metadump_header	xmh = {0};
 	uint32_t			compat_flags = 0;
+	uint32_t			incompat_flags = 0;
 
 	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
 	xmh.xmh_version = cpu_to_be32(2);
@@ -3039,8 +3041,11 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_COMPAT_DIRTYLOG;
 	if (metadump.external_log)
 		compat_flags |= XFS_MD2_COMPAT_EXTERNALLOG;
+	if (metadump.realtime_data)
+		incompat_flags |= XFS_MD2_INCOMPAT_RTDEVICE;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+	xmh.xmh_incompat_flags = cpu_to_be32(incompat_flags);
 
 	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
 		print_warning("error writing to target file");
@@ -3050,6 +3055,30 @@ init_metadump_v2(void)
 	return 0;
 }
 
+static int
+copy_rtsb(void)
+{
+	int		error;
+
+	if (metadump.show_progress)
+		print_progress("Copying realtime superblock");
+
+	push_cur();
+	error = set_rt_cur(&typtab[TYP_RTSB], XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+	if (error)
+		return 0;
+	if (iocur_top->data == NULL) {
+		pop_cur();
+		print_warning("cannot read realtime superblock");
+		return !metadump.stop_on_read_error;
+	}
+	error = write_buf(iocur_top);
+	pop_cur();
+
+	return error ? 0 : 1;
+}
+
 static int
 write_metadump_v2(
 	enum typnm		type,
@@ -3064,6 +3093,8 @@ write_metadump_v2(
 	if (type == TYP_LOG &&
 	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
 		addr |= XME_ADDR_LOG_DEVICE;
+	else if (type == TYP_RTSB)
+		addr |= XME_ADDR_RT_DEVICE;
 	else
 		addr |= XME_ADDR_DATA_DEVICE;
 
@@ -3112,6 +3143,7 @@ metadump_f(
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
 	metadump.external_log = false;
+	metadump.realtime_data = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3190,6 +3222,21 @@ metadump_f(
 		return 1;
 	}
 
+	/*
+	 * The realtime device only contains metadata if the RT superblock is
+	 * enabled.
+	 */
+	if (xfs_has_realtime(mp) && xfs_has_rtsb(mp)) {
+		if (mp->m_rtdev_targp->bt_bdev) {
+			metadump.realtime_data = true;
+			if (!version_opt_set)
+				metadump.version = 2;
+		} else if (metadump.version == 2 && !metadump.realtime_data) {
+			print_warning("realtime device not loaded, use -R");
+			return 1;
+		}
+	}
+
 	/*
 	 * If we'll copy the log, see if the log is dirty.
 	 *
@@ -3289,6 +3336,12 @@ metadump_f(
 	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
+	/* copy rt superblock */
+	if (!exitcode && metadump.realtime_data && xfs_has_rtsb(mp)) {
+		if (!copy_rtsb())
+			exitcode = 1;
+	}
+
 	/* write the remaining index */
 	if (!exitcode && metadump.mdops->finish_dump)
 		exitcode = metadump.mdops->finish_dump() < 0;
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9e8f86e53eb45d..b5c6959f2007f8 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -6,9 +6,9 @@
 
 OPTS=" "
 DBOPTS=" "
-USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
+USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] [-r rtdev] [-v version] source target"
 
-while getopts "aefgl:m:owFv:V" c
+while getopts "aefFgl:m:or:wv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -25,6 +25,7 @@ do
 		status=$?
 		exit $status
 		;;
+	r)	DBOPTS=$DBOPTS"-R "$OPTARG" ";;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index e9c3dcb8f711b9..e35f791573efc2 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -68,12 +68,18 @@ struct xfs_metadump_header {
 /* Dump contains external log contents. */
 #define XFS_MD2_COMPAT_EXTERNALLOG	(1 << 3)
 
+/* Dump contains realtime device contents. */
+#define XFS_MD2_INCOMPAT_RTDEVICE	(1U << 0)
+
+#define XFS_MD2_INCOMPAT_ALL		(XFS_MD2_INCOMPAT_RTDEVICE)
+
 struct xfs_meta_extent {
 	/*
 	 * Lowest 54 bits are used to store 512 byte addresses.
 	 * Next 2 bits is used for indicating the device.
 	 * 00 - Data device
 	 * 01 - External log
+	 * 10 - Realtime device
 	 */
 	__be64 xme_addr;
 	/* In units of 512 byte blocks */
@@ -88,6 +94,8 @@ struct xfs_meta_extent {
 #define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
 /* Extent was copied from the log device */
 #define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
+/* Extent was copied from the rt device */
+#define XME_ADDR_RT_DEVICE	(2ULL << XME_ADDR_DEVICE_SHIFT)
 
 #define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
 
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 496b5926603f48..8618ea99b9a57e 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -12,6 +12,9 @@ .SH SYNOPSIS
 .B \-l
 .I logdev
 ] [
+.B \-r
+.I rtdev
+] [
 .B \-v
 .I version
 ]
@@ -146,6 +149,14 @@ .SH OPTIONS
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.BI \-r  " rtdev"
+For filesystems that have a realtime section, this specifies the device where
+the realtime section resides.
+If the v2 metadump format is selected, the realtime group superblocks will be
+copied to the metadump.
+The v2 metadump format will be selected automatically if the filesystem
+contains realtime groups.
+.TP
 .B \-v
 The format of the metadump file to be produced.
 Valid values are 1 and 2.
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 269edb8f89969d..c6c00270234442 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -314,7 +314,7 @@ read_header_v2(
 			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
-	if (h->v2.xmh_incompat_flags != 0)
+	if (h->v2.xmh_incompat_flags & cpu_to_be32(~XFS_MD2_INCOMPAT_ALL))
 		fatal("Metadump header has unknown incompat flags set\n");
 
 	if (h->v2.xmh_reserved != 0)
@@ -324,6 +324,9 @@ read_header_v2(
 
 	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
 		fatal("External Log device is required\n");
+
+	if (h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE))
+		fatal("Realtime device not yet supported\n");
 }
 
 static void

