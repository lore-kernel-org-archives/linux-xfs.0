Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5333D4A4983;
	Thu, 10 Sep 2026 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052946; cv=none; b=EwWaEJ6oWYreMmPWalTQ/ASmq4vcmsi4Rv6799ADx7L8hB+vpNuO6sb8zQIPpyIvsuioGpDapMpTUaTRi2R6wPYM9vwDeivVCEyZwRAjSJvo6mCAIJOD+rta0c1AANRURVrWK95VC58+bC9MJ43AcUGVsvygadUWE9EAtGxsBAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052946; c=relaxed/simple;
	bh=ElTHav3YRvSamwMgbeP0+OBBpsbQ5uRBgER4GmaV6mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2cGIatcJt3SHEUyH29u09Orb0uXWQWenN5eivCKqiD6MI3ACo+V+OkdcfOqt1gmLKUpW+Bx+OzGNm9THTiShBc5PWh+7UxqpEIdYUCQeMPPIr5hi9grGWNyTiGbH63qeMWwizewsOeiCLNuk6VvULQmNR572TLiXk53raBRt7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuBvHwHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuBvHwHU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7585C1F00893;
	Thu, 10 Sep 2026 15:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789052938;
	bh=QINm46LqgvxXX38G/1bwyjev8OepYKK1sH7tzLP6Stk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RuBvHwHUuuXBX6hfqXqz6hehjO1PPOAq5sXP7GeSrnlO+80sjyfxDm9T/DGNwlJt+
	 dO3RlYSuiRZfX8mvsiQhZY921bMjfvMo6JCtIVOoxiG5fc71yClCp/7h/Ciygx6+tF
	 kVlJhgoMR6oSw87nMQbN4C7hfZULSnv/vPs+VUzqJfFpqoWcZL2ho0YKpZ36Kk/YNm
	 nlVnQCWBDhoSQefavngCb8wjr1qu399z9A1PBY/76Q4P7O/1qrql3rJUNwX5DXCWLp
	 kfdXopXbfigBqCUn1iVSrlePcVfNEPsLen0yZlrz2D6rsRKttCVomKPDFpusZeqPOe
	 1ftoLyv0HGnAA==
Date: Thu, 10 Sep 2026 08:08:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, dgc@kernel.org, floss@jetm.me,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix under-reservation of blocks when repairing
 sf directories
Message-ID: <20260910150858.GD6253@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
 <20260910050031.GB26687@lst.de>
 <aqJANTuQQMEIqcmO@andromeda.toxiclabs.cc>
 <20260910060907.GC6253@frogsfrogsfrogs>
 <20260910094344.GA5330@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910094344.GA5330@lst.de>

On Thu, Sep 10, 2026 at 11:43:44AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 09, 2026 at 11:09:07PM -0700, Darrick J. Wong wrote:
> > I prefer not to leave a logic bomb in the scrub code in case we ever
> > have multi-fsblock attr blocks.
> 
> There's plenty of logic bombs to unwind in that case :)
> 
> Best if we want to prepare for that would be to use xfs_dabuf_nfsb
> and make sure we use a helper like that everywhere.

Actually, I like that a lot better.  Let me rework the patch with that.

--D
