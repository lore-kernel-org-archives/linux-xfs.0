Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC645961
	for <linux-xfs@vger.kernel.org>; Sun,  7 Apr 2024 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712533867; cv=none; b=MsUOzPdsC2f+kIpP346/2wcCyBGjgZooykXoCI/sC0I0JWchBx5qNRoZVURC2mAUy8qqgY3qBzRsZmPHsNKkUl269E13/AP0G6PvzWvKmreEfb1DvpP7E9fMBMUtr2APHUP0alVPatmZUDbIOLOFGBLUC9LEgmUdnehvbaMPM0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712533867; c=relaxed/simple;
	bh=M24OEuwacvGs5lnxvOH8rimxuPdPvsIYSVVbsIFCxKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXf5iU1UE4QAANB8AqG1DHg+s7691bmz3bo0Z4uJfrxmCLtTXdk+/sv8iWnetG+2QzM5lU8m3DDU0VTOkqmP7isc0bolcSu1b37ctU94f5YgEPe2AXcdWiDIyLYkUIj5qgGLxAasp4dls/yUzRix2R8wqStGBMDPqM3Gd/2RCGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=zwsQ26+q; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zwsQ26+q"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso2701097a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 16:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712533865; x=1713138665; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2lKEjAvipRwKwea1GCWqPmW6DzzA6v2y16CMobCoY1I=;
        b=zwsQ26+qRKQZSie+HF2uRudECTWqgPKL+AYkqmXqDwBddSIhdfBGz+ENbUDnwTblmB
         XnZGIoAneZZFqnjUQ7SPoSEH5/+aAwsf67kCOPjNCkY2k7JQYdX38HZUNVqGsKM2cuR0
         8fxVemL4M9gNCpwD+e24LChW0a8rkJibK/6nDLK7z/YHkAXNezpB63tJu/G7zZ3aFomu
         NPxtvPtyPGk/08m28odxg9+RxnZHJj2acodn6Lp1Ym9QbQJgqwGdcZNVKwOYmNBenWdG
         sRAxcrSi3dKQ9uzel8IQutHc3sk+iZnBetKS8ggML9QKAJYgrzbhT2zelzXtA3KC3nbW
         AwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712533865; x=1713138665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lKEjAvipRwKwea1GCWqPmW6DzzA6v2y16CMobCoY1I=;
        b=fgLQqsH4AQTeSHZ83Ei/Q1eMQplUQ6VQS3s/iUMBVoD/GRqpwCPyeoIv0cYv9NwHPb
         FtuTBcRWmA3QfP+aLfepBzZyQ35DnhJqv1DRu84ENarEAawUHfqTUTe8Th4TRJ/q2umw
         DN7FD3FbVOvl5GeRYdToijRz16s0p9f8tNQxmMqgM9+YVMZngYnBx+dpfQgsbzC+lCSm
         OoFFg1qsHYYWAwAaKbty7BtpwNUgeYVhdR7YNhvkVMZIM12ctX/uIdQfeMjr8rpkslrl
         +++t/rxnamPhWn00KHji+Snc5E5i75jvimz3W/UKm4hode9sPvnslAA0LrkaN2Ithp7W
         caVA==
X-Forwarded-Encrypted: i=1; AJvYcCWBi1l491vKEwH5ML/7wxGCqZhqQC8K8owEJiOdzstzAOsUgJ5IjKnw2ya5k2/gH6eQ+70363fvxld4vqbElabBerZqzUgoQotg
X-Gm-Message-State: AOJu0YwjkFWacMZiYq8C8P1metknE+C2ocZrpXpbp0A4sstn1/jD911q
	qay70NP49L8pGkvRMq87Zi8ezH/DJHMDYXJ3AR1DvpOwWWQgE2sruKxu50qg2b8=
