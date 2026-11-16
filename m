Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822666;
	b=jvYzoEC/qpOUDwkxlphh6TAKgpwMmi/8fP7KwWlgGO79fWpAxS8Lsisa+pMCIG5kG8rh
	 Hk4gqRZGCJe19Az5r3+S2W0FUJlQg+0VAHwSsRoC1MTvn8jmJ2eR7hzdTqE03EP04I/0k
	 QOfpJPLWeDizvSGooOxkGMvBjql0ZLlPdPkiatRU76HwHsNBrwdolPkdKRDohL0MRKP5q
	 8mvfBY3M1BL42rvTPXfKNnX7OxmpIapBZffeiUtDR7a5k4P8YMa86ysmh77icP4F7Nw3r
	 8nNFenjfNDUyIggWx0JRZuVeW8CVHZ61dzC4MjXcaCHEHYgqeeZJSaUnPb1vxrSDtmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822666;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=WMX9pBMtAClRWJDRxKZww9HYXVLhq0s1qVF2v14nmjI=;
	b=Zy8IilPQNe3OZYF2TyyB3iN+6JtkQ+kl0xYz66x2k2VmUF3TWpGqLTeGIbBlXmpNZJhP
	 +vO5RPD0nmSHIN3pFREUPEn7tN4MkXZITYxneSbG54nj5AWrPLdCrbwBDQKJfQjqal8LA
	 STJDSrg5EaQzqafw7wT+iwYUrcru9cjftJcxtGgR3xR/hGzdFPvGp2y07hcd5YVTrLECs
	 KUlh1TTL0qLCwx4Jra9oapL/RWFR1gHbKUy1tQMI7s4O9aFz+QiAY495YpIyYs/DKb1p5
	 OYAYkBp083R+ljm7UcVvE88PsI7NnKYGrdIR9t6ilHsgmlklCiqkFKXICRNtdLLDn/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KJOopPWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E9C606A32C;
	Mon, 16 Nov 2026 09:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KJOopPWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE9E1F000C9;
	Mon, 16 Nov 2026 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822666;
	bh=WMX9pBMtAClRWJDRxKZww9HYXVLhq0s1qVF2v14nmjI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KJOopPWAZuqHeoKTeUi8HT9mhRMwYkIon7mX0IK2FrxH+lIz9w4mIDBtlmGpnVwRU
	 Yznll+D1uDUZyn3BGiguZs2RizD5iLGvUZBE1f/ahPSalGMk7cZl2oQ5Rqiq93s5LC
	 U9Li0n7CY5AN+wKZDFsmsA5wbGI9KypUjjh6u+/eNX8d7vTvDF0XwdYHWY4eW4yCs/
	 UUhi6mBwRxDCZV0B9xlkJgpNLsuBeCZTY3Svx6fZ/8BAuzHZL/zc06sHPQyavE6SoY
	 p+CeKKCxLUfa+oblEr0OQ46h01sLF+sff/BdqPIZamm+212su4blOkJvmv9qKQU08p
	 bamoC2xoNMOsQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:28:30 +0100
Subject: [PATCH 1/3] gfs2: don't BUG when remounting read-only after a
 withdraw during mount
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
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-1-95a25ce917ad@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3170; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F50L2TAgntbYoNLTOVTGw9OEVAO4TN0+aJMweOBfZG8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvgn97Lk/4uNB7YmLgq9Hbn82lu9dd2iLLvW/WZLm
 qf1pqr3akcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEWj0Y/hcIGl+at47v4bbw
 /0JhMtYReYZPVCT+SFzwTzzHv2tl8w+GP3zb9rVaJHMW/z6+7PjCrZNr9j1LERb/ECxrfnBtvKH
 qMj4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

gfs2_withdraw() doesn't queue the withdraw work before the superblock is
born. But gfs2_fill_super() makes the journal live before that and a
withdraw can still happen until the mount is done, e.g. from the log or
quota daemons or through the withdraw file in sysfs. The withdraw is
then never processed and SDF_JOURNAL_LIVE stays set. A later remount to
read-only, sysrq u included, goes through gfs2_make_fs_ro() whose log
flushes bail out early on the withdrawn filesystem and then
gfs2_quota_cleanup() hits its BUG_ON().

So queue the withdraw work from gfs2_reconfigure() and wait for it
before going read-only. The work can't run twice so guard the queueing
with a new SDF_WITHDRAW_QUEUED bit.

Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/incore.h     | 1 +
 fs/gfs2/ops_fstype.c | 5 +++++
 fs/gfs2/util.c       | 9 ++++++++-
 fs/gfs2/util.h       | 1 +
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 49cc232942a29..151458e90480b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -605,6 +605,7 @@ enum {
 	SDF_KILL		= 15,
 	SDF_EVICTING		= 16,
 	SDF_FROZEN		= 17,
+	SDF_WITHDRAW_QUEUED	= 18,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6ec47376aecf2..3bd5702535dfe 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1590,6 +1590,11 @@ static int gfs2_reconfigure(struct fs_context *fc)
 
 	if ((sb->s_flags ^ fc->sb_flags) & SB_RDONLY) {
 		if (fc->sb_flags & SB_RDONLY) {
+			/* gfs2_withdraw() doesn't queue the work during mount. */
+			if (gfs2_withdrawn(sdp)) {
+				gfs2_queue_withdraw(sdp);
+				flush_work(&sdp->sd_withdraw_work);
+			}
 			gfs2_make_fs_ro(sdp);
 		} else {
 			error = gfs2_make_fs_rw(sdp);
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 529c3ec37a18a..5558af374994a 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -238,6 +238,13 @@ void gfs2_withdraw_func(struct work_struct *work)
 	fs_err(sdp, "file system withdrawn\n");
 }
 
+/* The withdraw work must only run once. */
+void gfs2_queue_withdraw(struct gfs2_sbd *sdp)
+{
+	if (!test_and_set_bit(SDF_WITHDRAW_QUEUED, &sdp->sd_flags))
+		schedule_work(&sdp->sd_withdraw_work);
+}
+
 void gfs2_withdraw(struct gfs2_sbd *sdp)
 {
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW ||
@@ -253,7 +260,7 @@ void gfs2_withdraw(struct gfs2_sbd *sdp)
 		if (!(sdp->sd_vfs->s_flags & SB_BORN))
 			return;
 		fs_err(sdp, "about to withdraw this file system\n");
-		schedule_work(&sdp->sd_withdraw_work);
+		gfs2_queue_withdraw(sdp);
 		return;
 	}
 
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index ffcc47d6b0b4b..78690fe76cfeb 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -195,5 +195,6 @@ void gfs2_lm(struct gfs2_sbd *sdp, const char *fmt, ...);
 
 void gfs2_withdraw_func(struct work_struct *work);
 void gfs2_withdraw(struct gfs2_sbd *sdp);
+void gfs2_queue_withdraw(struct gfs2_sbd *sdp);
 
 #endif /* __UTIL_DOT_H__ */

-- 
2.53.0

