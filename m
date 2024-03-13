Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D645675F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366059; cv=none; b=Mf1CE0c32bV62XfNVF2HEn0sjeNIc/GdlNwRUdBT0+vhRQgnMwHjTcGkBoNA3CxQvk7xkhWUNYhzo3ERiBzMySoiLV+QOup4CX2EoZqRJsYMIBz1XZT7t1kEhvkqlXATnO7vO3Ppx+/hiiouQ+5ijwnBUUfERocd9sXrmbJuHMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366059; c=relaxed/simple;
	bh=ZxMFeIpIryyBPrRO7vPoVqHrBNsV1JladmFeDVLmzWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TNprHg66522vFG/HI6qwzm2rsu/oVHNFEE3O+TFMijXoeHzr7IucbvCT1VDL71Tlpoav7rfd45h1HUuuHCdwFIOOtggf5df6XMYSWy7KdQwX5tKFiUkjmWpCQhTBuOR3T7fkBtbS+5E36oO0JQmgrp3SwyI5CZrGw1T9LCb4NZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H/qW4Bzq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H/qW4Bzq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0IceC0HV8LnB6h7ZjhokKKeC0C/JKWOGckGMytwZIKE=; b=H/qW4Bzq8bSD0KtHqCqxsLdvxX
	K/0H/pzS3yZz8G7kBCNz1myyeEAGKmecXKfzAz1TDzQ7i4WxZiTuQdazI8wu59ZP39kXFRrgrWWzo
	c7gDtmdg+jmL0WRSBDekZ977fX3xsahw4RxibxoVnoILJS6HkMJNa9Sq+RCu0eHx/+hRPc3rmar9F
	3/FfP4tfSLiLYuY6t2BK1CZ8Ac8o7tR3e2BjNyoVqiKanTBwvE6E023CrR5IbYqg0BN7XQ7Pq3cSD
	l1CO0Nyyp29nZYQUTCVT1SW9fFLI/kE7WwCznXPO0hoAghiDnx1aUuS7plNRq/d96ekFhFEpsu4P4
	gCiD3mnw==;
Received: from [206.0.71.29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWLJ-0000000Bxox-0NQk;
	Wed, 13 Mar 2024 21:40:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 1/5] libxfs: remove the unused fs_topology_t typedef
Date: Wed, 13 Mar 2024 14:40:47 -0700
Message-Id: <20240313214051.1718117-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240313214051.1718117-1-hch@lst.de>
References: <20240313214051.1718117-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/topology.h b/libxfs/topology.h
index 1af5b0549..3a309a4da 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -10,13 +10,13 @@
 /*
  * Device topology information.
  */
-typedef struct fs_topology {
+struct fs_topology {
 	int	dsunit;		/* stripe unit - data subvolume */
 	int	dswidth;	/* stripe width - data subvolume */
 	int	rtswidth;	/* stripe width - rt subvolume */
 	int	lsectorsize;	/* logical sector size &*/
 	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
+};
 
 void
 get_topology(
-- 
2.39.2

