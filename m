Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F58345CA3;
	Thu, 22 Jan 2026 16:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097811; cv=none; b=hWTZVKZIM6bawL/O2RCBWEmUDCtU4d8I4aREcGPmxh8XUY9Uy3SoGAdkvVyksobxLX563iyNRRNq3D/n0FX40MB4QGJMe8+Ai/kEmkmis9wWK9IXpQ+biSO7T0IT/M4mkz9ImW7k/DkrSYIY/+SdWBzcOIcu7ujvrduOnY9AAqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097811; c=relaxed/simple;
	bh=GXwc3T1dK/s1GVRYygy2LTGFyXzE5DUI3PzhaGSwy6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8imOsk00ddFFNiA5QnH4p6XZoN4xkoMzph6pW08Rb8hNVpDP6wmQd1YP5ZLvfedGEfa2K002QeHX++A7MxLa/fO0Nvu2JGUNGjbjViJpKT0+YGDAXdec+dBnqeKOQr/iBZHoW9M6oIRhnGFmjERcvowDPSsLKGq4AqWg1kG4gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOL/Iu5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOL/Iu5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F38C19422;
	Thu, 22 Jan 2026 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769097810;
	bh=GXwc3T1dK/s1GVRYygy2LTGFyXzE5DUI3PzhaGSwy6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOL/Iu5lYJrfWt7AdjurA5AAr535dACaIt1rCh6pDH6UJL8aStqk+vmczuyu7q3al
	 CshAXFsMAWk2XwtEY7ZdTXQbYLz1Ape5FE/veCjXG8wl0aYcgGNB8UNXZ2BXbQVnLg
	 GbyBiAlqUVFpkGLkHotaehFdccEtKdNcJYqfhApJCjY0oSpBB/Ly+Zyt1MYoeJnpPY
	 X+W2btCpei2hvJmPCGS9iB8HPhB9g1HIdvI3MGt6zkfLR77H0O/25qEGkw5euptNAf
	 0tqgvPgucRZAfwaVoYjs0BBEkABerdUv5hKb69k5P0ThSeezUObI1ZCSyC4P3rnLGJ
	 3yL+9lOUPRH7w==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	<linux-nfs@vger.kernel.org>,
	linux-api@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com,
	almaz.alexandrovich@paragon-software.com,
	slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	trondmy@kernel.org,
	anna@kernel.org,
	jaegeuk@kernel.org,
	chao@kernel.org,
	hansg@kernel.org,
	senozhatsky@chromium.org,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH v7 06/16] hfsplus: Report case sensitivity in fileattr_get
Date: Thu, 22 Jan 2026 11:03:01 -0500
Message-ID: <20260122160311.1117669-7-cel@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122160311.1117669-1-cel@kernel.org>
References: <20260122160311.1117669-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

Add case sensitivity reporting to the existing hfsplus_fileattr_get()
function via the FS_XFLAG_CASEFOLD flag. HFS+ always preserves case
at rest.

Case sensitivity depends on how the volume was formatted: HFSX
volumes may be either case-sensitive or case-insensitive, indicated
by the HFSPLUS_SB_CASEFOLD superblock flag.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/hfsplus/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 7ae6745ca7ae..ec9a144aac02 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -694,6 +694,7 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	unsigned int flags = 0;
 
 	if (inode->i_flags & S_IMMUTABLE)
@@ -705,6 +706,13 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 
 	fileattr_fill_flags(fa, flags);
 
+	/*
+	 * HFS+ preserves case (the default). Case sensitivity depends
+	 * on how the filesystem was formatted: HFSX volumes may be
+	 * either case-sensitive or case-insensitive.
+	 */
+	if (test_bit(HFSPLUS_SB_CASEFOLD, &sbi->flags))
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	return 0;
 }
 
-- 
2.52.0

