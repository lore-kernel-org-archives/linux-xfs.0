Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6892740756C
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970879; cv=none; b=d/aLOsgwcanrxs9deJE7D9qLv+clfCXZ35mZfv4+eFWJCaF20JqQuX2SgmbsdRDc2NBRe2cIwSpPwBLyLEuMoS3tR67NICUnnSz8ElBNfGc65FeDMrcsNH5Vexa5UDOXN1GPx7BwDxmce7nhAbrDupO6bZwqz8RV8PIeTMQoNKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970879; c=relaxed/simple;
	bh=JThijfNkdIZWXFH1heCeSHhD3UFjUMO+V6ZJjHlPveE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkqgJf4Jh+6bjOvr1xwJEQozVSfcW7s8g2KxZtiXTB8Jr7ENb189pkXTuJruiriVyqiY3iGO+fTHPj1aUi4WK6bVRqwZSrCKUUn/ogdCQXR8laZf3d1JwcjArWQ2qsmuwHmW6DeMTbQBbM5VmtuNgkBsIOHuvs3mOc5ymwccHtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hrhWsX/5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hrhWsX/5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=R+2ppUBMrFyauWtxt9gNL9sV9QcRJUQ4a8UkfzpdgSI=; b=hrhWsX/5HyDYhGNGO8qW24u2MK
	7D+q6OL0Y0lU1hruE6vMOIiYA4XAngZMX5EoTIJXqWur1XzIZ+7ZgozRectk+/LBz+TExCeispiSF
	zTN9ymBbipUS7Y3Dx7fJSjx+7qCJdm9zVus0clGrbiBWtCvfQR8b1twPypqGR2gpFQf8vJUjyL8TQ
	kOHQz5PfSliTCHe9UlPoj0RX+VlXDlYdVrja6NRqirOAJdP28vGPMbGBENBUJ/mzix/J7Omh0WyuZ
	hbjFB7SlACZc4Shq3wWcy7OxQQIHTWyNBOBVtfcJBbLLS29/Q1EvSz9GwzlXI/nXLh8LZqaElnPCX
	QcpMaQYA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0X-0000000DBDX-2uUq;
	Tue, 31 Mar 2026 15:27:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/9] xfs: delay initial open of the GC zone
Date: Tue, 31 Mar 2026 17:27:23 +0200
Message-ID: <20260331152751.4048218-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code currently used to select the new GC target zone when the
previous one is full also handles the case where there is no current GC
target zone at all.  Make use of that to simplify the logic in
xfs_zone_gc_mount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_zone_gc.c | 45 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index a8f71231f351..00a996c13d8a 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -527,7 +527,7 @@ xfs_zone_gc_select_victim(
 	return true;
 }
 
-static struct xfs_open_zone *
+static int
 xfs_zone_gc_steal_open(
 	struct xfs_zone_info	*zi)
 {
@@ -538,15 +538,18 @@ xfs_zone_gc_steal_open(
 		if (!found || oz->oz_allocated < found->oz_allocated)
 			found = oz;
 	}
-
-	if (found) {
-		found->oz_is_gc = true;
-		list_del_init(&found->oz_entry);
-		zi->zi_nr_open_zones--;
+	if (!found) {
+		spin_unlock(&zi->zi_open_zones_lock);
+		return -EIO;
 	}
 
+	trace_xfs_zone_gc_target_opened(found->oz_rtg);
+	found->oz_is_gc = true;
+	list_del_init(&found->oz_entry);
+	zi->zi_nr_open_zones--;
+	zi->zi_open_gc_zone = found;
 	spin_unlock(&zi->zi_open_zones_lock);
-	return found;
+	return 0;
 }
 
 static struct xfs_open_zone *
@@ -1194,31 +1197,24 @@ xfs_zone_gc_mount(
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	struct xfs_zone_gc_data	*data;
-	struct xfs_open_zone	*oz;
 	int			error;
 
 	/*
-	 * If there are no free zones available for GC, pick the open zone with
+	 * If there are no free zones available for GC, or the number of open
+	 * zones has reached the open zone limit, pick the open zone with
 	 * the least used space to GC into.  This should only happen after an
-	 * unclean shutdown near ENOSPC while GC was ongoing.
-	 *
-	 * We also need to do this for the first gc zone allocation if we
-	 * unmounted while at the open limit.
+	 * unclean shutdown while GC was ongoing.  Otherwise a GC zone will
+	 * be selected from the free zone pool on demand.
 	 */
 	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE) ||
-	    zi->zi_nr_open_zones == mp->m_max_open_zones)
-		oz = xfs_zone_gc_steal_open(zi);
-	else
-		oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
-	if (!oz) {
-		xfs_warn(mp, "unable to allocate a zone for gc");
-		error = -EIO;
-		goto out;
+	    zi->zi_nr_open_zones >= mp->m_max_open_zones) {
+		error = xfs_zone_gc_steal_open(zi);
+		if (error) {
+			xfs_warn(mp, "unable to steal an open zone for gc");
+			return error;
+		}
 	}
 
-	trace_xfs_zone_gc_target_opened(oz->oz_rtg);
-	zi->zi_open_gc_zone = oz;
-
 	data = xfs_zone_gc_data_alloc(mp);
 	if (!data) {
 		error = -ENOMEM;
@@ -1241,7 +1237,6 @@ xfs_zone_gc_mount(
 	kfree(data);
 out_put_gc_zone:
 	xfs_open_zone_put(zi->zi_open_gc_zone);
-out:
 	return error;
 }
 
-- 
2.47.3

