Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDACE12E1F9
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903430; cv=none; b=W7Ev7IHXXjpsld92Z+tjDvbEHmoxebFKlpF/cp3T5vDU2+5iKAIrbAclZ7p4+qQxErrq46zZ8v2hISNhRf6lKt4K4AUSCGGfTCkvkLS8k9INlQnz9yj8Z6LmMDAuKxaibZYp5kLPBdB3jNpVczGd6Oh0bqnkcFv0ijdlRWfQYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903430; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNuwBkKdMzjZum2tT24EzcMmhlPZyymzz2mtsnzsBN9p+EKzZcaVpVJs+L14z+VCr2Vg4RnLKEjsIHFdxgDwElU9FfyeQVHjf+sBRAUemmasgrhbtcUFkQ6mTKzNVrhjU9EAtsBdyMpqWXKcBPhTxhL9FuGnAuWtxJeIcd3qdIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0F61C68BEB; Tue,  2 Jul 2024 08:57:06 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:57:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/10] xfs_io: support vectored scrub
Message-ID: <20240702065705.GC26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123180.2012546.8535944367157322296.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123180.2012546.8535944367157322296.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
