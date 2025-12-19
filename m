Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7412FE057
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766137361; cv=none; b=mCHjir4E1wujy491KZ4jxG/aXffRs8NyJ+AQ4oD1cY2QoUvI8KpyPK8A4xVoTjHb7uNoxvfyC2JZrAKNJrZKlIFpQ0q2UO3JiLzCTrqVswJ2mHeTh7MHq8kO/GVODtvkf4SJmUeKVAoE10mOP0agRB+TssppxY/M5a/WSnXkyBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766137361; c=relaxed/simple;
	bh=bsNqwImZgQ1Rl6AKdL++vq/619ud/XJJ/DCs+X3J23c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfCp9ZfBPUc8oPy8hX5yCogHZmlhOG9k+GR4CLCyNPvh6jtOzjYi9mCvbrRg1xqojRyIhyQo+DzxYn9wZYXP0AD1xa6SgMyz/5pRlCgF5gdotvZ5FpsrMsmzsbWPl3xCTZag8TqqcyrTskGkodUIGD9Olw89Udv7N5yTxHR7Sxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clOTlM97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clOTlM97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7582EC4CEF1;
	Fri, 19 Dec 2025 09:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766137361;
	bh=bsNqwImZgQ1Rl6AKdL++vq/619ud/XJJ/DCs+X3J23c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clOTlM97GofRFtL76Lb9ycTPQ3XWNBLIUHmf/H7tcrUCgrnxqsgr7Cw4QnBpuY6dq
	 HkIuP+Z9EP0HcMgrAdLJZU3sMJOiNRzQ7j9eBJFxYotpl98qqzwvdxdZOKBEjgxJGH
	 Z6s8jTmBi87/ngxsQ0pZEmORdQoVoVtvvBSt4+VG6ZihyZJjCNeLnoEjdoh/ynfrWl
	 v2Eud8fGZFsdgLyCB3fwCmtOM4B05vTApmrkCRkChTlCiqPWSdzUJc5tXMyeabNC/F
	 Es7AzL8ZfKhE5ZjmRHcQXOINgZMgbSy+YoPcoJxXIXPe6s+svPDynkP+nFsPr3J0Zz
	 dEuDmAPQUBGug==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v2 2/3] mkfs: use cached report zone
Date: Fri, 19 Dec 2025 18:38:09 +0900
Message-ID: <20251219093810.540437-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219093810.540437-1-dlemoal@kernel.org>
References: <20251219093810.540437-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use BLKREPORTZONEV2 ioctl with the BLK_ZONE_REP_CACHED flag set to
speed up zone reports. If this fails, fallback to the legacy
BLKREPORTZONE ioctl() which is slower as it uses the device to get the
zone report.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[hch: split out BLKREPORTZONEV2 and BLK_ZONE_REP_CACHED definition into
another patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bc6a28b63c24..59c673532ad6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2623,8 +2623,13 @@ _("Failed to allocate memory for zone reporting.\n"));
 		memset(rep, 0, rep_size);
 		rep->sector = sector;
 		rep->nr_zones = ZONES_PER_IOCTL;
+		rep->flags = BLK_ZONE_REP_CACHED;
 
-		ret = ioctl(fd, BLKREPORTZONE, rep);
+		ret = ioctl(fd, BLKREPORTZONEV2, rep);
+		if (ret < 0 && errno == ENOTTY) {
+			rep->flags = 0;
+			ret = ioctl(fd, BLKREPORTZONE, rep);
+		}
 		if (ret) {
 			fprintf(stderr,
 _("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
-- 
2.52.0

