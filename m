Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3931487D2
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 16:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891773; cv=none; b=k9I1jFdjPN/2yWWA3cwlFZtJ++/W0pjjFymF865g1PNdNjaAxqNGqTz2DfZclIDmuUAmuqNeQcoKpxabdUzZJcIYMXgIto9ti+txjiv7b+UdrCX2ZvXZoVkcr52UVNpFD4JZT5dMNVxgiLk8AC/b0OqfhAlvG3CL+M7vKfiqouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891773; c=relaxed/simple;
	bh=BLwUoLty6+QLTMvncS8MKiL1avC/pX7ceO1qMEssAI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLcIGA1FRF6ovnsZb0ohhzavkIqY+uU2W2HCNczu/JT/ECy9px4ZX2dChQwD/rtT4iNB9Setz8zpVDC4pSMmktl/eohxUJsc7IFWv5FlMZNNSqz+/XcZfLWJywZEQRtsCjut5NJJvOp10DP+yMlGnPSXXMYAFR4oLRUIngAfh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0PdhZti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0PdhZti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEADAC433C7;
	Fri,  2 Feb 2024 16:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706891772;
	bh=BLwUoLty6+QLTMvncS8MKiL1avC/pX7ceO1qMEssAI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0PdhZtierEjWWukcOuas12HAlKcayDLGLyvo5/S6eZ7eFRJO3nX8Ag9eQ6NqFGMV
	 jysaMnpttcmqwjJfNAy4MarRe0wj9i8MdOeppfWoRn/3CzartTTMsj2xDvXFSzO4QW
	 Nnq+wrjz64pJvOWsQdqfl0bu4xhvdFmQwgLk8GMeFYABQm/D/egQ3s0LlW/ZcG6EO/
	 zyOmGegAohuMsrSr6sDGyDLKg3QKbjdAVb5DmvwGtnvWE5CVS47XSfzuOtjg3yzLje
	 1VtS+5m7VaUFzV0TWIyn0Pw5tItjhaPaaIS1Cf3kQvPGkRaKhQQiZ8c/ieS+8QJlWl
	 sc+5E3ngZyu7w==
Date: Fri, 2 Feb 2024 08:36:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/23] xfs: encode the btree geometry flags in the btree
 ops structure
Message-ID: <20240202163612.GH616564@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334034.1604831.10246753237960404458.stgit@frogsfrogsfrogs>
 <ZbyKR8N9tnl2iOh4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbyKR8N9tnl2iOh4@infradead.org>

On Thu, Feb 01, 2024 at 10:23:03PM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (still no huge fan of all the explicit callout of persons comments here
> and in the previous patch)

I'll reword those:

"A reviewer was confused by the init_sa logic in this function.  Upon
checking the logic, I discovered that the code is imprecise.  What we
want to do here is check that there is an ownership record in the rmap
btree for the AG that contains a btree block."

and

"A previous version of this patch also converted the open-coded flags
logic to helpers.  This was removed due to the pending refactoring (that
follows this patch) to eliminate most of the state flags."

Thanks for the reviews, btw!

--D
