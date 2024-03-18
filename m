Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FBE5786E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710783252; cv=none; b=mC1yUizm3py4sz3xhj6FwWdE4i+f6h8MxH+ZJtZYx8eKGZxuh7Evd7pD3hvc2uLxjIuingpeuB4yrmByUbUN4XPut459lfQZUddikRAvD91U4fDIel5ho9/7sWT3ikqFDglEMx1lqXqThkMBzbzHAeA9BZ5j5NIbhkRushq94uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710783252; c=relaxed/simple;
	bh=UTbEDQuBPq0vcs45OgpExSveoxGH1wHzjv+GJN8St7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqGvRT0SlnLqAeUg3nPYqH4eRJtYMG3oU/SjFFo9b29ycpac/VfKpnvhr+ZkLv3lFgQCjUXD8XB4jA/ZRhFnIM9+7KsT8LTMuxiDF4HHPvCLOKvLS0LqA5Uvnnli4KXBQcDR/ZanlJY65SPYhWJsYkJEf0wgkw/of6uEZDmPJfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfhD0Bv/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfhD0Bv/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710783249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1b336hcpmrVHHwLQeQ8dAMc9BcLym1+XVHhIRwOaNJE=;
	b=PfhD0Bv/1bKsVZvLJCzGNN4xaw6KZgZpxz99R4EXVMiL7c2CuCp/sfTVmQ7DoA7bcVmHvu
	OjL8DGLukKPBDvM6u/2osuZ8PoYBOgYvxPhsSLeF6U2JD6d7L07oHa7e9DOxj4cBcNp0mS
	quKs6gbMmdF0bq4lEnF5x20AIhDKt00=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-vOW10iI6MK2zmObyXIEZuQ-1; Mon, 18 Mar 2024 13:34:08 -0400
X-MC-Unique: vOW10iI6MK2zmObyXIEZuQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-513e50a5aaeso1400994e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 10:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710783246; x=1711388046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1b336hcpmrVHHwLQeQ8dAMc9BcLym1+XVHhIRwOaNJE=;
        b=jahbiNvmvzjKkPn8nSAqkhEmMgQuo2FaZHtVCy7WSFU7GuQqiPBRcKFPB0MdNUFjCG
         IxB5EFdMhhvwN/SW/jCeP0Y6flN8eWkgYJm5XKBET8fNnXUM4wXlrWoPyRbJsRB7J6ln
         d4zOVtzL3LTmY6wEDvBUdvLm6GVc8IWKT4KwgYxI2lM7T3FjwhpwOWArqpCoAeTbqWe7
         +im+y45ZoPpvnwi6xUeYoCHt/+tb7RbL9RsrVLMfNHn1/h53lZu6dcEUk3BksPqU3na6
         BOgkziAGp5ICUTNHWVrPxAe/wQ42aE625PStv+5AIHOUlUyDCdmrH06Jl1n15urqJE9H
         4bCw==
X-Forwarded-Encrypted: i=1; AJvYcCWIk8kstkv66UhFbJEG7JhBG6dg6Tf0mNwf0ZSGEprRyQ+Uuk/P1/aMb58P7jCJJBAw2Riucu9kXmpakM1hQbyE5MJH1R8TQzkR
X-Gm-Message-State: AOJu0YwmqNKxlQNhV+L36tUeh3A5Cimp0zwbqMGfxm29qikFCMQryLLu
	HQ6pq1fagj9N+lCXq7uH5kkCA4yISVJ+A1ImLK2dNVN891c0QcY9y5DnzoxEzPbVXw90SV5WBqG
	3xd55anu5p3EphlgkiNW7Z8rzahDCcVJ48tSjURuDhNWA1PTecRerpd64CLQl7iGH
X-Received: by 2002:a19:9146:0:b0:513:d3c2:f094 with SMTP id y6-20020a199146000000b00513d3c2f094mr8043635lfj.29.1710783245869;
        Mon, 18 Mar 2024 10:34:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzpiw4+mEtjtGD7WM2sm40ah3Ge0myoXaoUNKqmzufoploM8oU95BG7gPUFQDrqvtjqK7wRg==
X-Received: by 2002:a19:9146:0:b0:513:d3c2:f094 with SMTP id y6-20020a199146000000b00513d3c2f094mr8043627lfj.29.1710783245311;
        Mon, 18 Mar 2024 10:34:05 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id bh25-20020a05600c3d1900b0041461b04cd2sm456682wmb.3.2024.03.18.10.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:34:05 -0700 (PDT)
Date: Mon, 18 Mar 2024 18:34:04 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/40] xfs: teach online repair to evaluate fsverity
 xattrs
