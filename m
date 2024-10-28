Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77061DEFE7
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730138303; cv=none; b=LjPJS43d6NkPmaYx7eaTXyjpXorUHoeGWQiSCHtbnn/xJ5GXSD7TfQSgJM3OkG23mxDbdvpuQ8RstCrPv9KRcToZqLAgczlPWNfpO8X3hwowGsG1+3aFzdjQxam6g6botDA8yCYCQoM7zFpDusR8nQqEaS0Wx5y69B6v6wVVjqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730138303; c=relaxed/simple;
	bh=e39WcBWpZqeVUu4ZcMU/3V5veUsWniXIZdeQTrPEbL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myFPtJEBw7wWEvrKQ38Wf7u/WOLtY6WrTw6zPnWYmWIonUFhmqbUI8tVZnat9gqvsypOL6k81iYR61NuAe7Tqpep+N4d2U2Uze6+iU2vMcS86IWh2KDTgmOkEWOR0Fq6iyMCELOKxtd+JIbD5N1B+f6DC4xjjCtg1LSncFzEbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+nxWDm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+nxWDm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB53C4CEC3;
	Mon, 28 Oct 2024 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730138303;
	bh=e39WcBWpZqeVUu4ZcMU/3V5veUsWniXIZdeQTrPEbL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N+nxWDm0mXwJd9f0fdnONP2djbYKwN4OriKEP9LbvV64DCL/OFZcGHYKT6LfBwOja
	 C+o3BvqkK+VctgRDgx58Gwn2a79gEQC2vsBcEVlfGKJCqcqTAKTRm/CfDF378dlwA8
	 mvr5O1HjmHJAIKk+1ZCcSJPareHBjyNip9FYstcBmhAFCpLpFYKh/KwVFOAuvE3myX
	 m0FKnzPhBO0lt7v1b2vTlwsQ+QgHf9xvH8ZoNLWtVgX4K8IgGEly6JXJWF9eyUlH1C
	 EjFt+Ci7lGVJv/fOa5ORnXDItVZyQ4FicLhuy2z6d1tKtdWTQKMLDPpQddmRkMkgo1
	 +GPI/Orv/QC1A==
Date: Mon, 28 Oct 2024 10:58:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs_db: enable conversion of rt space units
Message-ID: <20241028175822.GS2386201@frogsfrogsfrogs>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773819.3041229.79394639669103592.stgit@frogsfrogsfrogs>
 <Zx9OQo1uhTgy-UIP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx9OQo1uhTgy-UIP@infradead.org>

On Mon, Oct 28, 2024 at 01:41:38AM -0700, Christoph Hellwig wrote:
> > +	[CT_AGBLOCK] = {
> > +		.allowed = M(AGNUMBER)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),
> 
> Can you space these out with whitespaces around the operators?
> 
> > +		.allowed = M(AGBLOCK)|M(AGINO)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),
> 
> And break up the overly long lines?  In fact I wonder if just having
> each M() on it's own line might be even nicer for readability.

That does look a lot better:

	[CT_AGBLOCK] = {
		.allowed = M(AGNUMBER) |
			   M(BBOFF) |
			   M(BLKOFF) |
			   M(INOIDX) |
			   M(INOOFF),
		.names   = agblock_names,
	},

> > +static inline xfs_rtblock_t
> > +xfs_daddr_to_rtb(
> > +	struct xfs_mount	*mp,
> > +	xfs_daddr_t		daddr)
> > +{
> > +	return daddr >> mp->m_blkbb_log;
> > +}
> 
> We already have this in xfs_rtgroup.h in the latest tree, but
> I guess that comes later?

Yeah, that won't show up until we start working on 6.13, or whenever
metadir goes in.

(Also I changed my mind on naming and decided to use "xfs_" on the
db/block.h helpers that I mentioned in the previous two replies to
reduce churn downwind.)

--D

> >  Set current address to SB header in allocation group
> >  .IR agno .
> > 
> > 
> ---end quoted text---
> 
