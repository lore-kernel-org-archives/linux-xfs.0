Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C61381BD
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388507; cv=none; b=HhrCukoEA5VdoZeVREG8rN/jE9MpbJjsfry3nl4O/GbiccCKW1eIPeIS9FIFlJiZvse686R8zXieS3hIpV1YrTA9aNY1LLBPGjX9xQ/foqecr7sK3SGSKT0THV5inwLs6v6Owalolr8Df78HXEGoUmlsCDBB2kpMDFm0IlKLeBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388507; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqGFwNlQGWIPjb5iNwzFypWjcWMK6iTfrD5h0Uyc99sPvt8VwJvsid/WepRjiV6fTpKPgkdRqCIx+2INxkZuntUkWbeEtx59RnOBWyMg2T05aV7WWUXtBbGTo05NG21EUXtRzTkSIGab1yqN6Ak5gOrER52Ir+0ABsAt7YIOQgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nMMjWZbh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nMMjWZbh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nMMjWZbhEvBX/2wBsYqJtvL/Sy
	64qgl7XX8Eo1GH9qU64Zoieh8K8taVyArbwfwzS6zuhaptmwzc7KAHPgkyMlUIZA164gRviAbkuCB
	PdXVNzQEWlya6wOiVpQT5VE58AI7iIK2k7QWK8rknj4RJ/R2p5Msn81sqfbvnadLKnVrukTlV+jQ5
	7VS+hmg9EghwpQTv9hdRQbvj+155dFV5S5Q2lsZQolMvEy0IApH89NeREQiebY4qlFlGKSJxBCXZz
	uLCYANVmRDtAwLztng+fNECZcB5yG3E/imSNT4yeUvALgUjh+b03h4VSX/gl5tA+3pBjJmJ6dJsIB
	ccRm3p+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMDq-0000000FE7n-0hVv;
	Fri, 23 Aug 2024 04:48:26 +0000
Date: Thu, 22 Aug 2024 21:48:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/26] xfs: refactor directory tree root predicates
Message-ID: <ZsgUmglzF95T76Ww@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085434.57482.2266934601386619409.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085434.57482.2266934601386619409.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

