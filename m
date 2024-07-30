Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB634C97
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300999; cv=none; b=q2zo9PiaskZpsDCcxu/F/Od/4oBZj7aHG2/jrir0xnWXsRldiZWQswps/PduEGUA8zGbKw2ufn1okYOXc0Ug0+pASQsFL9J/BztJ2r869OWoUpX1TgHTt+H2lyMfWr8WbQ7ctyBGrfgWiOoWxIjU46MSb36ad86UdlBd8DmCCfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300999; c=relaxed/simple;
	bh=a6XDW7ThXTEPTjjcy/LKjpcrKbtlSUqt7XVJ0fDUlOo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDhnq5/KeDG8Z/UuZlH7TjZXJHqKwfag4ECojzGZgHbb/VMq4iiAtFcBFa3FoyrKhvqO7b4nLC+IG9CtwAD0hrQFdeD1KybHloQZnDcFLZjBQwqX1lOKworwIVou6ViR7RYavJRfo8/w4qUQ2sprq4wJ81QZHrnDq1v6eSzpAzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJuowC2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJuowC2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1219BC32786;
	Tue, 30 Jul 2024 00:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300999;
	bh=a6XDW7ThXTEPTjjcy/LKjpcrKbtlSUqt7XVJ0fDUlOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uJuowC2sA8Y6evz6uXhLFMii1MSFghVVAK77unqZuFcn5TgbGVEwiWqmOjD3ytrrD
	 Puo52pdtf7fbTPJBm4DSdrOAXRNrCjG4G/W9uTh+V8DHb6wY5wQtj4xjbeLy4sEOZx
	 b8Pm58tHs/1QS4twh+9MO0udPS9U8nqxCwKHy0N5hUt8P7B/BQgE3SGs6rVED2Fmmp
	 D1fRGNYR9QTfxqY/KFzDQBk9F/pYo+DE/mPH9xO1MXwDPq8N4Xe4KQF5aIf844iCIz
	 V27pnefVle1OTOGDl0PalOZmT1SGjnF9PbqOkYSkXBC8aiZVubWuJu/A6Hd8McghJU
	 i7EzraXPQN59w==
Date: Mon, 29 Jul 2024 17:56:38 -0700
Subject: [PATCH 11/12] xfs_repair: add exchange-range to file systems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844546.1344699.2406742125238441576.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Enable upgrading existing filesystems to support the file exchange range
feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_admin.8 |    7 +++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   30 ++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 50 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 4794d6774..63f8ee903 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -156,6 +156,13 @@ data fork extent count will be 2^48 - 1, while the maximum attribute fork
 extent count will be 2^32 - 1. The filesystem cannot be downgraded after this
 feature is enabled. Once enabled, the filesystem will not be mountable by
 older kernels.  This feature was added to Linux 5.19.
+.TP 0.4i
+.B exchange
+Upgrade a filesystem to support atomic file content exchanges through the
+XFS_IOC_EXCHANGE_RANGE ioctl, and to support online repairs of directories,
+extended attributes, symbolic links, and realtime free space metadata.
+The filesystem cannot be downgraded after this feature is enabled.
+Once enabled, the filesystem will not be mountable by older kernels.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index 24f720c46..c0c45df51 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -52,6 +52,7 @@ bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 bool	add_nrext64;
+bool	add_exchrange;		/* add file content exchange support */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index b83a8ae65..1eadfdbf9 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -93,6 +93,7 @@ extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 extern bool	add_nrext64;
+extern bool	add_exchrange;		/* add file content exchange support */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 063748179..83f0c539b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -182,6 +182,34 @@ set_nrext64(
 	return true;
 }
 
+static bool
+set_exchrange(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (xfs_has_exchange_range(mp)) {
+		printf(_("Filesystem already supports exchange-range.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("File exchange-range feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_reflink(mp)) {
+		printf(
+	_("File exchange-range feature cannot be added without reflink.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding file exchange-range support to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_INCOMPAT_EXCHRANGE;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -290,6 +318,8 @@ upgrade_filesystem(
 		dirty |= set_bigtime(mp, &new_sb);
 	if (add_nrext64)
 		dirty |= set_nrext64(mp, &new_sb);
+	if (add_exchrange)
+		dirty |= set_exchrange(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 88aa75542..e325d61f1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -69,6 +69,7 @@ enum c_opt_nums {
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
 	CONVERT_NREXT64,
+	CONVERT_EXCHRANGE,
 	C_MAX_OPTS,
 };
 
@@ -77,6 +78,7 @@ static char *c_opts[] = {
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
 	[CONVERT_NREXT64]	= "nrext64",
+	[CONVERT_EXCHRANGE]	= "exchange",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -360,6 +362,15 @@ process_args(int argc, char **argv)
 		_("-c nrext64 only supports upgrades\n"));
 					add_nrext64 = true;
 					break;
+				case CONVERT_EXCHRANGE:
+					if (!val)
+						do_abort(
+		_("-c exchange requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c exchange only supports upgrades\n"));
+					add_exchrange = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

