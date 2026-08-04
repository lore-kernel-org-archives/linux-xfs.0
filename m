Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82DA3E3165;
	Tue,  4 Aug 2026 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785848669; cv=none; b=ilvqo6i7Rt+U2nlWtD9xCdVd1xEDfFgcdVaR2A0WUQ5PLCkga/FnlW/cTsrgBpHZxyk97D5us5LyGEBfnYDSehem4SyiPmtbti9UwGQuJTf4vAe29Lt8OLd9wxTzX9aVR6+alrd5sc1a2R7amsHACIAEVzGnjJMA0WcDj0hx0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785848669; c=relaxed/simple;
	bh=pCzgM/UlbRF9/yIxA+0H0VVFnGNVq+C1dU2+IO9NTWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b65H3vmmXxSPdjnwiEouVNmaZENbK1AQjp9t7Z4oax1Y1rA1GybN5iOrYHVxSr8k/XYsNPPlBO81oPKYEIa9+/qPeR3zGveE0I2z1KOUgdmbZo5Z1GHhKO+M8hBVKx+gE8XMIv2dClaUHj8ZkAnDvWFLnK2kQN3D3FoXS5mVG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 839C16732A; Tue,  4 Aug 2026 15:04:21 +0200 (CEST)
Date: Tue, 4 Aug 2026 15:04:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] block: handle nogenerate/noverify properly in
 fs-integrity
Message-ID: <20260804130420.GA7567@lst.de>
References: <20260804123928.736596-1-hch@lst.de> <20260804123928.736596-4-hch@lst.de> <CACzX3AtEvhTmX8aGVi6zrWWu1=Cfoi8z9=Z17RsZB+pD0LU=9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3AtEvhTmX8aGVi6zrWWu1=Cfoi8z9=Z17RsZB+pD0LU=9w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 04, 2026 at 06:26:58PM +0530, Anuj gupta wrote:
> Pretty sure I reviewed this patch before, but FWIW:
> Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

And I'm pretty sure I picked up your review, but I guess I messed
it up :)

Thanks!
