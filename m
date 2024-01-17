Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C593922615
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705512803; cv=none; b=YzeA12+jHldEYZUc+YonwfAIp1a4usWj7mHz8LxuXcJxJLQWm9+ZokbsTGQYmJvoufDpfqAb5LlIcnb7beUXhGhjHlZ4vnqwt29FJqpJwdmyM2NJpDkvGdy/DK9FY2QccqZSF+krRXFYhtneQG3YMcWEuv66v8HPt/K1aPFNSo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705512803; c=relaxed/simple;
	bh=hXSG1g77xswyvkRXP4WeXANvK6IpRS+07hb4ILJ8m2Y=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite; b=EPx0bAh17AayBbhod+e1jtxAfzpjz1ECPcr9qM9blEnQmoZsbFUTOrEZ6B2/9lqdJXEtoME+7UWrt5jME6cx1hENoEQ7yY951q0CFbDuYE5mp+ZuaFFqmGRpY5+THs8dEPTHIGp4jznXT4hFKP9Z6tWm95p2AKnDuoekLYhZfOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pL6P/TJF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pL6P/TJF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8BKJvjh+tH+qJxKUhvvGRYcQDwsQ8vM7KRAg+bCqljI=; b=pL6P/TJFqibFtw4kiCgAUPajsO
	RbNX1dIWJJpUIaJFr+/gmDAuP9HC4fy9/l7AWqUwRpnt4YOIyl8L+LI2Vz9htAzH0EM+JGrvyKEiX
	fXiOuom+ZnQcukQK1OflQ8alAChSQ4iaNM3Q8dLHynQBVJgR2xeBxEIKKUH4dWwQ6qO0Fbuye8f8Z
	Z/CWComCvaDssdMXv3mZH30y8lgXH2LAN/qmuZ9w8qHjGCePkKcgcNELczTI1uPy9EqdEGOUroRnu
	oTeWtP8dCmy8wan6/8xdc7ASAwSPO/vUlx22B88UDB7WBo8XS+75R6R/2Z54dKnFbClgyzq0zwONy
	maxarMxQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rQ9mw-000EPw-2s;
	Wed, 17 Jan 2024 17:33:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] libxfs: remove the unused fs_topology_t typedef
Date: Wed, 17 Jan 2024 18:33:08 +0100
Message-Id: <20240117173312.868103-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240117173312.868103-1-hch@lst.de>
References: <20240117173312.868103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

