Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E78817581
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 23:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460669; cv=none; b=W/AdXqgq+2QfBNetRJ5z+17GE9tCFmHh1XXUmIeJClkD8/SaBW2yMee7s0tcZ/NCo7Zu1kxuFF7bUS2zPcoCNhPsd+SZOqADehw/crsKbXKrDH2jUJuglX3G+/HmnNA0FL9WX8l0e/mOvhbE1LkhYQLDla8FzxR03hup6yYgu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460669; c=relaxed/simple;
	bh=ERhP30EZpDJXTBJP4+eFrp+CDzcI3mhdgG/xuVkD2ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3Qg15E4LLNpuxX5FPmp1CKH1ZdC7HbNQ7ouVLWfUYF4Ft+oOJb8tj8iALULKVB6fIm0jRFcx5Z7kGaOyIiVRBmn94rrF2iltP9am8BoZzEl58/lxKDqVBS/+K6AJCiHEkT3foG1v1w2exofwEhAfNhqEj2EUKH/vx7JVLv0u2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5bsDqLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5bsDqLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F03C433C7;
	Thu, 14 Mar 2024 23:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710460668;
	bh=ERhP30EZpDJXTBJP4+eFrp+CDzcI3mhdgG/xuVkD2ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5bsDqLbNV/hm41LMHDL2Dy82fP6aV8OtHK93HIiay6qVNrqU8NgqI5oljuz8Yu5z
	 0URKK/ndVvZYUWxQI/7rFAP+HxdeptNEzZzzuzPfrlYWJEyWK8EpjKUCw5d38Z4IJp
	 IXapQjsmfwcrzQJNqJu2JMG5RVAvLc6QhSo/k74o9LhmPYUKbeLuzXhbv8lsuD5Ucm
	 kLguUNBKm46us5OhL0LgoCI44NhiGtltGdyhHX8pW7YbS0WXqhQ4OBy/oVQmyVtEFC
	 Qgb2J16ZM4k5VfYIovtAi9JWVC3D/SPBMuZi7JsmFVG2UpPrCQ28sX6VGjqi2+p2Xu
	 DwqwMQphKsIBw==
Date: Thu, 14 Mar 2024 16:57:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs_db: add a bmbt inflation command
Message-ID: <20240314235748.GU1927156@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434743.2065824.10519572186358226724.stgit@frogsfrogsfrogs>
 <ZfJah0BaLbNUFHSO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfJah0BaLbNUFHSO@infradead.org>

On Wed, Mar 13, 2024 at 07:01:43PM -0700, Christoph Hellwig wrote:
> > +#ifdef BORK
> > +		dbprintf(_("[%llu] 0x%lx 0x%lx 0x%lx\n"), bd->nr++,
> > +					irec->br_startoff,
> > +					irec->br_startblock,
> > +					irec->br_blockcount);
> > +#endif
> 
> What about just dropping this code?  BORK isn't really used as a cpp
> symbol anywhere else.

Done.  Thanks for the review!

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
