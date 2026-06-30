Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168CC86334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781501; cv=none; b=N4CqGEuw5S+D32D12QmtH4xFYJkTGWqEWqFbCWiv0HW+nGh8/58dcG6vXuYDmeu+bK+/FrCgWB4hF/RA1iGsRf2RuxfSZQAuiWaZ8oObjS4gPPPJZ62M37hnFjmgVqi17vlQovOg9HXa7kRfet/X+U6My0AA/LON7nWNKzq+nLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781501; c=relaxed/simple;
	bh=rzBJmTgMmvxZaMfFm2XXfmQx3WoWfwwU1FEkL+K1wew=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8nDJwnbmD1SrA+Oh/aK/+6SFNNJ54rqjbbfrEF5uvHJ0MmbBmjhDbjPvc9KloKLoPpaNmA4/UkHip+2w+rD5g9fPLoJAVTtJXv38jir7n2zPdYOg37ekD6BziAIcJqJaueUx20+ZPr2etAPHHqLxcsQj5jmQLtuOB0SNAdjsTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1Mp86PN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1Mp86PN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD52F1F000E9;
	Tue, 30 Jun 2026 01:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781500;
	bh=LKIulRQqauexlgzc/wXhipJEAcKPi3JkA7VDer4E40w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=b1Mp86PNE5QBiA6KRTOIP1iDUUuhhrx7slrp/fICRaHTz7QqNW3pvpmoOX0ncMKG+
	 oY1p47XQQ6k2IF4c+mZkDAhCDcbO0fEQ9VQqS13/eS2kV/GaSakM5wMT20I2Sk40dn
	 uzyMTemiZ1Zl137fGPGH9fM3V2178Exb9EYiRmTpLYevVN+w3c0KQi2Sp/Vc1QPBku
	 YAia/HdE5m1wQn+eAWo6wHGg4JRvRLjHx0XRCJZPl7C7XWSrwhl31mg69j85SC+9mm
	 nlXbWaq3TqPdmrGpbx7n/6QppUY1Pcxzj3JBlAiiHNf0froDtzPjzMCaLifOnCyySG
	 qIJtVrRPx0vbQ==
Date: Mon, 29 Jun 2026 18:04:59 -0700
Subject: [PATCH 1/1] xfs_healer: fix getmntent race in weakhandle
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278130366.858743.10151303158169061377.stgit@frogsfrogsfrogs>
In-Reply-To: <178278130347.858743.17561352882773270723.stgit@frogsfrogsfrogs>
References: <178278130347.858743.17561352882773270723.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that getmntent() can't be used in threaded programs
because it might employ hidden global static buffers.  GNU and musl libc
provide a getmntent_r variant that requires the caller to establish the
buffers, so let's use that.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 54c0ba68b007b3 ("xfs_healer: use getmntent to find moved filesystems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/weakhandle.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 9aa8859881481b..0601011d167cd9 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -155,6 +155,9 @@ weakhandle_reopen_from(
 	return -1;
 }
 
+/* three paths, a filesystem type string of unknown length, and options */
+#define MNTENT_BUFLEN		(4 * PATH_MAX + NAME_MAX)
+
 /* Reopen a file handle obtained via weak reference. */
 int
 weakhandle_reopen(
@@ -163,11 +166,13 @@ weakhandle_reopen(
 	weakhandle_fd_t		is_acceptable,
 	void			*data)
 {
+	struct mntent		ent;
 	const size_t		smbuf_size =
 		libfrog_statmount_sizeof(PATH_MAX);
 	struct statmount	*smbuf = alloca(smbuf_size);
 	FILE			*mtab;
 	struct mntent		*mnt;
+	char			*buf;
 	int			ret;
 
 	/* First try reopening using the original mountpoint */
@@ -203,7 +208,13 @@ weakhandle_reopen(
 	if (!mtab)
 		return -1;
 
-	while ((mnt = getmntent(mtab)) != NULL) {
+	buf = malloc(MNTENT_BUFLEN);
+	if (!buf) {
+		ret = -1;
+		goto out_mtab;
+	}
+
+	while ((mnt = getmntent_r(mtab, &ent, buf, MNTENT_BUFLEN)) != NULL) {
 		if (strcmp(mnt->mnt_type, "xfs"))
 			continue;
 		if (strcmp(mnt->mnt_fsname, wh->fsname))
@@ -222,6 +233,8 @@ weakhandle_reopen(
 		ret = -1;
 	}
 
+	free(buf);
+out_mtab:
 	endmntent(mtab);
 	return ret;
 }

