Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4001118C;
	Tue, 30 Apr 2024 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714449872; cv=none; b=MDJolYAovKnszE3atfMxIWqsSkV5vlSYRjnBJynXi3FAyfXDFfdrGaIaFjs67PKpBmtkvLH5FKovMZ2+0QtXG+ERm93v/o4jkzOD2JkLJ9hsbD6hAHdRTjvazdmvEvrrQoAYgzTvmFR7H2jQAeW3ZoDUnZWZJibLbQpOEd5Fgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714449872; c=relaxed/simple;
	bh=nF6LQcrEmVGEhjc7MSkv8pL8EDjX5ynjUzNpVXOw9KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqKANH1zL6Q30acwGcvRlHk5vA5DqaqpTExVpyl3EE6eNMPN5vpXhSWdeEQm9/z6fWH6UQ110dTlPCCwzQqD9p7PB4BQpQT2XpuhcjRuMXUFfou6JNuwiXpxNug94dgoZ2g4gh6rZV5uC5hEDqelu2ioXWhTj2Ujvvg6iNVW6KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rARIx8mW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rARIx8mW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AT3Srp7XSfHRfrClALLw8+4l6uQZcpl81nsKG7tBsKY=; b=rARIx8mW0TTPUIxulWlhOsrx8X
	8EM0pNbipPZUVdQqUd93j9F34bjARaViFOF8+RhXV62Pc4aprUTfsFd1x/WK93g/NFCf3tfqtdMg5
	yXWsftAxhHGbo0ftteAV6aEliGL+GuWGRZQJ4Sc4Hl6cFlnM5Ey012sBzldlS0P8kng5RXX8mGAFB
	UeXC2mKLG8h84Jk8sh1v4zkhRvzuSY3NW+xzSrxvKgdZI+B6dyXF74Bg3Y/IIuN4vbyXiPfw4cq8+
	KG0sqsYjdzp9p+C/KZqgjTYvv7QYozmZPc4WN61ss0vw1wBV74mLNolrQmJFBLXAkOTjcSYimylQu
	H4tRmCpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1ejG-00000004zbu-09CL;
	Tue, 30 Apr 2024 04:04:30 +0000
Date: Mon, 29 Apr 2024 21:04:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH 2/2] xfs: Remove duplicate xfs_da_btree.h header
Message-ID: <ZjBtzma2bnwNF5ec@infradead.org>
References: <20240430034728.86811-1-jiapeng.chong@linux.alibaba.com>
 <20240430034728.86811-2-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430034728.86811-2-jiapeng.chong@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same bugzilla comment as for the previous one.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
