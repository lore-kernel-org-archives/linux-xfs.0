Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BCC205AD2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420421; cv=none; b=rlKbsXEjSMiB9w4rcKopfjGNYoC5+7Q15t64cexiTYt48xltJr+yGg2dW7PkT2+bednzQjzhMxgxN9F1QHmPMyWuHAwZDlNeEBxeZCxWgyaIlj9qppIhHhv45xpc5v9jLtT4wJmosLwpCgzw+GBZ+vjSh3JAiRD2nLiFOQ08/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420421; c=relaxed/simple;
	bh=3Iw+jJwteF6GAVL0Rbi492rn/cIfPSjfeh28BGa61CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHt40ZnUVWEB38Ga66V7rjH7zQLQk4xkfGBUgoXtEnNS0vooc4/7Dj6pWNCizfx7Do1VroB6xNDEiFy3vxB6eagAzwQX7Fjk7XVjKSk/29tuXF3atIdFyaMLzrnWtwgei9HygeteQwkMuZDjg6dfZDJO68XhA8wo1s+mymBR2xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+Nez9HE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+Nez9HE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C51C4CEE4;
	Thu, 13 Feb 2025 04:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739420420;
	bh=3Iw+jJwteF6GAVL0Rbi492rn/cIfPSjfeh28BGa61CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+Nez9HEuFe8KpjkjWmUkdaDwFnSVbVJLPbbQF+QZbvVFq4ODboSiXcsTHKbNlF6P
	 dsXjYII/ISo/j6aNfr5r1Yr104G3nTsM3IMIdcc5gg1/ZoAWFI6W9rTHgwF6nKKWRi
	 +WGwiocD6rULsKQ1BinJfOW5chzvDLTn52zq6IWkyDgg6oZlXzjv0V8AzIJvhjr8Ti
	 mHzbf0BwYkwGLMcj8acfWzmW0HIDw0RNlQfQux8vmmBQcGvdreuIZao5Hk4cks3Dhc
	 oOp9y/xU+WpVvAoOa61jEJ5Sfw1Xi6MmAQ+u7iJhDPKtZwdxRa5iUXKANg35LWy1zF
	 Ajx+3TmcumBMQ==
Date: Wed, 12 Feb 2025 20:20:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] libfrog: wrap handle construction code
Message-ID: <20250213042020.GO21808@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
 <Z6WNXCVEyAIyBCrd@infradead.org>
 <20250207044922.GR21808@frogsfrogsfrogs>
 <20250207170002.GW21808@frogsfrogsfrogs>
 <Z61voxnKjM5izf45@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z61voxnKjM5izf45@infradead.org>

On Wed, Feb 12, 2025 at 08:05:55PM -0800, Christoph Hellwig wrote:
> On Fri, Feb 07, 2025 at 09:00:02AM -0800, Darrick J. Wong wrote:
> > Which is much more verbose code, and right now it exists to handle an
> > exceptional condition that is not possible.  If someone outside of
> > xfsprogs would like this sort of functionality in libhandle I'm all for
> > adding it, but with zero demand from external users, I prefer to keep
> > things simple.
> 
> Ok, let's keep things simple then for now.  If we need an external
> version we can still add it late.  And for the future reads curious
> about this maybe add this explanation to the commit?

Sounds good, I'll amend the commit message and repost.

--D
