Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06DA17546
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855260; cv=none; b=DNvPQ4/Dym2rrhGRvwSAZsvmxHp3v/ox/3FnCTAyofDVixf7EZyinwd4RYTuenEfPPsGDxvMnpZ0z3CtfGvbswBBiaSf8yr3AdLK5sY2XbTqRgrmJrSYCGWhV/7KtLTv/TuHt5CcFsf/d9qqSU07AIC7OMxmlGaGY6kGqisiTyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855260; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FXisO1YpK2Ezt3LWdonamGwTHxhgEZ6881LxTwoe65yUZhSyB1GMXGixTjTqF+3DL8QmF0UBASMexzn6K7xifdBYxfO/pz+cka6vW2/a1bv6mag1LgDj+v/7c51hSdf613baozZZdzk4Y2lYDJDQodrFimfuf9AQeUE0uhTM5qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3ieUxOM7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3ieUxOM7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3ieUxOM7cTcxnCXEFjZuGQXvqE
	PoodNFqNGfs6iTGJptHNO2I0iLNJsNJMA4tyaEuuHFJDYmEz+2QbM5dQ8XpZUcumXJQO1ZfJZ/mXF
	BIh7aFpzJgNhjYOkL+pppTCRL/fjgls6V5hDiVSQiLhtYs0OnPJzQk2O5hltG4Zk1Dt5Qx46yaqiF
	3qARlFGSgXqo81t4oDgslB18mjTJzmxY6sOwtp3UmdjFkLNzgVBtcGqivsL9Zd/YB9MljlZXCqcGt
	vPMtu0OY6jZuqSE+04bDu2Qd77K5LD688ZZYkRNZMnUIIn4S4O2pCVeBgBo7LURWIVpvFkIbVSKn5
	+bdfPVkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn1X-0000000APtR-1MQr;
	Fri, 02 Feb 2024 06:27:39 +0000
Date: Thu, 1 Feb 2024 22:27:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 4/5] xfs: support in-memory btrees
Message-ID: <ZbyLW4mstwRyXs3T@infradead.org>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
 <170681337024.1608400.6539701966034810832.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337024.1608400.6539701966034810832.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
