Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC312DDA9;
	Fri, 21 Jun 2024 04:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944594; cv=none; b=OiJT+VUUUdP3l21WKa4W/wv/knPnG37fhKZUGhWGxYL+VyJtBfMzLlW6k9/sc7zZ/FvtVSvzyzrUxGKbwWr/zVJPLuMoczG0YB2Na3E7S7JagausSVCGPEorxY1xzZ2bZ+Vh36vQ1Ybn32FXv15jw0B34fnOuJFSOjEvQTLPbfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944594; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9T7+Jl5NRoqMCuM6L9yyu6xfVRwCa+ad0hGW0DgE5ZsCe6VRUKFaL05Adqdsh7EmmrUNhf1J3fZ1Gw1KfW+nnN3DoKL6y8mjvQ50Pc8u9bJkZvTfGNXymbfTXKL7MlraQ0OtHJT7MVVGEo+opkyU9hL++UzAeZl8ItpgQZxBkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gj0c9jnV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gj0c9jnV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gj0c9jnVvS4bRz+jhEWeOO7fOE
	PF28nQD3qyoTrSVkn6t8HdSz+zxDGiHdbCXu92Rs6Ib0EX1fAyyqwdNvFt5GW27IKc0Kydl0OGRB/
	Zg5GELEaUMv0lF+8cGfzF6p2NwUcLsatPasbgU8hm/FvoNUSpRVISwRkBOG1L09Xx/TNaVUpHccdr
	YRCw09oQxuQJb+f4PNoGn9lfvzYT7pwD4Tz8B4LdzwRJQkO4Erd7e6IDDfTQJ9iqhKN4XHZFs0TQb
	ZKSdMUUsHS0aFVm0Md8xYMF1WH0l7iW/YWNY9QUMguXSJZjb04V+k2oa8Bue69zhWOAGNSLuOGJRZ
	aX09NPUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW0m-00000007exH-2B37;
	Fri, 21 Jun 2024 04:36:32 +0000
Date: Thu, 20 Jun 2024 21:36:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, Allison Henderson <allison.henderson@oracle.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] common: add helpers for parent pointer tests
Message-ID: <ZnUDUHoxAs9WwdOh@infradead.org>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
 <171891669761.3035255.13957512603260230023.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171891669761.3035255.13957512603260230023.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
