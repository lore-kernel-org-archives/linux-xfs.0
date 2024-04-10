Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3631A60
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730104; cv=none; b=s9KXCUUn+4xp2ZNHYSGlvHWUb9R5w5p2202oISbt6beVgXpT8RPg6VE++rWjt73lnXP3g4tGixnNmj5TM4+LmnwekV6DT4wzUDW0PwFP/aFBCg0DZrZRWPU7zy8cGOfDdK2ovmry8jLYiaH//xbtDXyY9nqCbani+TL+ZyoHHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730104; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnP66qq+V+WoSgC/YqyBkjbDIi9+XNNPUlcYPerRyKcMXavHB2CYPNmg0IA2ZBa96riF0kww6fZA8M/yTZRCNjVeEBVVzQbST77k8vDgnFk5ldHwojhbYIiKfSHp18/0UINslb5ku1VZY2UKDleOo4YCDKOY1zhozBREeKtS/es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fwYEikco; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fwYEikco"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fwYEikco3vJF6m6ksI7vBG+MC4
	P7jS634vrBKYWIAnDpT+sW6Hw61K0pAN8vNQCOZL1VJAMQlzbXIQ4uOf87SeWNDdhFhs7Nwd1IpCw
	0vADWvvu7LUa+4QA+UraCfRQ56IctE6ONHTu3FmVW9YSu2NltWjjp+g5Lfj8jqx4b5A3dGNNe2Vz5
	TjFjXeXZCZxDGBB+v1ixTRNBTtg8YvWiOiW+kqnPVJpYhJEHuNIYT+gH0YAz5H3hFlFN0ubV6utbb
	JlshpdPx6V6LYErG/fTOFEUPSHYlp5ZooVVvBJ3h3p+6q8NJv4DYrXUIS54NXXGYt/5o++MllwpCU
	IQTmlB1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRL3-00000005MZ5-1ozs;
	Wed, 10 Apr 2024 06:21:41 +0000
Date: Tue, 9 Apr 2024 23:21:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/14] xfs: split xfs_bmap_add_attrfork into two pieces
Message-ID: <ZhYv9YRDIUQNnrZS@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971136.3632937.4652714249716908945.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971136.3632937.4652714249716908945.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

