Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A6D391505
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849548; cv=none; b=kvIaMiIQJP0Q6fon42VQS8DPXqZQ7QQB0sPi7UMSx6gh8qMXbiUvqPST/qZed63jLQIMqPPPVcL9Qf3/exvmXM2N4v/hvTA3d3ErU3pi5TEeZjUa7L93SKgHOybxqte9r5QO94+ZTkSX40XIyn0tLzXEjQ0zP3npHEFvKoxgg+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849548; c=relaxed/simple;
	bh=UaPuJwCLVDcQv2CNcbI3ytXdM3frRYCK0Qp+5mC37wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VihVtj+GVknevzlDbLVoKQ3uv0VprPX/Dmgq1MxuNVNCUgOHSGMa0T467sueca9XuXttfeLRiXRfBpJ1HIZqWfGbQFdmZhQCxyFce6DFDIji+ufR/v891o7l4884ur0VLIQcy2G5/MaJjPnijgSpQC89KiVI5HixOuPa0jK5tMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g1HDLWM5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g1HDLWM5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vCRKViKdxr0e2X8gkXxtUYtDMe4T51AIeX0m/Kb8esQ=; b=g1HDLWM5MLKZkaqOKIv9S0zZnB
	+oSR2pPBZeqwSZQ80sAHzHDDP1OUjuQHh4WG4yW9daKALx1ivOcN+1hYyEhk2sfIrZxhh08Erh/1C
	eInGxHHnwpYHgbum8lZZNr49UcyhObhxNL8jtlB6aJu2r++wjpSkkvTK3iV2ZzTxe7vQWVgu+wFxe
	DDR5sanR7DRIavSWSYV9HXw1MvDePZvx6cQAGqs3keZd3jEwAWFc+N1KKev4fztdRmQYjH2k6haXc
	/BszQTtPTocscjHvb1TRTRJNDrckNFTkqAB5PMI4ieJg4krwxeBwa5iX89Vy7o4DVlcDYEKbFyHen
	vTTwaVOA==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75RY-0000000AeWG-1iSy;
	Mon, 30 Mar 2026 05:45:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: delay opening the GC zone
Date: Mon, 30 Mar 2026 07:44:11 +0200
Message-ID: <20260330054533.3856339-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054533.3856339-1-hch@lst.de>
References: <20260330054533.3856339-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code that selects a new GC zone when the previous one is full also
handles a zone not being set at all.  Make use of that to simplify the
logic in xfs_zone_gc_mount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 45 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 0ff710fa0ee7..f076f66c5d57 100644
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
@@ -1177,31 +1180,24 @@ xfs_zone_gc_mount(
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
@@ -1224,7 +1220,6 @@ xfs_zone_gc_mount(
 	kfree(data);
 out_put_gc_zone:
 	xfs_open_zone_put(zi->zi_open_gc_zone);
-out:
 	return error;
 }
 
-- 
2.47.3

