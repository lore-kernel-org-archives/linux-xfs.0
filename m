Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7F01F418B
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820768; cv=none; b=k2WUPJf95ZVs51vCyQsHedJ/L9dDfv1C7TJpNJoHbh+9+mw96OCspOBJkxsO2og9LTSIKVrwEaK44PSljprQgLNELf05wN2vIdiVbej5/rQqaF482Iz1Y8nnek9lSpKcEP8aQcmzMMX3xGXWIm/iMzUvbZinh62ETvm8yR8BZOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820768; c=relaxed/simple;
	bh=15yZlCw/gYAiU46D85lGv/oKcLJ/FeAiMWIBrnSMTcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UM3uhennWDf1+Nlw2QuCPnfL/KmvFHn/AuEXhsDJCZsaKodxqYahawiLLWp96u3wi/sPH8XWesHcmdqqcfeHr8N520xqUcXe/n7tTTmVdMb66X5ai0jVtC844yznheFTAcAMtKXUiRaOFzOutGd73GsJ0FABZaYc+89lCiL2JUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlatDESd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlatDESd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15676C4CEEC;
	Wed, 16 Apr 2025 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744820768;
	bh=15yZlCw/gYAiU46D85lGv/oKcLJ/FeAiMWIBrnSMTcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WlatDESdwV7gIC7qSqKGd7oHuG2H3X5JVkmFsZTkpc4zXx9o05xVpikiN2bZ3uh0q
	 6N/rPpH2xf3zlphaTS2uPoIGu9yGam5aTIRg7BvP457FVZR9M6HJUrDZd7oAFnyhG6
	 yHirANfbtHZjxzzei+m89l/92PDNcfRMnmrcK+pou9ZofcMFQB454exo7wOGuJGCuO
	 I6+eqtSn6FiCpEPfCqiA3+RYj4Y0yf67K/A0P8MgIkUq+VRmUzGTKGEJz++Su2GiVD
	 HGwX5RQ0dPfVS77G9elSzRoQCPcA9K4bNG4QCcrtcJgU0Rq6nkkDh9Ng5ZlcWAOmsQ
	 bewCYynfm71/A==
Date: Wed, 16 Apr 2025 18:26:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix fsmap for internal zoned devices
Message-ID: <2jqrlf3kiyuzsu37ih7hbenxbhiboz4h4jfq2xyibtufkmw6ua@zytdh6nt33tq>
References: <20250415003345.GF25675@frogsfrogsfrogs>
 <Z_8zvnmHAYewIP_l@infradead.org>
 <f0m37ft7elImOolijMp0OvKgJ6Xh-5QafcNweho4vs9gaFtKbw4lNH4pPJx6N1gd-z8Dorq4iIshP1CQ5JcNBg==@protonmail.internalid>
 <20250416161057.GI25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416161057.GI25675@frogsfrogsfrogs>

On Wed, Apr 16, 2025 at 09:10:57AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 15, 2025 at 09:36:14PM -0700, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Hey Carlos,
> 
> Can you pick up this bugfix for 6.15-fixes, please?

Already picked, it's in my queue, I'm pushing it tomorrow morning.


> 
> --D
