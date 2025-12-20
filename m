Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6023EAA3
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199480; cv=none; b=Wz4bm1gYdAXzt4N2y2SSbdLOI2/g8iacOxUOUC23R/IHnRyE+iQOx/cO+apP/GN4eTMj2t2QNx+6GKPfk8AV6IJP4rJTORm9oPj+V6MxxJTfKdeV87BASByf5iQn1Y4cLpY6wFl1rOQLtmEgJO+9y/v54Ty46gkpczlvhxXjUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199480; c=relaxed/simple;
	bh=8Fcn1ryh/6xTldXeQz7wZw52OiYQfAMjr6WNMDweJ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ1F/SJV55vuleQUv2O+LKG/4RntqtddZ9vnA/yi9G2nCEwFcCvm3hMvOXIE1+WXc/1awukxmOruOMPG19DM+1oPkrN7O0ww5SsMUp9VBEpfDBB8UTAkCQuexc3Rqh294An0g1FsZ0RlSRaUGud1R2A+jsnQoPKIvr8/9U8HO3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkwvnaYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkwvnaYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C153EC116C6;
	Sat, 20 Dec 2025 02:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199479;
	bh=8Fcn1ryh/6xTldXeQz7wZw52OiYQfAMjr6WNMDweJ4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkwvnaYZlaJJ2KXvq2xG/XFSeEG+hp5jUwXLsw/6vE5eyZxfcwBJmb0sC02622DBw
	 GEgKi8SadiRyzqC1FAeurzjWHz1TAj77hQUA2fqjsTKh69ApktNzZFygdPI3LrRTlk
	 Kh5tm3nQ4c2+Ik25Cp2wGnsbBi8atE4t9CuhW28YjTvGh9Z9a5Ihog+cUldRZWuUbw
	 binZYq9IzXGCxpnSL+aqac/0KrJkt/2HnVH5402F5AA0ZHkOuswPrvz3ttreNHzF/4
	 BrzD7pfYZ33azPyDUfB5qiqLxS3l8lWWpoFLhyPPJytjjW3NmU5khHRnAirEvQJhk+
	 oihB9OQbYznJg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 1/6] libxfs: add missing forward declaration in xfs_zones.h
Date: Sat, 20 Dec 2025 11:53:21 +0900
Message-ID: <20251220025326.209196-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251220025326.209196-1-dlemoal@kernel.org>
References: <20251220025326.209196-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the missing forward declaration for struct blk_zone in xfs_zones.h.
This avoids headaches with the order of header file inclusion to avoid
compilation errors.

Fixes: 48ccc2459039 ("xfs: parse and validate hardware zone information")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 libxfs/xfs_zones.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
index c4f1367b2cca..6376bb0e6da6 100644
--- a/libxfs/xfs_zones.h
+++ b/libxfs/xfs_zones.h
@@ -2,6 +2,7 @@
 #ifndef _LIBXFS_ZONES_H
 #define _LIBXFS_ZONES_H
 
+struct blk_zone;
 struct xfs_rtgroup;
 
 /*
-- 
2.52.0

