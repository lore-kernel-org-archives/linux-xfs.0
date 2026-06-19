Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AB2301474;
	Fri, 19 Jun 2026 05:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845277; cv=none; b=RpyN/aqVCAkOXs+RHXw5mO1imBSGKSG8vQWWWy/JRJ2A0hWp9+uL7ekxqQ8OnxE4ghZCny3gvB9u+83EQZv3edoZ3MJ4AqYgicPzsYSWbynu49IRENHU6z9mMr9+HlKwH0TUK4Mhhe5uuUfdAYOt2fEFAbImX0IyWbpzqcCTcOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845277; c=relaxed/simple;
	bh=EqObGat2cNnwACUojFU010e5hYh91aj49AOBv0BG5nY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MZGNhSA/BPJmrJUOFQbvvuU2fzINQTco0E8Qi0+oKWoq6+kgKLHMxDRMx9VW6whMdOoMTa/VI+w+M84Wgr4ohxBOZyzfwM9WEsoWCTjybQagGPLgdGUne/pe/bJdVmTyljra0QnVDJOrrqN3OH4AGHX1CRWg6s97OaEBhV1BztQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KBxf7AR7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KBxf7AR7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=3RTdskEA4tzXBpUPTIzVtRb3u/Fp36An/J4SqIF2JFo=; b=KBxf7AR7O9I/8vH/No1JC1CG+F
	XnkEev87+xTe+fGLXth4ggbMJV/yvapF7rSHBRYXnd2BOQhAVnOheex6E7SxmQ20oFhmX3245LsFe
	deE2nuD06R4QMKWmEa+YfojzSKpZa9xagOyxoP8i7+JU4n4vzkzjhp50eAJvk3mDBrb7a00cTrlXG
	6VG4JaecJnqKsruepYFvmnwTd5M8Qy0RSp510WWRLVpCoStZ+tvlUVKSQyn8od96vNr+pXMJl/S38
	Ld0qO8GCucUPZMQJtG8KAwvKOCVIE+FpOBO6lyGilTGefQ+d+NmBIb/GMgOzjiumnJEbQaetjTfJd
	01DiwEOQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRLr-00000001zi3-0VdP;
	Fri, 19 Jun 2026 05:01:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: don't build bios/contexts over multiple iomaps
Date: Fri, 19 Jun 2026 07:00:52 +0200
Message-ID: <20260619050105.439956-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this patch changes how iomap submits bios for reads.  The old behavior
to build up bios across iomap was already considered problematic for
a while, but we now ran into a erofs bug because of it, so it's time
to finally fix it.
