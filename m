Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47637139CE3
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 22:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723673050; cv=none; b=bYzI1DS538eDW8QYO4w465wVhP7somOgOQ25v9s71D/40y8op9r5VavMyu2Dq6vRv/ROILa77yCm9ScPNrh/Y2YdL3jv/sbzNtdaFHhEARKzldGx6rs0WJAt+n4rfC8fNF6Ly+C34qvPXYPnGbm6ssLdGQGqaw5tEGI7y4wzfao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723673050; c=relaxed/simple;
	bh=ej2IMUAmsnpGU8O2i7FXOpfkaPk6imttCsWaIDR8mNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCsKTKTxVhvPpvZ3pFSTEXlZ/cbajQwslYMD2Y2/H+48QqhsU2S+PcsP/jUeGUY4e/vNQw5j+2cwtHFsdrHg5lE/PzfJ575z1jDIu2qCDTbJoHfNvvD7q8f1Y9fv50d6wc9bz/4ZodYLLh2j7r6pgFTPVszFdVpcGjc09ug3bI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=n5O0H/Su; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="n5O0H/Su"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-710ffaf921fso214217b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 15:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723673046; x=1724277846; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=463ygjMlKQz67QoG0495w4hyl86iGYYoRtfwEYS7g0U=;
        b=n5O0H/Su7JGC0VLgmUciRjVZ2zWYF/8fmj8ln7+55lIRjju870GcbvJNmnfs2iVI56
         8pBNlF17+gkk5hpiA4aU2C294dQ7kjdo4OTnv3GPoCTUs/X9jJdoEcrH1Ucv2pMeskUP
         RmNiNIvM8SoGl7PUzkPciDGOXTQcjaazDHF6JxrlLERrd4HTs/f0yIHv0TMAD+8nQXcG
         gnmUGBc0PYPBnADWtozvArpRQlCU/3xmf0FZXGjn5cp4QYImEEjF1tTBcBkjQBheqWkl
         PWK4y4HEUMum483fwY8c7X0k00NvU6qt/s/ddRP+nbNu1kIIJbKTaM2pufBJ6nl0034G
         iHTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723673046; x=1724277846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=463ygjMlKQz67QoG0495w4hyl86iGYYoRtfwEYS7g0U=;
        b=iim1NhLFyfLekRgZ5h2Wuq/lLsYWYye3pHQ6BfvBN/16pc/EjYohnBQykyV9O847aq
         BgDQstlQL/SkST5GOyCPSIvi/WGkNVSkyP059LTUAdQ/y5cTdpQ7icVxx/2f2L7Wbo5c
         lFNM9v9YeORHZel1T3W11dVROAeDHjJlWSjVyuKtmfDcp8juGElAbSwoi2xJANWrhEgZ
         uso2w+Bn9qmHvqtxfiSwZ+M2yVQIl1eE87e97kQPRXmAu/e1w/B/QSnJgr76uJJm1f9s
         EA6tcxUExjRMWLHsuUW5dpVWHskyzG1+p/uRzMZp2uH71tkwosd7BIS0xepEaqXmbVuE
         g3qw==
X-Forwarded-Encrypted: i=1; AJvYcCW5IVRk+MvsPE/tZhoUhTmgIdysFMZCyuZ+ek8IOk72ur7lRbc7+BFZD83cEc5WK4iG7pCFZOQYyT9y1Mewq0Q0/6mrxMPD9sUL
X-Gm-Message-State: AOJu0YwyW4VftaK0nUYflsfLhdppix/T2zP5kZBf5CeklHnPz3Aqicd3
	+RjUTRb49Ug5gTrT5yiy0SYJ1g0t5kmH8WchMXMBOnBDmpWb7eGtBJMaoOx5Bf0=
