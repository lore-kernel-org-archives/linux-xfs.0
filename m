Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8D53955CD;
	Mon, 12 Oct 2026 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810571; cv=none; b=qfwud1Mmqdoi/OBoZ7+eXtyz9Pth6kgwnzUqBG5WEZtqwm8HnW3jShYpS2zOUhzOPpCGVEve48MX7D/+GpNp6F7H1DeSKi1szQVfl0ETEyDFVomshHs5n9g11CmogQfk+9Oy9B8f22lI51ATXPrz0s8J/1T7EF/y6ee9zKbZwuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810571; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3MtmRLjF09/v/SYHU/K36ZKLkC/jXhslMCsAydTQ+0UIZuPIIZZPBB4bPr04M3XqHRwHwNutOkovhqo1aaY0c0GBs7TMAPe88nVPVvQK1RZ3Khtz1rXWub8TMwjbXJ8qstr1E6sftzyJOfTmokStPo3mCfOGZ3vUVi2DBzcJBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GtyvPFxA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GtyvPFxA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GtyvPFxAb8BUprUemlm/dg5dic
	vjUvAruzdJEv/zPCuBb8P2xaOk76F3A0SymtNN8Vv1yEQpXTLtncl80qUyleR689VO/iyFXfl+uJN
	+10yxr4PxtXA4NTW3ih4Djt3BZdcbjMTdFGX10XPQ0RGw1hohhjoRw8d9fdnCJ0dIh8XRIoAfIJFZ
	bq+jWCZElydwu7johBQWk+XOde4Ke6BQVg9Owb3KcvlbYV5qS4QVBESu1rCEHlwoZzx53+cprcitj
	X0TVUH7KpTDQLvwg2t22KhzvU7U22yzign5oznc3pSbQ+SCPeedEVpK4FzTnG/a0Qw3xbjV7tm05b
	d9J41FVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFmU-0000000AXCB-1Hft;
	Mon, 12 Oct 2026 13:09:30 +0000
Date: Mon, 12 Oct 2026 06:09:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: check for fragments when full-extent sharing
 matches
Message-ID: <aszcCnLi2XWJEk8T@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065345.1058326.15234236043122923742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065345.1058326.15234236043122923742.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

