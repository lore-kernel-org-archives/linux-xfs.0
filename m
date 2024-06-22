Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D982492
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719072339; cv=none; b=kWJBZCDWikDl5jyYCR5b3KHho6FRQaWuVhlW7d+x2b0rCo1DhKgWWjvmiwiAwhG9iojbhhC11eW89eKAW/iGZlp2aQT3tUNfoTyFphgtaBe3umcYGDCKXA5KHFEz4CJM0RWEchlLpmdVi6byawwsIpHaaIFsUCiev3otlZUSfL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719072339; c=relaxed/simple;
	bh=GlrRbzZZvZwoPp8crJmWayutVyzSItGw2t9j+9UbO04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DB7MV3mKTabQqj1PDsXCIrXl+XUb0tDtLKlhysqYumb6G2Y+cKXV3AVQ1xnMnEg8khHQjlTghUm/NMC+ZMnp0usz2OMAZOudL6k6ZPDMSXj74bNko7pl2fbJb6RUAHtXzP1xrAU45Fp2KWR+cb/oKFJg+Fa3jW1pdWYCrQR0Kic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQCS9DkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQCS9DkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B98C3277B;
	Sat, 22 Jun 2024 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719072339;
	bh=GlrRbzZZvZwoPp8crJmWayutVyzSItGw2t9j+9UbO04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TQCS9DkRNjT6hRlmiABNeAsiMn3sypGc8vAXHe2V+5JkSFzYJKZTpbhHj875qSMDV
	 BfXRMUV+Y0qVwh0PmpKeHVRVcbH5IdMDOXKFq5s5g88iPNLgYnXw3E14XvsjQqUPtJ
	 de4JFOiz+MXuMgnA7fF6YksrOx0mNekY1UNuX1KYck1nU8QNt+QdQK34XQJqXyng6m
	 MuQ8dSfkjx6ZYdzqRr26c2DovVOI7h91vz9d5xZlR3/qCMh97o3jWESbvZAW/exTb+
	 9/yR14NtfFayStYvNz6LHeAPWlRPauWm463uywQmQp8r4lQxl1kZjjLB7hJcoV/3DR
	 C/iIyd99U/WHQ==
Date: Sat, 22 Jun 2024 09:05:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: random fixes for 6.10
Message-ID: <20240622160538.GL103057@frogsfrogsfrogs>
References: <None>
 <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
 <Znb1A0ZWI7Hw3X9f@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znb1A0ZWI7Hw3X9f@infradead.org>

On Sat, Jun 22, 2024 at 09:00:03AM -0700, Christoph Hellwig wrote:
> On Sat, Jun 22, 2024 at 08:59:00AM -0700, Darrick J. Wong wrote:
> > Here are some bugfixes for 6.10.  The first two patches are from hch,
> 
> There's actually just one left now :)

Having made a mess of email already, I'm going to leave this one as is
and not try to send more.

--D
