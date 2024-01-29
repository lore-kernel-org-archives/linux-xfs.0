Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88490152DFC
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538972; cv=none; b=m9BsFLS/CyYZFiM+xEYXInwM9Co3LFyoFr/18C2MK/RboZfuol94PbCyhnMfNu2FZNCuV3jNp9OLejksfFQEvqlFWK78BGHd8JCElTGtgR59lhq121dYfEW8hlgE5sR0i29syR7jjbusx+G2pJSnqj03TValn85dFbIp5PoTUC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538972; c=relaxed/simple;
	bh=fW3amsgJ72Pk0AZUtNdUzvZkBYDdmK4uYJv1DDYZyW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Eb9dnoZTbLTfZpNki9FFmFQXvkwV0VkJmVhr5ZXLxZRk8Gwe/NJOLhEYThF6VwuiLleo3My4yfsxQaEr72c4ogJh4zBUI5GIjuo1pUzPrnZRdQYbOXastyzppSS2T/oAnJRcI8HDmJ5oZluENUcXNu1CP5s/2UE72mDSGy80WmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H/w7piGv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H/w7piGv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YwCZytasSWWNAnywFhe0IpFtb/e1jDVoRPLD3Ievb94=; b=H/w7piGvmYseCZoWnQEN2+gOYS
	XZVy8VGbsjSpOcptgQ9Nw46YbyoaBxmNjyE84HM/zN50XLYgWgF/zrWsufaNowCMgFdk328RfMq3E
	1slTlgqkWFcoH2xJz3xsu9NzaVqiZHHFOb0yoywx+9lDmFt/lenGK8Xa4lf36tfDxc/xdrfsfC8KJ
	+H6byuh/5Dby/A+jD8Qa/sKrmP+yulLhguSZDh7HVAGxkt2g1/j6xyljvjGFx9pT9RKP8yAv0JrGz
	xZQg8E5bKKjEmg2d4RW3fidBKf3ab4LPmc6xsHF7JlXcTr+lj4auWsaXaBEqDuPRPLxhcEkERyHRC
	/gWJedDg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSk5-0000000D6TV-3DzW;
	Mon, 29 Jan 2024 14:36:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 18/20] xfs: fix a comment in xfarray.c
Date: Mon, 29 Jan 2024 15:35:00 +0100
Message-Id: <20240129143502.189370-19-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfiles are shmem files, not memfds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 82b2a35a8e8630..379e1db22269c7 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -16,7 +16,7 @@
  * Large Arrays of Fixed-Size Records
  * ==================================
  *
- * This memory array uses an xfile (which itself is a memfd "file") to store
+ * This memory array uses an xfile (which itself is a shmem file) to store
  * large numbers of fixed-size records in memory that can be paged out.  This
  * puts less stress on the memory reclaim algorithms during an online repair
  * because we don't have to pin so much memory.  However, array access is less
-- 
2.39.2

