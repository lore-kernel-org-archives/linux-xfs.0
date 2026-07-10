Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7103B7756;
	Fri, 10 Jul 2026 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718731; cv=none; b=ShOvmW9YiG6cSMCAyA/leErvSLlIb9vSi1Z5tD4ZvWhcfRpce6N3w0PnmiPpPneHstpyJzY8BaP8DNkhw+Mwzh6UUgt0rNXADvvexJuX5yjwNkzEIrkTpWr6cCWApxFcOfjBIkELpM6jfsDNJ1z11E9Z2fpglLRtNISOXQuS1OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718731; c=relaxed/simple;
	bh=tsTaICQaBinEYedMIWxdnINOCTA5FWTmKnpa2/FEjyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWxwvrPw6GwoPTRvXl2IzU9+gOIIZdCoCWIL16j0gx0cP0407eMHB9vHkWBlsk9S2+C6dRDpfbzDySNrEU5TFhkNo8Yhp/3Uy+dq34Le30NGKYzsjwy2I6iJYlJG1nrOPG7C0yWYd4kkIdtAhc2a54zieE/tMT+kQqZ5itJF4kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdZNgYnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdZNgYnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7A41F000E9;
	Fri, 10 Jul 2026 21:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783718730;
	bh=nCRZEwnwc3DCYrAKyBomPnUOyKlwf74P8ZoQ5QDerbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QdZNgYnLuX3WmPcbk86j+RBX44eJhGMVjnWYdZ5cAoVk6WD7e8+wPrg7wEgt1JTvf
	 iiexRDAXT14IurobE+Cr5WSgDwEpknDyr98j59zha0vbrIRSXN+FdHMYSdjztn/K+t
	 xoa2gst+efnITZbHQ+u0elFsOy4XBiX97Aof01wuFSB3PPp3m+y6v5sUSTYFw/uHfk
	 fjHvGeNYG5LFgN1ob8iKcoDu8S6lDmzgMwTBkY7zeEo+6i6yMq+aSwRcltYfyY142Z
	 6xYcevonlaN/nI27bKg2vZvjDVIl5q9VTFZ18beZjWmGLBSDK7lBFLeAz4KaY09S5x
	 TqScozRHKbCeA==
Date: Fri, 10 Jul 2026 17:25:27 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, aalbersh@kernel.org,
	jack@suse.cz, Christoph Hellwig <hch@lst.de>, tytso@mit.edu,
	Keith Busch <kbusch@kernel.org>, jaegeuk@kernel.org, cem@kernel.org
Subject: Re: [f2fs-dev] [PATCH] fs: report direct io constraints through
 file_getattr
Message-ID: <20260710212527.GB1911@quark>
References: <20260708011843.1036846-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708011843.1036846-1-kbusch@meta.com>

On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch via Linux-f2fs-devel wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Memory alignment constraints for direct io can vary depending on the
> backing storage hardware. Provide support through file_getattr to report
> the attributes necessary for applications to know how to construct valid
> read and write requests.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

This seems to be reinventing STATX_DIOALIGN and STATX_DIO_READ_ALIGN.
Any reason for this?

- Eric
