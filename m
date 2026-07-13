Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4894213B584;
	Mon, 13 Jul 2026 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783943826; cv=none; b=I5Fs39s6XbToYi1BSc+UqHyZqbAlaFsKJ9r1u5/V3yLOR1BN3GPgXo811Q/PlDEEFmkpG6hQtuliGbmCw/CQ3NfxVGP7n9un7a9dmWZePcJaF5XczZ31bp2p1wYqVk1UaMwnLXSCFvOsz9o2pRdeqLrm5UBVIwwkvN1Mut/RQtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783943826; c=relaxed/simple;
	bh=DJfladaX7FPk1V19qJSYGHkbtoKrpHa++BnEeBRAhx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fz01Bhbcj0vikljzbSP6kOZTx8QNeLIOZ/JWbGrtzTMzgVjQSE1L6APRpn8ceKGXmdTqsr2+JOuE5CaT+W7IlWCwcwnBBTQFQeEERl61OBzEr4I7DIWGQawI7Y+sI+Sx9fxC8RZL/HwvVyrwzQMYrt6rOuE3zX0yKWQSEfASCL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dly+lZGv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dly+lZGv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XW8bvXN48RU/CJC/pUHGZ2MA9eav2lod4zf29rqDpck=; b=Dly+lZGvOxZbzWL1tqIF9/Uu1z
	JFM8sEwMTUvuP6rfUAzD9LWWYnbKo9n0EHRO+FTNd17/VZ8ELcyZMIomQblRIQ/3b/GD3ksHI3VjO
	GLLVVxPWkBMJnFZhQJJeQ4Q5d7vW4uIp086mXKXQ84L/lpb/ogMAhrjsGGteoy/sbJYOLtP0vUt1V
	URKeyDX0mZ6cb33LjIKsniSVa4dU12oGilOROcJfOpPYZmnW2Tik6GkdFdTfN9pDHblEdSmcuktbL
	UNb218qy0A/kpCeO/CJFzY6/JLg95auuDrvPdZ5dRqOo6HzenlJz/WF5JrTFHQSls2X3WYf1JBUgz
	NvOjg1Dw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjFHR-0000000966X-1EO3;
	Mon, 13 Jul 2026 11:57:01 +0000
Date: Mon, 13 Jul 2026 04:57:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 2/5] block: report direct io attributes through
 file_getattr
Message-ID: <alTSjR-3gauVdr_6@infradead.org>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710210646.3576365-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710210646.3576365-3-kbusch@meta.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  #include "internal.h"
>  
> @@ -88,13 +89,16 @@ int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	struct inode *inode = d_inode(dentry);
>  	int error;
>  
> -	if (!inode->i_op->fileattr_get)
> +	if (!inode->i_op->fileattr_get && !S_ISBLK(inode->i_mode))
>  		return -ENOIOCTLCMD;
>  
>  	error = security_inode_file_getattr(dentry, fa);
>  	if (error)
>  		return error;
>  
> +	if (!inode->i_op->fileattr_get)
> +		return bdev_fileattr(inode, fa);
> +
>  	return inode->i_op->fileattr_get(dentry, fa);

While this is correct, it reads a bit odd as the check above
required the S_ISBLK above.  I'd be tempted to move the
-ENOIOCTLCMD below the seurity check to mae it more obvious:

  	error = security_inode_file_getattr(dentry, fa);
  	if (error)
  		return error;

	if (!inode->i_op->fileattr_get) {
		if (!S_ISBLK(inode->i_mode))
			return -ENOIOCTLCMD;
		return bdev_fileattr(inode, fa);
	}

...

