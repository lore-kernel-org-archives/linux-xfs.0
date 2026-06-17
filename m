Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D9046B5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675899; cv=none; b=tZ2YpafNFOYMEsh0+VucjHQ2jMcumxrqb20vAu9R9BYwYlZLwQOKv9BCK9AOlli9Cq2USj9KRyxI/K+L9C+Kve/grGUF3xD77tLWGOXpqhdWMFjqS1EC5mNeSzAf1YBs4l1ZeB8I+8UPsMOHdaGV7ZxdMrghA74aVM3Ove4mGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675899; c=relaxed/simple;
	bh=TwLAS7792ADmu6ETtAVcvp/khgpXenPYxzwSPjRLwGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pck+rTX0bmn9cR3W9ztcpBf2cFYUT6Msy8b0XItIex5MDdcUnUo106g9sFQfSAUBDXNcSVbUQzEuq60xmQHsj8f43OqvCrBIFbBVukWQOUSuR1pImLeF8FHghv6wsZ8Qzz0ROJGkDZEw+cjG8GIZUUg1vfbpevxHsSkvhiHAx64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ef9rMdrc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ef9rMdrc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wYxlmkTMkJENHA4Y6uyD25bHxCWwF2Jb2HcAhJnch1E=; b=ef9rMdrcwryaI/fovGWH+AVQZH
	58zqYeGZsxEjOXHIdf2wGFx9EKHc0VnUONWf6mlTNnYYRxk7n/g4ReUV5G0GX1W0WMUuuFEUrS2V1
	RQTDTSeY4w9t1vdawcuMNr1Lv9jt4DxMCu7yqAsw7cBwimr/AnuRWLYNohyZ0AHwp22ZyN8/d8vm6
	LEjSFXFAE51PL0dtz7GzuO2QmJAcu5h/FUPfKk1eul+jFlOryYiBN/11eVqMPTN1SmqTd+oZV7Ouc
	DtRxpNcPYK9FMT425aSSQSJONVlRQj4pVcY0vtk/3AZSlHh9AcM8a2GEz7I1CqZza0PBEMx53WtIP
	rqEun/BA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZjI1-0000000GgA5-14a0;
	Wed, 17 Jun 2026 05:58:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix GFP_ flag use in the buffer cache
Date: Wed, 17 Jun 2026 07:58:01 +0200
Message-ID: <20260617055814.3842058-1-hch@lst.de>
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

usage of the GFP_ flags in the buffer cache, including mixing
__GFP_NOFAIL and __GFP_NORETRY which is nonsensical, and passing
__GFP_NORETRY to the dedicated fallback.

Diffstat:
 xfs_buf.c |  105 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 60 insertions(+), 45 deletions(-)
