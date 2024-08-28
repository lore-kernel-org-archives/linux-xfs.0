Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444A18030
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819154; cv=none; b=Vy8tHq9flG6TcI5PBii5zAOeNElLMH4+0DahzaU97F3UfGgTDjWRPXU0QsiOTgQvkIGDGNTr1/SR/LQ7TwoGwLxJymmeOMOZvd9umMXc1FniNeeUhQM3ZGjlRTY3ZHIGIBf4k2sMybDauM89BlhZhHopqRmfy8GXkd1lFWF1qgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819154; c=relaxed/simple;
	bh=Th4faXs7S9u2oO0sPXBbhr3DBKsKumn8Cs64ZvN6LuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4GFPS7OcQ1RYp62isWl5mwpPwlFa/X4G3rkm/RqvACvP5IjdJEAZKp6dMmP41h6Mut2g5QkDTTupx7F0ro8zJUWDAVoFmA9CSyWrRbucrCljIvxVjmWUlSyb3OkaWS60sUVeykLifP9LzuaSIDkvRAvzT6pDhhPEdarpkA3t7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 31325227A88; Wed, 28 Aug 2024 06:25:49 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:25:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sam@gentoo.org, kernel@mattwhitlock.name, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [RFC PATCH] libxfs: compile with a C++ compiler
Message-ID: <20240828042548.GA30801@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <20240827234533.GE1977952@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827234533.GE1977952@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 27, 2024 at 04:45:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Apparently C++ compilers don't like the implicit void* casts that go on
> in the system headers.  Compile a dummy program with the C++ compiler to
> make sure this works, so Darrick has /some/ chance of figuring these
> things out before the users do.

I guess if we want to support C++ users of our system headers we'll have
to do something, so ACK.

