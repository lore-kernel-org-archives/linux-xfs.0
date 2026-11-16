Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822670;
	b=x9HCcftWI1bMoiDJU7O/7tAPXb7Cs9EdFPDq6WB4IQQdRTIQxbyEYnTHxgH8oBEaNdcp
	 Xz66dHbjoQtKNZzc/DN9AjGu3ne0h4bDv5zVEBhR56CXixoGDOxcdqb+imjIrR0wCxszv
	 dZE0I4+4DR4oKLTpuM5WYHFm0m4Z00vSTpBlzCgvyeUvHh2ccRvndvdcR0CoAFTJifzBR
	 nOjCN9ZFmJl2AWDj0+3J2nS3zr6EzH7ulAd5/iIZuvbKNDIfw6zW8DhCdapzzhLT9qxRh
	 sCPjS16T0MDuv0/aghQ+uSfFPv5rjnboVZHke0gvsR0EAOyxcR7DMQZRUyowjtDDNPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822670;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=L1lZ5wfKib47+5cbYuK6ksYT98WTq4lYB0XvmtFMUsk=;
	b=wA6rD1zYqQ5s9YfD+wk0toqotos4w+kN3VJY/1YNDGTuWaindZVKqsNl4V/BFiHd1Lc+
	 IUVkqWVo6xr4dI7xl+cshjQKKzES2sIMTGMCTmOKEYeabpuVCVPxDKFIFsvBcUGXRkH3w
	 nNdiEonus2JOsFiC//RHa6dJz8YU/COFXtVAQu2O088AafcFezbz7MFlBJG6xdiw1z/Ta
	 cJa7MRUR1PvIpGhBB0O+wAb849QLZFZNrucTC0xhzxZYWk02frtyBZYCm3R1ggI77ld8t
	 V8zCNXGyN5JkTH+EXXpiSZKnG8d4JuFJdJmCr8NrCyPIzxwQdmxrm+Oo/Et1rer3pMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndmzvTxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5EE606A329;
	Mon, 16 Nov 2026 09:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndmzvTxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3FB1F000CE;
	Mon, 16 Nov 2026 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822670;
	bh=L1lZ5wfKib47+5cbYuK6ksYT98WTq4lYB0XvmtFMUsk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ndmzvTxeL7W9/Jdvz6YxY8P8py51Wjc6qNExCmjwvS+9JImEf9epaC85hzjy9eYR9
	 uVUDbSmgWHfI5S2ZpnyUY95j+V+6dUc4x/eYgmcYHu6230ISr7IQbxB7A14/qh1SKI
	 z/tb+w3N095FxQ0FXm2/FU4pUUqM9RlWmH+HUlWsxVqgM3WeZNtSwQQrNUl/6m6qRh
	 pcxjjekvdoG0jkzcO1CZNWORgA41hbfuqMidkny80LdqROFR2yYY9l3tEwpYUDW1B3
	 90dJoUAo/iHmuVyrQsl3XF0DD0Bz1kpLrlqVa624COZ5W1omJ7iv9DbKGwbhBw+vM0
	 xBZY/TU+9NFfg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:28:31 +0100
Subject: [PATCH 2/3] exfat: keep the volume marked dirty after a shutdown
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
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-2-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.com>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1218; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IuQsw0bjMfs69fKlB5zik2hJtUUfvF+Vp2c63qEi16c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvhPuTT10dTm9V9DF81rmlGTNHO/a0zqhAtKP+fGb
 i+6d0DjQUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEUm4zMvwL2pdfVbTdiSvs
 MMdFJu780kSe1jUN1zMVOM8IHBO6uoHhf+KNiUcqlSdfkfxX1DlX5Cf711LOF4I9HiELIqeWdgu
 WsgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

After a shutdown exfat_write_inode() and exfat_writepages() drop
whatever is still dirty. But exfat_put_super() and a remount to
read-only still clear VOLUME_DIRTY through exfat_set_vol_flags() which
only leaves the boot sector alone on a read-only superblock. So after a
shutdown with EXFAT_GOING_DOWN_NOSYNC the volume ends up marked clean
although it may be inconsistent. Leave the boot sector alone after a
shutdown too.

Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 4943cef977418..eef7c159d32f4 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -98,8 +98,9 @@ static int exfat_set_vol_flags(struct super_block *sb, unsigned short new_flags)
 
 	/* skip updating volume dirty flag,
 	 * if this volume has been mounted with read-only
+	 * or was shut down (it stays dirty then)
 	 */
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || exfat_forced_shutdown(sb))
 		return 0;
 
 	p_boot->vol_flags = cpu_to_le16(new_flags);

-- 
2.53.0

