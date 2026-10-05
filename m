Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA7C3E51E8
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236663; cv=none; b=VXIUP4cNGl5+Uibrc1G0KAxt5zTzw+utASiU1HTnnmpR+lqfQr/RJnXkTPCaBBEBWY2hyilObQfAiAPY3xT8CboDL+hWSLmil83BkwnwU1VAfkhsJLepVuqa4z0BbbxDTnKbkpXcLZ8EQtugNbQ9HNvgUqtnrB4u5c09rYlAnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236663; c=relaxed/simple;
	bh=W1arLiAKp6NQMtHe4c85nnCVLsNfuC8/lkOjJxcXwQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Le2f0c/xapKvx22MhZXOnVDlUlCr4BcWerUimxukD1nTwUW5NdfitdNYEYSCFscqUGipYtT6JvqYYeyA3u15FPf1oo6teGvGdsN9bc90J+kVexkPU5oPZHhqfV3h0yf2fgY4BEBLMds5XPsFvRExGarzwQv0OD6PXpLiMYicHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giumI5ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giumI5ff"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C38D91F000FF;
	Mon,  5 Oct 2026 21:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236659;
	bh=TsaKwNqL9qCS6GomG/TV3jBvmzIz0dTGf+8kP8ubBnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=giumI5ffpV/dudHIf0LpYdaW9Z+IK5qZmGt0BjN4PyFMWseRhNAvOV7ChTPbsI8Rh
	 p4ILgma5pajjW4XD2b3V9rNk3OaGk5zZaQ3M3FSOg1RYbqnXkCixCq52Sbj/IUOXYT
	 DLjo0whGm0VReXC9TOgNsy6cJ67QXxZ+8g6lN066aQ33hDdC3IByxCJUAKXAX9Cg+d
	 H7mGM072I2tsuKgXtPcTXl2bqJjutg8YRpmyi7gDQ362skUa8SMUF1V5ap5EmEJHZF
	 QoaDp5B1LcBaQDFBCMaIPOE1+SJ6M1O9STDb9KNj46ffwnh4bTDFpAy6KM3JDY62xS
	 fbGE1Gx6Aq8Cw==
Date: Mon, 5 Oct 2026 14:44:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] libxfs: use libxfs.h in xfs_platform.h
Message-ID: <20261005214419.GH2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-2-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:11PM +0200, Christoph Hellwig wrote:
> xfs_platform.h duplicates a lot of the include chains and some of the
> definitions in include/libxfs.h.  Use that header from xfs_plaform.h and
> remove the duplication.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me to combine these, not sure why we didn't earlier...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/xfs_platform.h | 37 +------------------------------------
>  1 file changed, 1 insertion(+), 36 deletions(-)
> 
> diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
> index d09fb0aae00f..9aa898200da8 100644
> --- a/libxfs/xfs_platform.h
> +++ b/libxfs/xfs_platform.h
> @@ -37,33 +37,9 @@
>  #ifndef _XFS_PLATFORM_H
>  #define _XFS_PLATFORM_H
>  
> -/* CONFIG_XFS_* must be defined to 1 to work with IS_ENABLED() */
> -#define CONFIG_XFS_RT 1
> -#define CONFIG_XFS_BTREE_IN_MEM 1
> -
> -#include "libxfs_api_defs.h"
> -#include "platform_defs.h"
> -#include "xfs.h"
> -
> -#include "list.h"
> -#include "hlist.h"
> -#include "cache.h"
> -#include "bitops.h"
> -#include "kmem.h"
> -#include "libfrog/radix-tree.h"
> -#include "libfrog/bitmask.h"
> -#include "libfrog/div64.h"
> -#include "libfrog/util.h"
> -#include "atomic.h"
> -#include "spinlock.h"
> +#include "libxfs.h"
>  #include "linux-err.h"
>  
> -#include "xfs_types.h"
> -#include "xfs_arch.h"
> -
> -#include "xfs_fs.h"
> -#include "libfrog/crc32c.h"
> -
>  #include <sys/xattr.h>
>  
>  /* Zones used in libxfs allocations that aren't in shared header files */
> @@ -77,9 +53,6 @@ extern struct kmem_cache *xfs_trans_cache;
>  #define IOMAP_F_SHARED				0x04
>  #define xfs_bmbt_to_iomap(a, b, c, d, e, f)	((void) 0)
>  
> -/* CRC stuff, buffer API dependent on it */
> -#define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
> -
>  /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
>  struct iomap {
>  	unsigned long long	offset;	/* do not use */
> @@ -88,14 +61,6 @@ struct iomap {
>  
>  #define cancel_delayed_work_sync(work) do { } while(0)
>  
> -#include "xfs_cksum.h"
> -
> -/*
> - * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
> - * every files via a similar include in the kernel xfs_linux.h.
> - */
> -#include "libxfs_io.h"
> -
>  /* for all the support code that uses progname in error messages */
>  extern char    *progname;
>  
> -- 
> 2.53.0
> 
> 
