Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560600;
	b=vWw/vc9yBb+ZOD232XnaBqQvH9cQFVScXDUFb7L9K+Sw7pdEzCuNPIPaHwcq3QRxXZUo
	 EwJFjFIxPcBpg0q0PM2AiasvdX1MeCK9q2wryTSLlG2ttT+ihSajJaLSlQMMCC5EiKAth
	 1SHfwp/9+GiE+aWn8v0szYVRg3cLeUWS1t0ZJkbVuqEsX8Y9voDgB97xcnBPefpiQn21z
	 lYTuBAzxQQUvgmimjCmmnsgZReDfQJbPZXzNJzSeWvz+4AFtPRI3RSNNfeDVWQDwdnsww
	 0mq4y+QpaAbtxcgGMqgY+0v9JZryiDzYji++LZcVJnrpDBLquox9ZIrth0RAl62AnQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560600;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RI4kRWxl4XYAMairOnQShzPIXYese8AvwwdfRR+uYTw=;
	b=TYKy/9ajtKvySAb0jVh/WyaoKCCTQsi+YrKO04B6pcPu4zNJYEswRlyyjGVICS1KvwZa
	 7SdG6BV8o7/5uMGBsjDuYroEbokL42Spc6UEIXJjT3f4Bnw2omqGjxp1u8Try/4bwMizc
	 g5JEC5/3r3EoUs3xGyosv9t/APMWMkWmg9KPP6k9hAl2A3zLevlkjUPpY7lOcesLtP17x
	 /Zsmo9kFghfFLt3uUlpYTAQbJrSSPErkHSBf9/07cL0x7FrkoPHII8WngfNMVUpZMED+f
	 Y4ClwFpyov5Ey+xWNikxcer+BcMl1luAwty/PJgEG3v0csqJIPkBkSZFIEyH18M62Aw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VDcpPKea;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA803606A6A2;
	Tue, 24 Nov 2026 22:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VDcpPKea
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560600;
	b=wViXWxRyoCkEOTX6jg6Yo8qoG2DK4eem7MVLKhvQo9W4WDPmNa6Wl+bgdyO/D0Hljr4V
	 OO3zq6GuyNOEQntU69p1FzxOPiuogRoS/Ae4HO6wHs34rv3pB8vlyiH+rLhn68iy6nMZM
	 orKHo5S013fTNWwVQ1YTh89ewUSSGuBNIIRLHIWXeduEWBts7NOdfg4wf6tKvgY/JzDHJ
	 vM9aDy5+2Iw9XSh3XJreorDa1+cv2QC3PNkW3NX6hPoxu88j7/0I3AGb2E4O0duatIpKh
	 MZi2JXifw7R4+Im7wjZhU04br5UYaODRGAemJW5VYtTFPdzeGZXuV1UfaOj+NVLroYg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560600;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RI4kRWxl4XYAMairOnQShzPIXYese8AvwwdfRR+uYTw=;
	b=Pxibp+95YcsuyPecJgprclNdfzf5FgX+CNs+U1xndkV/8O4iBH45Xd+XD/rusxE60YjY
	 ShwTCrVuHcWnzwljjiiln/qk6/Qf58ADABje6J8+wOzVx3wjpX7IlLwkf1OkmSl0rrIQS
	 AYr7ex9DTW0mjovHFgwTNGA37FinVgBg/jlFF/5pizlFdgDmypDUgx/FlSysp4EVgUVQQ
	 uYZHI4JxkRRQqGSPIodQEiNIUaYAB6xcRx68KTPpM4U3jrlERJ+Mkwpvi55Hpc0DKYERS
	 LhfcrcXlcrYm6URrWB99N8bYhSE/Ds4Wriey3WwaMATvjLAWTVupJxRwPAUP9IkCC4w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CB10A1F000D1;
	Tue, 24 Nov 2026 22:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560600;
	bh=RI4kRWxl4XYAMairOnQShzPIXYese8AvwwdfRR+uYTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VDcpPKea3hnZCqsQMY4kLZ9fX00ylCnjH8Sx6VFaX8PilpGJzcuMC1KBJZQNZ3GlP
	 MH8xaSwV9xopv5A9+860inFv9ryQaiy5Dqmd7MPCZtSa1IZeqEhTX9an+0UhyJNQNL
	 XveWs/wrFIEWwlkY8w0ET2FaZBbpDq0ejRCxhnWss7V8ghuiJUOSjIFuhaG9hS2NF1
	 WLaenleOZm2FYs79RFkjtuopyXmpqBqmqrSCzARbhjHR5W2aF6WmWQR1mxgZohK/TI
	 sOlK/jL4F9/ZKSXj6PyRpWt9lhr4k3SIBeSkF0gX2sf5aSRm8OF0s+tw/ezyLNoCic
	 bO2n+xHOL/Syg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A64354CC2C;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:41 +0100
