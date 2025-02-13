Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E84205E3B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420966; cv=none; b=HXunvZwO83ttQSougZ4DFdSYjgk/D84r81dYTQt/0kqEMuE0INPk3JPU0JohZMp5zNRmV4lDMLYCU05oBqKJv6xObSNGsNLpfzc/a1fkoOwCeFKr4zMQSkF8pjhsoDD5hlOjlle/dhRwfx7VqgsupFDxWgy4bSaa2srFYx5OXq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420966; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LeUof+h3UpiADN9tkhYMwSfC3Yey1iM2rjbZVq+eaE0xKO+VGzpxjTA2t5Sd9T2pLpGheOd/nyWnNMe5utbcKhjzfMMd9icSz/SWkQlDKVAOTXaym08Pkim4TxO8no161yWrbHeBPHwa7v9D9tpxQoxILQzJWb+irXOIufKt51o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cDXbsXn0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cDXbsXn0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cDXbsXn0jKxVrCl++g29RZ0+i4
	6vPUBu1+W5pg2WR8tlXJ664+fKKGYO2gXg2es5k8Ch71SWR8MhcQp4oYaC3T3UsmgaWgF2vslz3h3
	Y+xc6kOKaMa9Pa4cVA+q+D3TvYNU2gN6m+BzcfWmEAdrTLfH6OlPACK8rsUqjtoAY+ZC8VFCULkNf
	DzuDS9TvmiXJoJFgVnFwC6TqahwH90639eahyP3Z2DJdENkGEV53Rk71SS+wKPePAmp1HM6sOmxlz
	PB53Kdn+nE8ogl7o2GvToq6VAzJvnFz2qI8t092RoY67Hrpu4SAVWHWDxPsuZbMCLdiIWX4GaWWwH
	hxEYMOcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQqq-00000009icw-2rbc;
	Thu, 13 Feb 2025 04:29:24 +0000
Date: Wed, 12 Feb 2025 20:29:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_db: pass const pointers when we're not modifying
 them
Message-ID: <Z611JDQMx3jc1IFW@infradead.org>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089618.2742734.15049031959195578708.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089618.2742734.15049031959195578708.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

