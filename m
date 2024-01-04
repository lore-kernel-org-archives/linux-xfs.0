Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307B915CB
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 01:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqTgjPal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8610EC433C8;
	Thu,  4 Jan 2024 01:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704332102;
	bh=XK+/+y1prMNPU8PIEktemD7UgzhlD1W+6rMSbgtbEjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GqTgjPalSK+YIG+HojeQ/wbSW3tROt9AEtmlVPBw8k1G8mSsh05pfl9ytngGfiFcK
	 yP9M/mL8sbZ0/t50ZSuPdEGcSrJJbH0tprWK1xmDocKfi4eAggLtJOr/MMoo9oU6Ui
	 rj009c559RSg/AWjvnutG7mWbdZaMX0aDW+w4hSIz/W9teDDvIBx79PykP0KaM4Wzx
	 sbx2PVc/Fc/Z8luTk6xi2qS+8+F0UztJX/lmp7WiazLOEmwyDkr+4YY5qyeHjhjfQ4
	 8bizS6ilCkOwU1kLMoXmxRM64H49GII6EIUUwnKbuZ59onpWw/C00AwnjhM/UHOZPY
	 y3KOOM7N4zxJA==
Date: Wed, 3 Jan 2024 17:35:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet
Message-ID: <20240104013502.GQ361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-1-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:11AM +0000, Christoph Hellwig wrote:
> Hi all,
> 
> this series refactors and simplifies the code in the xfs xfile
> abstraction, which is a thing layer on a kernel-use shmem file.
> 
> Do do this is needs a slighly lower level export from shmem.c,
> which I combined with improving an assert and documentation there.

What's the base for this series?  Is it xfs-linux for-next?  Or
djwong-wtf?

--D

> One thing I don't really like yet is that xfile is still based on
> folios and not pages.  The main stumbling block for that is the
> mess around the hwpoison flag - that one still is per-file and not
> per-folio, and shmem checks it weirdly often and not really in
> at the abstractions levels where I'd expect it and feels very
> different from the normal page cache code in filemap.c.  Maybe
> I'm just failing to understand why that is done, but especially
> without comments explaining it it feels like it could use some
> real attention first.
> 
> Diffstat:
>  Documentation/filesystems/xfs/xfs-online-fsck-design.rst |   10 
>  fs/xfs/scrub/trace.h                                     |   38 -
>  fs/xfs/scrub/xfarray.c                                   |   60 --
>  fs/xfs/scrub/xfarray.h                                   |    3 
>  fs/xfs/scrub/xfile.c                                     |  311 +++------------
>  fs/xfs/scrub/xfile.h                                     |   62 --
>  mm/shmem.c                                               |   24 +
>  7 files changed, 143 insertions(+), 365 deletions(-)
> 
