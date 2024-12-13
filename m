Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDFA1925A4
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074994; cv=none; b=gnUX31JNIMWSXxVWiPVArBeVGgRqDkEopKBSQ/RUuNKc7ECO2ZbB5cAoA1o8TmyHGSOV0SbKfU39cnMxLb5jrAdMHMxdHMAX9V6RMgMcg4Bn673JkaoWBbdRqX/kiCCfOxgQYizS7bRiLkerBGwca9x6apo7UJkQBbD0i5I2d6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074994; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AvkJ8rUj9uYm0rZwC+yo5cah5Sp7HCRlIf/mxq0U+WgVdHDTdbTOY5crP8AjrdO3xcJ3gnvfaRMghfttUVT2l7Rhevx6E0jmQGZfLdChwg8goAU6g5V3n64Vo8n9jlnBvouyRv5pbGEu39Bo/U9uk7IR9Cp32MOKHU+h8SBiFZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VYkggBlv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VYkggBlv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VYkggBlvHkyKTBLj6IovOS+hhz
	BQh5GU0mqhu6H+TCPGHMoo59bZ7cElWFQqE8A+4A9oaXRPEMxQBq4bG+4dJnBN/g2RixPhEwSmLEf
	Ms4S2uH36oMiTB9OHs5/dG7kf+TS7AS8OoUgYFyxxpC9gLK77j3A5OdOIUbl7279iNBRnDGV6Rynl
	s9wPGEOj49xu/18D2cGr56DFLbrJ8JpoatORX1hxFR8DXzKh+aCSpEo2ILdYIxUAs33alfPTk9Og2
	zjFS5U+d2rsCevAJzoiobHMp6Jfs3dph2/iF60D5+xXSXxIwbpFwjqd7FvirLGd6SvEdjh9NI9VNy
	mUdzi9Wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM07V-00000002xsc-0hYH;
	Fri, 13 Dec 2024 07:29:53 +0000
Date: Thu, 12 Dec 2024 23:29:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/37] xfs: create a shadow rmap btree during realtime
 rmap repair
Message-ID: <Z1viceAxgB8ClmMm@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123883.1181370.13660475990300912157.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123883.1181370.13660475990300912157.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

