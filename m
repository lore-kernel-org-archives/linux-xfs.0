Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A252877D9
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670458; cv=none; b=dYWxnzKx1hGYE7XkiBwLkgW7ZZ2unBo9gw7t4VzM58XvONTFxEvq8002UuR2QTEzVzsw/iTjUxuVGrEO9tdgHyy9Xcn8IP00xnS1GUeTh2UAL4sZBinS6bGqbX+G8/1ndygB1CvyT7WLLYhmEIeM+lq4J21iaUliBpDLCQtpuuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670458; c=relaxed/simple;
	bh=VDO+BeqpFITAPypbuXZn3CQWEUV7l06oXioTdTN52E0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ufHvcKgBXkoRoWGV4CSrO+ClsKUoKWoNVytW83aDFYlHxLSAH0Fm1HR9F8eaCFGArE8KHeP3lYRZJ/UnFWV0pfYWKU58pMoX2uepYATlUoyZ0rtxcMvN6OvjrwMkCSnCWvp7tbxh8jGX32dyFi4pZmwToSD+HvCgW/UF4mz+MAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sHNYAUfd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sHNYAUfd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MiyBVlx+/A7msXlC3LVeHtBWhsugLmdwlGRxKRzOq9Y=; b=sHNYAUfdicYaMh3d0LobV0eWQA
	322LGd75i4pCNgU+xBFu1RfmOUeITVsqDt1Uzl81y7QJ3m7uX9MPujqPYPqfyo4giPGERRMRkF6wG
	tM9ZuVNSy7wq8diIXJr7opX7PlsK1kjXfwZbah6UOXhkUHH8GVhMPdL0rbl3r/67PXidWP2dZUDBM
	/UrQR25aYq2KJnn14ia4i76T9MnWjHZ/YRGD133PpXtvm1KVtk0G52ZzIz9Ky7/57MPufpHFfZhtd
	j9TBxa2sNoqgvPgjH+cnbgZ64ljtD3wY7C+ifzcZRJ8BpvY3ixMB7Z6pF1L60ZnuipiezwU3JfHU6
	AW/07/DQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1eK-00000007iMQ-1Bo0;
	Wed, 16 Jul 2025 12:54:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: misc zoned allocators fixes and cleanups
Date: Wed, 16 Jul 2025 14:54:00 +0200
Message-ID: <20250716125413.2148420-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a few improvements to the zoned code.  The first
is a memory leak fix that might still be useful for 6.16 if possible.
