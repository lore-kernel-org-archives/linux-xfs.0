Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9973F204C02
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952804; cv=none; b=Yr22rPvICN6PITwqnC+Sjszu7Iy/Drb9HuhkylKcIAVPooJIhSiB9BaoeXObLfSZn91P85hXZwdSsgrlj6Dv+Q4cPO9Q1gmvUFIfVBbYpUTAVJDCyRj2iXZk+AcebuTxFHow3eWj0SOCydMLhHyL7jPfUzwoxPYzLYRI78T690Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952804; c=relaxed/simple;
	bh=L9fE5Q6LU1jgfaMxXJOmyrTo9F8hr352LuNPii1yMGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGEUgeFvAaX16uf7c4keUy4nSbnnNmcZpHlnqpxGAv2kXQ/lmYNGOyGYIjCVQM4P0+/vGR2I9xYr14hHqZ0IpYkerE932Q3s0kxoXhXyIqRZbBlCOQq6pKdFwIt/P9L2bEqIBAkEPG1aI7URL4IlQmjxDG6jiLKrbZEq8jmWdww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rNvuKM+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rNvuKM+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C73FC4CEE2;
	Wed, 11 Dec 2024 21:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952804;
	bh=L9fE5Q6LU1jgfaMxXJOmyrTo9F8hr352LuNPii1yMGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rNvuKM+I1Bcsde6KwegInYBdm4t+SZ1UGCN3V7fSEj5Jjdhwa7bMARnas9u99A5cP
	 /1LHy+wFctBztIBUKS7RNWOFbttYaHGFGCJeqAgP4tAq1Bn8LIIpQp1YHPlAsTTW5b
	 i+EiW+r8allGXlV6yGBDotn7wbBBuam0R6ukzH+d+eReont6XwU7q0Oef0c19Muum0
	 p/Mz3qPi+ncHVBVt7xPjw6jAzlNM0Aq5GPIklMhqF4eCKFm5AuHTkfJOEb9js0E4rE
	 fKTghQYwr9y9yzU+XVxW9QSyy2Kqg1dQespgFiNYm9VzoXqqwujPUd0dQlq0X7jwD2
	 8zaNNb3BOiUsg==
Date: Wed, 11 Dec 2024 13:33:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/50] xfs_db: fix the rtblock and rtextent commands for
 segmented rt block numbers
Message-ID: <20241211213323.GS6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752326.126362.1070873250646267314.stgit@frogsfrogsfrogs>
 <Z1fUDDP9jKCSVgUB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fUDDP9jKCSVgUB@infradead.org>

On Mon, Dec 09, 2024 at 09:39:24PM -0800, Christoph Hellwig wrote:
> s/fix/enable/ ?

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for reviewing all this, and building stuff atop it. :)

--D
