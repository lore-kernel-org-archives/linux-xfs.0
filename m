Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D688481654
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008014; cv=none; b=AB743t7fqi5b6Pi2/49xeNmD0iLpltDMeQyIX+3N4yroB7zeYm8bw5Pnw55/Ym7FzWEJGGko0V1GqCL4UohCzfd5nsWTTcDH570U7Yb8Un3qbKFpzk52AcL9qLxyB2V/03vTwQo8YppZEOaO8wQdLx6UqF11cyWo9zpU53qaigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YEpMa/zvDjPYWtoG6Un5ePiiE4fiTxGVIVVuAYiFQ82XJwEvQH1HVwXZnq4RkaiysFFu/tMuWMI0mtadVBCLG+nwX9Pseq+8+uwm4pS/fAVOHIjLRddF8nRbgcCAQxAmpvkmoIjP/0UN7ZAojaB/BQh1v/FXpbh4bo/fOMtsGW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OJDDT+Qt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OJDDT+Qt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OJDDT+QtyCGpS1ZlkqV3iAgCQq
	yr3Crj1kQHbNbs+3sORY0lmRTHEnsuUVupdCcR7cao/+hIrCmnXu/WFVWf0bWsrw9ecDlFOWyM3jx
	7DsBOkvfGMWu9a+6W9bW/C6J6qHIwJ1wGBOHRBqZmvJVAxFc0c4056BrfOMhXmTthxIzY3Z+NHC1H
	IFvlcPI/6+61QIXGI+P/mi1qHO+RRsDdbuCXe6ViO+ebR0+7V3zcIWrMzQPb83GM+kQ21j8Qiffml
	ERWQ7HBtuzM5xkO6a5w0+AloRDcvUzAVIyL77UbrL5JHkh2HNZo2BfPoaaHbdE4CRYIMYCauC16EL
	dYUQ712w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZnI-00000005hL8-3V0J;
	Wed, 21 Jan 2026 15:06:52 +0000
Date: Wed, 21 Jan 2026 07:06:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: strengthen attr leaf block freemap checking
Message-ID: <aXDrjLQHF1IEKeA5@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695642.202569.3013555748365939096.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695642.202569.3013555748365939096.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

