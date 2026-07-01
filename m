Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6D724A044
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 10:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902025; cv=none; b=HP7jHXMKnsfIWCqcHoxD/DFDJiN6M7kiKYFt0V1vMd9eiDITCDWcRfL96ANar1WeQVDsPyQiaBtYKABs3IUQiPOpi71aYP0x5e58CFZXjvXsoe+NVKXjQYIem6usDdg6HnZujhNBVSyw+jT0MWNmtYp+GBmHoIgRowkO3Q+P8vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902025; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIbLbr//dY0aRS3kp+7oNpfZFqcwGvW/YDPaupgDxeKm7sD+SACYBl5jmme9UmrFJ9b5lP5DyJOeDFOd4UHfpPkxA0kljLZvI7fppCLLcoMd222cohLtfoAjP6kg12DzV/VoreC071pR8Yf/1A8SVSa7k3h2Ty+Tml4OHkDlq6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC60468BFE; Wed,  1 Jul 2026 12:33:31 +0200 (CEST)
Date: Wed, 1 Jul 2026 12:33:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] mkfs: pass stat buf pointers around the protofile
 code
Message-ID: <20260701103330.GA12719@lst.de>
References: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs> <178288493202.702844.3058287741686145383.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178288493202.702844.3058287741686145383.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

