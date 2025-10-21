Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE6D21D011;
	Tue, 21 Oct 2025 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071413; cv=none; b=OVpVde6ksihLQHlwJWY1aHHSq17YbkIU9XW/y26qdp/Ig+NomvfS6gSPHfm2eN0Axk+l5mL1ISVq1lJZZLSvzEoToQq4+X0xh1Wl/rLxgNk0fNTi2P2v0zY29neUwyCaIbpZXSqHe/wUCOOZBHloq9D2mwAsBEMUOVrG8XH3WzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071413; c=relaxed/simple;
	bh=JSsSj8j1NHKCNf6z2Fz/W6a5Qncr+IB70eDEgwh8c8Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pWSl5hNhkemSbxl0m7m5GeXLJuolgi2i1+fDIVCsex+T/tP/R1kNjb3WZQYex2wnpgJ8m+D2jp0WqyQbTpKvuY6DildoBGTU8qJSt4Ci+M6AUKW7+lT5vsqENfmTs27NCTuEGIKf6lRH6XNezoYDrZllazwO7sT5IzxnFORj56U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYjhGmEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYjhGmEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9268BC4CEF1;
	Tue, 21 Oct 2025 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071412;
	bh=JSsSj8j1NHKCNf6z2Fz/W6a5Qncr+IB70eDEgwh8c8Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YYjhGmEL4s/LRXOWHewR2YeWHss/1EeSK29wQ8kwNV+NBTJAWgU86D01hOV/Krrmw
	 j3qwrWt/fARa6WGK5n6wPpRLeGOp3VpOL06/KJD1uwbThGLQH0E9vfdANdEDQJ953Y
	 DhOMQ7lz+kv6bneL1/2tV5hBSYXVl2oicWzPz9UqNp4LKX/HvP7ixnTgi6OfaDMIX3
	 oxlKbzkkcYDAL38G0J4OEKhDO+WTxf7XPMRCc4eBcF0X4MSpsZsrYRr7KQx7iK2duc
	 wR+mGuRwdclR2gFx+pdWEUED7sekkFkldxGaOj5GA3tK/rLb8XSCcyxwQacRzU9ccM
	 2vdyM6qjZJC3Q==
Date: Tue, 21 Oct 2025 11:30:12 -0700
Subject: [PATCH 2/4] xfs: always warn about deprecated mount options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <176107134023.4152072.12787167413342928659.stgit@frogsfrogsfrogs>
In-Reply-To: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The deprecation of the 'attr2' mount option in 6.18 wasn't entirely
successful because nobody noticed that the kernel never printed a
warning about attr2 being set in fstab if the only xfs filesystem is the
root fs; the initramfs mounts the root fs with no mount options; and the
init scripts only conveyed the fstab options by remounting the root fs.

Fix this by making it complain all the time.

Cc: <stable@vger.kernel.org> # v5.13
Fixes: 92cf7d36384b99 ("xfs: Skip repetitive warnings about mount options")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d16..ae9b17730eaf41 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1373,16 +1373,25 @@ suffix_kstrtoull(
 static inline void
 xfs_fs_warn_deprecated(
 	struct fs_context	*fc,
-	struct fs_parameter	*param,
-	uint64_t		flag,
-	bool			value)
+	struct fs_parameter	*param)
 {
-	/* Don't print the warning if reconfiguring and current mount point
-	 * already had the flag set
+	/*
+	 * Always warn about someone passing in a deprecated mount option.
+	 * Previously we wouldn't print the warning if we were reconfiguring
+	 * and current mount point already had the flag set, but that was not
+	 * the right thing to do.
+	 *
+	 * Many distributions mount the root filesystem with no options in the
+	 * initramfs and rely on mount -a to remount the root fs with the
+	 * options in fstab.  However, the old behavior meant that there would
+	 * never be a warning about deprecated mount options for the root fs in
+	 * /etc/fstab.  On a single-fs system, that means no warning at all.
+	 *
+	 * Compounding this problem are distribution scripts that copy
+	 * /proc/mounts to fstab, which means that we can't remove mount
+	 * options unless we're 100% sure they have only ever been advertised
+	 * in /proc/mounts in response to explicitly provided mount options.
 	 */
-	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
-            !!(XFS_M(fc->root->d_sb)->m_features & flag) == value)
-		return;
 	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
 }
 

