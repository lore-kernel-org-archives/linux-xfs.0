Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5047385D7C
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991823; cv=none; b=QO+byn612w70CWkNXbsLuXBzsKcPlRzlJUCqsYuqBwKpwafTC4sqP1eNjngeu7Uu+WIVZ0d/CofomTwO+P3+3+zvj/fQpjoAD3V8nzU+6sxA7L29WyIT0Hg+C6phWUgNWUUn+CdKxltgF+oiWrUny2iHa2pPcIaztD4ILFxCCzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991823; c=relaxed/simple;
	bh=wofFZAssgzJ6DzrDXNSncYR+NqTI0hrZIIGPAn3HY90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQxYV+m1fHVPy3PZRKfwck6oGaZhjsZD9AIBl7mXkJPWp0eJUfRQFXFn/vgWAA4A6UK+eXMK50G5vxrxOEhchGIT1JiUCAKpnVM3X2ZM0Pr9ZpFuwLYlZTrqekn58OC0jcb13b9ZBDzoUfvFz3ydGGsxY44Vh2l8JU4G9Ri4m+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xPOW//RE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xPOW//RE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/6mo7hvWExEfy0gZCgzqLgtpk2LWJ47gAa0IX3lnyjY=; b=xPOW//RElqP4H5LGGc1xBaTRFP
	eBvIrd36YdcY9TEGR55uMdhhJqLD8TzkzrwNHg3v85NBX6uTfb1iJoS2F1fb5TpxSzGXKGi0bTC0i
	+OJwhkhpIqXUPga+qBmWEyXxE6OiZLmpOXCR9lmQXClinqY+5Qxif7OILr0YbM9Z9xDAVmKZV1sjb
	Y5KsBNvNaeG4FSXnrgKzQ3gdI0w4smW9BW8E5VRDkadMD4BleM2GYM4ryVdW4tXQl4B9RDxz9ORFi
	W/CcsKEtuTJCnQJg4J2tkgN0w7wFaS2az4HUKgVE4+4ZDXBI3ramTI44Ak9ZsRaFK9cn2Zbf3Cdzt
	svjXXjhg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrKY-000000050zR-0UQs;
	Tue, 09 Jun 2026 07:57:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: factor out a xfs_add_free_zone helper
Date: Tue,  9 Jun 2026 09:56:41 +0200
Message-ID: <20260609075655.1698743-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609075655.1698743-1-hch@lst.de>
References: <20260609075655.1698743-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper for adding a zone to the free pool in preparation of adding
another caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 11 +++++++++--
 fs/xfs/xfs_zone_alloc.h |  1 +
 fs/xfs/xfs_zone_gc.c    |  4 +---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 5e297b75a85f..0a7c4863eefb 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -944,6 +944,14 @@ xfs_zone_rgbno_is_valid(
 			rtg_rgno(rtg), XFS_RTG_FREE);
 }
 
+void
+xfs_add_free_zone(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
+	atomic_inc(&rtg_mount(rtg)->m_zone_info->zi_nr_free_zones);
+}
+
 static void
 xfs_free_open_zones(
 	struct xfs_zone_info	*zi)
@@ -1082,8 +1090,7 @@ xfs_init_zone(
 
 	if (write_pointer == 0) {
 		/* zone is empty */
-		atomic_inc(&zi->zi_nr_free_zones);
-		xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
+		xfs_add_free_zone(rtg);
 		iz->available += rtg_blocks(rtg);
 	} else if (write_pointer < rtg_blocks(rtg)) {
 		/* zone is open */
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index 8b2ef98c81ef..cc16cc328763 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -42,6 +42,7 @@ void xfs_zoned_wake_all(struct xfs_mount *mp);
 bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
 void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
 
+void xfs_add_free_zone(struct xfs_rtgroup *rtg);
 uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
 		enum xfs_free_counter ctr);
 void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index f03211e4354a..670e05d2dadd 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -924,9 +924,7 @@ xfs_zone_gc_finish_reset(
 		goto out;
 	}
 
-	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
-	atomic_inc(&zi->zi_nr_free_zones);
-
+	xfs_add_free_zone(rtg);
 	xfs_zoned_add_available(mp, rtg_blocks(rtg));
 
 	wake_up_all(&zi->zi_zone_wait);
-- 
2.53.0

