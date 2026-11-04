Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782843;
	b=N4Z13qUCyH+dkjRjoqY/hWPT5LfeDMtiUeYNhQul80ugqhzaqH3bpxDO5lWCeNESiK5y
	 +3Zls4MBEI9nOOsKZh+SfgTjZfRyQOIM/brfQqFYgc6RtMqlQ32Jh+4dFIEWvdipITICR
	 kQqLoxjEXaDqsgvsyd73fCyZcku74OgJ6hwSavqHlX1Bzm2LoRIw2HEODb2S3KSlCE8xd
	 ibXW1EDtowXqwk/tGjKDIHcA8qUn787z/KGrx8nDB6GqJ8GFReM/x6dCE5BrUD8EEeayR
	 lLJRlrvmLamamI1G/N1VLUQ39AAzwPqYZNtX/ZAv0pZAN3qmRp//KayYi7+ffbAn/pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782843;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=LvvqoJDHibxy8UQLg+cOrm+AyPdcJHwIVc65L0Wvp90=;
	b=cGYfgSYgyOB5Oc+ZkP7I+/iDgkYRKXmsh99IXylkvys8j01SDnbiZVzSxWRqvPVx9PR8
	 yunDOyAmP6xL/U8iR9MRiYT4P/eZJaL0s9iHyYaVDSxeYJgiDgYGhKDoiaiq6XBy0xL9e
	 WipMPLYXpHeeOt6/LTqC/YTQVACM9oU2EIKbqFaCYAwrH2rPzx3bqYgJcusbE9nc5emA/
	 3SwhL3IH+JyN7eWV4z7l+VeGBXhOqRpyhhhd7Z4EPOIJLuzLfZgIllR8mVmJv5gF4BTO7
	 CdOGoT9x5WICVzkoyJGUMK5DO4bKM5SgHw2McJf63rh7n12VOXmeUC41ldU1tXqIP2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mfIX8LpR;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3529606A33F;
	Wed,  4 Nov 2026 09:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3529606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mfIX8LpR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LvvqoJDHibxy8UQLg+cOrm+AyPdcJHwIVc65L0Wvp90=; b=mfIX8LpRt8nvZqstaO1KpO6/Hq
	ub7u5KIgALNRgYVfwJcvskgh4LjbiUcKlrGaJaxo6I1Wq4Uuvn3PbRP1aAb/pMPe/86IhE+JmkQTq
	w8jqVK0lktrod+U39UbHA/wCYVEXnEq0Yg59Xq5FGEyJJ/OPKyIxCZ0zaM2L/Hzex3lzhPi9ufjwb
	efds5VMfTPk/AkjRh7aS8QcQYv6N8VZl4yma4TklW+AO9xGKHQl1/Dfew0zj5dMVLw4q73/jEwyEG
	pVN1mFzOOBJp5rk8YOKrFpzVIAdlZf/3MMm99WrrQaJ+U6ZCNiPdSX0EUk9YMdg/ODw0mSwIcH/+b
	0/1fqqSw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWrK-00000004ob5-0Wx6;
	Wed, 04 Nov 2026 09:00:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 24/25] xfs: enable RT data checksums
Date: Wed,  4 Nov 2026 09:57:28 +0100
Message-ID: <20261104085929.317544-25-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All mandatory pieces are in place now, allow mounting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3d794a2eb497..4ed938d710ac 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -417,7 +417,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR | \
 		 XFS_SB_FEAT_INCOMPAT_ZONED | \
-		 XFS_SB_FEAT_INCOMPAT_ZONE_GAPS)
+		 XFS_SB_FEAT_INCOMPAT_ZONE_GAPS | \
+		 XFS_SB_FEAT_INCOMPAT_RTCSUM)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.53.0

