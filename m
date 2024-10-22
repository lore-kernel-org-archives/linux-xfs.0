Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2BD1C2422
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619200; cv=none; b=Ew1OF+xZkOnjwDuf/wQweHgJHE7GzcmV5ic2S3pBYxJCQVuQcbgl72FsQmN/am1lq5BCVyf5jmoIfI6APb0VJHfExYWLm1PeUBNvyJu18XFIn5K8fCPI1bARUUE0Vu58czqIuJk9C2HbX+r5eO7FU8wHcX545IMtBAsfxgUNNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619200; c=relaxed/simple;
	bh=E2iFi/qUIcGwBIAkafCiySqw5hlyolsiisF0wPiWK8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7tiyVlx11/7aCPltbqptvRnS4S3TtqvMUE3n+eMOMxbtz00GvYibRPHMoOJxq5lcXNHZpwxuWhkWADUcb6fXCsr4VlgWYCx91kHIybZEjUTma4xhhPAV4HjN2iyFjxv4eww6J0aVIOMieQD9qCWJGbfLu4l4HEJ/YqHQIl5bSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bY2chs1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bY2chs1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82409C4CEC7;
	Tue, 22 Oct 2024 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729619200;
	bh=E2iFi/qUIcGwBIAkafCiySqw5hlyolsiisF0wPiWK8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bY2chs1vqw2+47A9F29g6xMEuzTiewbh7/WyTC/IJc5dXZoeE5X7p1DbPC0G4GnNJ
	 qsICf+6veyEw1lw2AAgRuRB6ra5Uuo2XTppslEEFaH8EufM6R8X1hGJe4UFrZ5SfPJ
	 7CPjJf/jDtk/x+84SF0IQPXvxvsofRgHU7f0sAIDJ4BT5gjG8cQuYjvQYmZ2IROFjS
	 P8wrrXXoslhvjV2+QuOT7jNJ9cD21reaamV8zI66U7wxTiOpGUyZrrXx80sEeMnjA9
	 MmrckcN0MJshlow/kPYOHKp6DRl/paJyr6As6sqreKaGy5xroX8ErSn53kphH4VrsX
	 CQ77P+as5mwLQ==
Date: Tue, 22 Oct 2024 10:46:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/37] libxfs: compile with a C++ compiler
Message-ID: <20241022174639.GD21853@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
 <172954783502.34558.4926204658396667428.stgit@frogsfrogsfrogs>
 <Zxc-4zDL1wzyU23H@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxc-4zDL1wzyU23H@infradead.org>

On Mon, Oct 21, 2024 at 10:57:55PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 21, 2024 at 02:59:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Apparently C++ compilers don't like the implicit void* casts that go on
> > in the system headers.  Compile a dummy program with the C++ compiler to
> > make sure this works.
> 
> The subject line looks weird.  This is test compiling the public headers
> with a C++ compiler, not libxfs itself.  Maybe make this a bit more
> clear?

Ok, changed the subject to "libxfs: test compiling public headers with a
C++ compiler".

> The change itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
