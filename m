Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E9538389
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388838; cv=none; b=Wfij3G0oGDDbFunTjHMRsGaxX2vg5E3wugvYGVYyc750gWLcNsd2txFV/o7sIGbXb8g+q5fENGYpyeURXR12vWZwTODeMfnbVAGtCWPdK0BqEHPxyKQ7/PY9F/VA/PFimdZLMUCERS/gIaw3GZiwPkl9nLI5A4U2e9DJsgsBHaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388838; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QX6RdWWODf8zXwXSD+VU58cSRj3zCjPd2XqAYOc/q5fr0+tOk1H3zNtzWFpRMbJDLnxYADdbcSAAoMttDs2raTv/Rbmn0nEDy/2mHBA5hsjXh7WM4B6PZIt0MAawOshWaU1tCxMKIG8CHs5MiAHV+6JjnNfEOwjHqtQFZaJBAOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wBCEBldg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wBCEBldg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wBCEBldgAYLhwYGbB3H/VtAqXn
	4952z7HsK6BD4iGi7VS1EMW2FvYKCTo4qo5mjI0e/rKdP4BUbzLHy5F9++S/xLUqk4vuPpa2iaBR9
	2zXUgnLcQdJgdqgaQZ8OkPk7f7XQ7u35kJF9ZkX3ZS7s4nT63MnoR9lERFV2x9F6lXrW3zFkBYVzc
	u2T35LjzzW/gKoG2E5dzOPOftC+ai9pm78juGvGpErSSgN9p+c2RFdgKO9UC4xBaDHMeVQU+PSSYN
	YkBS97VlB5CsD0FADy07yqF3nPky+6oLBJXmh6eTA/B9t53XqjFOetSr5Bj0q/4pU7iYI1K0KnH0A
	95UWMKyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMJA-0000000FEes-3Yww;
	Fri, 23 Aug 2024 04:53:56 +0000
Date: Thu, 22 Aug 2024 21:53:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/26] xfs: check the metadata directory inumber in
 superblocks
Message-ID: <ZsgV5EnG6T9F7RS2@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085553.57482.15943448034882910022.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085553.57482.15943448034882910022.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

