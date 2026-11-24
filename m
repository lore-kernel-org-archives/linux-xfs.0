Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560586;
	b=JqCTdzV2TzjMJnBa+pSFLBG0rcmCRaZMqK/57KmuTRNjJ+XiD2J2PU3xPRatfsZ8qdPO
	 32SB+X9zIDhm/m4lo7ksXceh8H+qu98zqJyqUXrbDQWSuDOs63jlFYm9bbbV9f3SqvYC2
	 vjZMFMhAItRLkofA426VbQ3KDo3RZXDuRCoteVxA6wwJC0k5ihdaYHT21fREHCQDk5aGu
	 4DC5L1tYFBH/vKibPNDKpgQgNjU2KcJnVCCctgQcDX94d8nDQd/oULCSwI5e88TjIO0ob
	 AM5wZrijxWWPevNlGUfucEbYoJr181LcMHAEK9NzNk9x1P/UQL3y5XPfmVsJvzoEjXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560586;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7oQB3/O/c4dFGNnygzjgJHN8nXWsiGK/1pYzsrZRsWo=;
	b=WQJB9kx8NZrT/LXWBqcBOoyV8eyq1QLS6Dj6KuKWn8YjgSZi8ZlOLd+D8wwOy2vbOhdu
	 3SMKLkaYdNveNssn7SPlMS0w/U4rIgj5zafnbQsWueoTGr+v+C3XPsc/AzwfWALJsvCws
	 z43gF+z1M5ooaNsea7w4PJzm1HtsFnPhnZAU5KsqezAWb/GXwuTvEtmAJ7sDHQvcJ/8hs
	 m3xTcZjiM9lNjUioS9A/mT4XRWmkK48U6kSPIW6TviyTjb0K521lRfsnCWSKH0h5vGOtE
	 NSGld1ebtmX7gTKtSROOAhFXqSm7jPTGOvJw49yeXjpqOstWprcpSSx7ljJp435dHng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJAzHGn+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A8606A321;
	Tue, 24 Nov 2026 22:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJAzHGn+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560586;
	b=YEZCBs00IYOxHSU+s6B3F8pUYKPzOlQMzG7xWE7+6ibgMbQYQiOV9OFlx8Ziq3Z1usID
	 cKNbU+s2m16ZG/4xfZvS9+BktXDt8EZT1TLb8o4EAQkYnpw3/7K6IRh6ZEQFCiEuTOWo8
	 ynkwBtGXsMC9Wc/QyzL05khvcgOY2mHsWfHgrtCYHq7li8jaej9reEZnijIFwTY4AQnzD
	 mVL0FZHCl9Dc14Qpek5q7I0C4w7i977MD20nZ+Q2T4/uI66gbHo1ZgYAfap/QhxO1k9ZL
	 ZSQupsBtrsBKRsX5sc6yGozUXodTW5KqI9qTHvhkJdHM0yo/KYouKF3pPCOlfd1PdiA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560586;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7oQB3/O/c4dFGNnygzjgJHN8nXWsiGK/1pYzsrZRsWo=;
	b=FvMH6zuh0KKgKuAxRKmVuWoc9OMrlsinPuu1S4MPknfXfxFIdtxoLE86KmW7g+vjztJw
	 EbvCfWnHpi4l0iDWjnK/YI9uRdqS0OAnciCN8vaNnDlRphisoy4/jnwgOL0DEJOlZKmFi
	 GGhPv27f6dZIT+R47pHjDpKrcrJiex9ELdtMVDaI0pFR1aj0ppcgUO/dFhj3w7Nx2IMlO
	 6LotvGiyqzP1LnVLtCn5BsHE/US79NNTL/QRushNx+rJzEIv3OpheFeJ756dJIEiUovv5
	 5CRxY9/0f+FtdDt3+pOYuXX/YDm0K9XLhwnLGgKH1U8SFIdC8ke7ZR13sV3Hl3YojpQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9C8A11F000D0;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560586;
	bh=7oQB3/O/c4dFGNnygzjgJHN8nXWsiGK/1pYzsrZRsWo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DJAzHGn+eGaZLPlzq3dgNnxfJP7ZBiBS8a2MoTtnzXr/YmmQIifOt+taW6egoDb4C
	 uPwTW1qxhSfiJR9aQ9aiidjEyninddP/DcC/m1ZSR3IkwDj/r2vUhC0NMRIVhjqm4D
	 w39vrZx+N/xJyN8mgJaSiYv85eKR5mIQ7cep900B8ePTK4CKHphMMdFqVCda/KydTc
	 9+H7CTmQeMOsb6UMOpV7tBZNzEv+AbqzEjtIQFE1HoZOzm+QGiWOy+swT77zaR9bYw
	 L57tOQaATBFX4IZyT1Io+bJNExSs8VqEQMoTHG8uDLSbuQ9Zhrfd5d2mxtfJQX0QEv
	 JuJlC9YADnuLA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2E1F84CC1C;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:37 +0100
