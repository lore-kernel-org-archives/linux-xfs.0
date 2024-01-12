Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC0E5B5B0
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 04:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZAZqrEi8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MZ37jBvjgEw2DJ8YTqfMx863wzG2JFDe82V4a3rn/aU=; b=ZAZqrEi8GuVOyRSV7Nly6o91Vd
	Zwnj041DKiR40mrUNtoWyWr/Exq5DLBN6YmTWdwx9eVDP65FGyiPE4RtxGaEA1iYoKv4I2oAwckIk
	/gd66v0vV1LBQigCWuTzLgZIyXbREPxQfvLjd3NPVgDRRk0SlPEQW6TduDSHQqlxgXwJubWivRQt8
	bAzEDDEsh+Hu9rwLxkj5by897gP1gdJaAg3mxnxzCYqULypHzfWa1fSMgmLWtAScwMzP4OCBTDx/X
	17+jOw7vTb/DUEHgBhGZbvEmutgYGedgRiHVgg4HqhtpoigUHswcHNOS6A0+J8NtWjNLAJZyFit1U
	ZnwEd40g==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9SP-001sX0-15;
	Fri, 12 Jan 2024 04:47:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] libxfs: remove the unused fs_topology_t typedef
Date: Fri, 12 Jan 2024 05:47:40 +0100
Message-Id: <20240112044743.2254211-2-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

