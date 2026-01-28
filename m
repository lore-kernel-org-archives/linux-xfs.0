Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2827286418
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769576832; cv=none; b=ZETX84Y0loAmieJ6HMrnmIKyiss2KiVE4Q9bR7qPBZAB3Mg6/WVH9T1ZF/lsm5jXaFZlv5S3w3inAvkUXyvHvvJOAbQi9DqO9sitGgehLayHOB0TmXtm393Pq2HyRmgUvgtQDZpn0NJ7ovSFtiENXll5CxrQHTeWq5d1dg3QSCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769576832; c=relaxed/simple;
	bh=15/dLewMtv8A9c+e6iMGVSoJO148DPxnG3I4uLk9qOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6+SYCeDqmvUFVluWSxzEItosSxzQ+iEubvFNT73RlU2ctuaqrgv4VIbGauMpuDBqlMjDEyVCcWw/FnS78v/vlNkcsIyuIDCb2o01DWLPU+dFGnP0VXUM7icP0Tvk9dFPEYZc3o9lOjjNVftk09xKu7kE6vIan9yOV5Rn3C6JZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0HAppYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0HAppYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AB3C4CEF1;
	Wed, 28 Jan 2026 05:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769576831;
	bh=15/dLewMtv8A9c+e6iMGVSoJO148DPxnG3I4uLk9qOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H0HAppYyZAcMF34a8RDiXvUotn+zSTA+LjYPDOARWKlrz2xMh5IScxPLJcjGp8VPp
	 k9XC52kc0MwjV8aezGMfm/ZjWQBbLtG4vmvqVnruYyce9iGMVdkxXepTxCnS4et+QC
	 o6c+4+G4eDHC1Mao61YHkv7Ch4b9kS3O+/HTrt3T1c2RaH3kOoJRKerhouwUCG15Wf
	 kSUMjw3U+Y93ljOb41E4qQ8yNVYoixNm+WheTQFo7gDUHIK5y70MPiTJMUmkcU7R0I
	 /s8Il8cgdN9To0wIzI5LwuR3bJo01oYgzo3FtTSRTZpv6CnsNJD9m6SN5Xbc6AydVq
	 w2k1yDMShE76w==
Date: Tue, 27 Jan 2026 21:07:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128050710.GN5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-7-hch@lst.de>
 <20260128013730.GF5945@frogsfrogsfrogs>
 <20260128034557.GC30989@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128034557.GC30989@lst.de>

On Wed, Jan 28, 2026 at 04:45:57AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 27, 2026 at 05:37:30PM -0800, Darrick J. Wong wrote:
> > > +  errortag=tagname
> > > +	When specified, enables the error inject tag named "tagname" with the
> > > +	default frequency.  Can be specified multiple times to enable multiple
> > > +	errortags.  Specifying this option on remount will reset the error tag
> > > +	to the default value if it was set to any other value before.
> > 
> > Any interest in allowing people to specify the value too?  Seeing as we
> > allow that the sysfs version of the interface.
> 
> I don't need it for my uses yet, but it would be nice in general.
> The reason I didn't do it is because it adds complex non-standard
> parsing, and I'd have to find a way to separate the tag and the value
> that is not "=", which is already taken by the mount option parsing.

Huh.  I could've sworn there was a way to do suboption parsing with the
new mount api, but maybe I hallucinated that.

--D
