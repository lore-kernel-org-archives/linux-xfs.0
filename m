Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794212817;
	b=I24ZaZFxLkCEm3+DCzUtlTxizigQ0r0Lqj0tHPZ6f+4L4K5JOLG/L3Iog1D84ZrkKMqJ
	 LOwGkPYisOTSPTjQtvMlT6G3R2ZxmaatRNH0fhDLwZM6sjKJuqkYNTbKHb7iCQU5PHmXA
	 1DovUIfohgQWkngII1Ykeqx0eliGsK+Ru5oFQwHMPlaPrAxpdoaSHC8F9KsHdp3GOt2Q7
	 G7wPR4lYiDTKYo6djvYBbut3/rj5ji2vU00AdI8KZz8152cjWO3t4BKyrX1KeeRhexW+t
	 Q39KQ0Hz6VMOF4reOm1srMh1OZSniQH8LCwsVN4/FT8AIK/cdwM6L1EzjoFVWAscHTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212817;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=fmPtUa1J/S7UkBf8oBBBIHWEPV+ZOOAq6ygmojPUylg=;
	b=2IEW2rw+zX8fOP2Evm7KgKrnSpqrgvWRdZGhykckbO4Le+1zlE9GHor+AoCJtcYGs1UZ
	 E9Gw3TERAA2jJq3k10SzNErIqmGbnI6nRUJMGzCtC+VeW0oKJFelpFRW+25/aTlpVGMyt
	 EJBCFGkc6MzAZUnvIKu+30Lh6uIqk0UvDuzOlknjJXFtJmT4SKJcAB5R0bW2cmouXYjEc
	 gDRTxwl1X5oXJIIn55tORReSWUjDFsdIiMSdmnUYBedvJkFCMJ6lV0suHfuKvC7gqEF+b
	 gVC7C0seR4/uj+EgDD4biDWfsJnrc5rLwIVZL8gC8/KvcGdzcMb3Q+7cgMGU+xlJ/5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AF9kwyPI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33925606A31C;
	Mon,  9 Nov 2026 08:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AF9kwyPI
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794212816;
	b=juYA10biWMrGsanfET1lNoh++ehAZsGGq5W6lmBvw2xviEA5gLWD79XjCFr8ExuN0TvG
	 tvgY1tluwHy17TAyMvVKBFKLDrC0X8ykmiTmoiXBiYPFV27ONWTiB1b9W/2ZDNktjclY8
	 iKOGk6fzbrW1B+GR/ZHYgJpnZDnANprPxgzy8xnBROOj8d8pqGggVBlmyY2jWA/nXjd48
	 iA+Hrx2pVxbQG1yMQ+vgui68Ojxrg79wBkgjL6BSwVuMSatS450AgPdkEykoNln03E7Ks
	 FdK0y5yDUpxfdtiuSc4Ove5kuJoFQLRdMpxBGUFEFfKQhpcAe7rS4CGi9+MPeHjfXqw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794212816;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=fmPtUa1J/S7UkBf8oBBBIHWEPV+ZOOAq6ygmojPUylg=;
	b=NEflHJTzXGMsgx1PfGVz1Gx6424a3XHKqLxzY4bAeel1QKPFqkB4UA7OcqwRwI5PG8ux
	 JKxaVFjH1PEfUhrutDtds72MgNudTsxxU701ZrEyjjmz1uva9+I+8R/+KMq6wv2iJUhFZ
	 WGvRLSeyJqiyrRWMy+pQkzEWMgw8tn5O/4eF7zOaps6+ptSHSAbn24GgZhTm+3M+OSP5e
	 nHhHFqa1xPhleMIuqWhuMQ01CHaPX2rTHpnBPrUZvdUVgkp2niptpv0YhvwWSpI0QhXSl
	 b+xgisvQefRtlf2Ltu+iWkk6dze8w93sKLzQqiiWzzBlAiSkEDIwSdiI5JnAvmCisOA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 57F681F0089F;
	Mon,  9 Nov 2026 08:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794212816;
	bh=fmPtUa1J/S7UkBf8oBBBIHWEPV+ZOOAq6ygmojPUylg=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=AF9kwyPIkjTMvQOH1okBvb4fYBmUnsCzrbn/P1ZKyvqZYlHJONQAWGhVAX79hC4WX
	 jzl0NVRt7E2NgdwGrufgjSeUiVfmzR00Dv29IYD5s69+BTzSy0ftkK+6PyvMg0cJ+b
	 kXZ6/UZ087jUt6/u4yyGSax3bXdE3S+PJsok9XFR2cp9FhN5/AblN9hXFe0EpXLyyp
	 uwAF2uHcK/8oI2LSRYsmLv5pV1LJjNeRX8WD3bEG06+D7DhUysSbVpt0grZ56dDQhe
	 a2uRQwZxPhIQPJBJ8/SAE593lqFZ/sLOrj2Zzhjv1zRY/HXjGw8oo7THVxIWO5fBQC
	 xnwTx+2NI3cYw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C676248357;
	Mon,  9 Nov 2026 08:26:55 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Mon, 09 Nov 2026 17:26:56 +0900
