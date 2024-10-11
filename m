Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897E518027
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728665411; cv=none; b=tkvXftoqmIBGfYwL162PdQYvP9PrvuXvLvZ+QdUSnu37B2o/lHviEB45Jfbad+DdRHblyKmlN2QYEt8+JqGkS4tT4p5sqVbo3Yn84y75SLa4ZzMiiz09Cb3f+pD2VlKjEUSIuq7GGYDohd+OTdLT886HMLxLqTCTkwdDEH8TIOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728665411; c=relaxed/simple;
	bh=hN1tFgIl3v/dSsZ2PpnuBIL2jBHnEVT+etuxfJQF9K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFyX45kLnKx67+nYraNrvLTcV49ZhIhavBQ61VmJNwZWFsJGEvONjG9LyThFu7cg/vC+oPHvK1WttI+wxcSibizzQDowcR03/DZVbrjHm6PnyBC6Qv2NFlY5EdGzIO00rarTvTzgkMixlpD+vjR4mSPqmmoPdNZGR/p5lsfFPVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CH2aV8lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CH2aV8lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F027CC4CEC3;
	Fri, 11 Oct 2024 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728665411;
	bh=hN1tFgIl3v/dSsZ2PpnuBIL2jBHnEVT+etuxfJQF9K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CH2aV8lRXW4RQt4yWXoM+COnmT1chiWpxjxq9ykf1qhqNQ570k1ch+TOwKIgSNAst
	 WFiBjMCADHX1wjpMgBU79JuMfEW1cA+bl8y1XuaPIJ4L0UR1TonUC1JAx9Ou3RQ+SJ
	 I6xQVPDRMOFNVfvyS+EmR5CobxkdburJudI9yeGHBkHSLkaDqvEQcXnpkgWzw1BPAi
	 DiZnxPmRBQyiTUp15ISFWAYgyLuUGSooCzdiNzc8NxfC1J7pDPm4zqHeRBeH14P/sE
	 nko9FjF+XGAt0CesCCvzs0kuUAb6LXjKKTJlxeunSaJ1HxnSNJLgWL4BTOSM1UqzVM
	 4OEc+CAPC0Ykw==
Date: Fri, 11 Oct 2024 09:50:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: split xfs_trans_mod_sb
Message-ID: <20241011165010.GA21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-8-hch@lst.de>
 <ZwffV8BDDJjr5xvV@bfoster>
 <20241011075408.GB2749@lst.de>
 <ZwkwrTajIqYz2Ykw@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwkwrTajIqYz2Ykw@bfoster>

On Fri, Oct 11, 2024 at 10:05:33AM -0400, Brian Foster wrote:
> On Fri, Oct 11, 2024 at 09:54:08AM +0200, Christoph Hellwig wrote:
> > On Thu, Oct 10, 2024 at 10:06:15AM -0400, Brian Foster wrote:
> > > Seems Ok, but not sure I see the point personally. Rather than a single
> > > helper with flags, we have multiple helpers, some of which still mix
> > > deltas via an incrementally harder to read boolean param. This seems
> > > sort of arbitrary to me. Is this to support some future work?
> > 
> > I just find these multiplexers that have no common logic very confusing.
> > 
> > And yes, I also have some changes to share more logic between the
> > delalloc vs non-delalloc block accounting.
> > 
> 
> I'm not sure what you mean by no common logic. The original
> trans_mod_sb() is basically a big switch statement for modifying the
> appropriate transaction delta associated with a superblock field. That
> seems logical to me.
> 
> Just to be clear, I don't really feel strongly about this one way or the
> other. I don't object and I don't think it makes anything worse, and
> it's less of a change if half this stuff goes away anyways by changing
> how the sb is logged. But I also think sometimes code seems more clear
> moreso because we go through the process of refactoring it (i.e.
> familiarity bias) over what the code ultimately looks like.
> 
> *shrug* This is all subjective, I'm sure there are other opinions.

I'd rather have separate functions for each field, because
xfs_trans_mod_sb is a giant dispatch function, with almost no shared
logic save the tp->t_flags update at the end.

I'm not in love with the 'wasdel' parameter name, but I don't have a
better suggestion short of splitting them up into even more tiny
functions:

void	xfs_trans_mod_res_fdblocks(struct xfs_trans *tp, int64_t delta);
void	xfs_trans_mod_fdblocks(struct xfs_trans *tp, int64_t delta);

which is sort of gross since the callers already have a wasdel variable.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Brian
> 
> 