X-Google-Smtp-Source: AGHT+IFmtQRENLz3IusvOYYSIWdf10CK3g+wLrim4FJsdK2aCtLNUH49eIXvxutnyCH1/NMfksy8fw==
X-Received: by 2002:a17:90a:d808:b0:2a2:2eee:e86e with SMTP id a8-20020a17090ad80800b002a22eeee86emr5105644pjv.2.1712533864552;
        Sun, 07 Apr 2024 16:51:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id f16-20020a633810000000b005e43cce33f8sm5182544pga.88.2024.04.07.16.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:51:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtcHt-007lEa-0b;
	Mon, 08 Apr 2024 09:51:01 +1000
Date: Mon, 8 Apr 2024 09:51:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: introduce a file mapping exchange log intent
 item
Message-ID: <ZhMxZdvk8Tq9WcLu@dread.disaster.area>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380732.3216674.5999741892452595331.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380732.3216674.5999741892452595331.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 06:53:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Introduce a new intent log item to handle exchanging mappings between
> the forks of two files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile                 |    1 
>  fs/xfs/libxfs/xfs_log_format.h  |   42 ++++++-
>  fs/xfs/libxfs/xfs_log_recover.h |    2 
>  fs/xfs/xfs_exchmaps_item.c      |  235 +++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_exchmaps_item.h      |   59 ++++++++++
>  fs/xfs/xfs_log_recover.c        |    2 
>  fs/xfs/xfs_super.c              |   19 +++
>  7 files changed, 357 insertions(+), 3 deletions(-)
>  create mode 100644 fs/xfs/xfs_exchmaps_item.c
>  create mode 100644 fs/xfs/xfs_exchmaps_item.h
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 2474242f5a05f..68ca9726e7b7d 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_buf_item.o \
>  				   xfs_buf_item_recover.o \
>  				   xfs_dquot_item_recover.o \
> +				   xfs_exchmaps_item.o \
>  				   xfs_extfree_item.o \
>  				   xfs_attr_item.o \
>  				   xfs_icreate_item.o \
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 16872972e1e97..09024431cae9a 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -117,8 +117,9 @@ struct xfs_unmount_log_format {
>  #define XLOG_REG_TYPE_ATTRD_FORMAT	28
>  #define XLOG_REG_TYPE_ATTR_NAME	29
>  #define XLOG_REG_TYPE_ATTR_VALUE	30
> -#define XLOG_REG_TYPE_MAX		30
> -
> +#define XLOG_REG_TYPE_XMI_FORMAT	31
> +#define XLOG_REG_TYPE_XMD_FORMAT	32
> +#define XLOG_REG_TYPE_MAX		32
>  
>  /*
>   * Flags to log operation header
> @@ -243,6 +244,8 @@ typedef struct xfs_trans_header {
>  #define	XFS_LI_BUD		0x1245
>  #define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
>  #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
> +#define	XFS_LI_XMI		0x1248  /* mapping exchange intent */
> +#define	XFS_LI_XMD		0x1249  /* mapping exchange done */
>  
>  #define XFS_LI_TYPE_DESC \
>  	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
> @@ -260,7 +263,9 @@ typedef struct xfs_trans_header {
>  	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
>  	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
>  	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
> -	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
> +	{ XFS_LI_XMI,		"XFS_LI_XMI" }, \
> +	{ XFS_LI_XMD,		"XFS_LI_XMD" }
>  
>  /*
>   * Inode Log Item Format definitions.
> @@ -878,6 +883,37 @@ struct xfs_bud_log_format {
>  	uint64_t		bud_bui_id;	/* id of corresponding bui */
>  };
>  
> +/*
> + * XMI/XMD (file mapping exchange) log format definitions
> + */
> +
> +/* This is the structure used to lay out an mapping exchange log item. */
> +struct xfs_xmi_log_format {
> +	uint16_t		xmi_type;	/* xmi log item type */
> +	uint16_t		xmi_size;	/* size of this item */
> +	uint32_t		__pad;		/* must be zero */
> +	uint64_t		xmi_id;		/* xmi identifier */

Why does this ID need to be a 64 bit ID?  If it is 32 bit, then
there's no need for any padding, and it doesn't seem likely to me
that we'd have millions of exchanges in flight at once.

(Edit: I see why later - I address it there....)

> +
> +	uint64_t		xmi_inode1;	/* inumber of first file */
> +	uint64_t		xmi_inode2;	/* inumber of second file */

Inode numbers are not unique identifiers. Intents get replayed after
everything else has been replayed, including inode unlink and
reallocation.

Without a generation number, there is no way to determine if the
inode number in the intent is actually pointing at the correct inode
when we go to replay the intent.

Yes, I know it's unlikely that this might occur, but I'd much prefer
that we fully identify inodes in the on-disk metadata so we can
check it at recovery time than leaving it out and just hoping we are
operating on the correct inode life-cycle...


> +	uint64_t		xmi_startoff1;	/* block offset into file1 */
> +	uint64_t		xmi_startoff2;	/* block offset into file2 */
> +	uint64_t		xmi_blockcount;	/* number of blocks */
> +	uint64_t		xmi_flags;	/* XFS_EXCHMAPS_* */
> +	uint64_t		xmi_isize1;	/* intended file1 size */
> +	uint64_t		xmi_isize2;	/* intended file2 size */

How do these inode sizes differ from xmi_startoff{1,2} +
xmi_blockcount?

> +/* Allocate and initialize an xmi item. */
> +STATIC struct xfs_xmi_log_item *
> +xfs_xmi_init(
> +	struct xfs_mount	*mp)
> +
> +{
> +	struct xfs_xmi_log_item	*xmi_lip;
> +
> +	xmi_lip = kmem_cache_zalloc(xfs_xmi_cache, GFP_KERNEL | __GFP_NOFAIL);
> +
> +	xfs_log_item_init(mp, &xmi_lip->xmi_item, XFS_LI_XMI, &xfs_xmi_item_ops);
> +	xmi_lip->xmi_format.xmi_id = (uintptr_t)(void *)xmi_lip;

OK. Encoding the pointer as the ID is a mistake we made with EFIs
and we should stop repeating it in all new intents. There is no
guarantee that the pointer is a unique identifier because these are
allocated out of a slab cache. Hence we can allocate an xmi, log it,
finish the xmds, free the xmi, then run another exchange and get
exactly the same XMI pointer returned to us for the new exchange
intent. Now we potentially have multiple exchange items in the
journal with the same ID.

Can we use a u32 and get_random_u32() for the ID here, please? We
already do this for checkpoint discrimination in the log (i.e. to
identify what checkpoint an ophdr belongs to), so we really should
be doing the same for all ids we use in the journal for matching
items.

Longer term, We probably should move all the intent/done identifiers
to a psuedo random identifier mechanism, but that's outside the
scope of this change....

> +/*
> + * This routine is called to create an in-core file mapping exchange item from
> + * the xmi format structure which was logged on disk.  It allocates an in-core
> + * xmi, copies the exchange information from the format structure into it, and
> + * adds the xmi to the AIL with the given LSN.
> + */
> +STATIC int
> +xlog_recover_xmi_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_xmi_log_item		*xmi_lip;
> +	struct xfs_xmi_log_format	*xmi_formatp;
> +	size_t				len;
> +
> +	len = sizeof(struct xfs_xmi_log_format);
> +	if (item->ri_buf[0].i_len != len) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	xmi_formatp = item->ri_buf[0].i_addr;
> +	if (xmi_formatp->__pad != 0) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	xmi_lip = xfs_xmi_init(mp);
> +	memcpy(&xmi_lip->xmi_format, xmi_formatp, len);

Should this be validating that the structure contents are within
valid ranges?

-Dave.

-- 
Dave Chinner
david@fromorbit.com
