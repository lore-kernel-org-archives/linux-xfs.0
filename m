Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867C15E90
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712724072; cv=none; b=AgFLOICoh8qHMz0IH87CPeh3qj/yXXToEK8tQWimHnCkb7+RD7sD8LNk4wRKJ+YTHkMgCEpAyPJNYuQGNudAKFaGSRu0ZL9lw6sb+QCf4FqB3BMuLA33z704oPF7cU0t386qbXLomYahjPYSOZNehH8oPX5vA971GKBQQHS2Iqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712724072; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/BQcP9EJHh+sIZGfEB9b+Mt2u+RLUqLgnwbj2I4x3hua1cE6JPK+raBezRMeTnjPQcmaf/4ASAlJJkkM3sAqLmBym5Ryxqyi124Y207W6sq3wqRD+bLWgJ2FaL8b3jjgOR1O7h3P4wdm6Jvq9pEb8y2BIe58KEYK1oNMvyvzvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sTHIlSRm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sTHIlSRm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sTHIlSRmZLETNAeV3PD9mAh9F3
	XG5+Y+MZLFhURU2CgDTbaqQSKGVqBGzPE+MCZiiVtaxXJdaLEZ834YiKG+a3LSYQSzSOGfTE+a5ZZ
	sFkMv+8YZsiqMK7q2qSSUdPW5Ui6T+F9jbWJAPexQ93kc5HjU3hl5QJWaU03xgAmAdPleyV5u1OFh
	GVEtd2yI46CKKot9br7yxj5u2lh7xb0LIFDvv8qMdkzCF9uzRqPzbJrHree5Vjyp6T1s8Mn84INPV
	SfEqwONEojq51lKI0aB/vTR2QvqOa+Nj2WJ3Ki7JeQ1H3ieXlJPUM31/Zg3ixYXC0yAQscx6sojfg
	v/WjQaDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruPlm-000000053Zb-33an;
	Wed, 10 Apr 2024 04:41:10 +0000
Date: Tue, 9 Apr 2024 21:41:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
Message-ID: <ZhYYZs49vejtgzNU@infradead.org>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
 <171270967939.3631167.6157751007952552705.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270967939.3631167.6157751007952552705.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
