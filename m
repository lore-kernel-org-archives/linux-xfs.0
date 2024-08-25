Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825B54A05
	for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724630290; cv=none; b=ETFWCPEeaEsqLrPC7OEeQTB30vrapeltAdsSdnZwTkGjVi4+s043NnCzdzwVX8DZp9f98rzf7dZ1Y6XEOr/LuUNDncx8WUY5oEO/XSgvhBfW3Bf+RDZtvR1lvyd+WnN7xrwwTbdoCJ0/6sU0cuy3W8EuU8tQ+mOW7qpF+wb74BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724630290; c=relaxed/simple;
	bh=4Bs+SuOExiCuWUCIwATb/F8vwfFjXIjm3uPgfKD6VMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mklEVwdesLWgTTJevd4lJ9WQ/ewiOgu83RXddvvL/sNTQSQe7Jb4MabKZBDf+3lPHLHAGCkE/6fpTd8zfnj4v+G8W1oB1R/hHFN29Lsp+sz5S/1OsatDpdfpR8BakmgZ4ZS0C2XdhRYKA92GcljGE84PlDuowz3dheGQG5RdQqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FiAJAuhe; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FiAJAuhe"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-202089e57d8so23505595ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 16:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724630288; x=1725235088; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBlRYvpGp50g9/JaUUGpBQmHa2XZ21po68X5vqsXmKk=;
        b=FiAJAuheNqeIi8jXrYI1oEtrtxY0sqBtkozloopKvouGMCjv/x1pg/GALbAIWQbtdo
         GcmH/FIZJ/thCFE16mV0nstttrgX80Qsb81e2c3ZMOi4dbLpgBdH3NwhWhjirfcxF32v
         djn+HXd/h8Ib/kXtlNGoIsEQULPedZ4xTD9x9zcmrlbdjzzlIjls+I9glhoCVs1c8Sni
         e48yg5FeorCRJBlf+jgoh72CdKtkQ920bo/8r0YbYi2rDpP06ZlmCuVSl3+tIYLkECJi
         AqOgae+9fjfFygVPkPCkoHx8BLBMT9taT7Ge7D8fB6L4auvx02CRyX0cUwXPrltSKZ12
         Qamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724630288; x=1725235088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBlRYvpGp50g9/JaUUGpBQmHa2XZ21po68X5vqsXmKk=;
        b=TXl4V7dgqyIMalp6lX7yzoTxNpgBVDTf7YH25J17uOiqzVBN8rKuGMwzyXmGnDTDCa
         njk7wdbwki2PAgIxduD9fQ42mgTKORM56QWj4EPwa/T0K4mzKrdjiNvGCxVb1IA+fVDH
         1mymZWXyzzvw6NZ1JSnptoP3dQwjnjG42/rjCY+uqkbNqioVbx2xUpicQeDC4f6D+jcM
         bXONqz0BWdHLmpIee750SnU8A75RExEuD//AIzGXGbWF4xPkkjiHZW85kYo8PXSqvxyM
         kxxqAazM2cFIni0Nj4CNtI39YgWjp+n68L5LExOjqwfB6TgBJiAITtge6LP4QcVwFADg
         U/tw==
X-Forwarded-Encrypted: i=1; AJvYcCVEvJzNxpmBI7Ur1eid878xet1bJ9z4DbBt/L/2iIHjVcUQhQDsBEDXTdhix5ZoWHquMBICkWWAUUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUuOFA1IyJ5SSnctsXyqKnNajyB2Ax+Axgf4iDaS8tejPT9GKz
	GPSWCRVDwPjz62fP69m3Ogdxc0lbMo+hFlZJ+idc+VixZtzTVSvlzE45Pi3BQJoz01DXwUOAa93
	B
X-Google-Smtp-Source: AGHT+IFvwT/zpOx6piDCqbKmh8ZL1zpcMJe4OuunGYhVfmlZOYqL9v0sZbShcUQlvd69/o+5m7WDxQ==
X-Received: by 2002:a17:903:6c8:b0:1f2:fcc0:66f with SMTP id d9443c01a7336-2039c638710mr95334005ad.31.1724630287736;
        Sun, 25 Aug 2024 16:58:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd985sm58805835ad.164.2024.08.25.16.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 16:58:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siN7V-00Ck88-05;
	Mon, 26 Aug 2024 09:58:05 +1000
Date: Mon, 26 Aug 2024 09:58:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: add a lockdep class key for rtgroup inodes
Message-ID: <ZsvFDesdVVdUhI8T@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087470.59588.4171434021531099837.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:18:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a dynamic lockdep class key for rtgroup inodes.  This will enable
> lockdep to deduce inconsistencies in the rtgroup metadata ILOCK locking
> order.  Each class can have 8 subclasses, and for now we will only have
> 2 inodes per group.  This enables rtgroup order and inode order checks
> when nesting ILOCKs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_rtgroup.c |   52 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index 51f04cad5227c..ae6d67c673b1a 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -243,3 +243,55 @@ xfs_rtgroup_trans_join(
>  	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
>  		xfs_rtbitmap_trans_join(tp);
>  }
> +
> +#ifdef CONFIG_PROVE_LOCKING
> +static struct lock_class_key xfs_rtginode_lock_class;
> +
> +static int
> +xfs_rtginode_ilock_cmp_fn(
> +	const struct lockdep_map	*m1,
> +	const struct lockdep_map	*m2)
> +{
> +	const struct xfs_inode *ip1 =
> +		container_of(m1, struct xfs_inode, i_lock.dep_map);
> +	const struct xfs_inode *ip2 =
> +		container_of(m2, struct xfs_inode, i_lock.dep_map);
> +
> +	if (ip1->i_projid < ip2->i_projid)
> +		return -1;
> +	if (ip1->i_projid > ip2->i_projid)
> +		return 1;
> +	return 0;
> +}

What's the project ID of the inode got to do with realtime groups?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
