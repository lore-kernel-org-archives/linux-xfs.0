Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D5F344DA4
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492409; cv=none; b=DK1m0Pv8Qmsap8IKFvyClyTQHywRyDGWFpN/QvVf7zzG4+qi4bItFznKBq2OwOwq7BKN4xBNrQJsRRV6sLu24Na84JtsUFdtyHiSmwPLuAcQRVCCKc+kJxHMA1GYx/+Hd4NPCjrDd15VgDWWPnW94ZS+yffmMDAfOpOtQjszYQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492409; c=relaxed/simple;
	bh=GIT4XksCV5jymrTSFE8hPMwSbHL8qEpcIX5EhXhpW7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dV9qrxlTh8M7X9noJtP7m15oVS552a+EwX4qLbfDlNfNzVrceBfgGqyyEtL0E9cEARSfFltzn5UURdWc+i6EjQmsRhFbefFZFYdvjakhY7Fr9rwaKuYo7uQuautFgjlHEy2kHgSnhAOsXT+zLcAuZvyMtPSjagnnMd6KqJcBxuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEvvAciz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEvvAciz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F11C41F000E9;
	Fri, 26 Jun 2026 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782492408;
	bh=/oHcF3OQI7OT7F39d7yqmjDWRpTD6nov1HX97KDlR7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BEvvAciz7u25eDHos8DpFwWoZVKpWTSy75WTMb2BeNyGDrwMDWzeueFIFHTY1A9n7
	 X0pBKsJvJ1kjclCoLvO9ZIOooPllELDqbAqWTt090tA6uypLtoQY/pyZ23hY/tsQhC
	 j7Kyxa4rIWPC4tDW1eRA5WPIGVNjS3F8M+qD7MJqGNy940kBW/qRnuONzITgu2pjzC
	 a5lDyp+utUO0h/xbQKYd5w2DYkuCZt0Weq66Fh4KdUklrz6KH++ONSxnLLtxMEHuX4
	 mi4vfLqOe6+yoZoJGfisWlzzUa1O8kTBQu6sZ+cCDpSjyAy3BZccmDntlgWUauEs2h
	 wW6CKVdxRL8Pg==
Date: Fri, 26 Jun 2026 09:46:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs_scrub: stop user file scan if caller already
 aborte
Message-ID: <20260626164647.GX6078@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
 <178242801323.1981574.6328414059926266139.stgit@frogsfrogsfrogs>
 <20260626045816.GA8786@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626045816.GA8786@lst.de>

On Fri, Jun 26, 2026 at 06:58:16AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 03:54:28PM -0700, Darrick J. Wong wrote:
> > +	while (!si.aborted && (ret = scan_user_bulkstat(ctx, &si, &ino)) == 1) {
> >  		/* empty */
> >  	}
> 
> Style nit, but wouldn't this read better as:
> 
> 	while (!si.aborted) {
> 		ret = scan_user_bulkstat(ctx, &si, &ino)
> 		if (ret != 1)
> 			break;
>  	}
> 
> ?

Yeah, that's fine too.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for reviewing!

--D
