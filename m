Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7902A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897383; cv=none; b=iIkOtjECmixKcYUinnWsdrU1Xe9Uu5jm+gnGOggl0sYDUD4PjDqI0VKVSP3RBUFDo0bVEcYY+i68+EQbl7DYFGWYgUcvi1vRW9esGOCntAyMOnHXrB2yOFikMCEq2TW/5p2QiEmvDnFGxoIasEphrOpe5PHsOyyGXbn7qpIwkeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897383; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXvB6M7kywEBjpRPoukIAiqpWL3zPl5KD6h6vlFLKHZeFm18WtILCAlhjO1tNznITyrYi1LLQpTW9aSByAFHkiVndxi7rIP9R+VNRQZ/SZw+sX7OYHwBO49YYmzANptILxszchLCZq1QF14oH6X0YyzxJZ4xVHDJt9i8VXXAQsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC8D768B05; Tue,  2 Jul 2024 07:16:18 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:16:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/12] mkfs: add a formatting option for exchange-range
Message-ID: <20240702051618.GL22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116893.2006519.8574742517764976343.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116893.2006519.8574742517764976343.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

