Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5413BBE2
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244334; cv=none; b=RYhqAjV8N9mDTbuOfHxYbmXt9OAiO6Pi5puDUvvN6FREzXhxaxT3x5S2t7vMWos0Kg7fzN2aEUf/gwEXWO+PS+w6f5jogPzNs7kWU4RRtKU8LmH0S3vhOFyV8OqqkAhVkaHKrVtKP1Rh5tULlU4KpCTciRvdDjPop8fhwnPvuAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244334; c=relaxed/simple;
	bh=waqPYTedp+/dMd8+5v7vg9ZSVvFg5OphaIFxvgZrF5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptrNYcsNTbPrV5DXMZhG6nNeeRKCVk+731ABd6DMddADABJ04gUXw7vNazPLkOrr8fbBYHFYvuwga4k7+TA2I4juRP8Rehns03Y90n4t26VMwXc9xdg14zesW4XAYQ08b0MUsJXRHDguRb9yh26wCNMIf2gG3ELyD/awKMuJMe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWTeUC/T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWTeUC/T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aSalSdDtSm2sG26/rEgo3jauAvJf8oHEr9ARbhtLloo=; b=mWTeUC/TOPC82gCRGO5f/vw4KQ
	PbWVRe4G9kO36UZr2p1itMPWj1ZfUgtFftupD1Il3InoipWffnPRbEQ4I3Hp5u+wYFdSc1TafuHdW
	IskCbd5TQfwXhtg+A1HEQCdQG0RqpnhpbasC/StcqpcGbiytXXdZRLVME/w/gWtuL2c/pK9PGla7k
	wv6zTfGD3oPpaqxJYvH/60+wH1Zawvas3PGI9Co1TlkLmVLYS6Nt0fn01rE3qOT8QwoDUuLNhTdH0
	MvqwyMLMUmcPQTVCwuFzL4648VjSoW2nV+b7Pt7/hGe7/muNper7ouD7CpHpAAwePYi8XQ9AJjZrp
	I1jCdwIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwb76-0000000AuWb-18GM;
	Tue, 16 Apr 2024 05:12:12 +0000
Date: Mon, 15 Apr 2024 22:12:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 4/5] xfs: make attr removal an explicit operation
Message-ID: <Zh4IrLX10rprLUiV@infradead.org>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
 <171323026654.250975.17998254398908556664.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323026654.250975.17998254398908556664.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>  		if (error == -EFBIG)

No need to change this in the current patch, but checking for a remove
on an inodes without attrs just to skip the extent count upgrade
and not fail the whole operation is a little silly :)

> @@ -203,7 +203,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		xfs_acl_to_disk(args.value, acl);
>  	}
>  
> -	error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
> +	error = xfs_attr_change(&args, args.value ? XFS_ATTRUPDATE_UPSERT :
> +						    XFS_ATTRUPDATE_REMOVE);

Given that we have a conditional for removing vs setting right above
i'd clean this up a bit:

		xfs_acl_to_disk(args.value, acl);
		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT)
		kvfree(args.value);
	} else {
		error = xfs_attr_change(&args, XFS_ATTRUPDATE_REMOVE)
		/*
		 * If the attribute didn't exist to start with that's fine.
		 */
		if (error == -ENOATTR)
			error = 0;
  	}

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
