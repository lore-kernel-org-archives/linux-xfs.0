Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D0A40682C
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236790; cv=none; b=cM4MuNS8TlkpPmtmIFxM/5oMFPRtdthl2ibhNwVNocjQu4rVJ3hC1vNfki5WZ/BtgJDwAKJFeS5/kYqS2O2pP97mdOHBczUIKfJIUAt0ZgyApj9OXEtxhWgT6AdSxV3ZQ0vidKl3mEaDPSiSs7/TgT0sOm0WMoMaosSdE8JId4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236790; c=relaxed/simple;
	bh=DKCYHZmEVZGT7Bgw504j/BpQHo1paOcKHsgN/nPECu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWv0XM4RR7NO43T7aoshjo1yJFsIdG377zTQ5eCsL413hXSHKRz4IOhlilYUT9pE0OmFbEfMdPzclukqMjkPX8EpgcX9npP+fNICycjPK4Rp1TQ9gbfVVgNcA2av3LY+bhLgop7JXsegtUfLEyGIIZWG9Bx6gghPJB0/zW1aUCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCC2CNje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCC2CNje"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0FF421F000FF;
	Mon,  5 Oct 2026 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236781;
	bh=W4IjQrD5GJYj8QxULBVJEVWK5ig/A4f3qQaLRAY+grc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FCC2CNje/+LAn3hkcF0OXYuxz8dEIlFGpPgd71xMOo54gSbPHf18Mhvc+IzMJH9A5
	 uOi0ZAiDUK2SyjJ128Ys7ZMAMRAqh4/+lMpSh3hRx3nOxfEeyq4x+wNW/Nl2MrL9kb
	 /SrZC9NO/zIrAGQ7I8UY+vf0JfXFqarCdE5cs4zoTvfatgBqmVxSuRtT5h07LCJqIa
	 WCNcIEh72q6WeW5glsvlZrOWpYbr5ycuFO0WYwjAnQ9nML/4SW0hLxOwzkmnxf7pwA
	 AzzwpdzzP8Bdz6bLKkHPEFElntc8kPq6vn+0rFbrViiaoLaDnqkvxBG+xee23TLONu
	 avilja0gXPKbg==
Date: Mon, 5 Oct 2026 14:46:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] libxfs: remove the unused
 xfs_inode_log_item.ili_fsync_fields field
Message-ID: <20261005214620.GL2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-7-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:16PM +0200, Christoph Hellwig wrote:
> To prepare for reusing the kernel version of the struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that's been gone for a while...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/logitem.c         | 1 -
>  libxfs/stubs/xfs_trans.h | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index 6e56e476d1ea..d09ff75e9ce2 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -231,7 +231,6 @@ xfs_inode_item_precommit(
>  	 * (ili_fields) correctly tracks that the version has changed.
>  	 */
>  	spin_lock(&iip->ili_lock);
> -	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
>  	if (flags & XFS_ILOG_IVERSION)
>  		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
>  
> diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
> index 9b6a47988147..fcd58930cc85 100644
> --- a/libxfs/stubs/xfs_trans.h
> +++ b/libxfs/stubs/xfs_trans.h
> @@ -40,7 +40,6 @@ struct xfs_inode_log_item {
>  	unsigned int		ili_dirty_flags;	/* dirty in current tx */
>  	unsigned int		ili_last_fields;	/* fields when flushed*/
>  	unsigned int		ili_fields;		/* fields to be logged */
> -	unsigned int		ili_fsync_fields;	/* ignored by userspace */
>  	spinlock_t		ili_lock;
>  };
>  
> -- 
> 2.53.0
> 
> 
