Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D6A1CD07;
	Mon, 18 Mar 2024 01:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710725673; cv=none; b=F0/Ibq85YDfV9XOmDIQgdok4CvGipk8tQTgB5upLx1CY0ZGHZn8jnn7cDTZZjGPQcUhhXeLNRU8p0YlhsEGfnzd4yj9Y0IxsnfTZriK00pLumSaHnJND2n5EdVOpNiwnsKj/uda/utm0C9jm4Q41fMLZlHKNYVuCR40fQybKgJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710725673; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p83U/wSUNdrbzoC60cydti1n6qqdPcM2cRmIrBYz8TrFlwuZTq+FoV2ldqMfNl7yXuFuSRtZVWSagESnYGTyhLPFuvvM34ijp+VAQAHju+eA0+Qf24WCjT3ak46qJJoJeNOsBPgD788ZaQtELwRlAVyjrBwe4lbL/dnOYo9LIJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iHg8JpXQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iHg8JpXQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iHg8JpXQzgls/5csjgdlcbSqbZ
	YNikfRhR8QRWsl/PR+ysXLVfm5JMGa6j7bpfX3sS0QSOx113hdqGg+EYMXY7Wxvb0qYFmJkraKRs8
	IpAPAVxLXW0JTXF0ttgMoVVFOGGzjrLseySnHPXh7FKfzUA8OeM9P4pNnCxCPZN/z6rWDlt2fZ/Wv
	56TGat7HwlSVvL/1jnGA8Dg3o2aZlQAZXEIGhsoAtpeSET5VkxD+wbfuQTcKDWUvmj+fvdpO/eM/p
	C+D9z/aZ3FVziZnOUStTWFQBx6nXBcgJGTHCV+nZo/eUNWTDPkmYi1SOZDM+CxvPFZtgRTtuuAVCH
	RmDTS0qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rm1tW-00000006wGk-4BLu;
	Mon, 18 Mar 2024 01:34:30 +0000
Date: Sun, 17 Mar 2024 18:34:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, david@fromorbit.com, tytso@mit.edu,
	jack@suse.cz, yi.zhang@huawei.com, chengzhihao1@huawei.com,
	yukuai3@huawei.com
Subject: Re: [PATCH v2 05/10] xfs: convert delayed extents to unwritten when
 zeroing post eof blocks
Message-ID: <ZfeaJqIXmUGt_Ejp@infradead.org>
References: <20240315125354.2480344-1-yi.zhang@huaweicloud.com>
 <20240315125354.2480344-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315125354.2480344-6-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
