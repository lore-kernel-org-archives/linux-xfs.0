Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9239C5FEED
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728956115; cv=none; b=Izhwzo4/lCfrkDSvB786PyShgKQtXGYE2zHr6rOM+0nZWQwOO99QkKzTuN6Hk7bqnhk6oqU/nw3cBVsoC/GZv2851Ig96Z3z2xHvM1bkupUvhiV8iJ3lXRbGX1XzWkgQv05YuaL8IR64oXCFwBPUDpD5KN45c/4qH/II1NQI0fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728956115; c=relaxed/simple;
	bh=K9jFmnaQV8DQI04FwmUext5L0RxA0lqAex6IZLGDxno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fa4kupSJ/6nloklb3HKY/rQhnTmV8lTOupsEiRupSuSa60KZ8A2ouuZpPn6PPxwYSTHIFGWf6mhun+aTSKOtMEkBVwVbFVAXnsf64kj3JBQzgbSk5pfhURneBqfepCEUZsYQwg2MptFSSmS1Ca4LGa9/JIj7FvMEiYbvVrTSrj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKiancA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKiancA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106A7C4CEC3;
	Tue, 15 Oct 2024 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728956115;
	bh=K9jFmnaQV8DQI04FwmUext5L0RxA0lqAex6IZLGDxno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKiancA/AkM3yY17T1Ebr0u8Gys7AdOpFIARF7Z5SIHDknSjlhk6qgxSfpGC724/c
	 hwUgIqDlGLnqEQiUH/t89dJ5xZyL+fQzQ/5OJLOF7jzvFPoRzb/UT0OVEyQ3atoodp
	 hXS+Pxm/w0HWszqwdDBIjTf5FsBJMep2RmsrB+4jVTh0AtBw7Q1wO76FJmLAVrI+o7
	 0+aC5AIBDJibxoP7MEAVndEKhvBwMqxc1UNIfEXXh814xuhNXKEaJMr9v/kWvlS6O5
	 Hz35nQ9+0X0JpCWoV+lEBmLSf+T3n94FL6erkLaaSr1xOK4NFz6J9byV+saz/qr90J
	 3BLkQ4XArUAbQ==
Date: Mon, 14 Oct 2024 18:35:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/36] xfs: add a xfs_rtbno_is_group_start helper
Message-ID: <20241015013514.GT21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644778.4178701.16054050216083032242.stgit@frogsfrogsfrogs>
 <ZwzRyoWmBwxj1pN4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzRyoWmBwxj1pN4@infradead.org>

On Mon, Oct 14, 2024 at 01:09:46AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 06:09:45PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Make the boundary condition flag more clear and implement it by
> > a single masking operation.
> 
> I would have expected this to be squashed somewhere, e.g. the patch
> addhing rt groups and thus all the surrounding functions in
> xfs_rtgroup.h

I could squash it into the rtgroups patch tomorrow.

Re-running everything through fstests before I start that, because of
other odd porting bugs from -rc3 that broke mkfs <grumble>.  Ain't macro
soup <deleted>?? 8-D

--D
