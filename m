Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326B59B66
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366067; cv=none; b=fOJO7VuJ9sRZrSlIAXIsl/yww9WlfD7ux4SKTi7u1bVLMvnwLaKwnMgvcjhEQ8iyok09Z5Fua43WOMZ+3B3yuyGe80KcVK7GKswRM1Prlq3xLGI7yZgVjuBK4isxE0zZmkkXV9iDlPxk3TfWm6JPj86boxhCwyrrQb01BIVkqig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366067; c=relaxed/simple;
	bh=tJ9p5WewJpZfyF4FWD953h5IIS7OUPrnuOWyctTMPvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G3enSMRas6n9FN+hexxN2QJEB++9P8BFyqhENu0nBGkOVtQiDbThTO9KqSNOEjFj5xTQLDnlHdF+UXU5s7NBHWl/K1mkLB+3j62Z/LRraBsLQrcmUmRz3Jxq16rMhskZD00h/lRv+VLeloTHkhuWa9QP98tF6OQLLLvA0xcQ2B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UWfjWh8m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UWfjWh8m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f3rFV9w3NnEWJ/ARPC3BBPefyCcjjBsG8HPiAaM19xo=; b=UWfjWh8mbpYFkwTLJH78PGg4Cs
	pr20hUUDiI+4S1ufQIlckrvizQ+h4ehrvmS8EaewLdj+GYLSn7/Kk298sPIPqhfmBMDGPfn31yFJH
	9sZdMREiVRVBHI6YGPFDiuD1IonwXSpyA68SuwVoVp43qmquJRm60z17xUNq8i11G/G0zIpsVtOUY
	2qrM7D3zuaUHjHvt8DZjjBTFpK9Rk2RVTROvY0wHWLV+pGUgg2RoWpxgUIPmwDVa+8GDUzCg8z/Yt
	QhSbg6KetKG44nX1sWi5RT+jteXJcNW5OYu2Kz3uHW1DG5txM68DvFLLjjkhDUuyUlDz+GQOxYoUl
	cJpBSGVA==;
Received: from [206.0.71.29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWLR-0000000Bxr2-0LIf;
	Wed, 13 Mar 2024 21:41:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 4/5] libxfs: also query log device topology in get_topology
Date: Wed, 13 Mar 2024 14:40:50 -0700
Message-Id: <20240313214051.1718117-5-hch@lst.de>
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

Also query the log device topology in get_topology, which we'll need
in mkfs in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c | 1 +
 libxfs/topology.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 706eed022..94adb5be7 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -292,4 +292,5 @@ get_topology(
 {
 	get_device_topology(&xi->data, &ft->data, force_overwrite);
 	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
+	get_device_topology(&xi->log, &ft->log, force_overwrite);
 }
diff --git a/libxfs/topology.h b/libxfs/topology.h
index ba0c8f669..fa0a23b77 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -20,6 +20,7 @@ struct device_topology {
 struct fs_topology {
 	struct device_topology	data;
 	struct device_topology	rt;
+	struct device_topology	log;
 };
 
 void
-- 
2.39.2

