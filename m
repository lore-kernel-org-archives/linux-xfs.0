Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5C955C07
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784236; cv=none; b=YGmwqrYeGuPLwt+PD3dK6YDKC8KXj4rDY/T2tkLluRVJMdtfT/D5eNEa1d3bRKuwTSq6DfcKIlG+PON7cxKph9VCcBssnWv2D5DQXQ/a4BI+KufuRoz1jwQg1krtxV87s1yz/DFyJUAiB/InwDVXnR769kvIrdDwuGB7mD+x+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784236; c=relaxed/simple;
	bh=VSQ0tmSwRjDwW5fy7UUgJMNC6Ng/wGsRe7imRURDMb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKSp5IYyTikhT3I9xiSZHPwpGzATOlI6PgM3XIaUdEILgrvkuiIH1A1EHhoT4fqltRnIrI/NOR/aer2VNYKcvO2/55Prfp1MpB+ZVImPR5ucAS6G9kxmBL07l6RjcCidjJSmEiLkykBzse4V5AcBmkHPQCsZGnoNBKzWbH4352k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pb+zJL5L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pb+zJL5L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710784233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Or4VimCWvfyGUvZM7p25HXg/XaR3dHWNB4n6Dz87mU=;
	b=Pb+zJL5LoPVX4n7jqwi34Mi+/0/xGzk3Xaf6TiQwxXvgorXnm805/wL4Q9YhHvLjUXMB38
	l7kIoTf/oXEiaj7f7rN8pmaIdXdPFfX6r5t95g3OOlfKog/WapCyHl2IFlV5j3nslq6DSp
	Op7lw1nUSxyxNajWBSMG/0DJ2nWgOQk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-dJrZMQvBNnGnDlnPQDLk7Q-1; Mon, 18 Mar 2024 13:50:32 -0400
X-MC-Unique: dJrZMQvBNnGnDlnPQDLk7Q-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ece03ca5dso2722699f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 10:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710784230; x=1711389030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Or4VimCWvfyGUvZM7p25HXg/XaR3dHWNB4n6Dz87mU=;
        b=eS4h4KsYRV/3k9BGv0Ai8QyR1ARSCd/GuLq41pTFrE0//cQV0AWPAT9JEEfWgR5OVs
         2FQvh5Q0rgnnYZ8DiYjwsmZo7mD0C8nTWW1bJb1xUqPN6mfLFCjoZ1bYa0Ee0v5LBniU
         Zmqs65vlOe0vE0zsqf/cf+VIvq7BBpd3ixgAGNUO7jJF0cwY5uken2FmH/EzvlX4PBu4
         DiYZOWL0ELXOXoX/sJ0mtDwBa0Lg3F6ufp6QCuwfLjRbvDeL7ZEgtdWJ/zUh9eWZZMB7
         0qkI36aB2hdJMsAl+RFGFJs3BsMesUMc31O0x6gxcXvEpQQQTUGPZpSue6oOG6bHRuxk
         xCWg==
X-Forwarded-Encrypted: i=1; AJvYcCXz0qDdg8UN3SkKahNutBOfNi3FEVYOdS5eknsRVavg3+fGyWNly96uA+Do5pVHGhVVNNrZfiDc/dTmWsKRMVxtu6tXt/Xw4cgh
X-Gm-Message-State: AOJu0YzTOastUsqnstBZS4oajPpD9iItBm4YyyLg/gBHr3xlYpe81gOx
	hBHfg/owI4cBiZVepeizse8uQlYWq4VyyzQPDV3qqPiXpPOwciKMuXYblkEvkG0EIcQ1J5UuyM+
	34UKU2Q9yfhnXhaAN5ytJDBQnXbBRphsUTXS55NUY6CVSbbWLRqjp+d/NJhvjzG/C
