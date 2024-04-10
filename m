Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2E41A286
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729064; cv=none; b=Yw3egrJXkBu3J3hwFmHrabqxQUljFe9we2vlvImVSQzytI/TyfyU6PRLWJR3sm56qfKNDIAsnFXY6+3DodVPkFH8yjFY2dQkCan5HY71j3jrmMO29Kai/ja6xnvGUNUB79O14S4MVEZcBlilBY4YQQfKi8mHQo1WMAlYjt94Zpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729064; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptLETgsxni7RbfU6z10RpIkNSp5KKUciU+mXoGwT18eGXMA1uhP/h+9d52hc5KxcoGZgK2Vj0Lk0Czho1v8Z84R9Y9W7iWgdigfDqOYRmsJch27JdzwuJdyUCvTZOzqjN+Z3R/pQX2JJJoDglOC+o3/hbgMRCkK243RbY+kRHrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DsU3rWO2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DsU3rWO2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DsU3rWO2hJaKc1OnFM7V+NWR+G
	w+3z26BnZAYJ5WfX+cekNnq7Fz9eFSYcjdqZHWPg6sec7gOsBOlpuYcvCq4l6fa0E/+R2chQhv1eC
	zxMAVNNRUTvaWPNURaBeoqo1DakqVNBVGZDBl83aDDPbBSLDpAQZPoa1fOnYnsSkBB/2jnKoTdoRa
	dhxUU/mW+s1xrh0zOB92GcwaY7A0Yi4tXtnbOEbGvr3f/G6KTv0zuXQS2mcSbjApofXab3MFbBLUL
	xIyaMwUqyytefLKEhk+nLM/TooF19WnxwvNRZOyOBNADrDu884XSdKLqM38t/mYC+cw3P+OmzrTaw
	TR5QmeFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruR4I-00000005IWb-1RN7;
	Wed, 10 Apr 2024 06:04:22 +0000
Date: Tue, 9 Apr 2024 23:04:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/32] xfs: don't remove the attr fork when parent
 pointers are enabled
Message-ID: <ZhYr5pkmcYfgGB7t@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970025.3631889.12207478353485734181.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970025.3631889.12207478353485734181.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

