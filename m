Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF321AE005
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081097; cv=none; b=f9A5nBkOJoSUSaSE+r22Iii/rGbn6Fk/hI8pkYZr/O9bEjdOJzSAjx4UX6X6hyxzB0B+K1R3cfsqkL3Mm/at8HFbmvQfY0V9LEB2XdjnX3pKO9ZkwBDhDfMe/JqC9+YfXHuv5cvaoQUtGvvkIERXL1c46jDk1HgVBVIhMOV+hGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081097; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQKZZ+4PQ4lVKhVAuUaeL2GxGMz7fytsKRqWfpawXnfeV9Zxc4yl1ZoTsthuyyThiqZQ9elxVN1IG/HpFE0e7m7nJipy+VRtjRLrq+HNZ+iMO3hXtZBG41LeYo1gjNhEOS2Ibn1qv3F3ms5HRTbEt4EHcR3tyOosfzRXnMo/FXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lgjdAuci; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lgjdAuci"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lgjdAucieqySP8zgpRIkv4+W/e
	LT3kzX3TnFU8mjMQR2YlRH5KDf4uFM5nI1diUnP/3TVc/J85SEcjAmxI3UgdBUpa5mL0eVgcBIX7E
	tq3fCARWNIr7/1y4C/dJhiQTXAJ403qIIEqUrQxw+OQ2tNO3ioRID/L8g290TYPC6DGUNjbpW7qD2
	YtJOZgxzui+ZUiiuB87TXpr2zXi6eAw4Fe5S3IXRIHt2V6XZW9aFu1ohg+vw9MyDb9pDSXswBWyj6
	RTGD4cUObAzmZWWjO7DsICb4d8E0jQsSgRKgTpoKUrxCY0hrDM5aiarIncukmv/DsojXO9K3hVaKn
	wGziODzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1hv-00000003CQN-3R88;
	Fri, 13 Dec 2024 09:11:35 +0000
Date: Fri, 13 Dec 2024 01:11:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/43] xfs: wire up a new metafile type for the realtime
 refcount
Message-ID: <Z1v6R5h9JcwYpeFw@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124773.1182620.12087827616201844932.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124773.1182620.12087827616201844932.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

