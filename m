Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983B21DDFC
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 04:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nLBej05t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D/j5BrvVIXmRGY4IxfjQCY38RW32vd14gX57zXKqRlc=; b=nLBej05tjO8F8kM7Or3rIiHooU
	+Dz0shO20vD3MZ6ZJ8nU1EmwUVFjLzmBSXP0Zb8I719/vS5LmqaNxyh81haGODooF28ux25xYRe3h
	7cgkvVnnnxJwbbX6Y+V+meT8uaQRC4EYo9KY8XgPvK9fJimGrbmkciLf97a/DoC99HIpp2VEWa1ZD
	sHIbonCG5fLXnlE07Y2cSBo2zByF69aB0x8yMlQ7zB3ZXIuM9hYesLoMZO5VXkwBIRwBHbauonZmj
	sa9Ly0CkZXPS+1TfLyVupHwdq6YFKzAUsNFmYvShH9LeazzyJL1PKxBF6SA0sPGQCREXu6i5orm3M
	G8jpVYMg==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9SV-001sXV-1r;
	Fri, 12 Jan 2024 04:47:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] libxfs: also query log device topology in get_topology
Date: Fri, 12 Jan 2024 05:47:42 +0100
Message-Id: <20240112044743.2254211-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240112044743.2254211-1-hch@lst.de>
References: <20240112044743.2254211-1-hch@lst.de>
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
---
 libxfs/topology.c | 1 +
 libxfs/topology.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 227f8c44f..991f82706 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -346,4 +346,5 @@ get_topology(
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

