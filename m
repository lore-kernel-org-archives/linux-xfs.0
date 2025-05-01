Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B240C1A38E1;
	Thu,  1 May 2025 21:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746136554; cv=none; b=NXDZjXNUOp10fECX6Gv4wGnWv2p4B04+ANObGuWW9lHThzT3YDSKIIt6iDyX7JBdOMppKKEJQNpvuuw23/CaGGxCma8QyCZDmo0JJG5tCmDn/a08mBuLwuVbY6DYlhUitafn3u9dY1V8Q5egYyo5Y2MKhTEdUxO4T+rUNJfRxe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746136554; c=relaxed/simple;
	bh=4fgsn7pAUO+9L+iT4ApL/JqbmEdOo0vND9xLsdAVBIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cK5QUt4JkE7Rk+1O/+jB3ZFx2Ye52/R3FK/p6C+USHPudLHQoY8J3ffAtmhV1W99oW7ozJNaawY/P+6gmrJBMlj2woIeaz9E/Md5aVaS8ceawor107pBe+ZPjHoEHQEpBhCz0+ZCPYzwYr9PoaviJMXoU/HNyzqdTf9nQW7ZfBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rgjqiu4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rgjqiu4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA97C4CEE3;
	Thu,  1 May 2025 21:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746136554;
	bh=4fgsn7pAUO+9L+iT4ApL/JqbmEdOo0vND9xLsdAVBIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rgjqiu4/4d6sJS0wOPPyM6gjODD+cMZpIlImr4g4GT7wXWvMxsiMcW7crvHFUWTvs
	 BUYQvMJwDKGPF+wlQaG2oilpM7oSxCAEA+MRc87JSqWnQpfYbmL6ildMI3UJSNIwbe
	 ClxSwZNpSf5e3iRmvzr/QG+qmFWfYKufpJWxDEY1YI99E3t5dXK2LVdZtOmy0GCtIj
	 V6/AJugFcFTyW6/e/F5fr9GK/Zo2Upjr/RuIruNF1tco4yo5UYQxGaNVHJAX/AHQ9w
	 Gfq9rLEm7F3CAw5I5Ji5E3gZ6N14LSSqS9ts/DbW0sQSn5p+W+I3hpCqiKqq4cQTTH
	 DquqeQxYhB4Dg==
Date: Thu, 1 May 2025 14:55:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: new tests for zoned xfs
Message-ID: <20250501215553.GI25675@frogsfrogsfrogs>
References: <20250501134302.2881773-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-1-hch@lst.de>

On Thu, May 01, 2025 at 08:42:37AM -0500, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds the various new tests for zoned xfs, including testing
> data placement.

The first 14 patches I think I've already been running for a few weeks
against software/hardware zoned support and haven't seen many problems.
I will have a few fixups to apply after this, though.

So for patches 1-14,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

(Will go look at #15 separately)

--D

