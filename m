Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90E17DA9C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848731; cv=none; b=gUesTUZFhcl9LvVIfDnSCEssF0brxjUudo4tTm8+oU/OG9IDTLfSijKXfeFBxlvqMiYD6+HUtN/RexyBap83uDhIXrpOMljVTLxG0vb7KwPHtw3vGnZb/1hBRJ/kxKgyA5DVLPpveHO4ZoPzeRnhSgX1owxdQ+yYU5BxjoTHNGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848731; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDcHDxiq8Oal5cPeHWAH32dMEWonGL96qOxTrtUYbzSdqn0VuF9sVd3zYjvbPVkWxK1aBKXWXPpGlkKE//9rKMjCt4ekL1mvS8j87X4k0mmJNeiWxXS0Yxv69BZ0O3SQYPNZ8bTcBptCP/DbzyHxYgkwT8TJYvNNvYskQ+j3Olk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kkv/4hml; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kkv/4hml"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Kkv/4hmlPxMV83BpYwhKJjBHil
	0igrkDHns7zKdXmDphURm9DEKFEHILbVK6ZK++lzmpMdTaO0pR4w5sqOdMi5cH0bvMS1mV9JfQvEh
	+/PBj90XunH3CJgusLjXV8f78d0yWVqe26ZV6diyv7m4rlOkdltjyFjX2RPaUDnaLLyCkdVgUJEwr
	JYO75Zm6z/N/xZF/ndBUrlVNpPP7743Cx+llWDnDNRzMHYlrb3A4zsXtosx1OQ9lvDaRLxaVh/vn+
	MAuvQtjoBC8wCl7TpAn34Md5dwvawpZJcCM1gcdFvvHZM40GYaOVpyRBrCvK+RUa8NHIJcJ/VLIlO
	G6L6Na+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsNu-00000004t65-0Zom;
	Wed, 02 Oct 2024 05:58:50 +0000
Date: Tue, 1 Oct 2024 22:58:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: use library functions for orphanage
 creation
Message-ID: <ZvzhGiD0fjwnChqn@infradead.org>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
 <172783103438.4038674.13322754481588384282.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103438.4038674.13322754481588384282.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

