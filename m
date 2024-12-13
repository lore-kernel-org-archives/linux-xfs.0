Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7813DDAA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071178; cv=none; b=PIFYjOdpoN3YhpTQiWu158E4ZR2cGFPdFs3dOPwezE0uHUYg11XVwEIfdt7SLjgO7B5HeL1yz6Yc6DQ4xiDapXVQF/fSYAHD2GGMM2r6g8mpqJ4QPD+Dz+xkLuinx++e4EPGBbT2S4Da9MfuaIM04tWEkWBdmFehTNna2qYOupg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071178; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ge0CFeX6qB6ZkEMb+bPbQyvyYysN3ZAn1C/6aNgksRgEbojuJqRrQJ1n/yXu/zst5Zkr30raqQzV18117fXL89n8f6F09hP6I+++s8z3sgNWuXrb0keWkZBGwYLXcFUgCbJ2P8vKoGcTENnBkPyOoUtwo1uH/rSlcPT6uGuHxfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xfhW2DbL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xfhW2DbL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xfhW2DbLNp4R2Rei4hiHhdHymw
	/Lrq8YYBDfEARQxteFcW2UVqdwsjP9Jdy56dsbZM/RRw/qqTFKfNe/6WqdEDnKu+4pzsds4dlgsCU
	7wCGL/EmCZ+Hvf6U4h9cGxX9RXJiSiTS/9Frg3BsU9wNuQSl0WXkZV67U3x//bS24EPq0oLGy9d/d
	ek92trC/LgREDdyk+bD3olOEXp9emKh1mdg4ZvG0gP/SFEUW0r8Fou9+V330t0i1hDvDGCRZ4GHJa
	yjyNi0OMFFqI7+yUejMq1KN9LvfPE+u2rINV+ysc+RK023SLSOwcjcZ63MO59ARCLWUCptJlTdE9F
	EwXsSyfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz7w-00000002rlS-3Epb;
	Fri, 13 Dec 2024 06:26:16 +0000
Date: Thu, 12 Dec 2024 22:26:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/37] xfs: add a realtime flag to the rmap update log
 redo items
Message-ID: <Z1vTiOr6M7YMcNpX@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123451.1181370.1057797621602382553.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123451.1181370.1057797621602382553.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