Message-ID: <cukuakjpyim572vkhcl24xxnkrgrmkkalkrnoglte735jmpm7m@epenfnca5a4s>
References: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <171069246470.2684506.16777519924436608697.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069246470.2684506.16777519924436608697.stgit@frogsfrogsfrogs>

On 2024-03-17 09:32:31, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach online repair to check for unused fsverity metadata and purge it
> on reconstruction.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/attr.c   |  102 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/attr.h   |    4 ++
>  fs/xfs/scrub/common.c |   27 +++++++++++++
>  3 files changed, 133 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index ae4227cb55ec..c69dee281984 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -21,6 +21,8 @@
>  #include "scrub/dabtree.h"
>  #include "scrub/attr.h"
>  
> +#include <linux/fsverity.h>
> +
>  /* Free the buffers linked from the xattr buffer. */
>  static void
>  xchk_xattr_buf_cleanup(
> @@ -135,6 +137,91 @@ xchk_setup_xattr(
>  	return xchk_setup_inode_contents(sc, 0);
>  }
>  
> +#ifdef CONFIG_FS_VERITY
> +/* Extract merkle tree geometry from incore information. */
> +static int
> +xchk_xattr_extract_verity(
> +	struct xfs_scrub		*sc)
> +{
> +	struct xchk_xattr_buf		*ab = sc->buf;
> +
> +	/* setup should have allocated the buffer */
> +	if (!ab) {
> +		ASSERT(0);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	return fsverity_merkle_tree_geometry(VFS_I(sc->ip),
> +			&ab->merkle_blocksize, &ab->merkle_tree_size);
> +}
> +
> +/* Check the merkle tree xattrs. */
> +STATIC void
> +xchk_xattr_verity(
> +	struct xfs_scrub		*sc,
> +	xfs_dablk_t			blkno,
> +	const unsigned char		*name,
> +	unsigned int			namelen,
> +	unsigned int			valuelen)
> +{
> +	struct xchk_xattr_buf		*ab = sc->buf;
> +
> +	/* Non-verity filesystems should never have verity xattrs. */
> +	if (!xfs_has_verity(sc->mp)) {
> +		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, blkno);
> +		return;
> +	}
> +
> +	/*
> +	 * Any verity metadata on a non-verity file are leftovers from a
> +	 * previous attempt to enable verity.
> +	 */
> +	if (!IS_VERITY(VFS_I(sc->ip))) {
> +		xchk_ino_set_preen(sc, sc->ip->i_ino);
> +		return;
> +	}
> +
> +	switch (namelen) {
> +	case sizeof(struct xfs_verity_merkle_key):
> +		/* Oversized blocks are not allowed */
> +		if (valuelen > ab->merkle_blocksize) {
> +			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, blkno);
> +			return;
> +		}
> +		break;
> +	case XFS_VERITY_DESCRIPTOR_NAME_LEN:
> +		/* Has to match the descriptor xattr name */
> +		if (memcmp(name, XFS_VERITY_DESCRIPTOR_NAME, namelen)) {
> +			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, blkno);
> +		}
> +		return;
> +	default:
> +		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, blkno);
> +		return;
> +	}
> +
> +	/*
> +	 * Merkle tree blocks beyond the end of the tree are leftovers from
> +	 * a previous failed attempt to enable verity.
> +	 */
> +	if (xfs_verity_merkle_key_from_disk(name) >= ab->merkle_tree_size)
> +		xchk_ino_set_preen(sc, sc->ip->i_ino);
> +}
> +#else
> +# define xchk_xattr_extract_verity(sc)	(0)
> +
> +static void
> +xchk_xattr_verity(
> +	struct xfs_scrub	*sc,
> +	xfs_dablk_t		blkno,
> +	const unsigned char	*name,
> +	unsigned int		namelen)
> +{
> +	/* Should never see verity xattrs when verity is not enabled. */
> +	xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, blkno);
> +}
> +#endif /* CONFIG_FS_VERITY */
> +
>  /* Extended Attributes */
>  
>  struct xchk_xattr {
> @@ -194,6 +281,15 @@ xchk_xattr_listent(
>  		goto fail_xref;
>  	}
>  
> +	/* Check verity xattr geometry */
> +	if (flags & XFS_ATTR_VERITY) {
> +		xchk_xattr_verity(sx->sc, args.blkno, name, namelen, valuelen);
> +		if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT) {
> +			context->seen_enough = 1;
> +			return;
> +		}
> +	}
> +
>  	/* Does this name make sense? */
>  	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
>  		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);

Would it be better to check verity after xfs_attr_namecheck()?
Invalid name seems to be a more basic corruption.

-- 
- Andrey

