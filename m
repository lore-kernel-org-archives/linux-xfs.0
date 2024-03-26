Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397E784D0D
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432717; cv=none; b=F/dT7Cv1260HTc0ys62SnNsazAKgPpQGYoKXYBAIgbKJbmAtmHoUgNm3ig8+a4nyRapJZmp+u3k0D1BAlSHkJMfj0IWzsy5S+fZ6xAGzmMgkrNEZjjoAXZz2yBjpGK//NhzEkNLCQUvDf6DbIMWROESJhyIA7W76zKo3VXK5aZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432717; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/IR8dqyiRw1pE75jmOpVxBHOdc5tApNWsR69u73si2oPv3rjhH8VTQz2obou/e7mCvl4dFriRAJj/lYb3k3kaiXriT0CtDwH/FD9R71YtyPFWd9dfPvO0NEL/dRe5ImkerDffTyCn/R5hQTag4nsGkPJHUmT7U9YViXpf/aipk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pddNCt6G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pddNCt6G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pddNCt6G5Hix5qMurstxiFS/eV
	ZOkrGudZiieqFk5EC4VyMWkodRh1Gg1LxBQmNzEU6t4us/oMUC17Ex+LxUIQ7YsReTY7sWoQ+4lEj
	4g+mzrnpZrgMqs+Nqv+V5tYVxe5zXyhkMIzKPVuO1TEeFItGQ5I1YyeUAZzCrazyy/zhM1xkq6JR8
	GASmSfle9bYmUoftlUvLeVxsqGmpxyRYU7iu6xAVOTaQwndr6zlQBq1d5ZrIH/kiKjPEyPYlTm834
	bkAMP74xawgDTJjNl5usZPrjoDrP6TdOSTzgN+kQf47j1c9s+YEVBw763+stShKE67k/aY1Ru45HG
	NkVkjtAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozpT-00000003CoM-3M2i;
	Tue, 26 Mar 2024 05:58:35 +0000
Date: Mon, 25 Mar 2024 22:58:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: port to the new refcount bag structure
Message-ID: <ZgJkC7OosXHCNu4S@infradead.org>
References: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
 <171142135124.2220204.11795253596640764488.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142135124.2220204.11795253596640764488.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
