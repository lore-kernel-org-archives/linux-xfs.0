Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E3EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945138; cv=none; b=TvNiE68NxpLS9JKUShLmv0JnY64Ckm/DGse/aFaOmKwxIuls6XfYwndK6OOWXVH7EggYG3aaYX6A8+SOIxJV1Ygk2su8qiePL7X6oS6pIUXCe14cm5hdxjt3dBbUUTLqYenNWf3h9okt2HSoFOiSTe9IJyVKx6f4+30e1Jep5Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945138; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uANkQ1pv2d77Zu+eNde3HOr1IQMnzrKfw+YtPUFmeuy9xvSTb2gPi1AjSmbGSgMb2n0sJzvzUHKjvnqoSFrsW5bd9tJLTXyyZqvpGkHl6gyphuJ5hFupOEczi9Nj786K/juVqWdD/8DEnMEF9p/zJR6Uu0FgeKTQzlSiPnYL3xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yeoNUq9T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yeoNUq9T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yeoNUq9T0GaN0S6AFL6Qhlteo9
	s/dhDYznBJL95MZa/8sDr6YXe2oHYLZkeaP3dUINf28EZKUjvsJDTESB19872j3CbEj9n0VcPLi64
	QpkRnWL16VptACNaK7Pn/5tHoG1cNcrf6NDgjiuEllQGO/C63xXHs0s0who5wlyOIB300gz1UsACg
	EC8hfN9DOhbBNSumrUD76G8eISImICKGNO0PC7BFBib8uG1yPS2bC7b3C1pjro0LTLQUdV+5nXJGm
	e4hoWVvX2EcYGJggHZ4ZR+prIT9rcEOq88f4q6bLSW8z4s4j6UE3s4IqS8Sj+bJoy2HIB5PbAecEU
	5y6uKLTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW9Z-00000007fyw-189c;
	Fri, 21 Jun 2024 04:45:37 +0000
Date: Thu, 20 Jun 2024 21:45:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: move dirent update hooks to xfs_dir2.c
Message-ID: <ZnUFcRNxNWUImDaf@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418278.3183075.2874879886308264652.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418278.3183075.2874879886308264652.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

