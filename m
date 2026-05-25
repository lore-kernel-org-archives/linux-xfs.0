Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B573E0227
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 09:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699968; cv=none; b=G3ghnndNZ9vfbI3uA7spMRuCRvIHMd8CosPDO8ZgEHlOFHZIoy4SY+hZLuJB7zmPUX7HbFTpVp+BY+pWNoNXC+GxGpsnRSjsVF3i7yQTQkWcuTTkCneFQFxWEFGbFNkXoaeLl17d0vazXqk7MXmRFqAfWyL2z5iDgf0mcD0yf9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699968; c=relaxed/simple;
	bh=frwsEpv/ns/nwytyGMp4DgKIjA5Q54TfkMftXcQXtK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PdYnVitdtiegdk6T7oYj+mAqv5U47qZsXGUSy7pkkNeuCAIHuzaacGqZwzyyC9sljvHJBeQewFgJUlu1+9Iw9Fs19Qj/8Y8ZwpqVW0L5iiSOIHUrKbiLjKCbGsqbh/KM3KO1RvGSjGEhjc1ztYjLa6zDGjY2p7+oyx7jv/XOUYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 6CEC4180F2D5;
	Mon, 25 May 2026 11:05:58 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id ostbGPYQFGoOvjcAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 11:05:58 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH] xfsprogs: mkfs.xfs replace assert on 0 size file with error and usage
Date: Mon, 25 May 2026 11:05:44 +0200
Message-ID: <20260525090543.4178496-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running mkfs.xfs on zero size file ends up with assert() and coredump.
It would be better the print error message and usage.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd8a48c3633e..3e83d336e8cf 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3851,7 +3851,9 @@ validate_datadev(
 			fprintf(stderr, _("can't get size of data subvolume\n"));
 			usage();
 		}
-		ASSERT(cfg->dblocks);
+		fprintf(stderr,
+			_("data size must be specified for a zero-size file\n"));
+		usage();
 	} else if (cfg->dblocks) {
 		/* check the size fits into the underlying device */
 		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
-- 
2.54.0

