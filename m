Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E262135F5E0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780381894; cv=none; b=cOts67FuoeMjlmQQ4iD0HH/NBExYUoKMRvgKfSo+c0ovpN/OmaloXuiYDucu21j8vlchDCs7nGRSwAXIFWQKW6Ut/Gb1IODVtojnAnZHb89G/lPnweNK470ooubLSXY1wmy0MdACXnETOutbetO/OPHebhOqd+xeD/hwj1FV95I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780381894; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/Dh9o7WrqMYMTglUS4E8ZkJY5bG8i5PEdw/1st9M2UaFvwjly1PecgW2U7/H3eXsCIGKYMPoJ/lbW6YycTorMZSk6YFwpMqdHq3voq6RCGQ6ZBJwa2KwARGRROUqRAxe3rh5EntWZ8mroUo/zx219HU1EPl0oOoZsncz0IxuKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93E1268B05; Tue,  2 Jun 2026 08:31:30 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:31:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/7] xfs_healer: fix error reporting
Message-ID: <20260602063130.GA2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627061.588879.3503165728247541179.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627061.588879.3503165728247541179.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
