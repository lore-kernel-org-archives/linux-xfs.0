Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5C3142625
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367363; cv=none; b=sXU68zTADPX+NjgTz8MRowJdskVsQVoyuIcGykRE0cWOkW4RSLBdX1suSxtpLfRmbfEh9aDeF322ONPA1UOqEYCthpJXWQ1BX6v+zl9qntvNRGdMxMUMPgNgi2vPP+JAqgpATVGV38/Edb2aZWhYmoZE6bLd2U9AWaVckkZsI4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367363; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q21udlzUhHBiTB4SyM5N2tN4EZ/l08Hwdk3+ruJyDBq82FrU/ZUcjU7L566OvDLx3cMh6UJ1g2u63KUx4gYP4EiZbQtNh7+fcLrAkdGzpf7Nzfrbg1rEnlfrhhuf0zkqjCwnM7IpJ25v74mrf2t5JaWGWI1kfcgkq7Ctwk1ss4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k+f5+3O2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k+f5+3O2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=k+f5+3O2CzKDVXhRDizd876F8/
	EPvNuVauPfBK1YmJyx5K9jTOEeDiM+xjdA2lNpf/OVVF4oNKbFFtRuZZTU4MAdNn8JTEaVE1LAcaZ
	zQMiKIScjzK/FfwdVJfUsJUtMkDO3TDXGaU6+2i7xxLH8zGZ2yYDosTb322RvX0MqWQQ9GMEUQzCH
	UaQ4qK6pjIspf4uWXiHGnr1eEttdom+6VvIunr4ex8CO62z4hgGHSi/7+wIgky87YH1cbYu/BdM4m
	73e1QH2v7eEmaoiRVkrdPqMaapzzKOaH8tIs6ZyudD5BcZfhQ0iwge093Xi9cOwyxdqwMbPaEDb21
	e/pwQ3XA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx77R-0000000GZMR-35He;
	Wed, 17 Apr 2024 15:22:41 +0000
Date: Wed, 17 Apr 2024 08:22:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v2 3/3] xfs_repair: catch strtol() errors
Message-ID: <Zh_pQZtZuWtVzdKu@infradead.org>
References: <20240417125937.917910-1-aalbersh@redhat.com>
 <20240417125937.917910-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125937.917910-4-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
