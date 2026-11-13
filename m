Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571328;
	b=TDYZqRz2K/UT1fHh5bZ8qPlsssY+oR4f32kKnf0O72IZxNrOF08HD3gCnulw0+hJ3AGp
	 TvCFfIf3tkM05dktyVB4IRpUF9e1CBCA8/s5WbRcZuXSubXjjW2dFKut7ceqASOn0tyBS
	 alRxtgEx9awKd54cEKPhXAmXeU/Z8OuhSJri2o2uBQjtZ4GGfocg+wx9loiXTkayvSt8X
	 EoTiKmViZwPs1C9+xbsubwE0WK44Q9TcsOMlMcWVuEpeU/HgLmDCdn/pHxKcAqSFrSTds
	 nACMZ6eBXdw7ArpAEcl7tmoHI29yv9Eq73ESI++ZlSBPhQvHZzEmA65TI28x5U/9TpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571328;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=YUJ/RH16CUAQaM0PxhxLjbl6pOsDoCFNUfhjJDzXYAI=;
	b=dfrMue7LrITMAtJCBohzdjbFF/apNqfC1TqDctsgLeA7YndWl50H7JuiH5fHnV7VYbqr
	 fIdDgC86iFRIKlghhyIQgoyrbIeBcXZrOHe0ftyHhCDKJwe3dGgo5BnzFgats+ZJEdYTi
	 gTJqBY1m9cfa/pw53KD98/b9W38SN8xcAO5JGmIiGoDkYTgnO0I2CGLbJTxjpJhu2Xqqi
	 o1otWx0vAFnCXS0Z97Q8lLtcIEVpb6x5kGF+ch02h/OmaaZRTaMMjjdwMrL9iVNIcFl6F
	 T3LNSwWz7pPnG0ciI7p97nGgb1cqSQRasFboNghO7ckVtEIamMD0pq6MCw6ik1KzduA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRpZnT4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7D9606A884;
	Fri, 13 Nov 2026 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRpZnT4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC31F000C8;
	Fri, 13 Nov 2026 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571327;
	bh=YUJ/RH16CUAQaM0PxhxLjbl6pOsDoCFNUfhjJDzXYAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JRpZnT4t/jYbHpTQBZoAPxuC43KKqhQeXRStGzW9hFFjLHr69igGE2UBo+5YKnWrI
	 6yXrPHlE7MVQKWFxBfBxlYZFy9S/vpLmUeGY3XqZjw//xJk7S0I5D1emk0NJFzB0U2
	 I3er5eljWMspmrvP0zgjWx8CbO5RuNDw/Wmn821zjZ+wkK2GUGAVl+HvAPjaVuAlIc
	 V/u3bYzEQCIURcDJ0eTE7xnepibFXGJ7BpvW3cQ2TTowUrEKBRovXGNL5psqJ/gAnu
	 vt0GVMPoozgBRhxRRGXMpZFjJYlQ2RL1gwHgAFYHmYciD5STu+MbLlHB3XtPlMAbPq
	 rHJ0XuzI4u4jQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:23 +0100
Subject: [PATCH v3 27/33] gfs2: wait for a pending withdraw before
 remounting read-only
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-27-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2800; i=brauner@kernel.org;
 h=from:subject:message-id; bh=c4mPQccEi9gz8unBosiI8qBxJmixdc+IlKuwVCk3jlI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73LfPfKBzIWqW9OvkvPjHxZM8nQtbrctT3gRuaXb
 rV/CWcnd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk6W+Gf5olC2Qc59ZVZAX3
 b9B4uFE95lx3xlX1KVFTD/fuKuKQTmBkuK4jWLf9WX8Nd90m/zPsRT+evmA7t3Hd0qArEs5hkU4
 GzAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit 9c4a3de6cd5b ("gfs2: Asynchronous withdraw") most of a
withdraw happens in do_withdraw() from a work item and SDF_JOURNAL_LIVE
stays set until then. A remount to read-only in that window bails out of
its log flushes on the withdrawn filesystem and gfs2_quota_cleanup()
hits its BUG_ON(). Flushing the work isn't enough because
gfs2_withdraw() only queues it after setting SDF_WITHDRAWN and a
withdraw can also start in the middle of gfs2_make_fs_ro().

So let do_withdraw() wake up waiters when it clears SDF_JOURNAL_LIVE and
let gfs2_make_fs_ro() wait for that right before gfs2_quota_cleanup().
umount doesn't need to wait because it sets SDF_NORECOVERY first.

gfs2_make_fs_rw() could leave the bit set on a withdrawn filesystem too
if do_withdraw() ran between its withdraw check and setting the bit. So
do both under sd_log_flush_lock which do_withdraw() holds while it tests
the bit.

Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/super.c | 20 ++++++++++++++++----
 fs/gfs2/util.c  |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 04bb4cf787d4d..f61c309368ef1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -146,12 +146,21 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	}
 
 	error = gfs2_quota_init(sdp);
-	if (!error && gfs2_withdrawn(sdp)) {
-		gfs2_quota_cleanup(sdp);
+	if (error)
+		return error;
+
+	/*
+	 * Check for a withdraw under the lock do_withdraw() holds while it
+	 * takes a live journal down, so one of them sees the other.
+	 */
+	down_write(&sdp->sd_log_flush_lock);
+	if (gfs2_withdrawn(sdp))
 		error = -EIO;
-	}
-	if (!error)
+	else
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	up_write(&sdp->sd_log_flush_lock);
+	if (error)
+		gfs2_quota_cleanup(sdp);
 	return error;
 }
 
@@ -567,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 				   HZ * 5);
 		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
 	}
+	/* A withdraw that do_withdraw() didn't finish yet leaves it live. */
+	if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
+		wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);
 	gfs2_quota_cleanup(sdp);
 }
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 529c3ec37a18a..888e0d6bf5122 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -121,7 +121,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
 		up_write(&sdp->sd_log_flush_lock);
 		return;
 	}
-	clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	gfs2_ail_drain(sdp); /* frees all transactions */
 	up_write(&sdp->sd_log_flush_lock);
 

-- 
2.53.0

