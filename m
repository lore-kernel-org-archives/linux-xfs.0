Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0736217555
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855341; cv=none; b=lCM8QOikAXshPkyv+h4GY2PZ9snDn2tvPPRjcQTqTFEfKEXiqa0Og/IYv2V4JkXGk5a4P4sLfzRXajwNupWL7rdee+sOhidCvlC7ExptTkaOfXrE53kI2IpmXEwiEO6yIjvNHJBfXi7fV/wWGKAWjvv/xCN9aJIa0ErqZ5Qc9cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855341; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOz+AfpjhdcIxSiu4tnURuqD6n7PP20KuTrcahIvr15eg2+LaPom9FaSuJIo9ZOwkE7wL8Rni6hBLCw3Wyunu3cm1BpZyvxApZY+bJFF9tduOm+UAiDEf5GPYbfiKlCi3JeAIzV3wLBJd5yjbRkdlLHhD0NMiDWiiIfHSePSR04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=krBfsdgL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="krBfsdgL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=krBfsdgLrPcwIyf6kgV9BK1AlA
	oidzMStSWCxg2cRIhjPsmtGDLytxKFiYoPy5y3yyMIs8CMkBcu1bLv+R+8lxa/9As6jZpaFwECiYS
	LfwATyVFDyn56lZaIQqcWp1xYUYMpAksceGcmuiFXy2Jj0oC+1UatGLS7ieLhfOihhKXul4hqKmIa
	jVh6wYrDeVdVs9BvQYwz6606mUkmYw/0fSaGrHNmeh2QjUnqzmdKwnWFcja50XeRIbH4myj+eywG6
	65NJtHYoOPJ07CV4WiCdkqOeLRoZJqMYd3ghHHkhCESMYrxVfPFuoHzbqLUJN3B+t0Qc1EsQN10eb
	V+jCSmgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn2p-0000000AQ5o-2aJN;
	Fri, 02 Feb 2024 06:28:59 +0000
Date: Thu, 1 Feb 2024 22:28:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: create a shadow rmap btree during rmap repair
Message-ID: <ZbyLqxIODHdDIaGQ@infradead.org>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
 <170681337491.1608576.3822702932308825535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337491.1608576.3822702932308825535.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
