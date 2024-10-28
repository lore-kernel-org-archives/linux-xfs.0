Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3021CC8BA
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104306; cv=none; b=tkbbwH8r4EG02XwFV9/h4glPvXeII5XNhUl2er5POOKM2bNJOYVunMBRRoUnUD5NMc26RRhCcjo88ITKq8c06M4ZN+o54WBP5wjSOWyjA2yVMyHTfmn//aShzz4mQBuF90YHWQExqY0O+vZy55nNCk7zaV/aNvDyc2Yoi8v7J4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104306; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXyV7D/yiHTIlDtof426+lZvOeHSKR9+QKv2Z1WyxKAlq4/4Jf9h7AH0fe5x9acff5gyhXumFGzGZrULkkJa+NUWitBApJ74BjqC0Lh13s8IStIj5tPAi2CII/dvLmfEttn5fIhWyDTK4ym/B0cDUUo/CuvWdkuhI2UQtFnsONg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V754rNd9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V754rNd9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=V754rNd9NADD6awPr03mArM7Ab
	eElnYU4DIzD8m8brxEPLD4q2GJk2pk3fPTMYSZ5mg9C+w+10Ix4wqayXqiBGx8zyos7n+wDjB4FMO
	j1Q41/fKT1StFgvTk62MD1oDlPRIXcldL68IglOL+QAaQybLsg1bqUw8ICLpxUuZHMlIW1TnlRjU6
	j3Gk7xSecZyn59oXba62bGeEcMAzqEUJ6mX7hIkzXX3iaxGn2jWoryHR3M08UVMxw8uRt0Hm5Tvhs
	d2mnKe2WWj5AzsyQTfaRdAmGWRDBxk1CI+teWTC5x9e5BAvRiYGZ420qX9PZnj5BDAL1JHpKyLAzZ
	yE8Cx1ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LA6-0000000A6aS-23jU;
	Mon, 28 Oct 2024 08:31:42 +0000
Date: Mon, 28 Oct 2024 01:31:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/7] man: document file range commit ioctls
Message-ID: <Zx9L7idyAXMzkNZ-@infradead.org>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
 <172983773345.3040944.13699158820293279920.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773345.3040944.13699158820293279920.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

