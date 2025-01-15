Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F28BE7;
	Wed, 15 Jan 2025 06:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736922038; cv=none; b=NpWX6VeUaEDbwbU5d7z1qqMd3OJpMPmduYume+dQwWUeYoAGCzeBSPg3rnRT5yDvPNUUxjsbI7KHqrFp9rv9k1854WyN+KQfFohFuk8o87sCc7uNn925uHbZ4eXyr6T+X0sXgqsBlD5DZ9JsFwflXm0eSvS546G/gdjUtCUPIQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736922038; c=relaxed/simple;
	bh=kbvmeKZmPZNFTNIeMU6JXyRlOOL4qh001SsF8asSOp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5g/qDx9CTbb9wVBvLI2AIcxeKvaoCFSPb4Zw7qWTr4CS+YyWDskYv9LbvYVfOEgfsLrnwRbdn1eDOfxVAqqby+We+A1ENfcR/+HnyV5D6RrZ65WntYGcKKCfoctgGrqLtr/LGBCkuZ+yTcMComOgdWJ7HvlIJPFFPD10TK3a7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVZfJ9Xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVZfJ9Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C76AC4CEDF;
	Wed, 15 Jan 2025 06:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736922038;
	bh=kbvmeKZmPZNFTNIeMU6JXyRlOOL4qh001SsF8asSOp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVZfJ9XikeKS+4ehZZBHrutJbLd5M4HFT6ZaHLHnnwvejWF2u3eSIpp3JEquncuQt
	 nU/ITyF8iG4kXzg66yMZesQPcO/huSIEfH5NfgV9qPAFvtEyU+Q6M7SkC8ATmcx9za
	 p9nnfu2IOjaQGuGsF4PusyUKsVZKVwTGq2HspCO6yGlu/ozwTOkimhfOvFCJAilnR3
	 d7zgCkCxGz9qOTeZA/RfPvu8fud6xcDySB1eXuJ9TtatdQ5km+wUW50/9KhZucg8jh
	 TbJ2zcPY+kVz4hOU8Xqeo9NrSsdhFKgQIV0KpY3ZxzTLxglhmngytwVSiq7WAc1mrt
	 89vyHCHjWWOZg==
Date: Tue, 14 Jan 2025 22:20:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	xfs-stable <xfs-stable@lists.linux.dev>, stable@vger.kernel.org,
	david.flynn@oracle.com
Subject: Re: [PATCH] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
Message-ID: <20250115062037.GF3557553@frogsfrogsfrogs>
References: <20250114224819.GD2103004@frogsfrogsfrogs>
 <20250115060615.GA29387@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115060615.GA29387@lst.de>

On Wed, Jan 15, 2025 at 07:06:15AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2025 at 02:48:19PM -0800, Darrick J. Wong wrote:
> > index 950f5a58dcd967..09468f50781b24 100644
> > --- a/fs/xfs/scrub/scrub.c
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -149,6 +149,15 @@ xchk_probe(
> >  	if (xchk_should_terminate(sc, &error))
> >  		return error;
> >  
> > +	/*
> > +	 * If the caller is probing to see if repair works, set the CORRUPT
> > +	 * flag (without any of the usual tracing/logging) to force us into
> > +	 * the repair codepaths.  If repair is compiled into the kernel, we'll
> > +	 * call xrep_probe and simulate a repair; otherwise, the repair
> > +	 * codepaths return EOPNOTSUPP.
> > +	 */
> > +	if (xchk_could_repair(sc))
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> 
> Stupid question: what is the point in not just directly returning
> -EOPNOTSUPP here when online repair is not supported?

Good point, we could cut it off right then and there.  Though this seems
a little gross:

	if (xchk_could_repair(sc))
#ifdef CONFIG_XFS_ONLINE_REPAIR
		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
#else
		return -EOPNOTSUPP;
#endif
	return 0;

but I don't mind.  Some day the stubs will go away, fingers crossed.

--D
