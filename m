Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290183;
	b=SOICikWdb5yOlI0UvCM7S1zLGnpz6YB1LepL3H13xIDfko8WVvw9V4ttcP82HeYlX4E6
	 lb4FcO0jf3UGrhFzg4xafUPTf8zhu3aILyYbjH3dx9aImhLcns7NopcwhridG/zLf34H4
	 KvA7qN8eETaxbGlNsOtgmx6cAWjsgZtdbxWFR8x35dq0ZdhkTaF01PQOspSozbXapP2N1
	 lVAnTGdrThP6zocqq3uZIIGkMTY5fJ0OeXUzx/2pD5oc0wnMO8tH4tXpF4NNUxw8oLqAH
	 +z8mOp3HhYMlDoG9ZONRPeO7oa0Qdh3yYDrMJ2+Z1aG/4+Sfqivc2tAOkm47ypvB5jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290183;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uu2WZyDd3RZlZWsibqonNb2mhu+3OgxLhhAg+SnBEig=;
	b=O6WcFjG7oM7lZ4dBg9V3jZghcQKkONpx+pAE5F1pW8HYDmay0utRsktTTfNxJ087HE4w
	 nyconZumXb2q9jXDO1bLkIOjP42kEqVSF/G2A9rRjW6jGtnn4kTVc8vUez1YDF2Kfb0VA
	 up1SgmQD+WIjHw3XbmxxI/sw6bH+rwS/acshv6RE6aGQGfIT7Du6apbMOml1tjiUyu3Jm
	 EF8UbAm3i11sutZCl8iNte1JV9tgj7WTTsyvSg/JRmwJNYRVoIxOyyICAAGhUhVUtXvv1
	 4+eoiJuePIa19O5z9/76ARwxe+Y69lUQm3CGuwzSJvhuasuPErMEqF9pROcOXZF8GXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nMjZ/AQE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90C5606A32C;
	Thu, 29 Oct 2026 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nMjZ/AQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0168F1F01825;
	Thu, 29 Oct 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290182;
	bh=uu2WZyDd3RZlZWsibqonNb2mhu+3OgxLhhAg+SnBEig=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nMjZ/AQEmAxledocQ9n+3ExKHoDEzHnf0mT+qoruM99B/d+FhxzlfdtRVlmt3+iCx
	 IwzpcFh7kugD3gwuTS9UxbnfonMQCdfrr7oKzA5E2T6EDI4rTB2cqtcAhGMSbw02M8
	 Ln8vA1wzgrdhCfq0EYl+yLzfRhyU+o6Q5p4s7vDMU87X5a0cSuKZK5rMcwWp/RsBiv
	 zOYeZQh+1uCd9Epg2VMVj8Uq3/P68Qlf9ffbS13vOiEfBVGe4T2BFmNIWQv6L26HUN
	 km/Kayv7uhrohDU0JU7L+XvpBIeVqCAiK+BrnCuylApb6wPnkl3/BQXRf/EMaxfyXp
	 VDORzaitoD+bQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:24 +0100
Subject: [PATCH v2 33/34] xfs: allow remounting read-only after a shutdown
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2140; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3Kb6qOKbZ504nrKdu5KYQnNbjYN4iHgbKmRWzuk322Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjdInCYZ5rLtdpyYVoEzQ3Vh8D/eS8sNopf0/lyTd
 cnA+ndKRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQuqzD8L479erR1WmD8TYYZ
 bb8fbl/56OjM+fXX/jcfVVvPeGrejXCGv/JtQZsquVR7XNepyVmqvg1ufriNmz+MdVKf2vWSC6s
 YOQE=
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
index 5a06132aa384..59c83438d402 100644
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