Subject: [PATCH v2 07/11] ntfs: do not shift the cluster number of a
 delalloc run on split
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
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-7-f394c800ec03@proton.me>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3638;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=QYrY3PPRwc1pxE1XgYFpRxvEIryQYj/9Bk2ICaRmWlw=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kYYNKpNPrYjlmmicdaAh77D82QOTDY73PDBqm3wvx
 KVz2sxLHaUsDGJcDLJiiiwd/2+E+IR8+7QsTqsPZg4rE8gQBi5OAZiIuR/DP/PMIsPY3Dbdqdpb
 vecl5Xzc8TqyyXmHYtrHeX/SprYsNWD4K9r80/G/hMCqFpfZtxOOb9cU3b/N9cyuhS7MH5L9BTo
 q2QA=
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

ntfs_rl_punch_hole() and ntfs_rl_collapse_range() advance the lcn of a
run they split with "if (lcn > LCN_HOLE) lcn += n".  LCN_DELALLOC (-1)
is greater than LCN_HOLE (-2), so splitting a delalloc run turns its
tail into a run of real clusters starting at n - 1.
ntfs_rl_insert_range() advances it unconditionally; its callers insert
holes, so only a hole split for a non-hole source and a split delalloc
run are affected.  ntfs_rle_lcn_contiguous() has the same problem and
can merge a delalloc run with a following real run.

The punched-out part then goes to ntfs_cluster_free_from_rl(), which
frees clusters that belong to other files or to metadata, and the part
left in the runlist maps the file onto them.  Delalloc runs normally do
not survive the writeback that fallocate() does first, but a buffered
write that fails after ->iomap_begin() leaves one without dirty folios
(fixed by the next patch); FALLOC_FL_PUNCH_HOLE or COLLAPSE_RANGE
through it then corrupts the volume (ntfsck: "Found 1 inconsistent
bitmap block(s)").

Only shift the lcn of runs that have real clusters.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/ntfs/runlist.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 76ba6ab72b..1e87db35ce 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -1770,7 +1770,7 @@ s64 ntfs_rl_get_compressed_size(struct ntfs_volume *vol, struct runlist_element
 static inline bool ntfs_rle_lcn_contiguous(struct runlist_element *left_rle,
 					   struct runlist_element *right_rle)
 {
-	if (left_rle->lcn > LCN_HOLE &&
+	if (left_rle->lcn >= 0 &&
 	    left_rle->lcn + left_rle->length == right_rle->lcn)
 		return true;
 	else if (left_rle->lcn == LCN_HOLE && right_rle->lcn == LCN_HOLE)
@@ -1832,7 +1832,8 @@ struct runlist_element *ntfs_rl_insert_range(struct runlist_element *dst_rl, int
 
 		i_rl[0].vcn = start_vcn;
 		i_rl[0].length -= dst_rl_split.length;
-		i_rl[0].lcn += dst_rl_split.length;
+		if (i_rl[0].lcn >= 0)
+			i_rl[0].lcn += dst_rl_split.length;
 	} else {
 		struct runlist_element *dst_rle, *src_rle;
 merge_src_rle:
@@ -1988,7 +1989,7 @@ struct runlist_element *ntfs_rl_punch_hole(struct runlist_element *dst_rl, int d
 
 		(*punch_rl)[0].vcn = start_vcn;
 		(*punch_rl)[0].length -= first_cnt;
-		if ((*punch_rl)[0].lcn > LCN_HOLE)
+		if ((*punch_rl)[0].lcn >= 0)
 			(*punch_rl)[0].lcn += first_cnt;
 	}
 
@@ -2008,7 +2009,7 @@ struct runlist_element *ntfs_rl_punch_hole(struct runlist_element *dst_rl, int d
 
 		new_rl[new_1st_cnt + 1].vcn = end_vcn + 1;
 		new_rl[new_1st_cnt + 1].length -= first_cnt;
-		if (new_rl[new_1st_cnt + 1].lcn > LCN_HOLE)
+		if (new_rl[new_1st_cnt + 1].lcn >= 0)
 			new_rl[new_1st_cnt + 1].lcn += first_cnt;
 
 		if (one_split_3)
@@ -2136,7 +2137,7 @@ struct runlist_element *ntfs_rl_collapse_range(struct runlist_element *dst_rl, i
 
 		(*punch_rl)[0].vcn = start_vcn;
 		(*punch_rl)[0].length -= first_cnt;
-		if ((*punch_rl)[0].lcn > LCN_HOLE)
+		if ((*punch_rl)[0].lcn >= 0)
 			(*punch_rl)[0].lcn += first_cnt;
 	}
 
@@ -2150,7 +2151,7 @@ struct runlist_element *ntfs_rl_collapse_range(struct runlist_element *dst_rl, i
 
 		new_rl[new_1st_cnt].vcn = end_vcn + 1;
 		new_rl[new_1st_cnt].length -= first_cnt;
-		if (new_rl[new_1st_cnt].lcn > LCN_HOLE)
+		if (new_rl[new_1st_cnt].lcn >= 0)
 			new_rl[new_1st_cnt].lcn += first_cnt;
 
 		if (one_split_3)

-- 
2.56.1


