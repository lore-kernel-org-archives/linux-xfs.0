Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C7841A575
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236725; cv=none; b=CfJwnJe+wtmMB1QtrZzngA4O7mMyZH4JL2+KIhdo6ZeFTg4jnyk0EIKSaoGNJacmjsYYyP/iBj2rlpvylKQL4Nz2nHhcFnk+KAfXGkQNDmeRKKQBdx7LHV68uyLDadfgbkwKAYAThbm2nVywnMxqpS02FnyZ5FdkU//4m7kV3bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236725; c=relaxed/simple;
	bh=2NiXE4blnqpE3om98iwIX45VDmrgULUfs09gJtGoALc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XftCvTzWCt7D0q/CeLwIW1YeEwyCmLy565TBntNzypLODDLYtyS75a17+ZnK5A6expL4bT3dcYJ+w6xLw1UuNYSckx0vrALW4lFfTqaHsrVl3/3/Ddtq4G97KGCiUbpmkbRaXsXNSpR9Y69p8cCxaaqdHMohi8yzpV5ZdsvQI64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jypphVnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jypphVnK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F5381F000FF;
	Mon,  5 Oct 2026 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236721;
	bh=N0o2R6bNBqAQDQzfyeIp2WqPyxsr6MVqbzEKl8v3SYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jypphVnKAV5FN/7MH71G3TVmDjvLqnpxjgNW1tGuZdVU4rOPAOvviq9Av5ZBFzGUF
	 6SDSatlvAvRSVFuhifhCXdLurUBJXTsmwR3YDERQWfAIngWDXVaCkXg+c/QJt/8eCU
	 M7WswAUAc5mkMbZxfi4pXI2y4cge9csxDyx3/BTqmu4AYnrY6RWfzV3zXzQBCoH1Fw
	 hgo1v/mhFeU4Esa0WxG4Uk/HWeh4Cmf646P1auew443HaoUkyGB+WNmo00B3uYLAiz
	 mhS3NMtSDo30HLBNpxi0ElHvXvcVQ/OUFITM3l2NeQFNV3aLfoYHWx3RQZ+Y4nNkpO
	 0UdLRiX89qkrg==
Date: Mon, 5 Oct 2026 14:45:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] libxfs: remove a spurious xfs_rtbitmap.h include
 in xfs_sb.c
Message-ID: <20261005214521.GJ2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-4-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:13PM +0200, Christoph Hellwig wrote:
> This fully resyncs with the kernel version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/xfs_sb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index ea99f8b5eee5..cccbcd153316 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -27,7 +27,6 @@
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtrmap_btree.h"
>  #include "xfs_rtrefcount_btree.h"
> -#include "xfs_rtbitmap.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> -- 
> 2.53.0
> 
> 
