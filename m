Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6C71917EE;
	Thu,  5 Dec 2024 07:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733385428; cv=none; b=DekGMCtKpCworuei8aw4wiJ0AYjsd7WP1SFhW0Wp5FsrvgFwRMJmLQQZfP1CqeyoEOClySswQMLxIf9XWztyafo4H8JeYJKXa36xJtoXDZTChgNpejKnieiC2frIDWeTEMSA7JiXvvxTDLyCOFSfq/ED2Xg42cfpta2ZEVjbrpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733385428; c=relaxed/simple;
	bh=bdq8vzYSfmz9LPGJNP9c2JSwOs2OYDd02yK0xwONFd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjlDCKiXlNDftPLN1bQESnSomyZb5hWafg1ZIhXJCLZV2LDaG08Apgjjc4oLJYTC+Djj6x1z4FPF1Ez0Fn2TKrShNdssK01W8mLb+1q9hnOWyjOusTPacg4GmPRs1B0X4U512yRlb1fmGeojaMV1d9wyjqSThHVbqHcJu5S6YIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpg8OEp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpg8OEp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E0EC4CED1;
	Thu,  5 Dec 2024 07:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733385428;
	bh=bdq8vzYSfmz9LPGJNP9c2JSwOs2OYDd02yK0xwONFd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rpg8OEp1w+uBmo4Fr+6RWQqHLatxovxATvx8yVfW7FX4PURTLHPz+2A59Vk1gXuwa
	 BSh8nYSrXLrjyp/BsFnyB0qSQtPsHZxFBBnpEO0ic/zl7a8IyjpELPXB9L3DcYn4aP
	 nZP7j4mjFrfJ4W9yBDVmdQ+4abNeMC4E2JZ16C14BSwQS/FAJNt7BAJm+FAhidQ1IQ
	 zF2pVjvhbsLpTovaD87+al03TxOKn2KPiliqYQ7c7H2Mervq1kCs5l9oaCZF3q8QS2
	 lZAGNAqDtKll/AXRerde5cMLZyI1ZLiW61LgMbTDPzdKSt91SAexijq6xA8pLFyPOM
	 1hTWZqRYsYMSA==
Date: Wed, 4 Dec 2024 23:57:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bill O'Donnell <bodonnel@redhat.com>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <20241205075707.GK7837@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1FPGXpTIJ1Fc2Xy@infradead.org>

On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:

<cut out all the hostility>

> What Darrick wrote feels a little snarky, but he has a very valid
> point.  A lot of recent bug fixes come from better test coverage, where
> better test coverage is mostly two new fuzzers hitting things, or
> people using existing code for different things that weren't tested
> much before.  And Darrick is single handedly responsible for a large
> part of the better test coverage, both due to fuzzing and specific
> xfstests.  As someone who's done a fair amount of new development
> recently I'm extremely glad about all this extra coverage.

Aww, thank you! :)

--D
