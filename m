Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C80830FA6
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 19:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4MTufhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E88C433C8;
	Mon,  4 Dec 2023 19:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701719587;
	bh=JBNQVHt6uGfyXNtDj9OgjHJregwqNrhl5IvRiGAQv3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A4MTufhygH8+Vol48UVLJXNscX2gd4e+cX+NCmORztYSqa6pWuyKSWlUtv4AVwKmS
	 kicXKHVnFguxZk1wO9Gs+M+/dY+flv9w8Rg+0uxOR4NjaxzwYcYjGFCxrUmzUvgJn+
	 UTwA2Qbj3uBJ6nRs24faNqLfSKgmlBzIMcm7zWVNc9VUkgj9fVQCZ+OTDnyAK+7ITq
	 KreyJhwMtRLh7PBki2cSMXALPAE1Yyr+6cJmQ9SX3tMYkkJKJ3kR5XbC9VfnVEXzHK
	 R5m+N+/5S9C/gZQdPbUxR3hmO0uprZ/6UVsFW0Kb94OnRVWRHQFsTdD8BbImoscMFe
	 /VE1PJahiedxg==
Date: Mon, 4 Dec 2023 11:53:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] libxfs: check the size of on-disk data structures
Message-ID: <20231204195306.GC361584@frogsfrogsfrogs>
References: <20231108163316.493089-1-hch@lst.de>
 <20231109195233.GH1205143@frogsfrogsfrogs>
 <20231110050846.GA24953@lst.de>
 <20231201020658.GU361584@frogsfrogsfrogs>
 <20231204043718.GA25793@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204043718.GA25793@lst.de>

On Mon, Dec 04, 2023 at 05:37:18AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 30, 2023 at 06:06:58PM -0800, Darrick J. Wong wrote:
> > I copy-pasta'd the whole mess from compiler_types.h and build_bug.h into
> > include/xfs.h.  It works, but it might be kinda egregious though.
> 
> Oh.  I actually have a local patch to simply switch to static_assert
> as that completly relies on the compiler and gives better output.  I
> haven't even written a proper commit log, but this is it:
> 
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 2f24bd42ac1dd7..3a5581ecb36d4c 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -7,16 +7,16 @@
>  #define __XFS_ONDISK_H
>  
>  #define XFS_CHECK_STRUCT_SIZE(structname, size) \
> -	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
> -		#structname ") is wrong, expected " #size)
> +	static_assert(sizeof(structname) == (size), \
> +		"XFS: sizeof(" #structname ") is wrong, expected " #size)
>  
>  #define XFS_CHECK_OFFSET(structname, member, off) \
> -	BUILD_BUG_ON_MSG(offsetof(structname, member) != (off), \
> +	static_assert(offsetof(structname, member) == (off), \
>  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
>  		"expected " #off)
>  
>  #define XFS_CHECK_VALUE(value, expected) \
> -	BUILD_BUG_ON_MSG((value) != (expected), \
> +	static_assert((value) == (expected), \

HAH LOL that's much better.  I think I even see that kernel code is
using it now, and wonder why BUG_BUILD_ON still exists.

Going back for another cup of koolaid now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		"XFS: value of " #value " is wrong, expected " #expected)
>  
>  static inline void __init
> 
