Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04A31C0DE7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712809910; cv=none; b=kuShXSI5zoRYwIYuON4eFQG5RmVYD/XJH5I9dBnD7O4oHrQeuZW8kIFC9+XvfsBCScYx+8XszA9WQv4EVA9E6V2xf5NvxkD1nPUt6xoBPNeIRtRBuj3YCwCP0QXe/D8We3D9OjCQAXruMfSUlaV/1Qtl99zWhgqJrui/oVdFoxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712809910; c=relaxed/simple;
	bh=LOhCyLNFqXuO6EW1nqFo4FiXK17vutWuS6Tfj0UfHCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YM2/15QO5opv9PTBQ9mf/0/+tuVTZJRM4SB7hNsBx6o8EyhFFx1D+SHBvqx9qJIeE0e8OBl3Ykdreyzpnbf0NoBSwQjzm2RZpPAKvjCLxTBmD5/QA1tuSeuxwfHDoRsXQTrEyc4ciAQjrQ33PbrAkxnFbGqUdtDwqcHV2B5H2Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sDG1PxuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sDG1PxuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59677C433F1;
	Thu, 11 Apr 2024 04:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712809909;
	bh=LOhCyLNFqXuO6EW1nqFo4FiXK17vutWuS6Tfj0UfHCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sDG1PxuTX3/hePu0XqgnT6whVy0yhthoLynY57ZiNcQREGp3QyiHPAH2LhiEJhpKX
	 +lzSPSEYh/nAWAypl8lMm3+9mbC6sC1QgbMWzy51TqxxoyrUC9wOVWQ/Ux15b8/Uzu
	 JeRXnUgg4xhmTmgPo1PwDaEtUeEfiCj56yxhE5ZDi+cCisR37j64Sp3VcCG8Aby9Pf
	 1jB9K/5CyOnYAEipcDhqLcKtB+7JfI9r6XC7yLQW5/x1ydxelBJhyJVUV6mZH72HCI
	 3iktVe5DjFQwFrp6/n/6nGk+BCESo3nk8zdo+NWUOTe7Q/ko/rWoL4qijap/BNYVTp
	 as6cgb9Gj/G8w==
Date: Wed, 10 Apr 2024 21:31:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: introduce vectored scrub mode
Message-ID: <20240411043148.GV6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972051.3634974.4637574179795648493.stgit@frogsfrogsfrogs>
 <Zhapez1auz_thPN1@infradead.org>
 <20240411005941.GQ6390@frogsfrogsfrogs>
 <ZhdbPhnf1Usplqfu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhdbPhnf1Usplqfu@infradead.org>

On Wed, Apr 10, 2024 at 08:38:38PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 05:59:41PM -0700, Darrick J. Wong wrote:
> > I thought about designing this interface that way, where userspace
> > passes a pointer to an empty buffer, and the kernel formats that with
> > xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
> > was.  I didn't like that, because now the kernel has to have a way to
> > communicate that the buffer needed to have been at least X size, even
> > though for our cases XFS_SCRUB_TYPE_NR + 2 would always be enough.
> > 
> > Better, I thought, to let userspace figure out what it wants to run, and
> > tell that explicitly to the kernel, and then the kernel can just do
> > that.  The downside is that now we need the barriers.
> 
> And the downside is the userspace needs to known about all the passes
> and dependencies.  Which I guess it does anyway due to the older
> scrub interface, but maybe that's worth documenting?

Yes, that's correct that userspace would have needed to know all that
anyway.  I'll summarize this conversation in the commit message.

> > 
> > > > +	BUILD_BUG_ON(sizeof(struct xfs_scrub_vec_head) ==
> > > > +		     sizeof(struct xfs_scrub_metadata));
> > > > +	BUILD_BUG_ON(XFS_IOC_SCRUB_METADATA == XFS_IOC_SCRUBV_METADATA);
> > > 
> > > What is the point of these BUILD_BUG_ONs?
> > 
> > Reusing the same ioctl number instead of burning another one.  It's not
> > really necessary I suppose.
> 
> I find reusing the numbers really confusings even if it does work due
> to the size encoding.  If you're fine with getting rid of it I'm all
> for it.

Done.

--D
