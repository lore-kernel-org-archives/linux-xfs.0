Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560594;
	b=IQCOIp+rFFKleq7JG+9NddCTZTJFzpiATgneMjtbp5ErCwLbdYQQ5XqAfIynxlWuHQq7
	 FopsuaOu+fHZdq6fKBfiOGHbc4tShJey/zaE2gXExFBryIVDTNiDodUg3/fSAlpfS+Ndn
	 hY+g0/h5faRe/ay9NG4BGkYAtvuPNo+Gv+XOc9AeVa3MtXI2pkC8xTppzn+bEq6+ikJ3H
	 Xq8NK/d64YsRUbWAN/Kq+mY9fcr2Gt5XrrmbdMXWSBWbXpn4rpL8c51Tk4q+rEMwgo/vp
	 YNsGhT0Ne0sZZ1hHhPhJGqq4+5+NtqGO8OMumJQYYaD0Gz3R5pzNX/S4iMJ4NgUQ/5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560594;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+RidziUgx+kZM9EX+B/idvPdGe7SZT8gd5HysQwlsX0=;
	b=qGsbbZUK8xl2y31/aIOe2GE5OA5hce6Z7R8gZU+7qVyqmvX3ymTOU5sfIuku2avRHQgF
	 MvzJjs6oyhAxA7Gar5jzev5yDgcE88O8uwis2U1lunfwotRTu7OiM07EJz/k+rqrf43+a
	 eA5MHlNHVd7jYG2vi2N8onDYkDSzno191auFda1wZgL5+ir4O0mTlMoj8dDQ5vN9ljCVu
	 +mE0bzvhzoPG1EZ1m4y+PMmCHhJXXWz//LQzii5BCMPCj9pwgDRC7nKYlx/CPKy3DUAiK
	 458Qb9meihWNd/ay5GPt0rgUPNnuzJwL3dJl1k+yDSuWncopAEiI1+tQxa4AXq4HKDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhNLX3xQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5597C606A683;
	Tue, 24 Nov 2026 22:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhNLX3xQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560593;
	b=ehRj4PwXRuqno0JkFuvXLH63lXyPl3l2nD860Lzr1l0pcpRpuzPUFI5I05Xf8gtOgnsn
	 /QtGUjrTmlIcbULmvsYRehLPjW90SH21KKVHyzoCzuRvtXZnVzmnhxAazl7vTiIC1hCEr
	 ikl9W/YCm5SlP9GiN1pSt6ZzN6c47QwzbezMJuTlsLEBudT9dDVIFM9hMIuSqgMQniIs9
	 pFMqnEJriYxTIrggOK4e5ztIBg/nobaZySUoXRMwHrfBs8kU3iFsKxJMCXTbezfJlIMPQ
	 4WbL5U/FDJWCyzl/mmPaK5HW0X9nxLj9QPphqLng+wgLPlf/+CDalFMryiklYSAMM4w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560593;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+RidziUgx+kZM9EX+B/idvPdGe7SZT8gd5HysQwlsX0=;
	b=YwmWBsIf0jv6U2XzF8cDoBSorJ+Cz3U+bYPNKuA+pdm9DtHe+NN9wtB7dXihRFk2RVpA
	 cSoZotJ0tSX5+eYgpoygEpzlDd88WrvGJZ1FVNXCvrMzWbEwilvCBT583FXazjyutAY7x
	 mrPpjVsYunhLw+zmswO+8SS1A3qCkL/LiQW7RnAXCGqy7FpYsDanylx9GhOT0Cf8mUSef
	 JxUKn82m3hBF05hfmo11By65Ncji+QpGZR/5B6DhCDJmb4sM5okYqXzvO6EVJ6qRkh1tM
	 Tx9a270UbfkKP0tskTgkl79Af9esyACCLCZtixrGvDx3RJA6OiYJLMemNaKSw3NjIrg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7E6E1F000D2;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560593;
	bh=+RidziUgx+kZM9EX+B/idvPdGe7SZT8gd5HysQwlsX0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VhNLX3xQE1jJyGl+QClYBZfzNVpeVj/ynOCi5YReulh9XPTA4PmayoyoIFYGD5xma
	 IDu45HOw9N9ed2ua6pZ7j2tvw283njokSiSo3ZAP4d9dFB4sA0jnEtt1gDS3lhG0gU
	 Js5bqL4/snuqMxlXJp8wkYfAUknJac659usA2lldVzIcCXe/t6ds987eWTZY1vh4dw
	 6yG2A/B2exHWi25fRWd17E7bItuZNEpPfmb/qv/+fnGptEMPZcrJFQkALFS8qVmHUi
	 R8RDM17W11nRjxI8c+RR/t7SUaCd959C0JhGJ+/iPBvc8GInRVktQcWsfrZ8x2L2eW
	 dSNCJAR4315cA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 49D714CC20;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:38 +0100
Subject: [PATCH v2 04/11] ntfs: do not consume delalloc reservations when
 filling holes
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
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-4-f394c800ec03@proton.me>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2158;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=+jVS4i0N2xYWTOmK5KLBxioqsjuDV8wLrjNVc80eqAM=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kXrPqauXXE0L/L/rCdfHoEML1u6/5eZ9yPDweh229
 VbHnji2dJSyMIhxMciKKbJ0/L8R4hPy7dOyOK0+mDmsTCBDGLg4BWAiJiyMDO+C+q6XJFs+2PA+
 MtE984D/w5SfW1Pyr9w/K+nO/2JPWjTDL6YXz51Ck6YzLF117GCo54Ol2dPP9dj1HZ98O3xTdAu
 bCiMA
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

ntfs_attr_map_cluster() always calls ntfs_cluster_alloc() with
is_dealloc set, which makes the allocator skip the dirty_clusters check
and subtract the allocated clusters from vol->dirty_clusters.  That is
right for writeback converting an LCN_DELALLOC run, whose clusters were
reserved by the buffered write, but ntfs_attr_map_cluster() also fills
plain holes for fallocate(), direct I/O and page_mkwrite(), which never
reserved anything.  Those allocations release reservations that belong
to dirty data of other files, and can use clusters that are promised to
that data, so writeback of the delayed data can later run out of space
although every earlier check succeeded.

Reproducer: write 1 MiB to file A without syncing (statfs() free space
drops by 256 clusters), then fallocate() 1 MiB on file B: free space
does not drop at all.

Only treat the allocation as consuming a reservation when the run being
filled is a delalloc run.  Filling a hole now fails with ENOSPC when the
remaining free clusters are all reserved for delayed data, so a write
fault into a hole of an mmap()ed file gets SIGBUS in that case, as on
other filesystems with delayed allocation.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/ntfs/attrib.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 4028c310fc..cdac846f37 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5520,8 +5520,14 @@ int ntfs_attr_map_cluster(struct ntfs_inode *ni, s64 vcn_start, s64 *lcn_start,
 		}
 	}
 
+	/*
+	 * Only a delayed-allocation run holds a reservation in
+	 * vol->dirty_clusters for the allocator to consume.  Holes filled by
+	 * fallocate(), direct I/O or page_mkwrite() have none and must leave
+	 * the reservations of other writers alone.
+	 */
 	rlc = ntfs_cluster_alloc(vol, vcn, clu_count, lcn_seek_from, DATA_ZONE,
-			false, true, true);
+			false, true, lcn == LCN_DELALLOC);
 	if (IS_ERR(rlc)) {
 		err = PTR_ERR(rlc);
 		goto out;

-- 
2.56.1


