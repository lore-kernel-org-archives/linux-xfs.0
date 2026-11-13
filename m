Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571355;
	b=cy2sRv+KlbSIWiru3VAXM7zZDslB2WRGtBnkNIuoVhoCIeRpvkMo4GMEaB0V4d1KRgkf
	 6RKaC3dzi8Vm7sYqOHImOqAj6RoiFIaRYj4V3mGz0thbNzztqBfmN4Ak9cK9cO4qc23ds
	 DFE9MZhPGNvMfMNJ4zm2V7TktByj+cSV4be6BwCKn/DIgw84SJQ7Rs5r7xcweJumBY21P
	 mAEkbucSIVyEBiaXXbcpErhl22oHD7KAQY031kLw9b6hOSOIMHFxPgLttMh0cTxYaDMS+
	 i88O+qIWmfXYMcmrq18MZ5Y7U3FC5+pjb81HdfwMPMJvkheLzlFkINPdU6wfCv8r/aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571355;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nqpl7OV39r2iQfy91FqwaHd5ZOtj6zGRSvahZGEYD+E=;
	b=tRMrYiX/KUHWHcuZ0mG3sKm7GbDgWs8D+uc60njCf7qYAw3lV2j4713lkFSXYr4RPLnG
	 P/6iJOrzKyjs28XoQOzicJF9nmqXMSAC0A+6xTZV0lju4Fuz7YvsvLpfOrAExewSA9hiT
	 xeeE8ZBq4n4Bph5Hqh4LRBtapM0XwKM8K4Gzcxt/mrVswuhsUzMIHAmQ2nXsZVd5Z9cev
	 lm3GECUE2/oaf+Ldsa9FUZ8FfltCiytzqxw7x6fh7HWQcgoFWq//LHCx4kEzpKnhaQqFH
	 mL39pNkF30KMb5RORrPC0m6s+FsePtcvT49Yh2LMp5p7oSsWFE2lkqxGXGnmP+0IlQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cf+yeFhO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47B2606A884;
	Fri, 13 Nov 2026 12:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cf+yeFhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF12E1F000C4;
	Fri, 13 Nov 2026 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571354;
	bh=nqpl7OV39r2iQfy91FqwaHd5ZOtj6zGRSvahZGEYD+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cf+yeFhOxffbF4Gcf34O35WTxadG12WvPaCmfzpM4r32A0Zx6mgMDJc1sLO/YM6kO
	 AttOejPt8vjAVMDguouOKgG4chNWLadxzD+/+x0udw00EWdrBxZXjjyUGxXiNfr0KL
	 2Cy4hMfY6XBfQRpX+3tRTOLMyM9ycZzFnmbhGe4vQX/XMXAN8zxW+nTIQRZUDSPFN+
	 UA0HoX/cY+5dUrCcKOGhiq27KEj1oYfFrxgN2XYCRdQGCGFk9rXYAWmgfrTpRTXfVE
	 pkxsl//WEYBESVhL4XDuY4okx74G61h8X8gdb9K34VBxKOCwUYhd2LlsYSC6gjpuqG
	 xJXrsVuVLfs5g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:29 +0100
Subject: [PATCH v3 33/33] xfs: allow remounting read-only after a shutdown
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-33-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2142; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Wv1rk/34mZRddPCwhZsrnHdy4Y6/8eX5Up6b2ymQePk=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr2+8Ci+Z4+6tOwi97X6NaG06NaC9t14B0Ks88kXi6ffXLsd
 Yh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr2+8AACgkQkcYbwGV43KJHWwD/VEUp
 qHV8TWkuKU4bX3KINk6z04cdivoCpFl2Vn3AuVEBANhCoTbo2sLJQwZevodePoMGYTNnOhgh2Gr
 V9nOa3SIE
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

xfs_remount_ro() starts with sync_filesystem() which fails with EIO
after a shutdown. So a shut down xfs can't be remounted read-only and
emergency remount (sysrq u) WARNs in reconfigure_super(), a panic with
panic_on_warn:

  forced remount of a xfs fs returned -5

Going read-only doesn't need to write anything. So ignore the errors
from flushing and from freeing the COW and post-EOF blocks once xfs is
shut down, also if the flush shut it down itself. The rest of
xfs_remount_ro() copes with a shutdown like unmount does. And refuse
going back to read-write with EIO, xfs_remount_rw() didn't check for a
shutdown at all.

Fixes: b97cca3ba909 ("xfs: only bother with sync_filesystem during readonly remount")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_super.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa3846..59c83438d402b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2041,6 +2041,10 @@ xfs_remount_rw(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int error;
 
+	/* Nothing can be written anymore after a shutdown. */
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
 	    xfs_readonly_buftarg(mp->m_logdev_targp)) {
 		xfs_warn(mp,
@@ -2115,9 +2119,12 @@ xfs_remount_ro(
 	};
 	int			error;
 
-	/* Flush all the dirty data to disk. */
+	/*
+	 * Flush all the dirty data to disk. That fails after a shutdown, also
+	 * one the flush itself caused, but going read-only still has to work.
+	 */
 	error = sync_filesystem(mp->m_super);
-	if (error)
+	if (error && !xfs_is_shutdown(mp))
 		return error;
 
 	/*
@@ -2133,7 +2140,7 @@ xfs_remount_ro(
 	 * cached inode, so this requires a synchronous cache scan.
 	 */
 	error = xfs_blockgc_free_space(mp, &icw);
-	if (error) {
+	if (error && !xfs_is_shutdown(mp)) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}

-- 
2.53.0

