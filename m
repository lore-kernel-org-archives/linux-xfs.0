Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E2D40D568
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186770; cv=none; b=HL5CymTsDbcYvO6mB3cbL16b1T5DWkZ6jL+xIZFno2kPIUVkxIHSsAxL9WHiIpyPje9XaCI+/dPNtb6H4Tr1mwKAgfKeL19MRLcD/W5T7BwICdZKo4LR41Ifmr+NAVhrHbOupUsFPcaEugJk5lbVO48hbBw5iOE0mZCXLqgFgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186770; c=relaxed/simple;
	bh=rtXAIqRHzSfYGxQyHj7DxOta9KWy4qUVPMryWiH5Pb4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WuyACOQDZ76t98yKga3+81QLHTHQaZC3B8yJ5qOEYEBEXr0F8dEVcpUKPnFe7ZDZwdQE7g0wuHo2QU/6Mfnx0f8ReG37x2IPkW9eLH+iqZesatIm4sZ/GSzS/1nAKJQnR3zMbWZH7cp22x2G9xQx57B26DcAb1Hg51T2QsdibzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoH1OYQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoH1OYQz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD6821F00893;
	Thu, 11 Jun 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186768;
	bh=tgz6IR6hPRipGCJJrcohivgY6Z515/cUMD42kli56Qw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HoH1OYQzlL6pUs0q71mwTmgpqmgR/VPuellqDrrBGlcXnD2+llwEzwxs8bTUkEGUq
	 YYbVtFFA2/auzgGM7A9o2sXTMbAsuIWQUWDLa8AdKnNY6IZuEnM6brZmlXh7dkDez4
	 c5piuaAGIfBeSFt9AIsuCZzJcChgYqdH3Gag/4c9uIiBROlrrehuP63JLJkpSkG8Ed
	 KMUA+m+P+Fb6Bus/5zMZdLLZQati4UVf8kdDIY1xT6Hya3O8W4YIgNXbegA8K/Okh3
	 0XeUWJhOf5tG2/9PygC5fbmHJcuPMNf0PNN3PV33EfG230UA29gzFLE0zyTbmETjRq
	 vMsW6K29mr6eA==
Date: Thu, 11 Jun 2026 07:06:08 -0700
Subject: [PATCH 5/6] xfs_healer_start: increase statmount buffer size
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661334.728615.10301394467406944970.stgit@frogsfrogsfrogs>
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that our statmount call asks for the mount point,
filesystem type, and mount root data for each mount.  The first and
last items in that sequence are paths, so we need at least PATH_MAX for
each of them to avoid overflowing the buffer.  I don't know what is the
maximum filesystem type string length so we'll just hope that NAME_MAX
is enough.  Switch the allocation to dynamic because 9k is a lot.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer_start.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)


diff --git a/healer/xfs_healer_start.c b/healer/xfs_healer_start.c
index 6bf2b9bf854e6d..b964aa13ef1049 100644
--- a/healer/xfs_healer_start.c
+++ b/healer/xfs_healer_start.c
@@ -67,15 +67,22 @@ examine_mount(
 	int			mnt_ns_fd,
 	uint64_t		mnt_id)
 {
-	size_t			smbuf_size = libfrog_statmount_sizeof(4096);
-	struct statmount	*smbuf = alloca(smbuf_size);
+	/* two paths and a filesystem type string of unknown length */
+	size_t			smbuf_size =
+		libfrog_statmount_sizeof(PATH_MAX * 2 + NAME_MAX);
+	struct statmount	*smbuf = malloc(smbuf_size);
 	int			ret;
 
+	if (!smbuf) {
+		perror("statmount alloc");
+		return;
+	}
+
 	ret = libfrog_statmount(mnt_id, mnt_ns_fd, REQUIRED_STATMOUNT_FIELDS,
 			smbuf, smbuf_size);
 	if (ret) {
 		perror("statmount");
-		return;
+		goto out_smbuf;
 	}
 
 	if (debug) {
@@ -93,11 +100,13 @@ examine_mount(
 	/* Look for mount points for the root dir of an XFS filesystem. */
 	if ((smbuf->mask & REQUIRED_STATMOUNT_FIELDS) !=
 			   REQUIRED_STATMOUNT_FIELDS)
-		return;
+		goto out_smbuf;
 
 	if (!strcmp(smbuf->str + smbuf->fs_type, "xfs") &&
 	    !strcmp(smbuf->str + smbuf->mnt_root, "/"))
 		start_healer(smbuf->str + smbuf->mnt_point);
+out_smbuf:
+	free(smbuf);
 }
 
 /* Translate fanotify mount events into something we can process. */

