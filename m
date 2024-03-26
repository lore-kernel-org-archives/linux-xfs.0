Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4AB1C2A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711472898; cv=none; b=UT1+hT+BDpDsV3mXSSZGkAt8WjAKyavW6BF137As3o+tCE0ZsduwyxZtlbiqcdZla+N/Ni8U5nh43tFLJAztThWBiObi/JdDz/qYb78b/45QQ6ayiAV7wxT/3KUqGNpi63mA1XkZ07jmPsoImU6sf/HlIJa2IaHPUOQV6Nvr9f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711472898; c=relaxed/simple;
	bh=j9+KzQZpU43Gy1xPqASOiMmjmgeGz47ZE8vBaEGqo2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YF8l8kvohfL0uig6/4r4/MzW4NKDtgLIyH7UfSCriKZwWHpcQPW5Aagqcl2ctTFGFq9x/tc+JslyboVFzWYsl+BksP5OUEZVvmOPiXTq6o+J0WQUijbKOYBVSyxGkTz5o2CJuWXAlPU5YLvPv+MmedrDGFdScimhFJegcbtDHnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byd6rTrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byd6rTrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99083C433F1;
	Tue, 26 Mar 2024 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711472897;
	bh=j9+KzQZpU43Gy1xPqASOiMmjmgeGz47ZE8vBaEGqo2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=byd6rTrjayCRgb8KkpI0pUj7IlWIE8tQCmkJU/elzY0jctbTQ+eMOrWn/pEMVHdoC
	 rG/ocZXKFKbJjM8OaLJMRb4wEpLRDeJE9LVpHTSdOEeTjJEblR6fGC30RABe+JXIrz
	 fBJbc0nf9mV++poC/PntriqPq6FcAgU32TmFMt206l2wV92GpV4St/IqJxcsYUtK5h
	 IzWsmKjtoYez2qe8GglCFx0h67ThEqL8XO5Dct/LNscnyw1KmYrlYczvm194+Tsnt4
	 P+b2HUq8N98LVjrbTH2l2q167TyEGCMsz5LDCLnghDa28e6jQ7ipLn/EtBlC5LRONS
	 Vw1KCpY753eCA==
Date: Tue, 26 Mar 2024 10:08:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] mkfs: use libxfs to create symlinks
Message-ID: <20240326170817.GO6390@frogsfrogsfrogs>
References: <171142135429.2220355.9379791574025871779.stgit@frogsfrogsfrogs>
 <171142135444.2220355.14042313671341548069.stgit@frogsfrogsfrogs>
 <ZgJjnY8iFD26xYUQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJjnY8iFD26xYUQ@infradead.org>

On Mon, Mar 25, 2024 at 10:56:45PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 25, 2024 at 09:02:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've grabbed the kernel-side symlink writing function, use it
> > to create symbolic links from protofiles.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  libxfs/libxfs_api_defs.h |    1 +
> >  mkfs/proto.c             |   72 ++++++++++++++++++++++++----------------------
> >  2 files changed, 39 insertions(+), 34 deletions(-)
> 
> Not really a huge saving :(  But the changes looks good:

Yeah, it's sad that using common code *increases* LOC...

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for reviewing!

--D
