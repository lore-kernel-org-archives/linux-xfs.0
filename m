Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EE449B5CC
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263012; cv=none; b=un0MLeZwelAj5P8NvS8iyHimKUaTnUv4S0ZkpmLiGAkJkgAAOjE6PYLfCqtH0HC+wF4oz/qGaDi00gAQIGZWj/ZLU6qSPSgfVpb8HNr/5qvmuVoIPRT/XkAQURoGLgtKr41WsoUgFsLAmeiSR6vMgsQUy96RAxKWhZ/NP7eeWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263012; c=relaxed/simple;
	bh=BoawHSvy+5tHJ0QceDo8NqgsHwYhgtcRgrhDTIeMGMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htyzEJSpGcCldb69KlPsJDObFVT9bl5Y6pRNqrXzn76rA2DBpS8WcLoy/Eyy2wGB5LVA4hinLxjuFP4Ns+h7p8uVAXWcWgWJGrnWfTEwMr196me0MbXXNimrpKUHhJJD9v7BdE5NSQKupSaUbeHcEDjTEpUIsgVE4ZjBlyDa6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMapwI+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMapwI+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849331F00893;
	Thu, 24 Sep 2026 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263010;
	bh=GWm0ChmpRji/OZsTixjC4jXIbjA2ekC3ZgemHJ3GVXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMapwI+GG/QGWPz8HUw0+IRX2yOKhQgdoS9IpGqiqO3pE5KFfC8PbGmra2lxp/7pD
	 Cq6avlwSaCFdn95D7xPD1i0BycJJRf2MVLd6FSS7YaYb7Bzj+BDfCeezTO3t5mKbNm
	 B0T6Lu/Z9oyBmjECZuGE7CANAgWY7+VSOwju2YRy+cgOpxB/QDLP/1uyWCi75pc72e
	 q+DVLVfs1mWRrgzu8Dtg2OMnYVb99aJe6P4AYhRTIcTn/Qx/8NcS89IMldJm+YRb6K
	 VsCzijk6H3JdlI7U7qxfmnT0tdgSsO1+7EDWeT8rANRScGbmTq7LwiyIwdJLsj82VE
	 8JNyzJwLnc/CA==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	sandeen@sandeen.net
Subject: [PATCH v4 3/3] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel
Date: Thu, 24 Sep 2026 17:16:30 +0200
Message-ID: <20260924151638.38535-4-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924151638.38535-1-cem@kernel.org>
References: <20260924151638.38535-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

I've been in the situation a few times where the transaction got
cancelled by some reason. Most of time because bmapi_write failed and I
start a guessing game trying to understand why.

So if xfs_iomap_write_direct fails and it causes the transaction to be
cancelled, send the error to xfs_trans_cancel so the error gets logged
into the kernel log buffer.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c6238fed61e..4906a4828d11 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -358,7 +358,7 @@ xfs_iomap_write_direct(
 	return error;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
+	xfs_trans_cancel_error(tp, error);
 	goto out_unlock;
 }
 
-- 
2.55.0

