Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF4F16415
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460568; cv=none; b=uzYwB9eC3mJQWOP1eqeLmdutVYD56ppQsdBiSxIk/RD3h5xRmeZVhtPjFnC3KqDvnktbvBH33G65fA/rROXpebM34ufmwhspvK4f3c2zi2nogowT1Y4bhyZ/d5o6GXU0BJfPQTg2MYnqcpRYmr1EfyTYUuik0vc0CQopOxH5AUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460568; c=relaxed/simple;
	bh=W6Fz/AzrwpfnwCxGSRlCES0CSyfwbZL/RgAEBevDRtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhL5L9vhBFWpkb4mxEUH9z+ggib6Oi0PE6IDwmdVi6K2P3swRETtBiOb3AXvA1oduigCglCOWlACJ70i9lO3Cb58UgeaTwVNJdHR21L36UQ9P2DA+/vAg182H4l4pG4tqMHmPMG+xBQ2uBagmuYKesli7pwttDRFCfB+EtieLCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8ezVg5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8ezVg5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1310FC433F1;
	Thu, 14 Mar 2024 23:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710460568;
	bh=W6Fz/AzrwpfnwCxGSRlCES0CSyfwbZL/RgAEBevDRtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r8ezVg5uNxcpSzZyK2iPhmz/ZHMkk1wsYr8TCbEgNnyO7XElzmusRMuZH4WxM6Mr6
	 w7mmYQCcpFVKiq7Z+cjrGLwtttaeq3Jp893dljgy7IysOd8+zD+TPQvdRgkLkoumve
	 CjEAokk62xU+LGAZPFuHemBmANQ6fXX8lDyZzwbsW8dzUd0Yirk5EJYcqxDJdQIKNi
	 xTfLV6Qf5WYt95Ri0SIPh3BRlZCRx0flJkBec093nEM+9TKvr3kdo5Cq4TRm+AQ30B
	 S6dNU1ogtWO/DrdnDcv6HZNUyO02RLyP+bAjPuN7h5oxIVw47fE6sNKeeu/TMoqO+k
	 xl3yTNwrcqbGQ==
Date: Thu, 14 Mar 2024 16:56:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: rebuild block mappings from rmapbt data
Message-ID: <20240314235607.GT1927156@frogsfrogsfrogs>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434369.2065697.1871117227419755749.stgit@frogsfrogsfrogs>
 <ZfJaGhIgMvL2LBG6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfJaGhIgMvL2LBG6@infradead.org>

On Wed, Mar 13, 2024 at 06:59:54PM -0700, Christoph Hellwig wrote:
> > +#define min_t(type, x, y) ( ((type)(x)) > ((type)(y)) ? ((type)(y)) : ((type)(x)) )
> 
> Should this really be a hidden in a .c file in repair vs in a common
> header where we can use it everywhere?

Eh, yeah, I'll move it to libfrog/util.h.  I'll even use the one that's
in libxfs_priv.h.

#define min_t(type,x,y) \
	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
