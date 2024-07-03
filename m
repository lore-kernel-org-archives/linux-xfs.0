Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE28B17C96
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719981014; cv=none; b=dNLC8nCwO/9uR26MzYOqv4lsfumT7aEUgoJMRfdg3yjncVkp59//DOWJsu3QcskWkzTmYh0NRJ6p9dLy5jc/+Ilqod2Ejzn8BHlny3ZkGhKnjs0VtyrXsDbKTVJf9I6zTkRCbPAyyV34dX9gUz0qo1PkeR7vCSeS8gIoN4NaGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719981014; c=relaxed/simple;
	bh=UEzWba6vX0SagU5N5riL36H1U93aDx5lUwEXpOm1rso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Caet7BFpIvBJo+yX6rVa8p9EOCW0nIwYnz1RPtRs5onXO23H2tubqavFcwomsxCXWjil1DhjLZDuwGGYzvXAZJ5Q2n0Gp1oeSh88wvwzXPeH2p3S7UpsxeJqpyVeoUqlfVBpvhM4b4EXD28MlHLjNOTE17hL/avzYujHdvY8eME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E8750227A87; Wed,  3 Jul 2024 06:30:09 +0200 (CEST)
Date: Wed, 3 Jul 2024 06:30:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: hoist free space histogram code
Message-ID: <20240703043009.GC24160@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118595.2007921.8810266640574883670.stgit@frogsfrogsfrogs> <20240702053238.GH22804@lst.de> <20240703024738.GU612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703024738.GU612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 07:47:38PM -0700, Darrick J. Wong wrote:
> Or change "blocks" to "value" and "extents" to "observations":

> The first option is a bit lazy since there's nothing really diskspace
> specific about the histogram other than the printf labels; and the
> second option is more generic but maybe we should let the first
> non-space histogram user figure out how to do that?

Actually the second sounds easy enough even if we never end up using
it for anything but space tracking.

