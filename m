Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6202449502F
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435661; cv=none; b=d44RDiY9Y/bm1+boIuXqUTJJOy3ONI+jXBf8nnLWKC2RWvlRYolU/DAzGW5LXzXaKKVt68Ma1utgmrIo9+ikYMmklzvJOuOH5t4jXxLJoxrgdgcEltKbzqXLKv8NYvY8r09T/vc1Dhtqj/gTX/9vV7tk0qa6GYpsUNZAx7TMPXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435661; c=relaxed/simple;
	bh=FBQ1PWBvXHGwLa7aM/BqdVDGQDMlJO/HhmjfxA4wrDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOeSVHH9cjvFiQINg6lyDgJgT92u95zGgObG8E+qfJFLQu0RWEer/tZihdbd8940ikxLrpQPQ8PoXcHio3H3kkdxX9NEE1kqlJ2dCQuvckJ3/2LCVnOLV2HllnQft2NWa5bQmIps2ylWRZq89PlCzwYgMj2652m5LKvLQSvdiLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvjyDXiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvjyDXiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887301F00A3E;
	Thu,  3 Sep 2026 11:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435655;
	bh=r/BkdjmIoJWbZgs+4C+H1m6uqZtRIzqTSsnXwgmNcSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvjyDXiJaEC+n96Ao8QoMjTWkkxnsNf36cpo8CDuuwexEgg+TfXZ+8/t08eAk7Ftx
	 pdiYgsp3avyaVd89e8gAT64NETxzdPtSYIowrR3r6oVBiESZATCM/Ff835ePyWvmOr
	 EKPlMDGhWrPXRFDBTSvxCVPn3AOODpjFTzt9nfHNVAbhlBlVz6wRz63iD97eonlWXk
	 LG9mNU7nU6Z/Hayb5E2/0ntH7Q4eyiNtEXwX+ENUxtIOAawkQiHf13zHswIoBsMm3D
	 3I4YoXPVZEkIc2Wj8lA1CHEY+PlpLaEO1iB2BQuuMQRAnRu66qk1zE6F8ArQDrkuCo
	 JROoyY/6JLAYA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 03/23] xfs: fix exchmaps reservation limit check
Date: Thu,  3 Sep 2026 13:39:45 +0200
Message-ID: <20260903114022.570210-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yingjie Gao <gaoyingjie@uniontech.com>

Source kernel commit: 0a5213bbff62b51c7d4999ac8c7e11ea57d00d45

xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
overhead to a local resblks variable, but the final UINT_MAX
check still tests req->resblks.  That is the reservation value
from before the overhead was added.

The computed value is stored back in req->resblks and later passed
to xfs_trans_alloc(), whose block reservation argument is unsigned
int.  Check the computed reservation so the existing limit applies
to the value that will be used.

Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_exchmaps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 5566f9faf456..651c3784caba 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -708,7 +708,7 @@ xfs_exchmaps_estimate_overhead(
 		return -ENOSPC;
 
 	/* Can't actually reserve more than UINT_MAX blocks. */
-	if (req->resblks > UINT_MAX)
+	if (resblks > UINT_MAX)
 		return -ENOSPC;
 
 	req->resblks = resblks;
-- 
2.55.0