Subject: [PATCH] xfs: break layouts before swapping extents
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
Message-Id: <20261109-xfs-swapext-break-layout-v1-1-7f6f137d18bb@samsung.com>
X-B4-Tracking: v=1; b=H4sIAM+D8WoC/x3MQQ5EQBBA0atIrVWiOwiuIhbNVFEhSJcZPRF31
 7F8i/8vUPJCCk1ygaefqGxrhEkTGCa3joTyiQab2dKYrMbAinq6ncKBvSc34+L+2/fAqubB5lz
 0VDHEfPfEEt512933A+YM3WxqAAAA
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794212815; l=2472;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=CaEz7uBoybLqkkBn52P/NyxwhKH05LuHzbS9Eqv03SQ=;
 b=VPEoMQhIVld/k5YkvBH0AmoaVyqS9gkXEFvSLrjzHvbtu6mNXWyDh3wo6FhDsy6jKs0aYJQya
 2BYjMR7naZFAAH8bvnhjLivZQ4J/AU5u8wSaXH7hsKTkYBawyIGnFaz
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

XFS_IOC_SWAPEXT does not break pNFS layouts. A client can keep writing
to blocks that the swap moved to the temporary file. xfs_fsr frees
those blocks when it closes that file. The writes then land in whatever
reuses them.

Lock with xfs_ilock2_io_mmap(), as the exchange-range ioctls do.

Fixes: 781355c6e5ae ("xfs: recall pNFS layouts on conflicting access")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
xfs_fsr uses SWAPEXT on kernels without XFS_IOC_COMMIT_RANGE, on
filesystems without exchange-range, and in all xfsprogs before 6.12.

When both files are DAX, xfs_ilock2_io_mmap() also breaks DAX layouts.
With two DAX files whose pages had been faulted in, SWAPEXT hit the
WARN_ON_ONCE in truncate_folio_batch_exceptionals() in 3 of 3 boots
before this patch and in 0 of 3 after it. A DAX file swapped with a
non-DAX file still hits it.

Tested with a pynfs client holding an RW block layout while the MDS ran
"xfs_io -c swapext". Before, the client's writes overwrote other files'
data and a directory block. After, the swap recalls the layout first.
The fstests fsr and swapext tests pass with and without the patch.
---
 fs/xfs/xfs_bmap_util.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5a..595b7ea3ac9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1554,9 +1554,9 @@ xfs_swap_extents(
 	 * page cache safely. Once we have done this we can take the ilocks and
 	 * do the rest of the checks.
 	 */
-	lock_two_nondirectories(VFS_I(ip), VFS_I(tip));
-	filemap_invalidate_lock_two(VFS_I(ip)->i_mapping,
-				    VFS_I(tip)->i_mapping);
+	error = xfs_ilock2_io_mmap(ip, tip);
+	if (error)
+		return error;
 
 	/* Verify that both files have the same format */
 	if ((VFS_I(ip)->i_mode & S_IFMT) != (VFS_I(tip)->i_mode & S_IFMT)) {
@@ -1762,9 +1762,7 @@ xfs_swap_extents(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(tip, XFS_ILOCK_EXCL);
 out_unlock:
-	filemap_invalidate_unlock_two(VFS_I(ip)->i_mapping,
-				      VFS_I(tip)->i_mapping);
-	unlock_two_nondirectories(VFS_I(ip), VFS_I(tip));
+	xfs_iunlock2_io_mmap(ip, tip);
 	return error;
 
 out_trans_cancel:

---
base-commit: 1e17fc56469d62d1c1ac45c137a2456d14456f1d
change-id: 20261109-xfs-swapext-break-layout-89fc24f5be8f

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


