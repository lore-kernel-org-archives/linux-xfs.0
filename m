Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8AD1C3038
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952330; cv=none; b=FoPAf/ZAElk1XNE96JmNqJwriDN50zmto9+ULQUE5J68CgXe8YHqUgGwi79jURhQLfrUPdCR+cfXnwh32E1XYEKQo1IURtoHKGx+b15dKffZBNbJ9xuzTgVy9Rq39ezXBkWbVTGuNeHkA5OoVcuwEjDMKzTwqmwAUMnZrGZjGvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952330; c=relaxed/simple;
	bh=mYAi4EOO0tP6k5Urg9LmrkisiVygq5e7ECluhn2YAqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJWMHW6pB9yYAZ+Zv0T/YzqnMKSjVOm+mkQMgPlwrbEw0J7CA+HIKeD1PoJP0jEG+ebUDPOV4AoA22ZHhTPAoPtDurDbcYPbPncnWaDbu1g9NjnP3KHLDSienaSA/aORe3Ns+0KE/c9v+3fj1TpeXtUZnxpvr9GV9thG2A1/J1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBgR0xbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBgR0xbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7235EC4CED2;
	Wed, 11 Dec 2024 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952329;
	bh=mYAi4EOO0tP6k5Urg9LmrkisiVygq5e7ECluhn2YAqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CBgR0xbdkRpDb+pYxa3pYwXLxNbd3H3rHfQ2d5KbbAt0fbZ8ObUwKa2sIs7G89+sX
	 decXg2I68RfeXCBaPcOFmCptbptayD1gHSDJzBQ9Q1HbYMNy3xOu94YgT9s34rNBd8
	 DP862fN8YUxjAQ3hCV/CgkiUXDyfzuSFSEfxvjUzvJeYJMRpLyUzVZReEaZ9Tn3ta3
	 60cTO5g0GZuh1zvHFLGj8OQtwDDD1OYjgZgntp9TRQJXoh1J5I1odpfZ8aNbz2a8em
	 vgH0nYZ3pqNmvFV3HlHcqR+yRrTGDlGo2FUutBKzFWDbb9oDewCXVlk1xk0C1I/Z/0
	 lAvUN2nzRt3aA==
Date: Wed, 11 Dec 2024 13:25:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/41] xfs_repair: fix maximum file offset comparison
Message-ID: <20241211212528.GP6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748828.122992.13639585878604982942.stgit@frogsfrogsfrogs>
 <Z1fP-lpYk-O6Llaz@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fP-lpYk-O6Llaz@infradead.org>

On Mon, Dec 09, 2024 at 09:22:02PM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Should this go to the front of the queue as a bug fix?

Yeah, I'll move it up to the "6.12" fixes series.  Thanks for the RVB,
btw.

--D
