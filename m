Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879806;
	b=3aMljxicSL4DDXlllKvGkgyRmDrjd5Pt18C1eK04/Vr4BQriad7ZUYCoeFsQ/qH5PzYu
	 rRggQL0bH1G1AdszZ56hkw2yz5JyeCgjBDSj5/dL7gxmtsrdHZJ9EPCfZULnbe+R9ZOvu
	 4Xvz+tUfKTHAcojzctn5rJH9AeRbvWst9dAC2Pcut5xfjTt4m95SspFKfI7soO5+tmKLQ
	 IXkzq5ttqAJtolA9hQwDy8mCIR+k/a5/J+v6qfa3jN1rUenMC6vWzzrwldmrknFaNqOqA
	 otrbGklPl7ZnwNcTFF5WHM3aeXSLHVRObqal8+1BSX7P947R/rr46gg1G0ETo5n3VxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S9Elr35owCGoWrbIbOfwaKZniSZ+EtPctIpo1HzYHSY=;
	b=Rzm2VIQoBQGDBT0LyhQn/DhR39rzfLXJS8zJassLJEajOEZs/8o4yVj2APcLukcF1BsN
	 CqLEavwfKvQrglNf5ekFWV22MaCFdtLD3LMWoEncdbyIw+nwP77mLZIVMhd8gEAWn25R0
	 1ki1u8sxwgV3S3SFPZ9tWHvXoxwZQSNj+4XZ7hVjghIDZAKtafdHFjLSURqxF9zTiV6I+
	 c+z/1Ay84IhTGTaW0JrxCvK8lDUSdg6ptsLZVZ8sFxLPYid9BHTQQ6O2B0GNluAVOTeKR
	 x3+SqBYbEAVrxEEGcZnNrRwRuio9O6pyxqhbex7+5t2UuT6AchJLTaWPyl+35hDc2XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DgBGr1nZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B96606A328;
	Thu,  5 Nov 2026 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DgBGr1nZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6CC1F000C1;
	Thu,  5 Nov 2026 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879805;
	bh=S9Elr35owCGoWrbIbOfwaKZniSZ+EtPctIpo1HzYHSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgBGr1nZDAETi124q1hztIbhXV6KtPoh9zp8Kr1LzjPn5+GbCdwbl6JBBxqprK/nL
	 KJr5Gvt5nNxIUrG9+7GyDhCjrCFkGGTUDcnSwU/xJc/nJ3S+qjSMYp2DfB7SzP7+WM
	 lR3RxxVf5C/KduUopuvlnjE9tm2f6zVpmzbGaoMYL7TTAtLyqLGf0b0QbeGQja4ZaX
	 qeZcTF3eb8UWxGQbqqQt4FIAMPKIdmXwSBputI1wBx0D3XQWUCqF7L0DGnFQ2iaEgl
	 la51mVTz2YciPEh0TEggsXfjJcEQ+4+TRICemIp9QK/kMTfIRZbpYCAwK0WJepNQci
	 mSBNyan/kY/Bw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev,
	dsterba@suse.com
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jaegeuk@kernel.org,
	chao@kernel.org,
	tytso@mit.edu,
	Boris Burkov <boris@bur.io>
Subject: [PATCH v2 1/5] fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Date: Thu,  5 Nov 2026 12:55:26 +0100
Message-ID: <20261105115532.613467-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105115532.613467-1-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
Filesystems could return verity status with GETFLAGS, attempting to then
pass FS_VERITY_FL to SETFLAGS is not allowed.

The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
doesn't work on BTRFS for fsverity inodes.

Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
no-op. The file_get/setattr() path is fine here as this flag is cleared
right before fileattr_set_prepare(). The future fsverity support in XFS
would also need it.

Cc: Boris Burkov <boris@bur.io>
Cc: David Sterba <dsterba@suse.com>
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..b43977d5f8e0 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -199,6 +199,16 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (err)
 		return err;
 
+	/*
+	 * verity is settable only via FS_IOC_ENABLE_VERITY; never through
+	 * fileattr
+	 *
+	 * Treat it as a no-op so the FS_IOC_GETFLAGS/SETFLAGS round-trip
+	 * doesn't break for other flags
+	 */
+	fa->flags &= ~FS_VERITY_FL;
+	fa->fsx_xflags &= ~FS_XFLAG_VERITY;
+
 	/*
 	 * Project Quota ID state is only allowed to change from within the init
 	 * namespace. Enforce that restriction only if we are trying to change
-- 
2.54.0

