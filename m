Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822676;
	b=VmD3taR6HVbSPJN7vLT/lRdE1lUwzElpk2BnKJQ2NGEHSLy6jsXccP/yjLMIYCR6iXsS
	 I43yjq2ISFtq47Yy1e/ehbht69Q+qHA5ukhCdAIko0+KzIe/urMMoeWF6Yxxtg+EsAjhy
	 4RBcJf3aOJ+t3swi3Qtjc52DQZ3V2HuSvWjyOW1UPUTL4Cmj1L5XLfgTGsvM4WFsIAEMz
	 uXj7I2j/TCFHbp1RREOqqbfAVyLn3bkKoaIvcpNzSwkHXLwvb4ujkE0hxTXdgktfwIW1C
	 jP/RL2N/RsI/W7tslH/2cPlRHCwNnl2XqK/w0/8Y/Uga3j6Oeq2sMYhjo+3NgdDI2vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822676;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=EzogT95rPEGnXO3ATl8QCqS0Fa+QqsMtxOYoDzHb5QM=;
	b=vb/UyPGGatyGlhj6/fHSZoIoENfdIyQE025HEmrRazPdZjTsF3gi1D4pjE3gHIaaushW
	 +MrogJAQDmtZW3SoPgQ4SlA+CVKthYTOafuGmUEV4tgLEgW0oOLwn2IFLDrBhGWdSWuyP
	 zXH9aYkwvBGY17cm48pFDbg/JGtJS+ClKHz8IIq8pYR/DdNzTppHYzIgqWeAoS83thlsN
	 +//jPI3tqLx9mzJc+KRL2Fa3IDz7BiUDPH9FiKm5Q+cbn7kbI6O+nIhpXTmUT/Av97biV
	 qc5VOLJZnXg7w7QTDx6XSgmfSc6n3WF5V6AiuWUP5bcpLpPTyMtCiXK0cO7xhYqYOrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaZ6rFBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26AA606A330;
	Mon, 16 Nov 2026 09:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaZ6rFBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014C81F000C6;
	Mon, 16 Nov 2026 09:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822675;
	bh=EzogT95rPEGnXO3ATl8QCqS0Fa+QqsMtxOYoDzHb5QM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VaZ6rFBAYjR/HM5+OlC/kYBh9eokBcyBlJyjLDEGD3pr/1owKWYUkIFonZyVuLy45
	 aXIGPPwoZFzAFIrDJPr3o4d1FYCF6gEzK4gRGZMRojP6nXuxOYWP66LFhY7XK4EIId
	 0F9FdRrfySm5SdHKaihGgGUwCpa5ozWOd3R+kAWEW0AOMp5LPHNYZv/BWBQ180WmCq
	 SGYcL6yKiAUlp1bl5aKgR19AOXfXXbOhxIdLs6gAifxrWtNtvWUXEAaCGYUZCiGaa7
	 +ReHVuM/M8xxPRelVNj4Hcpgf82OBXtXi/ghPvFAodx9BDyUzwtyIaiRzYrfov1A8G
	 2aAwCB6uJL+Jw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:28:32 +0100
Subject: [PATCH 3/3] jfs: refuse inodes with a negative size
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
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-3-95a25ce917ad@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1127; i=brauner@kernel.org;
 h=from:subject:message-id; bh=onsWAswaduk9DxHd2totA7LRgkoacrrwUPGlfjERZww=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvg/zPh7v4jJl9XJS1adTMmvc90Wskhx45urIQq/v
 +i4RRtkd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzExJjhf0I6X6NS5kOr9nci
 S1rdsg7WHb7PbXFnnvjvWZ/2HONbz87I0MOYE+3LnyrOK2+kdcN71Zd5ak/MHTqmCyzTLfcoFP/
 EDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

copy_from_dinode() takes di_size as is and a crafted image can store a
size that is negative as a loff_t. For a symlink that passes the signed
i_size >= IDATASIZE test in jfs_iget(), so it's treated as a fast
symlink and i_link[i_size] = '\0' writes out of bounds. Refuse a
negative size when reading the inode like a corrupt dtroot.

Fixes: d69e83d99cf8 ("jfs: ensure symlinks are NUL-terminated")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/jfs_imap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index b84ba4d7dfb44..f88e228d12620 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -3079,6 +3079,10 @@ static int copy_from_dinode(struct dinode * dip, struct inode *ip)
 	}
 
 	ip->i_size = le64_to_cpu(dip->di_size);
+	if (ip->i_size < 0) {
+		jfs_error(ip->i_sb, "Negative inode size\n");
+		return -EIO;
+	}
 	inode_set_atime(ip, le32_to_cpu(dip->di_atime.tv_sec),
 			le32_to_cpu(dip->di_atime.tv_nsec));
 	inode_set_mtime(ip, le32_to_cpu(dip->di_mtime.tv_sec),

-- 
2.53.0

