Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038A518628
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uh/+t2WV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JhCgkrtHibPlII0BBIGAXVuHhyHzEnEyi2A+L2TpO4Q=; b=Uh/+t2WVVTHbFcu65yNj5HGXPK
	zr8p8kjN9KsH0QOA8lxX9z5fe+eeSKdYu7nQs3+OXY1A84yOx0Da7bKN0XNxHdLodl0526xyQ2EO+
	rXJXZws2yBC2UGMDliAgkm1/CidU/9FYNm/TyF8zq+U74MB2lSSl8FLqZRT6aPkvn8/miiRalE9R+
	eIZzGNoPa08YzIS5boiamaolADs2FaUaAXCf5txRfEGkBML26JrKk60OnIPuIAvpQn1Vf5P5E3546
	UwDis5w7hc1hc3V+dNzVZh1fGq3zEZATbYEkryOpz1s6Ezt0mIoDvmJD/Of76BP87WeQjw3RAsF4h
	BAA367CQ==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpD-00A6iS-2k;
	Wed, 03 Jan 2024 08:42:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/15] xfs: shmem_file_setup can't return NULL
Date: Wed,  3 Jan 2024 08:41:18 +0000
Message-Id: <20240103084126.513354-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103084126.513354-1-hch@lst.de>
References: <20240103084126.513354-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_file_setup always returns a struct file pointer or an ERR_PTR,
so remove the code to check for a NULL return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 46f4a06029cd4b..ec1be08937977a 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -62,15 +62,13 @@ xfile_create(
 {
 	struct inode		*inode;
 	struct xfile		*xf;
-	int			error = -ENOMEM;
+	int			error;
 
 	xf = kmalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
 	if (!xf)
 		return -ENOMEM;
 
 	xf->file = shmem_file_setup(description, isize, 0);
-	if (!xf->file)
-		goto out_xfile;
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
-- 
2.39.2

