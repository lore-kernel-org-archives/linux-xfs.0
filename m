Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE8E381A4
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722448513; cv=none; b=QE+aIRH+T+/pWp9Bsgh+wJMU08U2/mPaDZoqBB1DKGpKhQgJMSlC+4c9gnckPhp6AYpxb7o1wPVLfXkIHscSz0Jqj81CjjFgd9y8Ybht1O0Kb8Bq292cCHv+CbeevB/nSWEeubUULR8p4UtRwjZ7TuQSIqnIjgl/TPhuJ1Q0B0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722448513; c=relaxed/simple;
	bh=SvpNhG2B8NNyiYZ24sEtmacqYx6YrXuk9uJGRfIRoJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJLS7XHNgzuI1JMlsNWlszulK1eQTLypZkSm3nY7mKkEOpScSTSu48GYDrRbsgM7XR2U/TYK2Jg2XYVn1JQSO8js3wTvKFJ1uSGC7aJmiWqM6lvCxDfqil7PRHOkVLaxFKgvFOCFiTzUyDXR5ba2AoCdX/ic07aCeMYUyUAN8rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVRzpT/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVRzpT/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ACAC4AF0B;
	Wed, 31 Jul 2024 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722448513;
	bh=SvpNhG2B8NNyiYZ24sEtmacqYx6YrXuk9uJGRfIRoJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FVRzpT/EUUbkwcce8ywOToRkNHN1n+b+MINpzXlyLApaydv+iCEcTNhjpx1nKZJZE
	 nfozDF8fITG3gZd/j6kY5F3J17iYZHEN/I8E5xvyuQjcMiVbRFaw29IQFYXsJD/OFx
	 /VgqE6qEqjeQHqXTbiYfJTnjrF7RxzKsbljuy5ThmR+gru5SDJVpptLuGkFPSgz2GD
	 yExBTk0z99tPTQFISt02DKty5zipLzj65epss50hhfuDXxBf/mDeMauVPTuguTzCTY
	 Ay9xBw6BhfVI92U8TESUMgmUD490rLYmXpRfAxhpGroCFonWWSPo0nz/RI/ZozCPfr
	 bBhhghwtL+5lQ==
Date: Wed, 31 Jul 2024 10:55:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libxfs: hoist listxattr from xfs_repair
Message-ID: <20240731175512.GR6352@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940631.1543753.17382323806715632348.stgit@frogsfrogsfrogs>
 <ZqldQN-v18yCGQPM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqldQN-v18yCGQPM@infradead.org>

On Tue, Jul 30, 2024 at 02:38:08PM -0700, Christoph Hellwig wrote:
> On Mon, Jul 29, 2024 at 08:20:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Hoist the listxattr code from xfs_repair so that we can use it in
> > xfs_db.
> 
> I guess there isn't much of a point in sharing with the kernel listattr
> code?
> 
> But maybe that is for later, for now this trivial move looks good:

I think we could do it.  The major difference between the two is the
prefix we use for the dabno "have I seen this block before?" bitmap
functions.  But that and the scrub/listxattr.c code would both have to
be lifted to libxfs, and as long as we're doing that we might as well
clean up the userspace bitmap implementation.

(IOWs that's a somewhat lengthy cleanup for userspace either for after
we get the rt modernization stuff merged or if we get really bored
sitting in meetings.)

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
