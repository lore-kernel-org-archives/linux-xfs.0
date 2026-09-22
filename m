Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120843E5592;
	Tue, 22 Sep 2026 05:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054074; cv=none; b=V1xTtZUCzPcsm2w63Fn5ksXVZG7Wz0vM56ouWOTzkeVEENBcPFJDkhk3W6tyCnZd+bDWzhYfLpXY3FdU9/HR7QQRaR6Zy4voas5Otn22rElfLJeHhMZA/+B9Rm3kLYsrXGklLSfPuGNcuw/sYyieC72s0+1jTtZr68Hu3P4qwM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054074; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2ZLtuMAp8KXj/S9Tp+ooi2QIy/J4JK3e9EN/SQ1MBw7DyZvwCtc4BGpJjr5DuthUyTticEsX/Nk+iOKMQMuQ+5rExkBHzZqVaF55HwLgOtStoRmgEkRDPKzWs2qGVRqu7mv+Cq0RCojcfJz+sMZt+Qumj/M7TZjMACCzfGYYic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KXysI8mn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KXysI8mn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KXysI8mnopgEhlI2QD50dFu+I8
	IJHlI1lzAfGbtKd0+AA4SMfyiExXBxhb0cPQVH0AD6cDjnI5SCb/UCh5grRDG03puYEzmByDF22aD
	mhRbc6azgyz6H2baavBN5t2DwtygPiVTw1QBqGl/c5cPq0rTNsV3JkcXfGZobwr0M/eYLnF2z8B7/
	OAWkFUbw2xPJ7Dp/Cf77UFC5s0onS3Jj5h/zT6zS+e6GICLvTsgkyQWOnM8FKuNBWI1Zq1kdhRKua
	yEibsyjqbaAUit6zpPLEORLY42VB4zgvikw2gLKpkBEBlxs+nXHRtvUDUe28VQOYApRkyhRzdH9sZ
	FbfkpI5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8spq-00000004EQC-4680;
	Tue, 22 Sep 2026 05:14:31 +0000
Date: Mon, 21 Sep 2026 22:14:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: online quotacheck must dirty dquot if
 enforcement adjustments needed
Message-ID: <arIOtpbYMziaDklA@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120594.181988.17443723006471773386.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120594.181988.17443723006471773386.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

