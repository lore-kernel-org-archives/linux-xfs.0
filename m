Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF5BA50
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724228; cv=none; b=SehUx4wpkKi28ncqeKx0dPKMylasAEX/Rx0pk22I872hU2Et3sZ/FTrHd+S21gyKYt+IJSycYrO/0oAB7GUxaIBb3jNjMRZqo+wYuirwiIFKqNJi2f8dmOSnD+phGKVvS8mKCKHpWHcsZsWWde7X6eoEolmwgrCNKvgdjJ5HDSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724228; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkZIV+MmCX77bG6JFwkTeEIM0HaKR4r770VM9hD1ToeQWTGxXcN8b8qBlNpq7MHB/3fW6zg/X9zIgBdTvFF2z8R/skBJDOMf3dfU+dP7RUjAKYCDCGPZ7zEZZ9g0hOUuAJdSbgnM+t5g+F+biSUsAFKNNdYZQRP1F5Gl9w+hGR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gp0/AQXP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gp0/AQXP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gp0/AQXPAkz/Kw8PqW+AvUwjLX
	Ypx58M7Det7KQVs+KKR3AslGte29QYhHbwMRLjD+N856M75Xpdkhlwzt9JnnB7jMSRIZvv1pt7F4k
	w9wlODbMXvM8vTKdbevR01pA4ayB105r3OIUT0BrxOjpV4eAVeAM6/fAVHQAoIDIIhZvRWkacUFRA
	xxVHjtow2EECRVYzYDicS80nLYAy7IVv8I1ZUHGnPN0m5jma5vnYzVhFPv9Zo0oWcM7UcVvu0I0Cc
	+d83cV6uiX9Ii9OszeblzL0ZcMfrxn3sc4/Bi/ZJOk9znvj0IA2MbT3ddceuaBJyopEgy4j9ZlV+K
	t8GY25iA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPoI-00000005434-3VXi;
	Wed, 10 Apr 2024 04:43:46 +0000
Date: Tue, 9 Apr 2024 21:43:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: remove XFS_DA_OP_REMOVE
Message-ID: <ZhYZAoPo1Q_Mkr9N@infradead.org>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968401.3631393.447688102804909615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270968401.3631393.447688102804909615.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

