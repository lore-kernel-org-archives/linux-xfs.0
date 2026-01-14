Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE7F376BE4
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373637; cv=none; b=OYldLEYlHdIJvxkavOK54MYmUtQWuACKYjTt07g1aANmHBYdBjKQ0aang5b0QeoNQ7fsf+gvP3XtYMl4nQovQggZX21glnngeIRiZRV+O16ghkg1Rtmd7c+UtnpOzHSCEwDuZimar4WHZ//lOP717KoNlv+U16uIjI2Xd8TPOpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373637; c=relaxed/simple;
	bh=Dgq4kfHmHdoNwk6SH+EhX4LYLeVjoY8Mo8rVJviZ6Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feZ0wZayjBSh/3f9dBC6UJqY9CtBqF8YkKqDkY930JZIAfxvjzdGdG/its7nMZ8lQ9BA+KKBudxLTDmqOZ0OH5GTrzfNYB6F9mT2Fiku5GR1iEFlaRXQQsqzZxgcGtp4RlKGABzJKDD0Qsx+uk66BVIoKKDnPEUdU73YezUHjf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o4rWSuCV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o4rWSuCV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GRjfvZcx9oH+aFMgLw81BPynfuIwOrj0k1UxPVYcbiE=; b=o4rWSuCVY9nB+YQG2mmdc0/2xD
	MmbrdgMXajnMN7Vm81GeFzMPhMc2s6X7+tbTeiEKfDWf8Px7GFlPZMUPxkDiTBBEV9wRjoqNpbUYA
	gpVIS7hqU7r4yOGyojijCWJk6wEVRrc0gl6mBregOoTTT+iERru7s0/9hDQxBEgIl/DBewnb6DC5+
	RhFpZ6qLmM5rn90nAjEjJY5JxLPwlho3G8OSEqFRRRjCv1vD6Iyx8AXJmlDULxef8Hts2igZCX934
	H9+M0bq9Vt/78ZkFK6qPYmKto2Nyuv3sxWtI0CwkD29BURpAKxA9+4MFtoS6LorG9bOFqZ7SvIfNv
	K2wOjKog==;
Received: from 85-127-106-146.dsl.dynamic.surfer.at ([85.127.106.146] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfulH-000000089h7-1gtC;
	Wed, 14 Jan 2026 06:53:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: add missing forward declaration in xfs_zones.h
Date: Wed, 14 Jan 2026 07:53:24 +0100
Message-ID: <20260114065339.3392929-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114065339.3392929-1-hch@lst.de>
References: <20260114065339.3392929-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

Add the missing forward declaration for struct blk_zone in xfs_zones.h.
This avoids headaches with the order of header file inclusion to avoid
compilation errors.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_zones.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
index 5fefd132e002..df10a34da71d 100644
--- a/fs/xfs/libxfs/xfs_zones.h
+++ b/fs/xfs/libxfs/xfs_zones.h
@@ -3,6 +3,7 @@
 #define _LIBXFS_ZONES_H
 
 struct xfs_rtgroup;
+struct blk_zone;
 
 /*
  * In order to guarantee forward progress for GC we need to reserve at least
-- 
2.47.3

