Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D706CA6B
	for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2026 00:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787185322; cv=none; b=nOgQG5Kx+JfW7QLYMvzB1899HSvZJUWXwItzc6Ca8Kg21Izw1C/A8TpBzbRM/P2TIdkWuNJGTYvOtKwm3uqEt03cJf/2BUW/F8mnHfP44o7nvrm0kJh+xPIawwMxgFVoA97GsSTJQYgSZCmmmvqL2g8xtQv664812umw6yPEqz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787185322; c=relaxed/simple;
	bh=vaY0P3hjZGMlXKCzaJyIxaJwtL7yg0HdeDCgjEEBY0c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=c+db1FfwxPWZ/Pw+1eyaFASgUWeSXE8QcqkBy5scaIJYUwPAcvLdTq2iexitwhdlb7XkPHsrCeaxQpFfe5aCmrOjnZFpEAmuAZDZUU6hhSn/fOcqtNyd4N9xIZxHb8CVhLTGtu/5lFGJ5gAS1wLmF0IwBJTIXBCzS5zFaoV+Jvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=anthonyvardaro.com; spf=none smtp.mailfrom=anthonyvardaro.com; dkim=pass (2048-bit key) header.d=anthonyvardaro-com.20251104.gappssmtp.com header.i=@anthonyvardaro-com.20251104.gappssmtp.com header.b=XrH5T264; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=anthonyvardaro.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=anthonyvardaro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anthonyvardaro-com.20251104.gappssmtp.com header.i=@anthonyvardaro-com.20251104.gappssmtp.com header.b="XrH5T264"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so18910135ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 17:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anthonyvardaro-com.20251104.gappssmtp.com; s=20251104; t=1787185319; x=1787790119; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=APwF6PUHOqN1JhIA+m2g5MAL7aCXBL5aOcOFSVNm7oo=;
        b=XrH5T264dJm0XaXbJGaXsNYcFq/7v5oGusxGeo9UgbTB19fx+DZpltZKLeSuMHST6k
         O7dyntksTMVC070VSKrBnMBuW3Mcy5dX5Xwcqrhx0UdvCCR4OQBAPvjF31gZEdqrTDKW
         I+DA/XWN3dV2SiCT3PaRbsbP5gEr6EFerlbc6Kl220N52QcuvBXyugsOTzQgl7l1KtWA
         HJCOcG8FUk0anqjYWQ/s4/qoi2W3Hz4WwZveULAjbDwRH6R3tDx3FeLbn8ATt2f+ay1W
         G8P0Pmnly2q7D3OUjwwzsYko77Lz4Fp0MlsiLXsvEi+7WdDqfEWtrN2LVejiJc5eODx/
         9vbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787185319; x=1787790119;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=APwF6PUHOqN1JhIA+m2g5MAL7aCXBL5aOcOFSVNm7oo=;
        b=VXYejbjlU9z6OetMtX9vk4g5Ur9bYEc1R5rqCxUolTvuJ6QKaI3U6MXRhixjxj/LZo
         ZOGYb3xQY6LFApxKxUCJsS84SSlp/NE+tsAW1+CReUdN8kkoCYjUbTYRmGxv1XIZOsYj
         5YiL3+hafWqP+vrIa/+du33wm5KccxMMM4TqFjIDiGkGrQrg5OJNq7CuDrJkABnCwbYD
         PGhgQy5U4ZqscptxFfHoJ11lZVl5bxjpR+F643Em46buh2lLsb1r52sk+X1Q5ZwMXq8u
         myWVAIlzUoMjN5HM7ebdcjo6eNlMb+tS1LiJeb+d9/vdWDknMxU3/qoneBjEt67Zicox
         m2/g==
X-Gm-Message-State: AFuF++nmbQWT9ePJbPtUzZab8IoBOg2aLv6kgcp6RehaZKw78MjOKs3i
	LOCx44mQTlxnehMxnnVYa0w3S5wAZP3DIzwwaZQNyknAw/+B9YjvBa688dvHuG8x/yP3wst6y43
	bczZJN8g2/OcT
