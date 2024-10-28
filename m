Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6C1DE3C4
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137805; cv=none; b=n3Zrj63259ICxHwEriaBHZVhyNcucfdrhtqhf1MdmOmQfEeKxmqYjthwbO1d0XjPoMhPIIajuKqB5jrTIevqLILhHTtUCADowsciXRFHmzGEekLoM0KEOPOdeG0hPwAnWopbw0cYEHhCraRRA5IhEUnws/HSYzgInJXPFNs+By4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137805; c=relaxed/simple;
	bh=qhO4HS0Z3c1JL9XylvJLmrR5ZDsNvEfsCK1ZHoWi8sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRZ3qom3EC2QM9C+AbcSj53EGJ5zOPlzwP11p76iXSIHURSKRMxLNx3+p+jhrTOC/dZ9yaik4zJ+D0lWBX+8COAIlwqVSWVfRytYbuk+V1Fnua4173XpVfSZi8VfhLGSWBoJpBzqTKoq+BgvSq2Hhtdg2Gz504xWgwCK7AjOh2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rL5YwbYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rL5YwbYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7227C4CEC3;
	Mon, 28 Oct 2024 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730137804;
	bh=qhO4HS0Z3c1JL9XylvJLmrR5ZDsNvEfsCK1ZHoWi8sQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rL5YwbYKalHaACrEed22Rn4DOPBSXRd30IE8HeWihB/LntSuJzCoBcGg8Cb/PMhCe
	 WO2z09OKqIjM8BVBX3p+zIOgqvOSfzsDTtwcbnw5Wlb7tAexwcK4vXQn7avmLlPDu5
	 0JBXbyUavOVe15l9a1MEd/p905VRhmdC3L08rVsj3YHw2PIVMPVPmR/Y/e/3HfwQ6F
	 woXvCPE2eYzGu46fZB2zP9fkJzsvK1zWMCXNgyTvEp7Qy2LBma0Y9YyRll+UB1QmMI
	 jOFFreXkx25ZdEh0E+6SHXj30inhNNcRqNPKM6y2iIcBf0JQCRFcldZ409QiVz1rWJ
	 7i5NFf/FVblcw==
Date: Mon, 28 Oct 2024 10:50:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs_db: access realtime file blocks
Message-ID: <20241028175004.GT21840@frogsfrogsfrogs>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773789.3041229.10050634092165024838.stgit@frogsfrogsfrogs>
 <Zx9NOOgASfMFkqzP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx9NOOgASfMFkqzP@infradead.org>

On Mon, Oct 28, 2024 at 01:37:12AM -0700, Christoph Hellwig wrote:
> > +	if (is_rtfile(iocur_top->data))
> > +		set_rt_cur(&typtab[type], (int64_t)dfsbno << mp->m_blkbb_log,
> 
> Shouldn't this be xfs_rtb_to_daddr?

This series is for xfsprogs 6.12; the helpers adding rtb <-> daddr
conversions won't get added until the rtgroups cleanups that are headed
towards 6.13.

I could try to fling a patch for 6.12 to add these trivial helpers, hope
that I can persuade Carlos to persuade Linus to add that for 6.12-rc6,
then wait until next week to port the new helper patch to xfsprogs and
*then* resend this series.  Then I'd rebase all the 6.13 stuff, initiate
another round of review, and maybe we can push metadir into 6.13
for-next after rc6.

Good grief that sounds incredibly bureaucratic for a left and right
shift helper.

I'm going to add rtb_to_daddr and daddr_to_rtb to db/block.h for now and
update them to the xfs_ versions in the metadir patchset.

> > diff --git a/db/faddr.c b/db/faddr.c
> > index ec4aae68bb5a81..fd65b86b5e915d 100644
> > --- a/db/faddr.c
> > +++ b/db/faddr.c
> > @@ -323,7 +323,9 @@ fa_drtbno(
> >  		dbprintf(_("null block number, cannot set new addr\n"));
> >  		return;
> >  	}
> > -	/* need set_cur to understand rt subvolume */
> > +
> > +	set_rt_cur(&typtab[next], (int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
> > +			DB_RING_ADD, NULL);
> 
> Same here?

Yep.

--D
