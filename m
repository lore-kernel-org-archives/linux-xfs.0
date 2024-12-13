Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5A17AE1C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072715; cv=none; b=SHL2dZIEy7U60T8QdmGM681JrZMfQIAUr+QpCsvj1MJahCOxjEmteKMTfT5CfwcepobFIfQhAShHgW4fRV0jn+t8UstO5AF8lfZhXmKnzUR1iggiG0h65iPk1y1jJ2EvfoTR5Mv3bP9jLxYuzz9ofbtnFo/izXZ1r4VrBJXIDKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072715; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISlCYsQ7rcbse4cMgmBEGtqDpbMvGXK+wzlgg3paX0Ca+k/4N+WByQiDQl0Fc5vY1hgvrp1vNQh681Y0K76PWyoq9ESJ8KcxGWXZtVVIVkV+g4Geos/bp03MMxFZU+E/bUIN5K7HGwbC6pOq/pjtfF3Z/C74uoFb167IQSotNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DtEYLwWx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DtEYLwWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DtEYLwWxkr94VzT8rrj7srUY7D
	inqpn2+D2QEu5S4Ty466pIujZjuHeQ10sd4U8pB315P8HU5pZYWJCnRRgMRH7efTVeJbiCPLIWQmP
	EFZKYti65AtoVbVIbAzWTH05aT3E8GYi7wMHfG9R2ncxGXhxDRe3iMQXyEsBP6Qsf1Wvppe/9kOqj
	S2F8JYrFGjEPn7oo0g1/hpLmJz5iAZkcmavDKrDRgG4J94wR3ogQypOA7v4Kz4AMyZALoaX/ViNnF
	wNTcljK3KeMElwS3304Wm0d5/WtaiB9q+7iHxzj12EW6gG37ql9RMI2nGC4B9lNGoPk3jVO/G0ZyD
	/HVqD1CQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzWj-00000002uBz-2uNi;
	Fri, 13 Dec 2024 06:51:53 +0000
Date: Thu, 12 Dec 2024 22:51:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/37] xfs: wire up rmap map and unmap to the realtime
 rmapbt
Message-ID: <Z1vZiexiL74n2Eyj@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123571.1181370.10004699515258970987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123571.1181370.10004699515258970987.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

