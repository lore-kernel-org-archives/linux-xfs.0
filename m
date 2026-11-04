Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782837;
	b=OfFtTHh2HTA56sdm3YFqNuFJG3uQHahkx1IyxkxUJ2WHXRbTzJ37Vz12Gfv3eEvsnaMG
	 RalV2B1W/dC4OpmVNQXUspY4VAdB8VVANE4F1P76ZY0VvvGnfhCrKiENGwZWS91gEr/GA
	 JtkPldLMo7RlRGUZ0ov9pQjjIeQ1ZvYto1yRobyhoXO6M9yW2mguZwwf51vJZ1OPAW7dn
	 WBs4Z6el/BAogMH/dUbko0zVn5r2BHZn6oLJevfcRfMmhw5FCqvt5cPB1y/+1tB52Mk3M
	 +9fjP4sDZvGT9dhazIbFWPkkK4HxAtHjcaw04oLKqhy+9gQ5FpwDJpdGYDpYuVYZ17Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782837;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=HCdCMzq/+bX1dLqPa6fkaSWeiTFeseD4AJonCOz2yyY=;
	b=HjwcLS4ugdQBhatejLQel3qQvj8G4lf57KafRtzZ6WJ7zrRCUjX2d579L5qH54nQZqMN
	 cZc6JejRTq7EWdbkY+kPmzTiENO2ZM50i2HNb4qfK5iJezRo7Vb4792u4HZoEgeb37wQX
	 DPmvqEvenJovFBHKbsD+kkKVLa15piGzBYMevapEqFe3/xZhszo+tlFnO+ZohpfP9HG/9
	 KP+DAFwysupyrJYL++L4q2ghzap3OdCpOYYwdMTUMC71/2lNLHqitW6IMsZcy5pNLgXNL
	 o1EK9r3OKbAFOos7YkhXLT+VImnsKOitnZ2MhKBX6zKeGjiFUXMBxZBaB4L/nEbTGdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=RaGWsVw1;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B03606A339;
	Wed,  4 Nov 2026 09:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8B03606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=RaGWsVw1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HCdCMzq/+bX1dLqPa6fkaSWeiTFeseD4AJonCOz2yyY=; b=RaGWsVw1dMqLO9dRtTOrKrHt6Q
	bacZy1La481JoA96hKFyE75Zb3hR68dGaB5ZocZvVXTz2+JtjLOxep8Ec4m5x+HyzaNz26H0RdCut
	Lst0AInpgeoAZMhNU0PTN/3PHG1xqtLtvnWSwuCRXiYa3JKQpfGGvM+anfk5oNQf1tWLH1f+tEAFr
	1FnZHhuFWxTrntvPpQxwYYzi9iJUPa8uygiK9bLUIVibOc5KPxXNEc8iTJ3fJKMhgS5VfnLWItGmp
	tTIm+TDyjegTjrj52zkNZtHqwZSQS8WBTa7A0fcndsNsL0r+oD/q+RUjoVkHxtvYI7LfVAOnsHepB
	DP5rbhCg==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWrD-00000004oZF-41Qk;
	Wed, 04 Nov 2026 09:00:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 22/25] xfs: report RT data checksum information via XFS_FSOP_GEOM
Date: Wed,  4 Nov 2026 09:57:26 +0100
Message-ID: <20261104085929.317544-23-hch@lst.de>
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

Report the RT data checksum flag and the checksum algorithm to userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 6 +++++-
 fs/xfs/libxfs/xfs_sb.c | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 226cb96dfae8..ef644cfe26d6 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -191,7 +191,10 @@ struct xfs_fsop_geom {
 	__u32		rgcount;	/* number of realtime groups	*/
 	__u64		rtstart;	/* start of internal rt section */
 	__u64		rtreserved;	/* RT (zoned) reserved blocks	*/
-	__u64		reserved[14];	/* reserved space		*/
+	__u8		rtcsum_type;	/* RT data checksum type	*/
+	__u8		rtcsum_blklog;	/* log2 of rtcsum bsize		*/
+	__u8		reserved_pad[6];/* reserved space		*/
+	__u64		reserved[13];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
@@ -250,6 +253,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_DATA_CSUM	(1 << 28) /* data checksums */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 8096706ed78a..a1aebf398423 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1630,6 +1630,11 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_rtcsum(mp)) {
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_DATA_CSUM;
+		geo->rtcsum_type = mp->m_sb.sb_rtcsum_type;
+		geo->rtcsum_blklog = mp->m_sb.sb_rtcsum_blklog;
+	}
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.53.0

