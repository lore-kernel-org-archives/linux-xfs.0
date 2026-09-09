Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967FC322C88
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934002; cv=none; b=jI4z5SooyP4hLkPms78eM2ooIRaFVvJ3O1a5yEkxdx7rDMmB09M/ALylVkiS4jd5A8GsrkcT74FlFQ0GWoYv7WntZroiA8bR/rW95CjifHD41/xjVoPBb6fSHlxYKoNP/iy+zVOIuO2s+tg88ceTFpWTGXdmG/hpwBbKz6tKbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934002; c=relaxed/simple;
	bh=PTroghb4pD7OG/Efo2UX7L/uFpLihhAjVDBGLbwKbrk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l5VAwnfG2xstAcQtbnB/QygvOft92DRfsk7cJH/EfL2sMPF1qPK+j4GTwaZ20XwQOc1yb/G3cigxx71aEZoiHGjzD1pngkrmQlJhwEiIaAkGkZzbSOci878KSduAUKysexmHSYIbc+nkGQxFhOtYnDQTNVbXkxEryVg8si7goLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3mnHDuNQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3mnHDuNQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PTroghb4pD7OG/Efo2UX7L/uFpLihhAjVDBGLbwKbrk=; b=3mnHDuNQ3AD0VctDF2hNMBHXAi
	T3cdAsDqKEYA0Mb/Wy6bTaPC7XSoX9NhGU2qJQxNzR7Gj+EBOWk970edkfoDcFcWZ/vDqeqS7gydE
	iJMkp5VJ6QFPIPS5PTJ4j27RCnzF1OpuE5HQzvWb0SIut4d5CahpqfdjGcJoNVvRdiKVY0MXN8vU3
	L1xs9J16cRC0rArU4K8bccg484zJHaD59mxS8CekhzisXVcH/N1pEQj8OcTyz1KNSQ4YfoTNBCz/b
	iyVAujVTYeUr+DL4i4ZIU2D8qdE5ZxaUgsut88iD9hCiPxD7NwFBN8NUYttMMx7wooUDIiCoJXL3f
	4C4Ax1dQ==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BS3-0000000AqJG-3YPX;
	Wed, 09 Sep 2026 06:06:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: convert all !XFS_RT stubs to inline functions
Date: Wed,  9 Sep 2026 09:05:25 +0300
Message-ID: <20260909060619.1101875-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

this is a fix for the ioctl cleanup series, which currently can cause a
warning for !XFS_RT builds with some compiler versions.

If you end up rebasing the 7.4 tree, it might make sense to thread it in
before that series.

