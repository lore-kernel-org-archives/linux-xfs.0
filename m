Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2FD25760
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943129; cv=none; b=Ql7TaqIRXz/cd21M4rxwgOIomOBV+QU7bEjOdhgWONaRBQWv9nU7go4KNOcmhl5PXeEdntv7jKXvZjOH+bOPifHqk38pGFr2HlRYmC+bObr+UOwT7fXmaEZZheSe50Dr/nMMLsYfEs0T45tENC+4FhwGEM0x0OR5hb8iubBD3XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943129; c=relaxed/simple;
	bh=qLRiRUBtJ6+2cV0MYWwW/zw4fu+UVHWiat3B3LcX5PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XICm4nLG2qzthOobBlPT4BJtqWXgWgp1rBJqaiEieHR12TOl54+nQNbgepyy9nlNkpJHvrwM3sCan6YrSiQHQy5a17gtj9xYi6XNBzk+pz3qGDPXo394nTH0VbRW0RVKoYs1sey+5qt0Fu9rUk6RTDVqyPZnEov6LGldzhfpPp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94E3267373; Wed, 19 Feb 2025 06:32:03 +0100 (CET)
Date: Wed, 19 Feb 2025 06:32:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: reduce context switches for synchronous
 buffered I/O
Message-ID: <20250219053203.GA10173@lst.de>
References: <20250217093207.3769550-1-hch@lst.de> <20250217093207.3769550-2-hch@lst.de> <20250218200551.GG21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218200551.GG21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 18, 2025 at 12:05:51PM -0800, Darrick J. Wong wrote:
> What does the return value here indicate?  I /think/ it's true if the IO
> is really complete, or false if we're going to retry?

Yes.

> But maybe it
> actually means true if the bp reference is still live?  A comment would
> be really helpful here.

Sure, I'll add one.

