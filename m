Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822662;
	b=ZPQ+6CCZU5+C8W7QRERrUWVmAMKbMpSTjNWnxfBgQ71sTBwVLLOPihzTI8+2QHfaXSyT
	 xbCtMzsei30NPh/wOac1UkJDleK1tZz75cdwr9S44aW01oe69Zxdr41HJckEslaTWQh9G
	 QyyRLVSw2Oy3yTHSLT4NJt4wg3iqLJPjvyHGvRVMoA+aIufWk0gvE20+ZYEcDrk84eH+d
	 lKju4ajpcqjL4IaHbi7r20YBIiSnmb0tZXOuUDF+jW7IWONtwXxuhjyERe6GMHTrQ76qN
	 conCdS4FuF3bwLodk9q+k+2QGgKsgkEaL5GZGZ7dmwcOuT0NVRS7t1G6RmqBqLtof8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822662;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=8aRGBcpvx8xM7mxQtHaidBWPdNvahzYjZNEX0jkJ1yE=;
	b=AUrbPjzgtiJkIiQW5UyWbqc3vElwrUqFRgzM+ZY6TBSKyWfJnOHvWoPG9mIzihpnPD5W
	 y1FSQqwPly9nPWi4MJwgN9TiEEmq0/Vq7qNvvHDpMPg3gYC01fpg4U0up3zZDTPE5v7Ei
	 pXnFXmRXyKszyGpdnrghF9wVvKIXNcnDqP9xRgj6lIQbqDv7KVTmOQwvV/NXOpDESWa+4
	 v6SVAasxcdHcxXKOd8Qu2ZGUx7hq0D4kC+iSOPHgOO18M2nCgkvPeC7mNJVB/31MVWtkO
	 p4gDysvRMYSV9PEt67gatrbm7A8Oo/fujSfwBxTteo0aFyXUrSJ7fJ43qXr2MTOv/hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2+7tRLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7E5606A31C;
	Mon, 16 Nov 2026 09:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2+7tRLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609D61F000C4;
	Mon, 16 Nov 2026 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822662;
	bh=8aRGBcpvx8xM7mxQtHaidBWPdNvahzYjZNEX0jkJ1yE=;
	h=From:Subject:Date:To:Cc;
	b=K2+7tRLzUA1vHpSh9Z4eYxrLSWLfx3VxiAtV+I2wsfPNb9ufsZBXDAGRXgVgW5eVT
	 7EPd2127puPa6m8jR0gUbbLngHeCTt0SNmH9jNftFfvciTpnZOwt9ZFB8xaifyNx5I
	 6T4/eGhfCJ4f1ugyPqE8JW8/pgNBj81vq/a0P4QMlvX9rDmpcnRbSLEfn3OZwjS09o
	 Ffj8QthI/KmMMkRMsxQrY2bpnNRJNH0bSetX/pu6Ptvz0r4Eeu9O8UNelZBCix0Dko
	 77WqR1fbWuPXsEef+M7YM+E7QUpfT9xgzJUFuXdxSrgNBt3AgthI6/SanCUbgR5X4y
	 DYCuvs09giVyg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] fs: pre-existing fixes for the SB_RDONLY series
Date: Mon, 16 Nov 2026 10:28:29 +0100
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2M2QrCMBBFf6XMsxOaoK36KyKSZWKjksqMK6X/b
 qLg47nLmUCIEwlsmwmYHknSmAvoRQN+sPlImEJhMK3ptNYdPkc+YxQUd+Aw5ssbY3qRYOiXfmP
 6uG7dCsr7yvQtynm3/7Hc3Yn8rerqwlkhdGyzH2pUxSqK+otVHcA8fwDm31WGpAAAAA==
X-Change-ID: 20261116-work-fs-sb_rdonly-fixes-d74c927f80b5
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1425; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jeCsQzF34oL0Arvs8F9B2uJQSCX+EzbT3qRU+Rbsju8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvi7fE9w7bmpcv5J82/1za9S4FUrcTJtdFY06i+ct
 14hJSyuo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLiSxn+p61423H1yuqphyNy
 CypNQ07uYf2rs/yuFLtD9f/+bZMLtzEyTOL9teBm7yq3mqbpzbY+BsIR898sTkj0CjXjaTy2tLW
 IFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Three fixes for pre-existing bugs that came up during review of the
SB_RDONLY series (cf. [1]). They don't depend on it and are all tagged
for stable. I'll put them in front of the series in vfs-7.5.super.

- gfs2 hits the BUG_ON() in gfs2_quota_cleanup() on a remount to
  read-only after a withdraw during mount. The withdraw work was never
  queued so SDF_JOURNAL_LIVE stays set.

- exfat marks the volume clean at umount or on a remount to read-only
  after a shutdown with EXFAT_GOING_DOWN_NOSYNC although it may be
  inconsistent.

- jfs takes a negative inode size from disk as is. A symlink with one
  is treated as a fast symlink and jfs_iget() writes out of bounds.

[1]: https://patch.msgid.link/20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      gfs2: don't BUG when remounting read-only after a withdraw during mount
      exfat: keep the volume marked dirty after a shutdown
      jfs: refuse inodes with a negative size

 fs/exfat/super.c     | 3 ++-
 fs/gfs2/incore.h     | 1 +
 fs/gfs2/ops_fstype.c | 5 +++++
 fs/gfs2/util.c       | 9 ++++++++-
 fs/gfs2/util.h       | 1 +
 fs/jfs/jfs_imap.c    | 4 ++++
 6 files changed, 21 insertions(+), 2 deletions(-)
---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261116-work-fs-sb_rdonly-fixes-d74c927f80b5

