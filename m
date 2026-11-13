Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571224;
	b=stoLmPWH3dHTZOfv37e0Yfrcd+egaRFAT30yLkaxmzJSj6LWh1hNWuE6o17MYJqK0yPB
	 +y2AnT5mT1OLQql2C1jgCNMNHVthnf7mQtPYWL2q+VZYXF6FZc4LDu4AmVeX+YqHFr0HV
	 TPuM6rbJt9oqDVPT1uPnUUtDffhZFF5sFEbmCwnsUYrBhLmgD4M34cwUjYWXImMv4uOm0
	 gp03SrBYw0B7l0DniNI/ESOzVHhRvCpf9/4efAJvSjzezRwCQKUhIotyVRxpgPqnfgy6g
	 cMQbMi83ctaOOa8LWyH6nWmOBjbVk1I7+gjaZiOLYn+XTq2Z+cDmGH9ZEbr02baIPNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571224;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=fcUPAY7Omn+SLVKKp6rIXL2FdbTX+CoaPRplNDl/Les=;
	b=FFQast2BZYusU78kO667VzD8c/wl6CNwae50E6NbQRKiDD7g6SnjP5FFyPtBdkjGKTzQ
	 oH5RdBrostpqO/IZVaxwbJW2FTgySxJ1v/Tsf5JQKrP5PF5TwJw1EW61Wowj9/I5CgaCv
	 sDqSQ8qIsOJ9rXXPeTEhskYzRSO8Wx475EQkZZTnrkiVczJ6j1lHQlBupnQJ+NOMwInz8
	 IMPaRotx2NkeyETuZQxhADdDYC9WVep8jK1pBu5V5BI860Ss0IkbzUhhPnZ+zspHvMSO/
	 rgQiHn5kq8mDl5VZf1YgWbJZyY39P5Px6W78PsDr102RkTS5f0FucQNONbZRwdyIVeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRILRqwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB32606A881;
	Fri, 13 Nov 2026 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRILRqwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E811F000C5;
	Fri, 13 Nov 2026 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571223;
	bh=fcUPAY7Omn+SLVKKp6rIXL2FdbTX+CoaPRplNDl/Les=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JRILRqwd4JRgYzxUqWzJjNJlZe50YGlY+OaXv6HHQUZ/YRL+egTShAGjpX/70665+
	 Nd9K1WH0rqdzRgv8HsOuog0O0NolbJ+thxfmrdZowu+oxZTtS5QzEQcOIUdVNmx8f0
	 UJQ4eQhxK+Fnl9k+68gHrlzlyKY1NN8Vyj/sEz9ODGaM5Rdxwnurz9lGIsrgOf3Lcj
	 SmgyiukO64uSDlM/RD3oySDk+ptebhvq18FN4TuIt6DchF+K+FbLsqScLqwKzVdZ8s
	 LrgCTVlLMbHT9Vv3dBRYuIx42nvdS3v4ICzRtq/RueTY/XtvzirWDph/Fv2B53Vl4Y
	 Cbno+lrB2kv9g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:58:59 +0100
Subject: [PATCH v3 03/33] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-3-0be92bb73709@kernel.org>
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
 Farhad Alemi <farhad.alemi@berkeley.edu>, Tyler Hicks <code@tyhicks.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1544; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YAwCWT/i/fjx/KfCi+3/MK6nbc2fiyWIJhkFODNNUZ8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z1HsaTv488H3xpWX/srV7CPeeZrxWrdNBszu55di
 c3reiZN6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIrjQjwySrtUH91ksq2b6F
 f2RuXzKXt/pX8WYeq3KBE7xBVrNFCxkZLgr684g+2JrpYdtgKnfy3fWJk3dof9NZl8QWURbxans
 0OwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ecryptfs_lookup_interpose() opens the lower file of a regular file to
read the size from the header. If that fails it marks the inode bad and
returns, but a new inode is still I_NEW and nobody ever unlocks or puts
it. So it leaks together with its lower inode, a concurrent lookup
through another hard link waits for it forever and umount complains
about busy inodes. The lower open fails e.g. with ETXTBSY while the
lower file is executed. A cached inode is marked bad for all its other
users instead.

Use iget_failed() for a new inode and iput() for a cached one.

Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
Cc: stable@vger.kernel.org
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/r/CA+0ovCgYP920GT68hAJK6Trjyv1kGv2dZAuem4LEunycQ=POww@mail.gmail.com
Acked-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 48e520960d665..3a966348a578a 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -362,7 +362,10 @@ static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 	if (S_ISREG(inode->i_mode)) {
 		rc = ecryptfs_i_size_read(dentry, inode);
 		if (rc) {
-			make_bad_inode(inode);
+			if (inode_state_read_once(inode) & I_NEW)
+				iget_failed(inode);
+			else
+				iput(inode);
 			return ERR_PTR(rc);
 		}
 	}

-- 
2.53.0

