Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89336351C27;
	Fri, 21 Aug 2026 05:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289272; cv=none; b=AEnMPIqjK3wHgI3FfvDfuuVdan6hA67H1AWXELgkQh2G+DIqMu+Hz+eQUDYRZdi4KZ5kV5fPlabF0BHsJXezgKVv9DwMDgLIpV2Cz4kz6wuQqMZ/aK0y5mCwtZ2cwT4KT93g5s42whGRLIX3vtdNaOddpPWYCsAw5E2kUQx5YRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289272; c=relaxed/simple;
	bh=ninkcO8O7Hi7Th8B1KP63joGewra+RIUW2o5Jm5ONSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hSmZSYo2Z5LWbUutxeLj4yostT2TeqTMOHsE15lqfH82AOBhuPI2mgX/SMijEN7FrNESWztd+pVqXYmxKGLAuQRdqKufGxYqjceXMT4GxTnGXdVwWkPk5VvYoxolXyHGj03qNQ4SzmTZmYSYcfT2Thmj1UwZ6kK+Y+C86qD12G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Riz9TghR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Riz9TghR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Rq225du4J38XSWz/fYaGV9PsqPS7hZoYrdeeVvKDlSM=; b=Riz9TghRrNMnJMbOhOL/Asj50U
	N451xZyWadBweh6Coq2x5P1Kur5ElOfDM8YTui+vit8JoXWhedmvZS8jFL8/bA+t8oaVlXEvW6xds
	HP5ByPhZKmSVIkByaYLu++zu99Jwj+No9wZxVclZpfFtX53CDgxFTtYQe+xj1JTf468Zs+KKoHqEI
	9t18ckL1XQGa20nvde/SKicWc12ozXhEFbDHpMXId1XEDD7w5UDdRSbDGt1HpMgQoOX754jcQWctk
	vzYnN/h7CBaSf6YSICq+nVRZWRfY4Dpto6yc4F0mjTTchJdNfYfSdu01xPhNlY4J6C6faMH3u7G+c
	uDPYc+JA==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHaF-0000000CYNM-35Ab;
	Fri, 21 Aug 2026 05:14:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/073: destroy loop device when mount fails
Date: Fri, 21 Aug 2026 07:14:24 +0200
Message-ID: <20260821051424.1818198-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Otherwise the failure will leave a dangling loop device around and
prevent unmounting of $TEST_DIR and thus various cascading later
failures.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/073 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/073 b/tests/xfs/073
index 2274079ef43b..057d1447639a 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -74,6 +74,7 @@ _verify_copy()
 		_mount -o nouuid $loop_dev1 $target_dir
 		if [ $? -ne 0 ]; then
 			echo mount failed - evil!
+			_destroy_loop_device $loop_dev1
 			return
 		fi
 	fi
-- 
2.53.0

