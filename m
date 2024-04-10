Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66933134DE
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726221; cv=none; b=nDTpQ/Iini1NM1JdujzweiDA32ZPGYTLbmUikwdb/xt0dvzVKiaeRSjTmKeRd6EhSm5OnHvocZj4n40nNe7gr7E56dYglRmxKD2+UqMzHzS3JdpV3Uk8QdVpfgUY5fq5Flo7UjD/n+prGR7lj7WTE0A9dIYAaVZQByB5EE9TcqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726221; c=relaxed/simple;
	bh=8fMo7EuGZtyEibS0qdXR5c7B4ydJE9L/PkcqFLvHgB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AputUZnhE3/TFsZ98zIHHIK5HfiptphIl9Apx18X4AmRBzR9XrmR4ERgt81hcnRwXdX9d9ZF9deJv9UJvOwCPl1S14wrysKIbzniRqPFF/s3cFWR1BaJqs0cga2mqOTGbp40bi2mCiJk5QRD2XZAeKbuROwcRBXboaZJhsd4W8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CVfA4TSg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CVfA4TSg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mIqfaYeCUk2OuIwe7rO1eDi1aWmx7g2rGsraMW04HH4=; b=CVfA4TSgiLqxBaSgY/o4OzL4XF
	wR+DmMN5STyy4DuVhLogNCap/qagVWLhtrXEMYl7+U48/MGD9AjOYtkJaKdpx8dn/2rKo0VvD9ouz
	obaegyXDvqBIcKtzUsDrXBknhCDJeMAeHDS774VW/w8zU2AoqIR+VQuFAKv8zELGcYMNdLcQbGFWS
	xm5TGmPRRoDc6f63LnWyEpEHrf7Ex6TXd0c4ztMgRnr8eGJilFoXi+hh+31/gPzt9byZjI30D7BZe
	rVFgyonZyiMbszy3TDLH5Nu4G8UHH5EXODSWv6rmBV41vq1rASCliU3/gNaWN81tajoVzCy+ypNwc
	Y+aFEHPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQKQ-000000059wO-3QbH;
	Wed, 10 Apr 2024 05:16:58 +0000
Date: Tue, 9 Apr 2024 22:16:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/32] xfs: allow xattr matching on name and value for
 local/sf attrs
Message-ID: <ZhYgylDdpjtxHdvY@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969674.3631889.16669894985199358307.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969674.3631889.16669894985199358307.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:55:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new XFS_DA_OP_PARENT flag to signal that the caller wants to look

The flag doesn't actually exist, the match is done on the
XFS_ATTR_PARENT namespaces.

>  
> @@ -2444,14 +2477,17 @@ xfs_attr3_leaf_lookup_int(
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
>  			if (!xfs_attr_match(args, entry->flags,
>  						name_loc->nameval,
> -						name_loc->namelen))
> +						name_loc->namelen,
> +						&name_loc->nameval[name_loc->namelen],
> +						be16_to_cpu(name_loc->valuelen)))

If we'd switch from the odd pre-existing three-tab indent to the normal
two-tab indent we'd avoid the overly long line here.

>  				continue;
>  			args->index = probe;
>  			return -EEXIST;
>  		} else {
>  			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
>  			if (!xfs_attr_match(args, entry->flags, name_rmt->name,
> -						name_rmt->namelen))
> +						name_rmt->namelen, NULL,
> +						be32_to_cpu(name_rmt->valuelen)))

... and here.

The remote side might also benefit from a local variable to store the
endian swapped version of the valuelen instead of calculating it twice.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
