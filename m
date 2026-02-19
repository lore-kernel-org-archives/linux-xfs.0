Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787C52580F2;
	Thu, 19 Feb 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771522902; cv=none; b=SoBPnINT6PsRr6jninioC/C4oW2lYfNU+PfNqiFc7I6W1MDX72odrem/6yp0VvPANreqLWxne1Li7JMabuUZd+Si251XJ5f6LC23sVvwRD4OgxDsRJsKBmNHvQqR/0IJlAkRp9wgzj6G/M9vTuNmLCGnvu99Pdp/6H24ejVGkQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771522902; c=relaxed/simple;
	bh=+5EKlCZXSKj5AZERPInNpq6HbizzuxCJDMqHpyc2f50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br0iRBFnl61nSMQ0ofvpl/pkU/76mzh71znmT6rK5ZkYrGz1xJNV2soUAPEue/zn1MzldNg55ztxPHrqqwHCNdWPXKVlwD42QiSRaLU3QX6xEgNo+ukwhZgw/zG+0m9lxzYevy76AeajtLGlyp9k+2saQKzracxjFpcnVSXk0N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uVy4IraA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVy4IraA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5DFC4CEF7;
	Thu, 19 Feb 2026 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771522902;
	bh=+5EKlCZXSKj5AZERPInNpq6HbizzuxCJDMqHpyc2f50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uVy4IraAVATY50PGsjp6R13/RQFHBsNMtXOace3HEx1uNPkHaN8VQm+I8EaH/b1Ry
	 UzHftV5vl7zNTT7tQKfpnOxh56HmpjhltIxNaRHecK81jlpQctn2L21QaldMFqZuN1
	 tf95qyrmhrhyWCqjaEkUYimbBQokKqsaP8zT9ZBJ0IRhocoXlaCRodAUgrriPlUE32
	 2YaUT5Uh6pz8gFYYqEJSMHC/D77SNKGIot5dA//Hw2pGnWiNRGFF688LnBDZgapvkv
	 erPzPiVpXX0Tc9TcoEcvHx0TVV067R0jSF2QTSbLNWGhywcsyRv0Mh1nCrzHnWz7q+
	 X5NBcaoMeAAKw==
Date: Thu, 19 Feb 2026 09:41:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 26/35] xfs: add a helper to decide if bmbt record
 needs offset conversion
Message-ID: <20260219174141.GN6490@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-27-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-27-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:26AM +0100, Andrey Albershteyn wrote:
> A little helper for xfs_bmbt_to_iomap() to decide if offset needs to be
> converted from a large disk one to smaller page cache one.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/xfs_fsverity.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/xfs_fsverity.h |  9 +++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 4b918eb746d7..4f8a40317dc3 100644
> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
> @@ -5,8 +5,13 @@
>  #include "xfs.h"
>  #include "xfs_format.h"
>  #include "xfs_inode.h"
> +#include "xfs_shared.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_fsverity.h"
>  #include "xfs_fsverity.h"
>  #include <linux/fsverity.h>
> +#include <linux/iomap.h>
>  
>  loff_t
>  xfs_fsverity_offset_to_disk(struct xfs_inode *ip, loff_t offset)
> @@ -33,3 +38,26 @@ xfs_fsverity_sealed_data(
>  	       (offset < fsverity_metadata_offset(inode));
>  }
>  
> +/*
> + * A little helper for xfs_bmbt_to_iomap to decide if offset needs to be
> + * converted from a large disk one to smaller page cache one.
> + *
> + * As xfs_bmbt_to_iomap() can be used during writing (tree building) and reading
> + * (fsverity enabled) we need to check for both cases.
> + */
> +bool
> +xfs_fsverity_need_convert_offset(
> +		struct xfs_inode	*ip,
> +		struct xfs_bmbt_irec	*imap,
> +		unsigned int		mapping_flags)

Odd ^^^^ indenting here.

> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	return	(fsverity_active(VFS_I(ip)) ||
> +		  xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION)) &&
> +		  (XFS_FSB_TO_B(mp, imap->br_startoff) >=
> +		  XFS_FSVERITY_REGION_START) &&

Kinda wish this wasn't a long complex if statement:

	const xfs_fileoff_t fsverity_off =
			XFS_B_TO_FSBT(mp, XFS_FSVERITY_REGION_START);

	if (!fsverity_active() && !xfs_iflags_test())
		return false;
	if (mapping_flags & IOMAP_REPORT)
		return false;
	return XFS_FSB_TO_B(mp, imap->br_startoff) >= fsverity_off;

> +		  !(mapping_flags & IOMAP_REPORT);

Hrmm.  We don't convert offsets for fiemap?  I suppose that makes sense.
IIRC the other users are bmap and swapfiles, and you can't swap to a
verity file.

(Blergh on bmap, that's just unconstrained crazy)

--D

> +
> +}
> +
> diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
> index 6f3d60f010d8..ab01ceef4d15 100644
> --- a/fs/xfs/xfs_fsverity.h
> +++ b/fs/xfs/xfs_fsverity.h
> @@ -12,6 +12,9 @@ bool xfs_fsverity_sealed_data(const struct xfs_inode *ip,
>  		loff_t offset);
>  loff_t xfs_fsverity_offset_to_disk(struct xfs_inode *ip, loff_t pos);
>  loff_t xfs_fsverity_offset_from_disk(struct xfs_inode *ip, loff_t offset);
> +bool xfs_fsverity_need_convert_offset(struct xfs_inode *ip,
> +				      struct xfs_bmbt_irec *imap,
> +				      unsigned int mapping_flags);
>  #else
>  static inline loff_t xfs_fsverity_offset_to_disk(struct xfs_inode *ip,
>  						 loff_t pos)
> @@ -30,6 +33,12 @@ static inline bool xfs_fsverity_sealed_data(const struct xfs_inode *ip,
>  {
>  	return false;
>  }
> +static inline bool xfs_fsverity_need_convert_offset(struct xfs_inode *ip,
> +						    struct xfs_bmbt_irec *imap,
> +						    unsigned int mapping_flags)
> +{
> +	return false;
> +}
>  #endif	/* CONFIG_FS_VERITY */
>  
>  #endif	/* __XFS_FSVERITY_H__ */
> -- 
> 2.51.2
> 
> 
