Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083ED368;
	Tue, 13 Aug 2024 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562731; cv=none; b=VyP9qa9UUkaOaT1UW/jL/b962s2op22+JXryXwwJm6wTH/o9SDFWng21Cfjut7WhA3YM0W5vyC5vfrWj+t4ZW80m1OMnVWdFk0dpwhwtUiKre4rCM90MNtyG11oPsEfRY9mOxA5ZdQ5TecqVrtC7Y+Kh7JezPmbVIIQhYzcooT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562731; c=relaxed/simple;
	bh=lxQR9HxC8qgVN7dp/yr9LtTKsKx/912Gmt6tQWlmm1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJzE/YmTyvV8hxrCrLF6MCtpeTmW2+MRP1xC4RCm64WM4csIHLh/h2jaz19WgYEpsBh7ZjbnUwGcEUKxVXcrB3z4v42aucd2MZ1OO5KQaZz05FFqBM2eO4SA6QTimWivbN7W/37huZpuG5okFpmSBfMsjyKWYYXaBBW6PUSVQ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2G7Wdcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2G7Wdcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70AEC4AF09;
	Tue, 13 Aug 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723562730;
	bh=lxQR9HxC8qgVN7dp/yr9LtTKsKx/912Gmt6tQWlmm1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H2G7WdcbTJdaPlVogjVYT0nyn98oT8o5pHyvj7yioIMA6E7cJRCWDZMNDVXBAhU6m
	 jSfxDtv3uON8zG61fWXJhw4QumVhpyTrrvz+tVeh4u+u7SIY8b97RkfnJeZlUV2gag
	 DLAMJprgcwx5xs1nZPZqSu2Wu0Iwff2jBlBetd7YSRh49RSkLACfJ6uKZVdco245vF
	 vIvCecCt5csVzgJ6SpDp+pUh2UY1z/bW74c2nRWXefDXJl3ENUR90oPzz66aBjN2JB
	 I7jCorfYdFQMILefwp+YWwYOwpgRMXmWmtzJAk1Wn7N8ufjAO67eDSw10fsAznTIhN
	 EcvZm+1rfKFiA==
Date: Tue, 13 Aug 2024 08:25:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>,
	Anders Blomdell <anders.blomdell@gmail.com>,
	linux-xfs@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: XFS mount timeout in linux-6.9.11
Message-ID: <20240813152530.GF6051@frogsfrogsfrogs>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
 <ZrlRggozUT6dJRh+@dread.disaster.area>
 <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>
 <ZrslIPV6/qk6cLVy@dread.disaster.area>
 <20240813145925.GD16082@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813145925.GD16082@lst.de>

On Tue, Aug 13, 2024 at 04:59:25PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 13, 2024 at 07:19:28PM +1000, Dave Chinner wrote:
> > In hindsight, this was a wholly avoidable bug - a single patch made
> > two different API modifications that only differed by a single
> > letter, and one of the 23 conversions missed a single letter. If
> > that was two patches - one for the finobt conversion, the second for
> > the inobt conversion, the bug would have been plainly obvious during
> > review....
> 
> Maybe we should avoid identifiers that close anyway :)
> 
> The change looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me too
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