Subject: [PATCH v2 03/11] ntfs: release delalloc reservations cut off by
 truncate
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
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-3-f394c800ec03@proton.me>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
To: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Baolin Liu <liubaolin12138@163.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 "Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng1024@gmail.com>, 
 stable@vger.kernel.org, Ernest Borowski <ernest.borowski.git@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3407;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=3nT+zUonqfx2kvoDVZIlPQfmCvPmSP51Ad2wiF9F3AM=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kXr90o281beWvL0Zy2Jz4uZy84q5HW7FkZwrn2YHN
 rheWXqqo5SFQYyLQVZMkaXj/40Qn5Bvn5bFafXBzGFlAhnCwMUpABM5+4+R4QRjZI9L2GqlM+vP
 rEpPW+rqtv/E89/MZm0F09/zcqXFJjMyLBSrDVT4uqiuSHpr0+OiuP/Cm5lTJkzVyhGLchHZV2D
 EBAA=
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

A buffered write into a hole turns the hole into an LCN_DELALLOC run and
reserves its clusters in vol->dirty_clusters
(ntfs_write_simple_iomap_begin_non_resident()).  Writeback hands the
reservation back when ntfs_cluster_alloc() allocates the run.

A truncate that cuts off delalloc runs before writeback drops their
dirty folios, frees the clusters of the attribute with
ntfs_cluster_free(), which skips everything that is not a real cluster,
and removes the runs with ntfs_rl_truncate_nolock().  Nothing gives the
reservation back, so the free space reported by statfs() and used by
ntfs_available_clusters_count() shrinks by that many clusters until the
volume is unmounted.  $Bitmap is not affected.

Workloads that rewrite files (open(O_TRUNC) + write) or truncate freshly
written data lose free space quickly: a test that writes, truncates and
punches holes in six 400 KiB files on a 128 MiB volume sees statfs()
free space drop from 79 MB to zero in 80 seconds, after which writes
fail with ENOSPC or come back short.  A 1 MiB buffered write followed by
ftruncate(fd, 0) and sync leaves 256 (4 KiB) clusters reserved.

Release the reservation of the delalloc runs that the shrink cuts off,
before the runlist is truncated.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/ntfs/attrib.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 6ee6b6bcac..4028c310fc 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -4383,6 +4383,37 @@ static int ntfs_attr_make_resident(struct ntfs_inode *ni, struct ntfs_attr_searc
 	return 0;
 }
 
+/*
+ * ntfs_release_delalloc_from - give back the reservation of delalloc runs
+ * @ni:		non-resident ntfs attribute whose runlist is about to be truncated
+ * @start_vcn:	first vcn that is cut off
+ *
+ * Delayed allocation reserves vol->dirty_clusters for every LCN_DELALLOC
+ * cluster when the buffered write is done and only gives it back when
+ * writeback allocates the clusters.  Runs cut off by a truncate never reach
+ * writeback (their dirty folios are dropped from the page cache), so their
+ * reservation has to be released here or it is lost until unmount.
+ *
+ * The runlist must be mapped completely and locked for writing.
+ */
+static void ntfs_release_delalloc_from(struct ntfs_inode *ni, s64 start_vcn)
+{
+	struct runlist_element *rl = ni->runlist.rl;
+	s64 nr = 0;
+
+	lockdep_assert_held_write(&ni->runlist.lock);
+
+	for (; rl && rl->length; rl++) {
+		if (rl->lcn != LCN_DELALLOC || rl->vcn + rl->length <= start_vcn)
+			continue;
+		nr += rl->vcn + rl->length - max(rl->vcn, start_vcn);
+	}
+	if (!nr)
+		return;
+	ntfs_release_dirty_clusters(ni->vol, nr);
+	ni->i_dealloc_clusters -= min_t(s64, nr, ni->i_dealloc_clusters);
+}
+
 /*
  * ntfs_non_resident_attr_shrink - shrink a non-resident, open ntfs attribute
  * @ni:		non-resident ntfs attribute to shrink
@@ -4479,6 +4510,8 @@ static int ntfs_non_resident_attr_shrink(struct ntfs_inode *ni,
 		}
 		ntfs_attr_put_search_ctx(ctx);
 
+		ntfs_release_delalloc_from(ni, first_free_vcn);
+
 		/* Truncate the runlist itself. */
 		if (ntfs_rl_truncate_nolock(vol, &ni->runlist, first_free_vcn)) {
 			/*

-- 
2.56.1


