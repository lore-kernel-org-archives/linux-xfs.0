Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C8921FF28
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206098; cv=none; b=bJaZ3AYPC5L18M+RsWLAbhsHICNLpwwzwHXtY1lrtK0eBHLM3kv+I4dEdK3QXc/A5NOT/0BCHhbF15wCHyHTw4rjOAA0IUNQJOhSEx2saJvBixbIOd6dI1HLiO5Gjs3bgsdKHDK8KoI9PfSgcJMu43tTDbf72rM3v5eop093Mh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206098; c=relaxed/simple;
	bh=op6mvmwdAXxyTSvmcToJVAbphIb2ycpMSMQx+g6q0Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw0nXnXkO07M4e62zzXOjOWgPc4nRqUpr3ud9jlPh++/JVrBMvpvKEgw5IUA7Fo8orZ0k+q46GXcdCW4QNpTJvaaYaAQv4iqkOLzzsvpC5WrEtCh2x0nC8DYi2ICFxF7paScWkZ78knWbb9QWVxkmw4MXHz0doL0dAN8pNKPbUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PYDh/6Lp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PYDh/6Lp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+jX7qbLYHMipzEPAcA0qmCSrcnZpYfl9fALE+uItK+U=; b=PYDh/6LpL2ivQB1bUXzTngy0pk
	SLLdn6sTrz8lIof0CNWz2WEUVXEABhfVf0MPd8NAoly9JvPz/CI4sAHuLgBsuu1jDJjz78fRVzNeZ
	+WOvZdTo1UNL6jNsr4Iaq1aytPHOIXX+/n+RJXkH97fPoDGr+LTwqZZ7tWW8/f9Ub+TpHFEzraFNR
	k2idc9M5GlMVG39xM0sUxNV7d+ylvcXH1fASRcPkozmGqAr3db8KVoSyXODOQbwXs+LC6sSCKySDo
	///95e0kW9fnTdbiAFqD6481cEgfsKm82x1Ox35S4ufMRz8JdhBKL+Acyj5aSsPJtLkr5g2gRXOQd
	KlL3X/HQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzFiq-00000000ADz-1A0D;
	Thu, 18 Sep 2025 14:34:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/5] xfs: remove xfs_errortag_get
Date: Thu, 18 Sep 2025 07:34:33 -0700
Message-ID: <20250918143454.447290-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250918143454.447290-1-hch@lst.de>
References: <20250918143454.447290-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_errortag_get is only called by xfs_errortag_attr_show, which does not
need to validate the error tag, because it can only be called on valid
error tags that had a sysfs attribute registered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 16 ++--------------
 fs/xfs/xfs_error.h |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dbd87e137694..45a43e47ce92 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -118,10 +118,9 @@ xfs_errortag_attr_show(
 	char			*buf)
 {
 	struct xfs_mount	*mp = to_mp(kobject);
-	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
+	unsigned int		error_tag = to_attr(attr)->tag;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n",
-			xfs_errortag_get(mp, xfs_attr->tag));
+	return snprintf(buf, PAGE_SIZE, "%u\n", mp->m_errortag[error_tag]);
 }
 
 static const struct sysfs_ops xfs_errortag_sysfs_ops = {
@@ -326,17 +325,6 @@ xfs_errortag_test(
 	return true;
 }
 
-int
-xfs_errortag_get(
-	struct xfs_mount	*mp,
-	unsigned int		error_tag)
-{
-	if (!xfs_errortag_valid(error_tag))
-		return -EINVAL;
-
-	return mp->m_errortag[error_tag];
-}
-
 int
 xfs_errortag_set(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 0b9c5ba8a598..3aeb03001acf 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -58,7 +58,6 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
 		mdelay((mp)->m_errortag[(tag)]); \
 	} while (0)
 
-extern int xfs_errortag_get(struct xfs_mount *mp, unsigned int error_tag);
 extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
 		unsigned int tag_value);
 extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
-- 
2.47.2

