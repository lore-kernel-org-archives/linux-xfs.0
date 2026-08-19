Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D0B3515D5;
	Wed, 19 Aug 2026 07:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124104; cv=none; b=jNDolCX8/8aFWRQsLJWD2nRunUkq+iNcKd2k52y8wUsHbTLUkTRyNlhBn7SYSxVc8SZSTxhj3VNOMB5LEokHuL7O3IunNpuV/KcZmrnxhQkvaw/pVPxNmraW2qpHINU4VwV0EOD760SqN1+hGWoAFGngClmCiVAAmOFvDVHOeFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124104; c=relaxed/simple;
	bh=JLmWBd13CdMp0qtnOUeYYS5wJYaVdUn3H3Oy1zORrPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qk2GDSCeJEWSOedzc3tIvPvNihVzuc76GNfHE+zq/tMcL1g+k76eLfRLiTQsix14fjD8RlkSkxImQPZgOWpPh1ileuFDEYS1XoS51A8dGrCU4KeEZ/a4X87fkkdv8SbS6iRqjgCdQc/U4+00t7fBfECAZNMqJIo3iQmEQet1VW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 90B4C68C7B; Wed, 19 Aug 2026 09:21:37 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:21:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 4/6] xfs: generic AG set based steering
Message-ID: <20260819072137.GG1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df@epcas5p2.samsung.com> <20260717125538.508925-5-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 06:25:36PM +0530, Kanchan Joshi wrote:
> Improve allocator concurrency and reduce interleaving by introducing
> fixed sized AG set.
> Use low bits of the inode as a hash to select AG within the AG set.
> Overall, a file will try to use the same AG (and contiguity is maintained),
> but multiple files will be spread across all AGs in the target AG set.

I'm a bit worried this kind of magic - the inodes close to each other
might not all have data or very different amounts of data.

I suspect the root cause this helps with is that the XFS initial data
placement algorithm that tries to place file data next to the inode is
actively harmful these days.  So doing an initial AG selection similar
to how the RT device does the initial RTG selection might be more
useful here (and thinking about moving to an inode32-like scheme
where small metadata with a lot of churn is constrained to a few
AGs).
