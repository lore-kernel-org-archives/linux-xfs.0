Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FE51E88B;
	Fri, 26 Jan 2024 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287532; cv=none; b=d5JFCnZXFMBdhQMX1fqQcRLUwE0rdRG8YuLDbzhvkDodDRtLVZq8B+gBSDqYdelC9yOk6gkxrohiLoMtx4e7EV51Jzye07+F67rZvEFqDHnTVwp7m5zK4bXR9gA46B36WITy0R4Jpue4PMWgtaEtN+9wsPEmWNIQXTXbdz/JVEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287532; c=relaxed/simple;
	bh=Bw21I3a2DG/QaCV2w89fjIl4mUYqO4JpYBMjJiJgXpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joPJj0mE42lqigygVjLOcriIuQIo/GhkgIs1k0mbkiB7Z51MHtzS/JFlRw8TpOrgILhm7dkANxoPXD2lCnNeyHOP9tgQZjmVLUfJZd064ObRy6nlfspQyJQIPGHJIx/5tecO0sE9dqcdPfQ/HscIlvsbo/qIkE0vGKC2d+q1o9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjGWGjdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjGWGjdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EA0C433A6;
	Fri, 26 Jan 2024 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706287530;
	bh=Bw21I3a2DG/QaCV2w89fjIl4mUYqO4JpYBMjJiJgXpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sjGWGjdcMVIPzKzjj7/kxUjxa2Av3jmfzlq8k4V1wmOKEJsjH0ldiNWb0itipi6qE
	 O7dZOEakt8UcF8+5HcUcGaCk8JEaegff4V/uCV1+XbAV4K/Sn+s7ewroMLwpZ8XpP9
	 ozPKsYNWevQCmn9vf1vq9U4l4/eBNp9uUeGl2xknZHY6mDMj/tNV59meuJMrSJYyAT
	 OiMUIsMDjczK79cbF4b/EqMDfKq4JTzBubexTMkGJrDogiB6xovdTiimBd/jcAnNPV
	 KF/B31MZxGEIWDF3Cwxa3iDGboFV56DHexbHJkmSkOicj6pmdGtFkfKWTfHosX8X88
	 Wcwum8SiurwDw==
Date: Fri, 26 Jan 2024 08:45:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs/503: split copy and metadump into two tests
Message-ID: <20240126164530.GA1371843@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924478.3283496.11965906815443674241.stgit@frogsfrogsfrogs>
 <ZbO1Ue1hYr7d-o0R@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbO1Ue1hYr7d-o0R@infradead.org>

On Fri, Jan 26, 2024 at 05:36:17AM -0800, Christoph Hellwig wrote:
> > +++ b/tests/xfs/1876
> 
> What's it with these weird high test numbers?

Two reasons: I don't have to renumber all my new tests (and update the
spreadsheet I use to track upstreaming status) every time I rebase with
upstream; and the maintainer can git-am the patch as-is, without needing
to hand-edit the patches.

(Hmmm maybe fstests needs a git hook to detect a new test and
automatically renumber it.)

--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
