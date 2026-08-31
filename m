Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154BB2D5C7A
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 06:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159582; cv=none; b=s7SttNHqqjhZmbpfgxhSnF2553leZhQszNmepgUJbS7flClXKvT4SZs0ve/z+97R9cMvCEQK3D9ftQ9apgO9NqmCTnkOBBFLXR89AlQ4D4ZH39aUMQ1op2fHkE2/BX5RmukfND837RWM1Mpi3gT0YfOd57WugYsekdmUJfvMbFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159582; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBUJTg7OaaSPY3bxPHT8ZEVTYcyttF6q6oexNcAruwcPQ4k/Dvw/vxzx6P/8o1MCapJPslo5YMg1i/iEB73wZToy3KWYJg1CwZNJPTengwtPV+1gZWaQvoW9Fe+ceJNJYC8klw7AayaCM71oJ+UnADXMkJGgo9KT66ngxC9raG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8E02068BEB; Mon, 31 Aug 2026 08:59:37 +0200 (CEST)
Date: Mon, 31 Aug 2026 08:59:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: merge healthmon insert/push helpers
Message-ID: <20260831065933.GF24602@lst.de>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs> <178780640668.3528467.13347610952808276371.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640668.3528467.13347610952808276371.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

