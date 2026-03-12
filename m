Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BA53242C8;
	Thu, 12 Mar 2026 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773298532; cv=none; b=CjlzYxmx/SC2syDRRdnhc04l5zCOUCb7mQjEfjpISmodBIeaXY/MQUjYtai5n4GHSLKx+xhuRnzXRIoPrTex7X7R7+i66POg0+bikf98xENzTwGnNA6Eiyn7DG46MLhUA1ONyVB1MmRzfYlwclcD18OAAOQ+ZjT1bqHigQIm6pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773298532; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TktsSlfEv2eSE6Z066pPz7De6nMcVVR6akoClie7CiXN0S3R0D3vACzBDHM9plbwNo4M0cbhdV510J5aMmLchBbGJyxdlAtCC5J1pMe0JloiIff0wwJ5D4ccLJwJmfPb+W/qZtN6RY7igTlZ7YgAulqSDsY8p1oPMNIDxi7WhUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VcyaTQzw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VcyaTQzw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VcyaTQzw6Tm/FGb362eIYWf6Hp
	IblPXcZy1TSFg5Ew6vuoFQi6icfYGWcQx0XYM/zujeIGhZladLFmfSPI+323E5pAEQ+GUPO6Hm/Dd
	Mz+YF2+1gOujJcxMpCah0LmDR2X0EZhRdUbfNoypFdcRAIEA5hbrzCXAVCuyqG1ldO2IuaQ3g8nH6
	eP5xlfSe2RqCkxiXcGBaS53e2MCnR8/OnN5l7jCuEwVSREFG1SJcp16bnvnztYI4agCQYeVj6fRuq
	5VF+wb3TlbNT2z9WNbnp2hTmts6XaugMhewd3k0EdAooeLOm5gy2W9Mg/SGVkrVgCxSYjS/b15zfk
	50WfQDGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0ZxA-0000000DV2A-0Zuf;
	Thu, 12 Mar 2026 06:55:28 +0000
Date: Wed, 11 Mar 2026 23:55:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 8/8] xfs: report cow mappings with dirty pagecache for
 iomap zero range
Message-ID: <abJjYLa-HFxTShrj@infradead.org>
References: <20260311162502.192375-1-bfoster@redhat.com>
 <20260311162502.192375-9-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311162502.192375-9-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

