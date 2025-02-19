Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D801C245C;
	Wed, 19 Feb 2025 07:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739951024; cv=none; b=bEOFvrshmkAfUJExGb2hkKbLJqF7te5BTsqxL0hfL07bkYDdsccHnyKfSL81yXbbw8sSblv2ooDvXKQL9qjVZVWdHcByZfLyQC8V0TbIzZiuhHfSsPERr8I7noV8kjRvAGEi07T3XLUVEqYSC2rd1ozeQoeLvOPXN/Awhf9WugE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739951024; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2QpXpyteHg9GlJlaq9zMkuBGZ/IzH7ALheqyma5+jhDFcxYM+KpnUZUMKAMPebIJWsCP08F7Iij3bkH36SWeSUlhZynKAXNcXg29dOEKoJx1b2ePGh/VDGDVln4B/1NdWnumhjJFc5pPCY5eKqwGXjFCCGxcz4IOq4Uxg3wiVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yyYg7Kr6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yyYg7Kr6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yyYg7Kr6bJiXNU1eIktQ0gyl7t
	wz8D+s+JuD60rHALCJDcv/TNm2+Fl6p5gVbLAO9zzEINBC305LAINrxWa/XiuSbiaf5DOk6YAHsWf
	+QgzkUOJAXxHNJLsSF/dUiYF3+hmZobCl4BYaLSrtVteYaCK9Jswz4VYFcQQNyXCbO/sX+kp1o9QD
	xq2/HDXiVQq64a1HSgKri8Bp4ZVVEvmlFgBp38VN3EM+RoBkCAbJvCunteARHSI4x5E0wwXJ1oq/K
	xcI+e1g331qMYdOluKK5ljTmh3qdRzu9PcCbE/fpwgYCK1QkWM5m07NHQ1OyMUshvgwj/zRSC/q5Z
	uNgwM/Ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkekA-0000000BJoB-2iry;
	Wed, 19 Feb 2025 07:43:42 +0000
Date: Tue, 18 Feb 2025 23:43:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: remove xfs/131 now that we allow reflink on
 realtime volumes
Message-ID: <Z7WLruSCl0qZd6PS@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591845.4081089.4278978282673903512.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591845.4081089.4278978282673903512.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