X-Gm-Gg: AR+sD10SpcPopawsf/Q88dxxx2elERt3k6tVaEAMuSQtdiF1mQ/GmSltp2gNFes/XOB
	xZvIaJIandpfhUmds+sjRDtsSmHhzrAlXFuiWAMwoObynznYlSXODYBwrg2FshrgFYCptYFBeFp
	8VtgJYLe/tdgf8AEWemzRZFKJCXYhfn0ECzs10IUbSS1zvVivHueB4VgscCU5a5i8eUX6XWgYy5
	CFGaVC6wT4EyrxqwVJQwpiDiaZo6L1ilhtUQJE1/6LwuA39ol5QwPa9nbS8f/7hgOVaK2eVHBVY
	aV0db0YV7dEdsE4smhCRdQNFdhnf9/tzhemND0KW/1hHCzAP5n0meoe5Lgz4xmy+iBSfAEm1Br9
	zIajSa5YNB3FiMEOeaYYbtLJYXy1bkpz6gNl44NCigMcfKfmwN63910qbCFfZgj0CtJzjq4sLhm
	BqWZeo+bAaGsLwpe7Sxs1TbUAI9mV5PEQmDqrcr4nlzBSMaI28Yw+eacq/uTQKseZVmnRaQ1Yti
	MJXGCN6T1NDVqIulB3vJqsoT1LlyxWNgssugJF5gypg8uT9+7ZLz2jkz//0+JenGrqadkszd2XA
	XngKFjx9QkTy7fxBN/oVYkZCGqwa9z+JMx8WLP3VXPEn5qLxTTH/4YkZipWohp4VQGvT6tW6mPN
	LFm/cj5Bs0VwA4epOql4T2qE=
X-Received: by 2002:a17:902:c950:b0:2d6:2901:6265 with SMTP id d9443c01a7336-2d629016342mr11412075ad.2.1787185319472;
        Wed, 19 Aug 2026 17:21:59 -0700 (PDT)
Received: from coder-vardaro-vardaro-2-0.coder-vardaro-vardaro-2.remote-dev.svc.cluster.local (ec2-16-145-69-213.us-west-2.compute.amazonaws.com. [16.145.69.213])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3d27basm229915ad.79.2026.08.19.17.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 17:21:58 -0700 (PDT)
From: "Anthony Vardaro (Anthropic)" <me@anthonyvardaro.com>
Date: Thu, 20 Aug 2026 00:21:38 +0000
Subject: [PATCH] xfs: revalidate cached COW fork mappings during writeback
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-b4-xfs-cow-wb-revalidate-v1-1-8a19080799ea@anthonyvardaro.com>
X-B4-Tracking: v=1; b=H4sIAJFIhmoC/22Nyw6DIBBFf8XMuhMBjTb9lcYFj6HSGjBgq4nx3
 wt22+WZO/fcHRJFRwlu1Q6RPi654DPwSwV6lP5B6ExmEEx07MobVC1uNqEOK64Kc0VOzsiFkLW
 iN9yqpjM95PocybrtVN+HH6e3epJeiq98KJkIVZRej+U0zXW2hviiWJ/R3x04ji90XxSgtQAAA
 A==
X-Change-ID: 20260813-b4-xfs-cow-wb-revalidate-0427d1fb36d7
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, 
 "Anthony Vardaro (Anthropic)" <me@anthonyvardaro.com>
X-Mailer: b4 0.15.2

