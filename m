Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35B54035AF
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970888; cv=none; b=Ll8Yyk44Mucl7upnF9Z6V8u7aEOtu3Z1Zx4BthJo99/AYMYj5fTCUXyS1TbYtH+s8khUSpNcvwm95fX1zVWsKIHzOPitTmmgbflhbLUJNP9L13nza4hGeipVMDMawtUlgiZd8G7C7UiMLYSOvJ8L9RmKaWYo9F7R5GPHudgsy4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970888; c=relaxed/simple;
	bh=Y+VdcjwIAv0PBbcmrt+Nsb4ZxTKS3DwtmCAutkHuZIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB+g6jjmiyGmlzcROKcSOdyi/5mi/JpeO+psGhfqREitBxyQvjCJYxr8Kga+HT/Ld5G5JOr3lNOR6CaDi2l0vLHmf6ze8A9bn9XbIi9TuweMsaSxraGoV4TvYNxhrD2DTdaQWSzsnA73d1NVx+c58YoVaaRQLsCc/NKjlgrgaIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EXbicWfK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EXbicWfK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eRcMMUmM+hvyOGS5apoU0POJTTxigQ33WGzmlGHJGdE=; b=EXbicWfK7Mj39B9J7kZ4fqk+w6
	hUAKtqo59n24IT2ACVBJknFUGl8vCK85n62ek9j8+t1oSDBvAgkrJijsG3nL3PscufJNVSzRKa0Su
	I24/uV59uyLGXYQatmc9kc7y8ikPMDNVj4gdlPSXUcKMnPEK6CAMEoJFsUHa+hArSrfjgwpcgkede
	RLKbt55kaugiDLgDH0cYkOHQXdLuW1qHQuFIcpBjyBMSQkhx8xjzB/Rwcnkx2E+LZiUkc2aLhKSb2
	Q67P8rdp+bmd5Yr3YAoMLgRga3E/vX0rqj9/jI2PuY6N15YxZdB11eBm2RaBqJsSlrlKzMyEWV48q
	3pAPSWCA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0g-0000000DBEQ-0O6k;
	Tue, 31 Mar 2026 15:28:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/9] xfs: put the open zone later xfs_open_zone_put
Date: Tue, 31 Mar 2026 17:27:25 +0200
Message-ID: <20260331152751.4048218-4-hch@lst.de>
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

The open zone is what holds the rtg reference for us.  This doesn't
matter until we support shrinking, and even then is rather theoretical
because we can't shrink away a just filled zone in a tiny race window,
but let's play safe here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 5f8b6cbeebfd..17a3762aa951 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -182,11 +182,11 @@ xfs_open_zone_mark_full(
 		list_del_init(&oz->oz_entry);
 	}
 	spin_unlock(&zi->zi_open_zones_lock);
-	xfs_open_zone_put(oz);
 
 	wake_up_all(&zi->zi_zone_wait);
 	if (used < rtg_blocks(rtg))
 		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
+	xfs_open_zone_put(oz);
 }
 
 static inline void
-- 
2.47.3

