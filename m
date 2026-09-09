Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F139EF39
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933727; cv=none; b=gZVt7RNLI7mzqTYvBzd6lU2nv8nx5QQso6+YIJr7p6UzJDVbmObiDK4J1/n4ZyvvLCb0UebQ+NyzszDJxWzSRfa0bG9qUoHsgCgljii7bW/1nLXIoFhjT+qtMXAcHQxD62DoQ51xmQGDV/RJ7lsdmSSd2+c8rZYHI58gQWQQwRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933727; c=relaxed/simple;
	bh=nivCGiq/icDm4zBnF5OTUNdBTwzBhJHxuwRVOM1m/7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8Poqp/8wqHQoe8tjlZtfWSXJaypQjeQy3EEgR5E03ef2BsHawXdI5ffmqHkBtqijNuOQnJl6RI4gZJ8xCdyn/w6Lti28S76rXEU9ZK7wRdlTB8FH2V5rsR1pASPrWKtnim/USnZ8OyRsVAqhqTMoyIG4/IbLhDmoNgGZaOZ4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8Eu2lVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8Eu2lVw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C6BA41F00A3D;
	Wed,  9 Sep 2026 06:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933724;
	bh=+ekHQ3HCSxF4+iKZqkM3cj0k7yzzKAInIkz8/TqB96w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Y8Eu2lVwArXHp6OWRCSZ7RYXESCWJhhNzG16EnHkDkCawsN6nSAaHhLBAi+Of7tbZ
	 vBlXCTHIX0PzXngpZXXeX8MPCiNXUac3/wtMVGSqUxqgYt/0/FLqfr3+ncbEiM3s1G
	 TqOfN7eUyObv8Kl6FgloGeWTX8sYmjMNXDV1WqYdrUm38dheIr1O4qf07i+yNVQY12
	 N5tmzuXL857I8c3g7SHRz2KfgY4GeeGWV5TQqNLANN3UesyvV+3nWsnoRXWBD84Rxg
	 y+Zj/Is01IZ2dD7VSLAByIGP6osPgY4i6TUhsgIln2mbaoz7+eX75xffGcs4U/2Z0C
	 lEKa8XE0d5A1w==
Date: Tue, 08 Sep 2026 23:02:04 -0700
Subject: [PATCH 7/9] makecfg: add a few more file related options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892910659.4047311.5368828900056094997.stgit@frogsfrogsfrogs>
In-Reply-To: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a few more configuration options for directory and inode related
options that might cause user-observable behavior changes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/fsgeom.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 5f2d8dc428fee5..efb61935a07073 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -11,6 +11,7 @@
 #include "libfrog/fsproperties.h"
 #include "xfs_arch.h"
 #include "libxfs/xfs_format.h"
+#include "xfs_multidisk.h"
 
 static inline const char *
 rtdev_name(
@@ -287,6 +288,8 @@ enum {
 	I_NREXT64,
 	I_EXCHANGE,
 	I_PROJID32BIT,
+	I_MAXPCT,
+	I_SIZE,
 	I_MAX_OPTS,
 };
 
@@ -294,6 +297,7 @@ enum {
 	N_PARENT = 0,
 	N_FTYPE,
 	N_VERSION,
+	N_SIZE,
 	N_MAX_OPTS,
 };
 
@@ -498,6 +502,90 @@ print_dirversion(
 	return 0;
 }
 
+static int
+print_dirsize(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	/* No need to emit the directory block size if it's the minimum */
+	if (fsgeo->dirblocksize > (1U << XFS_MIN_REC_DIRSIZE)) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->dirblocksize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static inline uint64_t terablocks(unsigned int nr, unsigned int blocksize)
+{
+	return (nr * (1ULL << 40)) / blocksize;
+}
+
+static inline unsigned int default_imaxpct(const struct xfs_fsop_geom *fsgeo)
+{
+	/*
+	 * This returns the % of the disk space that is used for
+	 * inodes, it changes relatively to the FS size:
+	 *  - over  50 TB, use 1%,
+	 *  - 1TB - 50 TB, use 5%,
+	 *  - under  1 TB, use XFS_DFL_IMAXIMUM_PCT (25%).
+	 */
+
+	if (fsgeo->datablocks < terablocks(1, fsgeo->blocksize))
+		return XFS_DFL_IMAXIMUM_PCT;
+	if (fsgeo->datablocks < terablocks(50, fsgeo->blocksize))
+		return 5;
+	return 1;
+}
+
+static int
+print_imaxpct(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->imaxpct != default_imaxpct(fsgeo)) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->imaxpct);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static inline unsigned int default_inodesize(const struct xfs_fsop_geom *fsgeo)
+{
+	if (fsgeo->flags & XFS_FSOP_GEOM_FLAGS_V5SB)
+		return 1U << XFS_DINODE_DFL_CRC_LOG;
+	return 1U << XFS_DINODE_DFL_LOG;
+}
+
+static int
+print_inodesize(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->inodesize != default_inodesize(fsgeo)) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->inodesize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int
 print_autofsck(
 	const struct mkfs_config_opt	*opt,
@@ -647,6 +735,14 @@ static const struct mkfs_config_section config_sections[] = {
 				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_PROJID32,
 				.print_fn	= print_fsgeom_only_if_missing,
 			},
+			[I_MAXPCT] = {
+				.name		= "maxpct",
+				.print_fn	= print_imaxpct,
+			},
+			[I_SIZE] = {
+				.name		= "size",
+				.print_fn	= print_inodesize,
+			},
 			[I_MAX_OPTS] = { },
 		},
 	},
@@ -675,6 +771,10 @@ static const struct mkfs_config_section config_sections[] = {
 				.name		= "version",
 				.print_fn	= print_dirversion,
 			},
+			[N_SIZE] = {
+				.name		= "size",
+				.print_fn	= print_dirsize,
+			},
 		},
 	},
 	{

