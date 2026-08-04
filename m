Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1754846D0AD;
	Tue,  4 Aug 2026 14:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785852553; cv=none; b=MSlpuR+/XNtp21BlGKMd33rEQBfrXKGF0aZiK4KJHK/5RQmnG8phldyJ7gUVrvCdM9Hsqv1olR5UX6kbAgMfTiZzXcEX8QgVezz1fexAu7EAV72pL3R3A0abqNIfBPpf8RfGBW+ItREZH1oYDyCFkSmPJYISAove2wDWdpfOz4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785852553; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXGRh/TpVXeX56bPwH5cOHXWTRf8zjNBv1KQPbPxFE0sjnxBcjgjVOEyCG4bFSqiKsahe/esla8aH6xqmY2MiofmqHjn4jXB/f3QoKdciH2zyde7aotBeFdMc8DqJaqXZRKo3xVT1hZQoSgUHDr5aVRyZaG3vkniyTWHYdqqLKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 556126732A; Tue,  4 Aug 2026 16:09:08 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:09:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/5] xfs: replace ns_capable_noaudit
Message-ID: <20260804140908.GB9121@lst.de>
References: <20260804094602.84766-1-cem@kernel.org> <20260804094602.84766-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-5-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

