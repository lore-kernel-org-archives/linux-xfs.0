Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290045;
	b=rOiNZHOhAbjQqZa+5VPtITKoCb5bBeBewJYRhmHkNEr9C1T9ZKbQ8w+evfqRk6j8i+2l
	 eJNkSwNCh8vZtHfHTNMc6VlMXGB0XZrzbybZLjVSIT+YzpWlTtlYZ5kfpdiht5X8nPoDz
	 LWh2OXwzsv13MSNW9RlK9A11QgIIl3A6POHJNWmeJPQWGHjMz3OU1yppnrdukEzCicbij
	 q7Kp9/NYQx/eaxGW8us5ltX2WS0RtD0Ch4PG24BLIw6zjSAoCj1C80raGHRPs2XTrYOXk
	 Xveve5Rp2eX3wiOhUVVoJ3hKcDxAJH9JOk8kth/bh21bGjZeFPC+gvc4Ai19FnldFnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290045;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uBzHd4puvf7PelR0/56wwfcOU7QQK1cg7vOg9biOXQ0=;
	b=vlWwFhle4psuBeVXlvaUNOWCqyHeNI2uo74us/fRmWlt39ZuFimmJOmVIGv40W9OZ+gw
	 cYOQcz/4Q27tw+YzF+g/TdP49vQDaovnxPQEm+/G0Od9W6VVyNa5Hrw1exqw/mJ7tBn7d
	 G35ZsiXuW5pjRZlINDII7qyZ8dofmxdc+60P1ARK1xY/nuaUfF58sx5we4Sbhh5Zaz02u
	 rGUSW543ZK5hrLNhGtoTH3g+vvPeOBsZuH5AfsfRt+yMJpdCeCtdPDtqnbmX59pJn++T7
	 wv+OAaBgLPMAGB0rJ6dLlJBLamlBwmJCUsEiUTilkcuN7kmnIxrVZGfafGv+KvKKKYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m9szMX/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519F606A32C;
	Thu, 29 Oct 2026 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9szMX/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EA01F01816;
	Thu, 29 Oct 2026 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290045;
	bh=uBzHd4puvf7PelR0/56wwfcOU7QQK1cg7vOg9biOXQ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m9szMX/fEVXD68Fjo3EeIkbSZWBiFCaUdnZ+VIh59ux0qGOuLrE6FOEM4OJ1WZJSQ
	 f9sjcBIGp3cmwtR0Vr1suMoxuUz16RM22QVCXpsDoj7hgG+YtZpQhzQ+8ERPTwSOx+
	 FENqtUXhbWb6AJt7guMCyWwmoiN2tg6DAlUgnisQ768405K+ORmRZs5e5Mai6t3IC7
	 JCG+wlnqB5yg7zzE/v6YXROVwr2DAybfz/I3VBKz/fd7tFcRlVQ9jktvnhDRhYblg5
	 /ZXlk9pRMGfEiSj5AyGOVRF7ifG92+RvMqsktF5VXStBqOVxXjmAQApSiLmPU3bTZN
	 rhuPH0MlQETDw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:52 +0100
Subject: [PATCH v2 01/34] ecryptfs: don't leak the inode when a lookup
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-1-2f44f64f0b66@kernel.org>
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
 Farhad Alemi <farhad.alemi@berkeley.edu>, Tyler Hicks <code@tyhicks.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1542; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x7sC/M8PNJXXdVBMQkSwa4kj/sguCVJ7hcSWkzP5Ueg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfzU+27Xxy89YL9ydKruYr84d16Vtu6Xx3cYmlqd
 2qRy3v1jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlI8DIyHLp2+rNUvlLI3k6/
 3/ESRv/2vGuTuqrwxpzRw0Za2C/LgZHhgMcuQdFr2SV/T3svv3sy4ytP6qPJq7j+hG79yNS0x2Y
 vMwA=
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
index 48e520960d66..3a966348a578 100644
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

