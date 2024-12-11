Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF5F2594A8
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733945192; cv=none; b=b/u/uk8us9s5DnMoWErCFMq++9EP9OXThLTHfsDyqhgSjWlusdGfoRTnRuLHDyUK0LBlI6oQEZkf4oBzI3/67Qw5AAmB/Sh+372RLh7vf4E4W2H76GbrD65kOuXFhceLN7xLJc4tN3AFEvZejWXXXQhrgFzbtMCWWWfw8i7yvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733945192; c=relaxed/simple;
	bh=DqK8sIFSTcjyqLhSdD7VVkcs+M5WN3lA563kfmunVVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAiozO2jKdrhKXRaD9sFToeY4eU0bAyluJL4jp3JLSbMcgrVFdyPN+BB/u1aTlE35w3ef0lvlmNlOnXW6BSqh7/01X0Ydjj3gC/ab5NcGVtn7F0ZllcVyetRgto4OupoaSFm3VJ7jC6wSEk9w2Pkoz7X1lAhwpyUHpYvidphnBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfuCUu1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfuCUu1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4233C4CED2;
	Wed, 11 Dec 2024 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733945192;
	bh=DqK8sIFSTcjyqLhSdD7VVkcs+M5WN3lA563kfmunVVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfuCUu1sTt8FZUy6eAYgelS0YDQN+i1SxKmX5ZRqc/rfSPQI8GMqeCsILkTOTDW5/
	 AlGIbo2Pln/wQSmFSufJLyqRHUncYJRRCdbgJCF8yD3EGTo0xvTBHK2YmyL53IFl3D
	 ZMSAX8F7Zc9t5hYg1yRS7hnkHIBqyzuEUT662eWbs06oh3eqmC+7tUSTOhvgYS1oEf
	 Z5s+e6u4cEu+QfeXQVWsX4uTp3XlQbzPEmCy+RD83SN9w6jFFdcbUuI9kBnG7yVOn3
	 ClV0i+7Vcv34PUixcV+G5S6tSIINSu4emvUCtFW48N5QzBHHTkd0+L5vTCNcvuBWPy
	 xA9ETUVi9iyRA==
Date: Wed, 11 Dec 2024 11:26:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/41] xfs_db: disable xfs_check when metadir is enabled
Message-ID: <20241211192631.GG6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748376.122992.14095194470830359878.stgit@frogsfrogsfrogs>
 <Z1fJxuvjsExuYbye@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fJxuvjsExuYbye@infradead.org>

On Mon, Dec 09, 2024 at 08:55:34PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 03:41:59PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > As of July 2024, xfs_repair can detect more types of corruptions than
> > xfs_check does.  I don't think it makes sense to maintain the xfs_check
> > code anymore, so let's just turn it off for any filesystem that has
> > metadata directory trees.
> 
> Puh, long overdue.  Would be great to also have a deprecation schedule
> for it in general..

We stopped shipping xfs_check a decade ago and removed xfs_check from
fstests back in July, so I think we could just remove everything between
check_rootdir() and the final quota_check() in blockget_f.

I guess I could try that and see what happens.  Thanks for the reviews
here. :)

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +
> >  	check_rootdir();
> >  	/*
> >  	 * Check that there are no blocks either
> > 
> > 
> ---end quoted text---
> 
