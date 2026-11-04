Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782840;
	b=tsxuo7/im5Kcd8ObaPYCzMlyQ+AACgPNdDmEDWrWL4PshPPNGoaxUrmG0SCKFGA/i4Am
	 JOF6dvZmXWrZLoCVX6vYLdgoTCNnVCOS05PLmwUQj03ySff/kyDqvURi/FucrqVA7dK8d
	 /jL6uwmNYnDTQF71mAo5tIxU50Qtl/XIyVaFfzkrGA5EATgbP4ssQ7bkyBvgaWGzZAmGU
	 XIZleHADvlMnLGItZvvo4iB92m8UltChav2hOoVfPwCO5LDPfPz6Fh6gUI2R9oAR5lxJa
	 GB9q7zzOH7Vu1wbwaYyFiSaOiFL0nqK/isylaH/FqtZt5Os84HFPwPfcoW+iYMTosVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782840;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=7s2gOhRlZiCSrJAoHT0ucgl6w0CxdpYkUM+aU9MvuV0=;
	b=oBfMzgxK8lSVEn6TizeA8LVDuMGyQinmPdcLLkw14kjvT0FCWakRlq45CdlwI5TMMYWl
	 F+MCHCRr96DsjyxO9jfuVTP+HshoFUMHblCL6p1KvW6Ea3nAp0p9z0IJ7VYEvE1T0hkq3
	 1kr5q73a1mh2b7f5m/MovBw4eBto57kiIO0eMssDQWDiZccwioJxjmIjWguTXlkEGr+uM
	 sV3A/PDXLNqEdzIAvmVDUc5QAX2cR4O6oy6znlxwasQY/AExHu0GhGAHQFdO7/lQ2gtrJ
	 fTMbwF1iYQoSyQgRwZOlatKf/u68tWze9L6jtKQx0wwdj0XAj4dbgvIIczefsFkhhAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Q3tbgzCt;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B41606A336;
	Wed,  4 Nov 2026 09:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6B41606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Q3tbgzCt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7s2gOhRlZiCSrJAoHT0ucgl6w0CxdpYkUM+aU9MvuV0=; b=Q3tbgzCt2TTeLZjQzqe0+T6cAl
	LGTi414Y2i1ygpWPDNJ6bagEZoLSGVcguFGupdTmPG2bFshDfwb7MS+esSm3uoOHwrLOv11VOjIoA
	dxLeMB3TsVhA3OMb223vtwOPzVsXMbVkyxZHk8GbeA56YQpeLmKG5JvN/OFanEJOnjmmEFk2jRH4c
	GdzZRS0LZv3TP+Xk6EHZHX+LpSEZJSCf3Ih/zyeetSU1Kzr9YbzO9WfG2byUmtZKpg+FoYaX9JbUV
	hZtj+t3+sJLy9NKj/ms+Keywm8HIri6xaHICzImMN4bIBSFqqq9u8RQU4ChLp3II/xF/vIIUxxCSO
	Y3OJ15Vw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWrG-00000004oaN-3iYU;
	Wed, 04 Nov 2026 09:00:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 23/25] xfs: add an experimental feature warning for RT data checksums
Date: Wed,  4 Nov 2026 09:57:27 +0100
Message-ID: <20261104085929.317544-24-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_message.c | 4 ++++
 fs/xfs/xfs_message.h | 1 +
 fs/xfs/xfs_mount.h   | 2 ++
 fs/xfs/xfs_rtcsum.c  | 1 +
 4 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 0243e509a468..2924e5c2b8fc 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -149,6 +149,10 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LARP,
 			.name		= "logged extended attributes",
 		},
+		[XFS_EXPERIMENTAL_CSUM] = {
+			.opstate	= XFS_OPSTATE_WARNED_CSUM,
+			.name		= "data checksums",
+		},
 	};
 	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bfae8dddc9a6..23b178ea4976 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -94,6 +94,7 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
+	XFS_EXPERIMENTAL_CSUM,
 
 	XFS_EXPERIMENTAL_MAX,
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0e60d5c29c9d..70f7563cde61 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -583,6 +583,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
  */
 #define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
+/* Kernel has logged a warning about checksums */
+#define XFS_OPSTATE_WARNED_CSUM		8
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	9
 /* Kernel has logged a warning about logged xattr updates being used. */
diff --git a/fs/xfs/xfs_rtcsum.c b/fs/xfs/xfs_rtcsum.c
index 64fbf6886f8f..93e9792207c6 100644
--- a/fs/xfs/xfs_rtcsum.c
+++ b/fs/xfs/xfs_rtcsum.c
@@ -308,6 +308,7 @@ xfs_rtcsum_mount(
 	}
 	mp->m_features |= XFS_FEAT_DAX_NEVER;
 
+	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_CSUM);
 	xfs_info(mp, "using %s for RT device data checksums",
 		xfs_data_csum_names[mp->m_sb.sb_rtcsum_type]);
 	return 0;
-- 
2.53.0

