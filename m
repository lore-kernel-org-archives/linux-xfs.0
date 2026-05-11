Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388B337AA70;
	Mon, 11 May 2026 12:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501426; cv=none; b=i0HVD3AmYgv2Lpm5hZHOOPedv5gwRnKRXPTMmQuA7Oup3HrKWRfpr+aGR+oW4u9J/WTBMD6i4hA99MNhdAKF5KGoL3/z63qAA+slCXHHiu2nEauiYrHBZI+RXZRLW+F1rHeowHbg4gwU6AHN/wC4yVJa9bmflLswGDQEkSXsNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501426; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ct56wwnw4dIVe1uYBseLukh6my6+44/ttfKWGqUcPSJmf0BHv0zYwtP5dOE7tJOT59wEr85pFBUq7F4YMvGnkKJWPwuyuULdza6aQ3VCGIujlm8KETpg82Xn6VELdp7peq/Fwy0/CO1CxgsTknemaryOsqcwwPXCYf7ps0pMA1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E54D68BFE; Mon, 11 May 2026 14:10:20 +0200 (CEST)
Date: Mon, 11 May 2026 14:10:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Andres Freund <andres@anarazel.de>,
	Jeff Layton <jlayton@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, hch@lst.de,
	open list <linux-kernel@vger.kernel.org>, pankaj.raghav@linux.dev,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: fix forced iversion increment on lazytime
 timestamp updates
Message-ID: <20260511121019.GA16027@lst.de>
References: <20260511111918.1793689-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511111918.1793689-1-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

