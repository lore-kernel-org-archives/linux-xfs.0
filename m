Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0701C12E70
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726838; cv=none; b=Pg4t/h5f1KzFd1+cE/SPvgoceYLQUVpNMVARtQ9d3zsgTMgOeBL7YctWLZ7R78wAaRpHlPnzk9UFF2vTQBuwvC3RSeHRy2zWcckUdZGTvaw2J43/j6evR+nYkBWfvOEmYzqxj4WKWdWsQ/WhsrYPW3hSj3XD2fk6Ko3ROeFZtg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726838; c=relaxed/simple;
	bh=Tr3/uj0x/6HkrnFXkypOpKnWKwFc7LJb4T/u6vRF2bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buGW0Ii9HSzz/t1na+ji79GKKeTYiuylDKwZlwGB3gy33WxsRtJftYFicmBXxf4yHOf/osmpzB1933yV8F2Hr2/iNIZ/Y3niutaGIDV9svZEfvc6ubHbdcvP5BVfKdaqcryq7iMgAY+1fQXHsYgkwRNesQYNMlj37xUINB0ZNjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A/fcHycy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A/fcHycy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BpXoRJcuNfXAgN7eGMczYua9DhURluiNeRiP3JQHCXA=; b=A/fcHycyHltXwosyfUJxRM2oDe
	YQkzm80GEYUg/yOjkQdptF+Vidf2fK63QumYI5VXt9LSVwprbtV1TXD6jmIaZDqbV5J5g4mnt55Na
	kAeGZD9iWYp7cFPZIJ/tST84q3ak0/EBrlAfa+rWkSCrIItKykOxvukrj01bLH8F68sERuwKcaZg9
	//QWGQmC5KlwXCfnN20CyHFyVZzur5iqpHuvbs638Uly5wVxp+cLw2yucvJJtr0sNPIL+M9ehMFDZ
	U9HIPFdJZexC3MD60ULsTwlQcn3rJafMXB4T9owiT/JjNEQdGMlg/uAbLl3g1ijPVh4uWYzBhloxF
	XKZBnXcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQUO-00000005C6c-2QCc;
	Wed, 10 Apr 2024 05:27:16 +0000
Date: Tue, 9 Apr 2024 22:27:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/32] xfs: record inode generation in xattr update log
 intent items
Message-ID: <ZhYjNGgKc5lOlxUP@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969756.3631889.2291525923694183307.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969756.3631889.2291525923694183307.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
> +	switch (xfs_attr_log_item_op(attrp)) {
> +	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
>  		ASSERT(attr->xattri_nameval->value.i_len ==
>  		       attr->xattri_nameval->new_value.i_len);
>  
> +		attrp->alfi_igen = VFS_I(attr->xattri_da_args->dp)->i_generation;

Please avoid the overly long lines (maybe xattri_da_args needs a shortet
name or we want a local variable for it?)

