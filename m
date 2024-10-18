Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA3714A09A;
	Fri, 18 Oct 2024 06:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231225; cv=none; b=vGWee7NbzMD0AFSGpHXUTaClPkbt0ho3A+62IAyKYEGR6u/XveSL10IbK4tQI04cF81uSUJSVsRaxGEiuP9hu4IPss3Jj0n/An1fRf/tidexAVMyzHn/d7/eDZ+5AVqu/TiqToLcMCAbVnX3HjhwYApCr9zMoNST9u9bx6Mqj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231225; c=relaxed/simple;
	bh=2Vd5aNMqQdgqBlO8RAW8K3OzD1t4MFyLe6im/Hnr/nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4EfcPPq1qHxIx4sYaeJmG0xlNfRHCEpmykMoN6LrWxI0TP+2HbuNnxu7soUyBffvQTiRKHakLkkbn785Fo827dmf1XagSJTpCEA0KbTGGsdR94a3UYvJBdnsBIHiFu7ZnHSqGCzNcU51j57mmY25WcZcaYJNf46KD+2+5TYaXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwuRhgGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwuRhgGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2804AC4CEC3;
	Fri, 18 Oct 2024 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729231224;
	bh=2Vd5aNMqQdgqBlO8RAW8K3OzD1t4MFyLe6im/Hnr/nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kwuRhgGG08VvkbNTDqGwdAHLpSmagRLhFasvNqug3c7lPq/sLS4bEVK00ZGgECG/a
	 aSWQJmYJzH++/EgNR2a9+nVj70TmsZcnQOHxXi6S6VP7JNWFx9L+qmCNPXzujE5Pe0
	 obQBiz3vTypty/2sm2LzvV3UoeIcBew0QsgzXW4k=
Date: Fri, 18 Oct 2024 08:00:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 20/29] xfs: don't fail repairs on metadata files with no
 attr fork
Message-ID: <2024101838-thickness-exposure-ec78@gregkh>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
 <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>

On Thu, Oct 17, 2024 at 11:58:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a minor bug where we fail repairs on metadata files that do not have
> attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.
> 
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: 5a8e07e799721b ("xfs: repair the inode core and forks of a metadata inode")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/repair.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Why is a bugfix / stable-tagged-patch, number 20 in a 29 patch series?
Why isn't it first, or better yet, on it's own if it is fixing a bug
that people want merged "soon"?

thanks,

greg k-h