X-Google-Smtp-Source: AGHT+IE7t4J+4cqZQXUHBFbYhSBIT7SpgdS2BVYdXOCyAYVvWGtO3sonWrGZp6MpD8SgwB87RGvfeQ==
X-Received: by 2002:a05:6a00:190e:b0:70d:2709:3b53 with SMTP id d2e1a72fcca58-71276eed914mr1535788b3a.4.1723673046384;
        Wed, 14 Aug 2024 15:04:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127ae669b7sm50190b3a.88.2024.08.14.15.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 15:04:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1seM67-00HGb5-0F;
	Thu, 15 Aug 2024 08:04:03 +1000
Date: Thu, 15 Aug 2024 08:04:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix handling of RCU freed inodes from other AGs
 in xrep_iunlink_mark_incore
Message-ID: <Zr0p09mKjoxMdZD5@dread.disaster.area>
References: <20240812052352.3786445-1-hch@lst.de>
 <20240812052352.3786445-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812052352.3786445-3-hch@lst.de>

On Mon, Aug 12, 2024 at 07:23:01AM +0200, Christoph Hellwig wrote:
> When xrep_iunlink_mark_incore skips an inode because it was RCU freed
> from another AG, the slot for the inode in the batch array needs to be
> zeroed.  Also un-duplicate the check and remove the need for the
> xrep_iunlink_igrab helper.
> 
> Fixes: ab97f4b1c030 ("xfs: repair AGI unlinked inode bucket lists")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/agheader_repair.c | 28 +++++++---------------------
>  1 file changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 2f98d90d7fd66d..558bc86b1b83c3 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1108,23 +1108,6 @@ xrep_iunlink_walk_ondisk_bucket(
>  	return 0;
>  }
>  
> -/* Decide if this is an unlinked inode in this AG. */
> -STATIC bool
> -xrep_iunlink_igrab(
> -	struct xfs_perag	*pag,
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = pag->pag_mount;
> -
> -	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> -		return false;
> -
> -	if (!xfs_inode_on_unlinked_list(ip))
> -		return false;
> -
> -	return true;
> -}

This code is wrong. It does not explicitly check for RCU freed
inodes (i.e.  ip->i_ino = 0 or XFS_IRECLAIM being set) and so will
never detect stale RCU freed inodes in AG 0.

It is probably working by chance to avoid stale freed inodes
because ip->i_prev_unlinked will be 0 for such inodes.

*However*, this code does not have the necessary memory barriers to
guarantee it catches the ip->i_ino or ip->i_prev_unlinked writes
prior to freeing. The ip->i_ino check needs to be done under the
ip->i_flags_lock as it is the unlock->lock memory barrier that
the inode cache RCU lookup algorithms rely on for correct detection
for RCU freed inodes.

> -
>  /*
>   * Mark the given inode in the lookup batch in our unlinked inode bitmap, and
>   * remember if this inode is the start of the unlinked chain.
> @@ -1196,9 +1179,6 @@ xrep_iunlink_mark_incore(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = ragi->lookup_batch[i];
>  
> -			if (done || !xrep_iunlink_igrab(pag, ip))
> -				ragi->lookup_batch[i] = NULL;
> -
>  			/*
>  			 * Update the index for the next lookup. Catch
>  			 * overflows into the next AG range which can occur if
> @@ -1211,8 +1191,14 @@ xrep_iunlink_mark_incore(
>  			 * us to see this inode, so another lookup from the
>  			 * same index will not find it again.
>  			 */
> -			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> +			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno) {
> +				ragi->lookup_batch[i] = NULL;
>  				continue;
> +			}
> +
> +			if (done || !xfs_inode_on_unlinked_list(ip))
> +				ragi->lookup_batch[i] = NULL;

Same with this new code - it's not explicitly checking for RCU freed
inodes and doesn't have the correct memory barriers.

Hence I think the fixes for this code are:

1. change xrep_iunlink_igrab() to use the same RCU freed inode
checks as xfs_blockgc_igrab(); and
2. remove the (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
check altogether.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
