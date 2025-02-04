Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF125A624
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 04:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738644808; cv=none; b=BKPOGQBL+ShGdvk8qhf9jaDmY5ruBKhUkAu/d7G/QC5irbj/hZ64W//oGJuJecA7oIKYHvVWu50+Adj8iOQdP5hCv0vlP5Uv+LPqBBJho+yH0Ap8kiQdLMHGuSdv6wZZfp6/uFHQzpb890ZwHgg/rI8Fd04Sos6csVzEHyserhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738644808; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBJn6nABOYrfG40z4DI+0Yy5tpKr8qHV8PG5V4Wn9weqNwbgulMf4z272XVfSzWsdbPggKYlURvSee+Ft8eT9rTTutW9uSKXDfD3zK72m2kOcqX67VKKHvvGJ1ASG7ZNRdWjqJu7GN0qT0/acL9CH7CByw3b1YJOb77g2Exym/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8D37868AFE; Tue,  4 Feb 2025 05:53:20 +0100 (CET)
Date: Tue, 4 Feb 2025 05:53:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] mkfs: fix file size setting when interpreting a
 protofile
Message-ID: <20250204045320.GA28103@lst.de>
References: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs> <173862239048.2460098.9569795439422233357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173862239048.2460098.9569795439422233357.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

