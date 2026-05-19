Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F393DA7D0;
	Tue, 19 May 2026 08:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779180011; cv=none; b=OSocjotjjIgT4v5Mg0lYhq9E/9XeXVLU19E6RpoNcv3JzsP5OusyldHorjp59H5/FodRFjqhBzrjt7VuKvvxnvHQ4Ii5LU5Il77K5R/IblNmRiHp2Cg5Q5E3V7uMtn918OnU0gTZ+HiHrWFyxTMeot/ua2rBIodXLkbXI8ocIfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779180011; c=relaxed/simple;
	bh=P+1fWRAhXE6k2PXzoR0gZ1EiSrbFKNUt/lA5VCPR6EY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPebLHsx9e2+LKpg6Dujg/YxTqMMSdNyDo2gv4/s3KjqukHzUU/7+Q2YBLrdJJ/CmGjSXok1AUGTxzefsBSbUxeS1c8hBEZfFsu6Jeb8Cz4QkJ5lwNjgj7rpZbpk/QNUN1/Vfkpgp/4ZF46lQY1iF453wB9vk19ydID25t5VFTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PKNF4H9D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PKNF4H9D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DQtHNeDWKfGe2211FMNbzsOoqIf6S5P496dEmaRYZXY=; b=PKNF4H9DgaBN4OhSLJ1yjLj/z1
	+2+L223y31CouMd9YD6A0YicQnI7Mb+ohZR2vVtvtULDro0G3syfY0/L7FpowpzGJbaHj9L5TnmeW
	vXlO2vY+MuP+6j4wyDsS6VXcO6rZgoNkJCkKYdO9hZg4FcvOUuJD+iw19C9XzXushQiL9ScS7dBu9
	7N/eevdChb6FnmqnG2OEFC+Kp9EpT1W9OL8V+TWfDL9/Ns4USZ8usBsgIvFihVc+oV0cyyH/SnWDE
	nLPINOdyHUen+a5mOHo/knYb5W2WryEWTxHOiYktnA66yXhtqdNrC1FZNnB1RtBZRm6SM/lIZ6irz
	WLeOZ7SQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPFzl-00000000htt-2oQS;
	Tue, 19 May 2026 08:40:09 +0000
Date: Tue, 19 May 2026 01:40:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: Re: [PATCH] xfs: drain inodegc before quota teardown on mount failure
Message-ID: <agwh6darf9q52za7@infradead.org>
References: <20260514160712.2260541-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514160712.2260541-1-rollkingzzc@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 15, 2026 at 12:07:12AM +0800, Zhang Cen wrote:
> Sanitizer validation reported:

How did you run into this?  Normal xfstests under a new sanitizer?

> Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> 
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Nit: no empty line between the Fixes and the Signoff or other tags,
please.

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index b24195f570cd..e8a870482d1a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1228,6 +1228,12 @@ xfs_mountfs(
>  	return 0;
>  
>   out_agresv:
> +	/*
> +	 * Drain ordinary inodegc before we drop per-AG reservations or tear
> +	 * down quota state.  Background inactivation can still attach dquots
> +	 * here, and dqget can still need the quota inodes.
> +	 */
> +	xfs_inodegc_flush(mp);

This looks good.

>   out_free_metadir:
>  	if (mp->m_metadirip)
>  		xfs_irele(mp->m_metadirip);
>  
>  	/*
> -	 * Inactivate all inodes that might still be in memory after a log
> -	 * intent recovery failure so that reclaim can free them.  Metadata
> -	 * inodes and the root directory shouldn't need inactivation, but the
> -	 * mount failed for some reason, so pull down all the state and flee.
> +	 * Flush inodegc before we destroy quotainfo.  This is the first drain
> +	 * for paths that bypass out_agresv, and it also catches any reclaim
> +	 * queued by the quota, realtime, root, or metadir teardown above.
>  	 */
>  	xfs_inodegc_flush(mp);
>  
> +	/* Clean out dquots that might be in memory after quotacheck. */
> +	xfs_qm_unmount(mp);

This is later in the teardown order than where I'd expect it. The
first thing that can bring in quotainodes is xfs_qm_newmount.  I'd
expect a new label placed above out_rtunmount to handle this.  Is
there a reason I'm missing why this won't work?

