Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483C5157A6C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734080951; cv=none; b=pWZJcfWbUkm7yw0ch2fPKLehbvdII6Uxj9P9d43SwrpV3qmRL6Ge4XSNxGFzEdS3I+sj2TlYjrgGcpybSXDS2cq1OO7YxqsWZ2Tq25d8902rz2yuKlnZYcjitUiFj9h1J1ViWKLsjtGpLB/xs+mDQozN6FQnR9CTYFdhBc0e9yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734080951; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWOSTgu5li7sG9OVF5Z3zc6M5YnoKHyn+pM3Gk1jlDl5W/y0IhYFpl3DNuE7n2mjHU2JRgZLNOd5RCay40ueFPvm2b38DMRP5OmaUT+CwZEQY/olcFAE5VrBlQ+IKVb0Fam+mC+dlT59CVWdVPu+k9pn0NvD9ZfGbNoOG6Rsw4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O/kIH8nP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O/kIH8nP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=O/kIH8nPqTkRlxDHaloLxxyQhz
	C56Bc2DiXdc84F905iAw+ZsP29CeEPYsPz6K1NtckXgfm97GubDNf35CXl6jmT0aGJM/dY3gXm5gX
	03BJUO8xePExGUeu2zFMO07rxKN+3vXaiVXURLaBrxKOa7r9KxJUFFT19gvfoXEskUd1exJIUqeRp
	J2zJy3VpyA3JmruXbzG3x5M/5yZt3H89LR091Dc3S8xYXDKksFQ5/E+HzDIvBjymf/faLBAxW/HqW
	GQEf7AwdimZl/C4FmkFFTLBQZzJcQynq06yxhlGH9KR30qv2TDk2UDYIG2gutty+dLbcYY4JHJtQH
	S5ChLHKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1fZ-00000003BoB-470S;
	Fri, 13 Dec 2024 09:09:09 +0000
Date: Fri, 13 Dec 2024 01:09:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/43] xfs: add realtime refcount btree operations
Message-ID: <Z1v5tf2oa2Sfbtw6@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124653.1182620.16512821656534066704.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124653.1182620.16512821656534066704.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

