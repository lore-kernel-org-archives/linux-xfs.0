Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1401D0DC8
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884841; cv=none; b=LpGTOa8MNewV3XG8c7zicAPpbH7FABclB7b7bWpsC3ZfpfTdm1AlopMl9NxybJi3nAdkRo+6hWLU8oF4oHhUK5uYzPh70lJQW6Ohxill2GX5+xywf+3Fu0buaFZya6Cbv+zUC8reGGaqixkZdHuICCQYDWziBL1B+ASyxctbxUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884841; c=relaxed/simple;
	bh=Sf3YcwHZ5bkZK2LJt9rV+Ayz14bpGLw6myXonMiTZp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Co4o2T4NHQkIHggoDggJ+pJGS7yEt3QgANj/80WVf9Of99MBEyDSLUrhvSzARE2nvol36iY5auY/WFo0pQYVE6doLGNKKlqU4uvuQLWTuzOHdiemOXA0UxHwEJFSwuwRuz91CFHzhIcvAfg3rSkCFQR5pFzpbAwZG3nB3adhky8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnYplhIN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnYplhIN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727884838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eyA1ypbvzB+LBo6FKEjPys+6nNl05QYiIsVBJtMHFRE=;
	b=XnYplhINj66sYI96OF8wDh+QOr9iJcPzzMsQJgWJVGbW7dm/FBdLVwrTPG4mwjsAMyM/Jp
	VLmfFCmUCzMB3M/RxY5tRmlIm0cjrQJJnppki5ad263MOzofnjF3D5Ee8kcsJ6aqbboSK1
	RJDTbUieKKwn+6qFjbzbPdBWERudrjI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-AoqjOKAaODiUVjb40HOCyw-1; Wed,
 02 Oct 2024 12:00:34 -0400
X-MC-Unique: AoqjOKAaODiUVjb40HOCyw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 722E919560A2;
	Wed,  2 Oct 2024 16:00:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.70])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA3F73000198;
	Wed,  2 Oct 2024 16:00:30 +0000 (UTC)
Date: Wed, 2 Oct 2024 12:01:39 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>, sunjunchao2870@gmail.com,
	jack@suse.cz
Subject: Re: [PATCH 2/2] iomap: constrain the file range passed to
 iomap_file_unshare
Message-ID: <Zv1uY_fH_L-MWU25@bfoster>
References: <20241002150040.GB21853@frogsfrogsfrogs>
 <20241002150213.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002150213.GC21853@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Oct 02, 2024 at 08:02:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> File contents can only be shared (i.e. reflinked) below EOF, so it makes
> no sense to try to unshare ranges beyond EOF.  Constrain the file range
> parameters here so that we don't have to do that in the callers.
> 
> Fixes: 5f4e5752a8a3 ("fs: add iomap_file_dirty")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/dax.c               |    6 +++++-
>  fs/iomap/buffered-io.c |    6 +++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index becb4a6920c6a..c62acd2812f8d 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1305,11 +1305,15 @@ int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  	struct iomap_iter iter = {
>  		.inode		= inode,
>  		.pos		= pos,
> -		.len		= len,
>  		.flags		= IOMAP_WRITE | IOMAP_UNSHARE | IOMAP_DAX,
>  	};
> +	loff_t size = i_size_read(inode);
>  	int ret;
>  
> +	if (pos < 0 || pos >= size)
> +		return 0;
> +
> +	iter.len = min(len, size - pos);
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.processed = dax_unshare_iter(&iter);
>  	return ret;
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index c1c559e0cc07c..78ebd265f4259 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1375,11 +1375,15 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  	struct iomap_iter iter = {
>  		.inode		= inode,
>  		.pos		= pos,
> -		.len		= len,
>  		.flags		= IOMAP_WRITE | IOMAP_UNSHARE,
>  	};
> +	loff_t size = i_size_read(inode);
>  	int ret;
>  
> +	if (pos < 0 || pos >= size)
> +		return 0;
> +
> +	iter.len = min(len, size - pos);
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.processed = iomap_unshare_iter(&iter);
>  	return ret;
> 

Heh. This was pretty much my local fix when I was testing fsx unshare
range, so LGTM. Apologies, I probably should have just sent it out. It
just seemed like Julian was 90% there, but then review went off the
rails and I guess I lost interest. Anyways, thanks for the fix:

Reviewed-by: Brian Foster <bfoster@redhat.com>

