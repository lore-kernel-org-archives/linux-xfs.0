Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F30F30BB91
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 08:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767687424; cv=none; b=notR3ihTH4ZAXae9OcyoiU3XUli+fm2v4Mh2QUmFAdMCVFnmr0n6/DHYAX3W7HMpFDr/3ZExL6wwnYWhbpBbF3WB2zyFOj68ersQngi3eS3j3Ia7uzzFoxeDmiBq+0rFTiApzHrDjeF96PWWOaW7EXmy7qtaiLhv29Y94mApkW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767687424; c=relaxed/simple;
	bh=0e4ja48w0B6N1nb33/SX8eKZr1Zs31tu6Cus3lbXVCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsPu1vJyaUcUxL0P9GHObY3ReGNRnhpq0YKkM2viltvVpgEt1vzPHhAC1SwEWSKEgPGcqj6J0eR15CUvyjejYKLAPHRbDQNRzMcdneAB6BYp+SH/fHQNStwuwLEv8VLe6fUJJY7pntk/xPSu683gtGrHrBEdbLWBnR3cBVo90xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mdBYOYaU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mdBYOYaU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EecfvK/M58ydlCUkRs1CA6dc3/0K0pg5yt5aqfKnJYI=; b=mdBYOYaUEKJpUpTagzKMW67OEI
	kwH0U1Iwkanpc+sdDRk8F1PdWG0tp9HpZho1QpfO0vdMP+D4DCdYAWU7M8grPomQOIh2/jlSr9nNC
	9SEzCLDndx6UxZ4Ij0NcEUwbyhuggdigBi6tEUP6gt8ceJlMb4sIp2Kgo61U2ve+wqJo7Hz4DHJu7
	KPDe6j9CPHWBe+wi7KN52fE9CJmo4oVwznfOz80bDK4PdY2PiJi1ThMeV1/we7JA23WnqAP9P9unX
	wRSDR3E49nLKXC9kuiOD3KDU3Z/NWzVFFgn0+X3CV/IsLjPLulhPP6spxImX82nY7W2VJJcWVaaYS
	qatvCH3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd2FP-0000000Cb6A-10j7;
	Tue, 06 Jan 2026 08:16:59 +0000
Date: Tue, 6 Jan 2026 00:16:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs: speed up parent pointer operations
Message-ID: <aVzE-5gMi1IHOLTW@infradead.org>
References: <20251219154154.GP7753@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219154154.GP7753@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 19, 2025 at 07:41:54AM -0800, Darrick J. Wong wrote:
> Now parent pointers only increase the system time by 8% for creation and
> 19% for deletion.  Wall time increases by 5% and 9%.

Nice!

> @@ -202,6 +203,16 @@ xfs_parent_addname(
>  	xfs_inode_to_parent_rec(&ppargs->rec, dp);
>  	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
>  			child->i_ino, parent_name);
> +
> +	if (xfs_inode_has_attr_fork(child) &&
> +	    xfs_attr_is_shortform(child)) {
> +		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
> +
> +		error = xfs_attr_try_sf_addname(&ppargs->args);
> +		if (error != -ENOSPC)
> +			return error;
> +	}
> +
>  	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);

We should be able to do this for all attrs, not just parent pointers,
right?  It might be nice to just do this for set and remove in
xfs_attr_defer_add and have it handle all attr operations.

> +	if (xfs_attr_is_shortform(child)) {
> +		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
> +
> +		error = xfs_attr_sf_removename(&ppargs->args);
> +		if (error)
> +			return error;
> +
> +		xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->new_rec,
> +				child, child->i_ino, new_name);
> +		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
> +
> +		error = xfs_attr_try_sf_addname(&ppargs->args);
> +		if (error == -ENOSPC) {
> +			xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
> +			return 0;
> +		}

And for replace we should be able to optimize this even further
by adding a new xfs_attr_sf_replacename that just checks if the new
version would fit, and then memmove everything behind the changed
attr and update it in place.  This should improve the operation a lot
more.

