Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792932107;
	b=B1UbnPPgXqkDpBepiV+4hSu8jgmq1OSxRnZLKzbz4r4zIbPbgvz728N5upt5AJxbb7nX
	 bZf/6zT8pZpO/JK2zBOF3qvVcvQVSOPqqerhrx/bsvtGUFvhpB68nSVzhtB0EguVRnCaA
	 9jb9FU5apfBSjBD4umFeuwcuofQ/kBI+1bTxYq0WsdqSaZzy4oxgkmf7qUJyxIDjwlbcg
	 g8+ZV0tHlu+r1gpirY4nSpyl8O5OtxRQYKcpOnyH6LJiX70YkcDSP2Xe7bAd4P2VGhdPs
	 Q8HlC5juhEQchScJteqD3tNW/iXKFn3cQOx5KpA2e3fWMgnUhhNyrFf82AMD96JOz5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792932107;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=TTMfSnuvvxIs+38X9pj7jTo4dpEjpC8oCgiQEVSo0Xs=;
	b=FMIOCLAKPuwowXQMnl3QTXktYnp6Z5mXGNPnhmVgds07NxXvYyylImCjeKC+zP7+eyMp
	 0Xa1paR9rayoySJ2EIibahiiBxi1p0TIl2c+V6VgbsE4F2ZZN3+LF4GjfXrbsXeLxBTUG
	 z5vpKX+w+zf8nca65wWyW8HLo4dV4fCuY6t/q1xssi8exy3Xmvf56/pFiHP+2u2ERUt+M
	 +745cae6tYHZi4OaAhc1nw57o4hCcpghBC2KGZfutme4uib60nhA9su6B6If6ivmP6KH9
	 lluh4F4AgDrskCpzAnLFTcbN2GXOCLnsicsksiOpayOizqsOfJ6AuX9AfagXr91GiFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="aAJGW/1j";
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B3C606A324;
	Sun, 25 Oct 2026 12:41:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2B3C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=aAJGW/1j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=TT
	MfSnuvvxIs+38X9pj7jTo4dpEjpC8oCgiQEVSo0Xs=; b=aAJGW/1jJtDI1Frnoh
	y2EVJgy/GJHKMI05TE35BgOdC9FiVuVd7ZT6vfkQekaApXk1w7Dd463TUGeYcX4T
	vgIF2icbZCeFXyMwfjS7SKKupiaS1HDgPzLrjM04RSP9m3lJ2owesQEXPQzj2D7X
	negtvlZdGaLCekkb+nOpnvPyo=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnvTzs+N1qxJALCA--.54355S6;
	Sun, 25 Oct 2026 20:41:22 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 4/5] xfs: drain in-flight DIO before zoned buffered writes
Date: Sun, 25 Oct 2026 20:41:13 +0800
Message-Id: <20261025124115.3178287-5-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261025124115.3178287-1-yaojiale02@163.com>
References: <20261025124115.3178287-1-yaojiale02@163.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnvTzs+N1qxJALCA--.54355S6
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFykJr18XFyfKFyUtr18Xwb_yoWkZFX_W3
	yvvry8Xw45Ga17X3WxAF1FvrZ5Ja1fJFn3Z345tF4Skw18J3sakr9xJrnxKr17ua43Wrs8
	Cw4kXr10qr9rujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU05l1DUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BKMxmrd+PIPYAAA36

Buffered writes to zoned realtime files hold XFS_IOLOCK_EXCL, but direct
I/O submitted earlier while holding the lock shared can still be active.
The buffered write can dirty page cache before the asynchronous direct
write completes its post-I/O invalidation, causing an invalidation failure
and a mapping error.

Use the buffered-write DIO drain after acquiring XFS_IOLOCK_EXCL and
before the zoned write checks can touch page cache. Preserve NOWAIT
semantics by returning -EAGAIN when a wait would be needed.

Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa7cf51b5843..96a11af8e71a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1121,6 +1121,10 @@ xfs_file_buffered_write_zoned(
 	if (ret)
 		goto out_unreserve;
 
+	ret = xfs_file_buffered_write_dio_wait(iocb);
+	if (ret)
+		goto out_unlock;
+
 	ret = xfs_file_write_checks(iocb, from, &iolock, &ac);
 	if (ret)
 		goto out_unlock;
-- 
2.34.1

