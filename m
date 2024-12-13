Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A873189F57
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081274; cv=none; b=ovvfLxa/GLPil258meP4vUQqFeYY9i4ce7JLM8dV7gzXl/1FJjG1vr4IsaKS0l9Q6hbd/l5CujhtKF3gJAwX00svbsKA9mOB8ER/LPEBgz2U33Z5gApu4nnodWbhjOYvf2fEzu68QOUlm3EieXcbgDauJdr9MJ4Fb9/+i1//iic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081274; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fViDPfQctSuQ3agF/9gZm1HNRjXlbYJ3nD4U7c6FZRTSlonLl3YPc4wImQ9uAk08n17I4GceEFxIa6uKleGuWaO6eslTm39FOczuYG660l1PjpmRgfjUUJBxH39zYbV8i7u4RK+Fj90/uu7ktEnqFRen/gCe6i3F14q/gWHz1GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wzpNJAH2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wzpNJAH2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wzpNJAH2WGWCWuSu89LSHNOG9O
	WBmaTXfmH8sW3d8skjiQrGAxQfOCQRh7T1rS/duDlQvBrAFz6SS5gjZp8XRo72Fs4HTp4qWFfkE/5
	R2HmKp5EKxuoHPa5E+YmbRf/7yzHcouFSTDEn6NidWCLcAJHty1Xao0W0IePthzQ226/nHi8GYJHC
	Q4XpaSYb9m+5CxGVitSTuBbjEdq5RD4tNwBP+dtcjcptDwBrUK5yEAZz3tiaP5lDXA4aEdvjusRO+
	9KhFWiQQ7/mCchqQyfM9HfgvLt5qes5EyT+YLVQZ8bDM09TsuL1mCaxp3SqhhhMw4VuQ3R2bw3jpp
	1mGjE9eA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1km-00000003D1Z-3jwN;
	Fri, 13 Dec 2024 09:14:32 +0000
Date: Fri, 13 Dec 2024 01:14:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/43] xfs: enable CoW for realtime data
Message-ID: <Z1v6-CZVoBOtu-8N@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124893.1182620.5109119081905843755.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124893.1182620.5109119081905843755.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

