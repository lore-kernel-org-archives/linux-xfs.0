Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E77F446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431909; cv=none; b=uluyqm9iUj2yrvQH/tFZv07FGSENH7MWwbY3C7ilzDebr6YOmvxnHqncL0Drz0AkbaYgSmBsQZKZ9ipMMEgzeAFSKquD/YArE3TFCQ4f3sSqdC83AyHOSkB+fHwfgb8+1D2DmeZn8skHldWYlK+WfL0gUOklAT0ZQXlgC2S18EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431909; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtCDNy/HGK9ORJwOH417h7UbBccuKlKU11iC3vW2JfujFVEPxgk+nR/29PUA4o9zGBMH53xaHK0TpvYeQt9RKtrU9M84n/tdwe12xGnphksWt/X2Dmn5nljrZCdD2MMFlMJr3UfL9/OvYJQ3YxnV9NG4+sWW9WLFcLZDoDu3QNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VJOuwxsl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VJOuwxsl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VJOuwxslxkzpXMqZSM2cRfRmo0
	CYU1Getwaj886nF45v9vvoWj4LShxvVUGq1qiui3TXi9phJKyw/gtgT5Txes9e8wO2JQpk6f5k11g
	917bzSxb99JyedHP6qElwX7Fx+bhGizRIENsFS2Zp15hZK91s1LOYxaPr6K2JSKutwubkKyA79K7t
	1GqXkSgXni4u87Rdbv+8ZdtkL1KbTFdgfA/uipnQtLRO+K4PUtm3jKTNgSg+4Tv/BU5QgWnZHK3mh
	CHhm4yBEbuWVql1Ts0cDBP6gh1g3zVbgbDKzn4MPWDoPjqifiSbnBprQi19X0OQ/uwFKF6nCxVXOR
	Hm+X8KpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozcR-00000003Aif-0PfJ;
	Tue, 26 Mar 2024 05:45:08 +0000
Date: Mon, 25 Mar 2024 22:45:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub: use multiple threads to run in-kernel
 metadata scrubs that scan inodes
Message-ID: <ZgJg48omOoEtmou-@infradead.org>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
 <171142134366.2218196.11088974993404154240.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142134366.2218196.11088974993404154240.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

