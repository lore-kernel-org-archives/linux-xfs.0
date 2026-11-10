Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794271098;
	b=ZH66WZXOXy3b+QZBN4rJr/WdErhh7gQ19JPT6QkPRhCpeD9BKguBzEnujzx8x2A/Ea3Z
	 tAZzi0VIOYFxBJybO5xn8FNrA2IBrZs1Dc/apaI8GQ50K/7ZNBtIz1IAYJYtVSZ62w9nU
	 vnnqpZwTL7e1YgCrrxpucDdSbxCMMGYNTfwLvxpdMsAmeqPoPk0sivMRcGss09GRQOT9j
	 031DlIg6ZDLQnK8kkT1CESUZpT7X6rVwqHA1Xwhi9loPt7B6h4Kn8VGWv/e2UWm4IAURL
	 D8s0z0O6TrzkQOMDp3r3WN5Eu4t69yI9ysdqTXEYtVHEEVflIxoVcgAqIRw7xNaO3Kw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271098;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=F7SYWC9p63wzk1OOh3GF55OxJUzxN5yPYEBvs21OiD4=;
	b=rBWOBCqa5e5wIMgRinhGGPQZQCWxd1I5Sq6LF45Inxmg7xCFyywehydlZ/At/Z5YGirr
	 VxlQXd1tXlmS3z9dduf9l45YQ3Nv9CXUAbEdxOCkV1lIPU95QDiTQfOPPPnapb1Na3D+c
	 GhtAIJ2BYSGo6smUz3E+aHJoVG2MgqEJ6IO9D/Yc6IjxdMhkbfbqJUqS1bkFqtlgY4wUL
	 hRU7BqJVAGsuI6qda+ULlLc7pAZorqrjzb97UhSHuMS89TRC/ClANb88oAXNM/NEppv3S
	 NWTSeBdrB0HrTriHykqNiAict/tijYC3ipETxWm8DY2NF3ZIt2dGdpTVDxiQFjRnNHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rlu9OpHn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638CA606A325;
	Tue, 10 Nov 2026 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rlu9OpHn
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794271098;
	b=K04v+fIUGfWMlR+vNYZjzR4NaL70pAnoxN7NMl4OD+d9znl9BdehfNF7G6bomSgHV1AP
	 rDJIAlf71Sut7qmlR1EXfXKMUS7or4HnW4pzEScRnYQrBsdlD71kdMYjbQKF4MOe9Nugd
	 hg0RkHKWiwvidEL2mSrCMwujIRFXaRAcLOzKPdsLzwUaALjpKxrzqli2hXVGYpxHG18hB
	 ahUaEzm/5XeSLjNAG3CplxOQp7XAovIv5OpYWLdOQcJO/pHsQM+9Mv+dS2ccnXQlgLd+0
	 ErED3ZeG16UGLkJQ0GOLjupJPw2h1PiRlvly3VZEtPJTVyZUQSSW2Uc8iEtDzWa5k7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794271098;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=F7SYWC9p63wzk1OOh3GF55OxJUzxN5yPYEBvs21OiD4=;
	b=uGbuk6YsoKfHPGlDlP24EZLcdHNvBA91xnZJVolIx5pZ6toWtWHsEpCIJoGCEt2WnfgD
	 r8UXRNROM8ydnf7RBJv7ummxueJYOoNwWXsvdHwvRmL9MJSZbRi+BnF85Jf5ens6fTN70
	 VrUDVGN+w4fHX5mpB1aHTv8Dov85e/rrU9AqgpVF+29s9vKJTh1Sd0GBq/KbaDlzsNg8y
	 POhMw22Gy3pb89sWe0v7vH8/xotplwcu4HeLPhWG47Wp3LVBpbmPXmBHl9jDiriZ69Mkr
	 6r4mCqiFvUpi/XtQCizea73EMDa4VQM22kMwOfMk6dabXJjh8QIPWfN5SCtgewKbwBA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AF59B1F008A2;
	Tue, 10 Nov 2026 00:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271098;
	bh=F7SYWC9p63wzk1OOh3GF55OxJUzxN5yPYEBvs21OiD4=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Rlu9OpHnuB0ZRJiI8If98KrGmFurlDmcc+Xz553n9Af4StU7AHbr/nYGQMt5ufkpB
	 zIEH9hngZqj7Sl8WxJs6P8KpPeAvMKSD1riH2VL+eZuKakuv7oyBTCgerekqstmlPR
	 UWSEi70M+YJSsslh6Ey6EGzhAREHIHvvpCzWtkAcLz2KdlB+vJ5rz/vtn06MWrHYD+
	 f6iSJGkG0PcZ4De+Cgiqx9FUmFj2B4vbRYZDcPkgU+0Kt24Wj+DXqpExCeJmY5lmf/
	 WL+tCFtJ4SE8y3AE+Qk7jO2tFhPPNhuDQ05mYcW2rG2momN56mKbhqmrRSsAXaLZZA
	 xNL39gK9SONmg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0F71C4872D;
	Tue, 10 Nov 2026 00:38:17 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 10 Nov 2026 09:38:17 +0900
Subject: [PATCH] xfs: wait for direct I/O before swapping extents
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
Message-Id: <20261110-xfs-swapext-dio-wait-v1-1-b8ccc5d5ef3c@samsung.com>
X-B4-Tracking: v=1; b=H4sIAHhn8moC/x3MMQ6AIAxA0auYzjYBBhWvYhwQi3ZRQ42SEO4uc
 XzD/xmEIpPA2GSI9LDweVTotgG/u2Mj5LUajDKd1spiCoLyuovSjSuf+Dq+sVt6pbxxdtAENb0
 iBU7/dppL+QBEvDAdZgAAAA==
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794271096; l=1421;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=grxFvx5J+h49fGNJIZy/14ToLYlTBOdKLe89d7TYHY4=;
 b=B51sfxA0+dz3DqeZ+HRW/V1/hxt+LhhEHxydxcXybSn6BwVKeZsYRYTVhyEbN1Z446A40ukcB
 M770yk8DukNC2y8v4PlXy9orTllGOoVeeB6+FsoewycphEKwIN6cB/8
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

An AIO direct write drops the iolock before its bios complete.
XFS_IOC_SWAPEXT does not wait for it. The write can land in blocks that
the swap moved to the temporary file. Once xfs_fsr frees them, the
write corrupts whatever reuses them.

Wait for direct I/O first, as exchange-range does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested with an AIO direct write held back by cgroup io.max. Before, the
write reached files that reused the freed blocks in 7 of 7 runs. After,
those files were intact. The new fstests case "xfs: test that swapext
waits for in-flight direct I/O" fails before and passes after. Running
fstests -g fsr shows no change.

Applies with or without "xfs: break layouts before swapping extents".
---
 fs/xfs/xfs_bmap_util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5a..4d214708f9c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1257,6 +1257,7 @@ xfs_swap_extent_flush(
 {
 	int	error;
 
+	inode_dio_wait(VFS_I(ip));
 	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
 	if (error)
 		return error;

---
base-commit: 1e17fc56469d62d1c1ac45c137a2456d14456f1d
change-id: 20261109-xfs-swapext-dio-wait-6b700c2a981e

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