Writeback can write a folio through a cached COW fork mapping after the
blocks behind it have been freed. Since commit d9252d526ba6 ("xfs:
validate writeback mapping using data fork seq counter") a cached data
fork mapping is dropped when the fork changes, but a COW fork mapping is
accepted on range alone, and since commit 3b3508980730 ("xfs: remove
superfluous writeback mapping eof trimming") nothing trims it to EOF. So
when close() or truncate frees the post-EOF COW blocks and the file is
then appended, the same writeback pass writes the new folio into blocks
the inode no longer owns. fsync() returns 0 and the range reads back as
zeroes, or the data lands in another file.

Check cow_seq against the COW fork if_seq for COW mappings as well, and
only sample cow_seq where the mapping is built so a failed conversion
cannot pair a stale mapping with a fresh sequence number.

This costs one extent lookup and one cancelled transaction per
invalidation: about 5% more fsync time on random 4k overwrites of a
reflinked file, nothing measurable on sequential writeback.

Fixes: d9252d526ba6 ("xfs: validate writeback mapping using data fork seq counter")
Cc: stable@vger.kernel.org # v5.1
Assisted-by: Claude:unspecified
Signed-off-by: Anthony Vardaro (Anthropic) <me@anthonyvardaro.com>
---
An fstests case for this, using the wb_delay_ms error injection knob,
follows separately.

Backport note: kernels before v6.2 do not have
trace_xfs_wb_cow_iomap_invalid() (added by commit c2beff99eb03), so
drop that call there. Kernels before v5.5 test wpc->fork ==
XFS_COW_FORK instead of IOMAP_F_SHARED and have no XFS_WPC().
---
 fs/xfs/xfs_aops.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2a0c54256..c043e5bad 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -304,12 +304,22 @@ xfs_imap_valid(
 	    offset >= wpc->iomap.offset + wpc->iomap.length)
 		return false;
 	/*
-	 * If this is a COW mapping, it is sufficient to check that the mapping
-	 * covers the offset. Be careful to check this first because the caller
-	 * can revalidate a COW mapping without updating the data seqno.
+	 * A COW mapping is only valid while the COW fork is unchanged. After a
+	 * change, the blocks behind the mapping can already be freed, for
+	 * example by the post-EOF trim on close. Do this check before the
+	 * data fork check, because the caller can revalidate a COW mapping
+	 * without updating the data seqno.
 	 */
-	if (wpc->iomap.flags & IOMAP_F_SHARED)
+	if (wpc->iomap.flags & IOMAP_F_SHARED) {
+		if (!ip->i_cowfp)
+			return false;
+		if (XFS_WPC(wpc)->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)) {
+			trace_xfs_wb_cow_iomap_invalid(ip, &wpc->iomap,
+					XFS_WPC(wpc)->cow_seq, XFS_COW_FORK);
+			return false;
+		}
 		return true;
+	}
 
 	/*
 	 * This is not a COW mapping. Check the sequence number of the data fork
@@ -359,9 +369,8 @@ xfs_map_blocks(
 	/*
 	 * COW fork blocks can overlap data fork blocks even if the blocks
 	 * aren't shared.  COW I/O always takes precedent, so we must always
-	 * check for overlap on reflink inodes unless the mapping is already a
-	 * COW one, or the COW fork hasn't changed from the last time we looked
-	 * at it.
+	 * check for overlap on reflink inodes unless the COW fork hasn't
+	 * changed from the last time we looked at it.
 	 *
 	 * It's safe to check the COW fork if_seq here without the ILOCK because
 	 * we've indirectly protected against concurrent updates: writeback has
@@ -394,16 +403,14 @@ xfs_map_blocks(
 	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap))
 		cow_fsb = imap.br_startoff;
 	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
-		XFS_WPC(wpc)->cow_seq = READ_ONCE(ip->i_cowfp->if_seq);
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
 		whichfork = XFS_COW_FORK;
 		goto allocate_blocks;
 	}
 
 	/*
-	 * No COW extent overlap. Revalidate now that we may have updated
-	 * ->cow_seq. If the data mapping is still valid, we're done.
+	 * No COW extent overlap. If the data mapping is still valid, we're
+	 * done.
 	 */
 	if (xfs_imap_valid(wpc, ip, offset)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);

---
base-commit: 0877338ade31b825884a744e03f27c8de300f101
change-id: 20260813-b4-xfs-cow-wb-revalidate-0427d1fb36d7

Best regards,
--  
Anthony Vardaro (Anthropic) <me@anthonyvardaro.com>

