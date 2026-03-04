Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619EF3DFC88
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 19:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772654283; cv=none; b=s3c0F0wP7R81MZtd9LuO3cc2KL6hcB5MFdjJt5nl/I5NoqjVBbGTBtjfOdDBoVek8huMIWZWuBbifDuNwid/HW9sVKM4NTH5N+0V/XYl2HfFMUz0nAXDFEUMfFn668mKKRvi7nHxXtAvk/at7jG9FyVj+vQafc02Y/HPPqoAQSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772654283; c=relaxed/simple;
	bh=2b3BcYshVI0ys5MlNRzX1fUgAd0mPVO++Y+X6SGMCZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUB+Bzsc2gif7CXCUBj0eOZ8+A9O7biU8Gmz7+WP6cXO1+Kw7wwCOiRhq+HOBVhBLW2lY5eDy926UA77BTBnFDFxO3b+LveL2xs+4K0N4pjLs/5Xm6mCsDOq7b1iUNDBrPnQxbWRok31+ZH3ZHLBIp5op7ubTes0owDvquQV2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UibRKpJw; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UibRKpJw"
Date: Wed, 4 Mar 2026 19:57:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772654277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tj1LMzsNN+o8aC+HAre/O2tWQUU3/YabUMS/UfEj64c=;
	b=UibRKpJwo2sSAlsGpjzAO9leJpxF1ZN6/v8w5gR9omriLG9FYqNMKr2sjaMkEfLrFHviqx
	aMjF6+BHoDVOoxzzZ7dzHm1kzE73vgtc1QCTEI3pg5CASZ8jW3w8Uzxs9Ej2rI1If73ywG
	dACX2i6nkkIBRon1r6GLpOkdolAE0SI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com, dchinner@redhat.com, "Darrick J . Wong" <djwong@kernel.org>, 
	gost.dev@samsung.com, andres@anarazel.de
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
Message-ID: <i3bbr3komctputcxqz4mnto3bdzmfhq7u5vma6bleay5zxme2r@rgtjf7tuyocl>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
 <aab9Lgt-HUaNq-FL@infradead.org>
 <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
 <aaf6QgbmQQ56ZlhH@nidhogg.toxiclabs.cc>
 <ecd24894-bd95-40d1-9f3f-579a6b666391@linux.dev>
 <c4839f9ca3959790aefe153b505aeb8c@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4839f9ca3959790aefe153b505aeb8c@herbolt.com>
X-Migadu-Flow: FLOW_OUT

> > > If by any means I got the timeline wrong above, forget everything I
> > > said
> > > other than the "work with him to get this done".
> > > 
> > 
> > His patches are not working properly. It is almost a week since I sent
> > that message on his thread. I have messaged him again on how to proceed.
> > I will wait and see what he replies :)
> 
> Sorry, the original CC somehow messed the filtering and it fell trough the
> cracks
> of the email folders. If you agree I would add the `two stage Ext4 like`
> into the
> original patch still utilizing the xfs_falloc_zero_range. Doing the the
> default
> XFS_BMAPI_PREALLOC and sending the XFS_BMAPI_ZERO|XFS_BMAPI_CONVERT if the
> WR_ZERO
> is set and the device supports it.
> 

Sounds good. I think this is the right way to go.

> I think that would still be quite readable without the of duplicating the
> code.
> 

Yeah. Maybe also you want to split your code into two patches similar to
what I done here? IMO, it makes it a bit more readable.

--
Pankaj