X-Received: by 2002:a5d:5f46:0:b0:33e:cc1e:399 with SMTP id cm6-20020a5d5f46000000b0033ecc1e0399mr111483wrb.43.1710784230286;
        Mon, 18 Mar 2024 10:50:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0Q5QGGaxtRRAp41mQLI9R6LLdwMi0/OK+Zlpqg7BDZ5jGKy59R6hNbykKKkAiQg1LfeWu0A==
X-Received: by 2002:a5d:5f46:0:b0:33e:cc1e:399 with SMTP id cm6-20020a5d5f46000000b0033ecc1e0399mr111460wrb.43.1710784229665;
        Mon, 18 Mar 2024 10:50:29 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a26-20020a5d457a000000b0033e7e9c8657sm10302050wrc.45.2024.03.18.10.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:50:29 -0700 (PDT)
Date: Mon, 18 Mar 2024 18:50:28 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/40] xfs: clean up stale fsverity metadata before
 starting
Message-ID: <ps5yrmbecbh75w35jgsc4j7yup6wkspu7g2ulrkgn46z5na3x7@jnb7im6wky5z>
References: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <171069246392.2684506.14484170564314714404.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069246392.2684506.14484170564314714404.stgit@frogsfrogsfrogs>

On 2024-03-17 09:31:13, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Before we let fsverity begin writing merkle tree blocks to the file,
> let's perform a minor effort to clean up any stale metadata from a
> previous attempt to enable fsverity.  This can only happen if the system
> crashes /and/ the file shrinks, which is unlikely.  But we could do a
> better job of cleaning up anyway.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

> ---
>  fs/xfs/xfs_verity.c |   42 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_verity.c b/fs/xfs/xfs_verity.c
> index c19fa47d1f76..db43e017f10e 100644
> --- a/fs/xfs/xfs_verity.c
> +++ b/fs/xfs/xfs_verity.c
> @@ -413,6 +413,44 @@ xfs_verity_get_descriptor(
>  	return args.valuelen;
>  }
>  
> +/*
> + * Clear out old fsverity metadata before we start building a new one.  This
> + * could happen if, say, we crashed while building fsverity data.
> + */
> +static int
> +xfs_verity_drop_old_metadata(
> +	struct xfs_inode		*ip,
> +	u64				new_tree_size,
> +	unsigned int			tree_blocksize)
> +{
> +	struct xfs_verity_merkle_key	name;
> +	struct xfs_da_args		args = {
> +		.dp			= ip,
> +		.whichfork		= XFS_ATTR_FORK,
> +		.attr_filter		= XFS_ATTR_VERITY,
> +		.op_flags		= XFS_DA_OP_REMOVE,
> +		.name			= (const uint8_t *)&name,
> +		.namelen		= sizeof(struct xfs_verity_merkle_key),
> +		/* NULL value make xfs_attr_set remove the attr */
> +		.value			= NULL,
> +	};
> +	u64				offset;
> +	int				error = 0;
> +
> +	/*
> +	 * Delete as many merkle tree blocks in increasing blkno order until we
> +	 * don't find any more.  That ought to be good enough for avoiding
> +	 * dead bloat without excessive runtime.
> +	 */
> +	for (offset = new_tree_size; !error; offset += tree_blocksize) {
> +		xfs_verity_merkle_key_to_disk(&name, offset);
> +		error = xfs_attr_set(&args);
> +	}
> +	if (error == -ENOATTR)
> +		return 0;
> +	return error;
> +}
> +
>  static int
>  xfs_verity_begin_enable(
>  	struct file		*filp,
> @@ -421,7 +459,6 @@ xfs_verity_begin_enable(
>  {
>  	struct inode		*inode = file_inode(filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	int			error = 0;
>  
>  	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
>  
> @@ -431,7 +468,8 @@ xfs_verity_begin_enable(
>  	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
>  		return -EBUSY;
>  
> -	return error;
> +	return xfs_verity_drop_old_metadata(ip, merkle_tree_size,
> +			tree_blocksize);
>  }
>  
>  static int
> 

-- 
- Andrey

