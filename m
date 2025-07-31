Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7E23B63A
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753981444; cv=none; b=rSXy+YB3jSQWcoiEZjylK5sDdCFWLB3NJ08F3Vvzqm5PSNhSREAgASK577eBIt9zQT4mBgymGNqcYkyzdw3lGwVigiMXrGjCwfQ/kZAHe64lTJDDxwYA1lPtEZndBGB//nTBEtasukSQRqS6ubP/tYqhU0ZB/ZmNgyLlyof5DBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753981444; c=relaxed/simple;
	bh=6IHEZp3r/5eKbpEbxf1bp1wYpcTc8yr11AJgzrzOJeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8aEqDekXi4ETTGMWlmAJfkass581H4lS/8KDOTljCKHTGXzgr0xaIJT0ZMdFTvTHBOJqbSNKlVlmufhFZmDUb+SRgGkxSlwGeNjo9gLcTXWpJ0mi7dtrVd254p9WYjOApLEaZFjQXxNvZ8abMRQAf+qHLs3b0KPfeounbjiCmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/VRIwoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/VRIwoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F4FC4CEEF;
	Thu, 31 Jul 2025 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753981443;
	bh=6IHEZp3r/5eKbpEbxf1bp1wYpcTc8yr11AJgzrzOJeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/VRIwoAkl3QrA/1rAYnRopL4ZOkjarK/GTGHcrNHH56wXVcRZCTs/U8II64LuHeh
	 pio9vDHdE614hphnQTpx6JFoLtqUBQ6tnFBAy+x/aKCPiBl+5yDoaiHrwQs1PcSdnf
	 EdRfsJ8sYSK0jfewn5MG6RH+nThb8wcGiAj4Gy6TQ75jN3M8zN5OAX0hVpPiouM1DV
	 Q8zx/8yjPfJR0wEfN2w7zwM43t1EFEmYkRJAXdyNt/ZH4gaN2Uo8SFU8n+x6mVF3ZE
	 BIOuWcjmQLfvtndHu3QAqjQcdIIJRMAaR/0y4g8hqU4wBJEKmVg3pou253S4SMjIXm
	 RDSCxD+XvRiYQ==
Date: Thu, 31 Jul 2025 10:04:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix frozen file system assert in xfs_trans_alloc
Message-ID: <20250731170403.GI2672070@frogsfrogsfrogs>
References: <20250731141941.859866-1-hch@lst.de>
 <20250731155941.GT2672049@frogsfrogsfrogs>
 <20250731161558.GA10215@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731161558.GA10215@lst.de>

On Thu, Jul 31, 2025 at 06:15:58PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 31, 2025 at 08:59:41AM -0700, Darrick J. Wong wrote:
> > >  retry:
> > > -	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> > >  	tp = __xfs_trans_alloc(mp, flags);
> > > +	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> > 
> > Empty transactions can run during a freeze, so please put back the
> > original warning and comment:
> 
> Empty transactions don't end up in this code path any more.

Oh, hah, silly me, I forgot that also got changed by that patchset. :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

