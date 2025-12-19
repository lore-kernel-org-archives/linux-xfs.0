Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5C23093D2;
	Fri, 19 Dec 2025 11:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766142874; cv=none; b=BFD9i1ZRz4kr03fFOjG6NfhjkdKxZHQyx+ZkiZWn1e6DAVm3w/O27IqJSZrtl6/A9hlLsoxITrzwY0CAVrbyhYjUd4LlPwad9WDGo+1rosv1qXKwB9VI9L2OTA6Ub7e+zvU0IhAlmPL+hnPaW4c2iyduUtJFwn6GdpMMxIb6npA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766142874; c=relaxed/simple;
	bh=Z+o/dFve07o+9wwHusV/cur6ad19ZY+AwAI3EXDqAro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLgx60puUhUwul6fih73GBylOk8CyrtmEF2LJeWX9UaKdMp0W2Nz38eot+aG4FKN41A2AtThp1WsSOfJWCk/9Ery+gyfbtyFbiEzpMjPurZuVvQsSwr8Q1ibJFU0K+i5No7zwomRE/UM9seFKuz/qMza35DXlwl8Lzz/EpNLJQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B8F276732A; Fri, 19 Dec 2025 12:14:29 +0100 (CET)
Date: Fri, 19 Dec 2025 12:14:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] xfs: fix memory leak in xfs_growfs_check_rtgeom()
Message-ID: <20251219111429.GB11715@lst.de>
References: <aUUqDiGqwfmDcY_p@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUUqDiGqwfmDcY_p@stanley.mountain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 19, 2025 at 01:33:50PM +0300, Dan Carpenter wrote:
> Free the "nmp" allocation before returning -EINVAL.
> 
> Fixes: dc68c0f60169 ("xfs: fix the zoned RT growfs check for zone alignment")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

