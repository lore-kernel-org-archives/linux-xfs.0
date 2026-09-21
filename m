Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332F455637
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979537; cv=none; b=hCGPqsC143Ps4OF56q1P0xu2yH1oqyOuAngQ/JWBWW/DaMIknRWzoQKR0PZRG46tT3WAMRZtVQbbtBdscFEH0IPFLuYPj8m6DuLboNNLaknX8adF4EDpgHnX/TEQMTLODYFHrvHsYBKKGL7+G6noZdoChKe7/ML4tgpkqPQJsH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979537; c=relaxed/simple;
	bh=5w3bKTheiRENHYbzw7Hs+HnRJrbVBZhYnmx0e7/LD9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u65aaGJzu8haIWzbFyvXY8zWVRC2bpq+1XU/moO5jFintizH7K6mNX23ifGXsowD73gNTKthdhC05yiGjD5jLAMAgEqLnzBjQ4GdkQMM9JGuQWxbui0yaAF+PCoVs4W8Jqy5r2htYtJueqeo6F6N9ERw6R+9UUOCwVIaUHxDRqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qKi56HCN; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qKi56HCN"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d37b5so15224465e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 01:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789979534; x=1790584334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GCFblZT5c9t+k9mTW4Xpv48TzEDBf3qgpT7BTEui24U=;
        b=qKi56HCN+7s0FTr31iu42hX2IX7livC+h6EFyb9CQx3um7kXt0NAZThsDmeFU901+p
         pBh8NJFG6Xtsm45LmIRHz3V9CKLsCcR4Td33ls7goS5iChWx4p8h6jb3sUT6QFUSRZfB
         W5F9MNS3x1iRxxZD71PKU0WWG7no/5I3B+YIVT60jWfNZArlEJKmksI+bCFjh02Wp028
         wKH8gYA1hJr6ai0xtdbvjnzH229jR0FlQFyYTP7Fql8g+NaCnuCjYv7se1LHBSlQpD0q
         DPN3Z1D30DWd4oYZCxLagKxAsWK2jORjT5JlPKqqOMXFFOCyIjz8Kqswyx5IBG5xoYOf
         7mMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789979534; x=1790584334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GCFblZT5c9t+k9mTW4Xpv48TzEDBf3qgpT7BTEui24U=;
        b=kU88y60swougfiblLXm4DGd2eBplPQ2YuLL1I0jhg8jp5E6B08gFCCdsky81KO7dA8
         l531kH6zUUzYXSVHLSyWrefusObttFs63g3nf/gEzI2MWK+HdpucO1jWYqEbY0g4Flpf
         BOmlnlGpIJqBiue9G+TdJ8Q4AGL3QYhVrm1HEQwBeAIouRIKi+HYRsdSp2zaaYYC5lSY
         XOZYmm1E2cp+HVACQqCS1xJ671utP+qCNWn0tyd/thO+/oxUl+2m/Tdh39t/2zZncjNB
         zjI+YovO74MTg+UXQ8/ZoxFMfYFIJZZKhyWbu6MHLC54l2oxR7ZdlWryf7q2j5EZZkJW
         OBRg==
X-Gm-Message-State: AFuF++lZ3OuBEHAtDE9u9yB07G2/eLOy04EhW3dJTc+PSkoJBfJewxGB
	nXO2fWF2dXCETgrbodi0Z2FYLw27O22+8HtD8fhLxPuFYeQmR3ooPo4N
X-Gm-Gg: AYBFou34bGCyDK2bHKLVQlndR1Cohq99ZDfJNwcVYIL98ZBII5M3Jr0meN0wD15t1hB
	BAPs8IZQaMrhc4kZFSZFI8QEbwLnVR/gvw+0Mw2f/RFwEeRrbUiVl7+00WimY4jSq0SneHfqTon
	m0aHya0x++Zu8215ixaku5oikR9OgizHzu5nQ1zNSaKIpvs9boiKf1x3AlJgciOX9UM4WqZwa7Y
	s8rKjL7mC7Zb3fH3zOcWs1t6jsEQTW5kxluXTuDi5mIpb0pSk/7wWkHqndox8tqnWMWsbSGSOqQ
	FyKS6Vij+MHfckdWV1PCxYZ8im2AQuWN4gSOrkxW1F5WOt/F/DxKs7inlj9npwHrPMMvm4DJxGN
	ZZI1rdVhtlUPOXUUOIOlTfbAMszRAy+vL3/BMjLR5uOPfbUbMwY1Bt7Vj/PdzqEPUA+0ZbY6Lg7
	4FiuB8Xyet4ogGNGYebj4UiJb+bz1iBuvJNr0pkQidnqf+85ITnMNBrYWTO8vuv3nfxGPuQzWmV
	cKX2YBqsL6wsy6F9g1vxBi/EVjlRr/xlaHGA3GoHJvexQ==
X-Received: by 2002:a05:600c:4e50:b0:49c:ee20:e787 with SMTP id 5b1f17b1804b1-49fc566443fmr121010765e9.1.1789979533422;
        Mon, 21 Sep 2026 01:32:13 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd10d174sm222806105e9.11.2026.09.21.01.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 01:32:13 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrea Parri <parri.andrea@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] iomap: don't lose a fiemap iteration error when emitting the last extent
Date: Mon, 21 Sep 2026 10:31:32 +0200
Message-ID: <20260921083133.2960-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921083133.2960-1-parri.andrea@gmail.com>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_fiemap() emits extents one behind: iomap_fiemap_iter() flushes the
previous extent and remembers the current one, and the remembered extent
is written with FIEMAP_EXTENT_LAST after the iteration loop.

That final flush overwrites ret, so when ->iomap_begin() fails partway
through the iteration the error is replaced by the result of
iomap_to_fiemap() (zero on success) and iomap_fiemap() returns success
with a truncated extent list whose last entry is wrongly marked as the
last extent in the file.  The pre-iomap_iter code returned the error
from inside the loop, before flushing the pending extent.

Check for the iteration error before flushing the pending extent, so
that real errors are propagated and only a successful iteration emits
the final FIEMAP_EXTENT_LAST extent.  -ENOENT (no mapping) is still not
an error, and the pending extent is still emitted in that case.

Fixes: 7892386d35715 ("iomap: switch iomap_fiemap to use iomap_iter")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 fs/iomap/fiemap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index d11dadff82865..54b824b7edb5c 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -76,15 +76,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_fiemap_iter(&iter, fi, &prev);
 
+	/* inode with no (attribute) mapping will give ENOENT */
+	if (ret < 0 && ret != -ENOENT)
+		return ret;
+
 	if (prev.type != IOMAP_HOLE) {
 		ret = iomap_to_fiemap(fi, &prev, FIEMAP_EXTENT_LAST);
 		if (ret < 0)
 			return ret;
 	}
-
-	/* inode with no (attribute) mapping will give ENOENT */
-	if (ret < 0 && ret != -ENOENT)
-		return ret;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
-- 
2.53.0

