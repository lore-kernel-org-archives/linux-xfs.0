Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290174;
	b=JxpwqXAwb/xFOpdM0X2wHhnfHHahIOd0gf0iGEEejNUFrhnuAxClJAoOhq37iEmhHkxO
	 BE9rmlLftW5zvFRhSuF1dj79EhPL2+1ShFHES9D4Tqx8Ob7VCb9geR8BHBSvck1SQoHDi
	 dXdDPFdL+jslnyjTh26aXhT4E+zWsMh6e7cq9Rpk1Rw5bUF3caJp1t2/ob2fOG9p2c3kH
	 cTn8mSnXH5J/UpI/THuWQrr3s4/2nqzTXNCccWmwHAnJFxMzL4nsBibts5niIo1Qp1sMQ
	 554px3b+1+oc2uBqLdC24y/jRG0n16QayheSuf8xuALCyVt7nSZfNA9SaLjXRzBWRvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290174;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=5Pp7M5kHXjNf3+1q9VkVlIi5dRXg3Q7oc/xEP3VOCsw=;
	b=Bk3ik1kAyySxFz6i2ZRTZ6UkbjttGjHbgFgpgiOd1iceJqOY3RoXrf8OVDmVbAD0Ux1f
	 y/WHwgAeGKB0fLP7wfCFza+SqXCEb5pv9Ze6pUPZe15qfBpyLWvTQ5dX7cu1Y2IMcuO+5
	 OUnNagR5oZO3pE0OlfXRB9w7pPHGRyPbZtNVP2uPJmovt7HbdAKT0czsOGuVCYF3ZRiUS
	 BTlAOq/4J8ZXI6R7wvW1rs52l7Xy5whsJRmL7N0kTocv5B1W2QJxdYmyo6pKjq4/eCNZH
	 i0nYJWPNCD/e18QVcqUz9T59IfFGFF4hLdtVSAohn9LzEvIwnYRMHVUDSn0pA5fBblA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LBGAP223;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41D7606A337;
	Thu, 29 Oct 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LBGAP223
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFD41F01825;
	Thu, 29 Oct 2026 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290173;
	bh=5Pp7M5kHXjNf3+1q9VkVlIi5dRXg3Q7oc/xEP3VOCsw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LBGAP2234hdWhTWmkiwtcNBNLZv3kdKW7A12H240APspISuOw8K0/DrAk7cojALfy
	 eCHxkuc1RjFeg9gL9Niid947L2sIZw0O1vp4xM3WSlJ/cIZ+6GJwJzAmYhb1pUSigM
	 elffXST2g2mTJoisTvyydqNgN1fAMiS9HWcTtk4UGR/v1R9ojlbwgaxL0cJDVDkGH9
	 fLOAD9/SI1nCadBee7QduMMaKKYC16TUXwXDzVE2+RpABZBbICCzAn71NbYDalAJBA
	 xiIoaKYRb9NGzWeBGBwaNy4g1sVrHEexNQhZrmOdcjHIG9gTW2Z0Jjt2hJygAQl/kT
	 0cCHArmLVPfmA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:22 +0100
Subject: [PATCH v2 31/34] ext4: use the generic emergency read-only state
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=980; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QT9bEmgMx7HOZfltPAgtswWtwVjCWwJIOMw37FP7ctQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjeY/8T6pH+S+Yw5W3oCW1aZtRdPydBI8eCT75jgs
 r9D4FRARykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwET8kxkZDm07O8G75MpxzcAF
 s/+9sTCSZFr/8Vf0/KXT3zcKLp8yg53hf0Dn32fFXMe3rvnJUbozJu2VU4WVc/3d0K9vLs7e8dD
 mBxcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
makes the filesystem read-only. The VFS then refuses modifications
before they reach ext4 and reports the superblock as read-only like it
did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
and so do all of ext4's checks because they cover both states. ext4
keeps showing "emergency_ro" in its mount options.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ae5ba6823c01..afbdbb607b14 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -757,6 +757,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 	 * and other problems.
 	 */
 	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
+	sb_set_emergency_ro(sb);
 }
 
 static void update_super_work(struct work_struct *work)

-- 
2.53.0

