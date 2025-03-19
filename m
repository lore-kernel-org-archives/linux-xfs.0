Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B63253F27
	for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742383525; cv=none; b=SKzup/Mh99/JV4kuIPwHiz+tx9FpF7mukGbkxmrsXfgWl9e35ScEMTyvJrNcw+tW/JYErK4oeHlDHJGjWQjD3Y19cU77Wt6ruzoM+9bnrSuFlFdzdz8bXv+8gf1E6HxKROjiA4d58wdZiyALJeQ3OncOXWY7l7kv44DsgGh8dDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742383525; c=relaxed/simple;
	bh=vwMTr86cjKA0aQoVciMyE+Df9venBQGtzO+ZXbWMuz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rnh7/gylTmomIlLfkM/hRdnuZ+LKJjIVLG6hehiMyMu0q2Z4gbKxLweT8WpYlNBtS2AZHXQR/sNsvb6kKuyzAmdryW95LdK7pg06jNPe+MqCZVz0PZ6Z6V7XNzaFlsf+co+oaWtbXSWHen3X24vO/6YiUsfleK+Y/eYnV2nVrbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpB4cUWf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpB4cUWf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742383521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YUnzkbtrwZH0stapapghGEgR80hWuxX8nLtU7XZASAw=;
	b=CpB4cUWfeMEhElHZZLXIpg1fS7IMSZhuKLszgeWhVdKHIpABFHcRJbsnM04wUqCsuu16Pk
	1Q3bEUQsB/Zsb4rpIxfcNMGY+FTW1cbC20WBXk1xAgnzzvXCjrMMG9FaR1blwQPXvbduvY
	OSCxHrzlMIdg/ux6rHJv3nyQJI+f6u4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-5Rm8FN8UN4KtBfIoD4hPiQ-1; Wed,
 19 Mar 2025 07:25:20 -0400
X-MC-Unique: 5Rm8FN8UN4KtBfIoD4hPiQ-1
X-Mimecast-MFC-AGG-ID: 5Rm8FN8UN4KtBfIoD4hPiQ_1742383518
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A72219560B2;
	Wed, 19 Mar 2025 11:25:18 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.174])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D57D180174E;
	Wed, 19 Mar 2025 11:25:15 +0000 (UTC)
Date: Wed, 19 Mar 2025 07:28:08 -0400
From: Brian Foster <bfoster@redhat.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	Bo Liu <liubo03@inspur.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2] iomap: fix inline data on buffered read
Message-ID: <Z9qqSHlItlWJCPJz@bfoster>
References: <20250319085125.4039368-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319085125.4039368-1-hsiangkao@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Mar 19, 2025 at 04:51:25PM +0800, Gao Xiang wrote:
> Previously, iomap_readpage_iter() returning 0 would break out of the
> loops of iomap_readahead_iter(), which is what iomap_read_inline_data()
> relies on.
> 
> However, commit d9dc477ff6a2 ("iomap: advance the iter directly on
> buffered read") changes this behavior without calling
> iomap_iter_advance(), which causes EROFS to get stuck in
> iomap_readpage_iter().
> 
> It seems iomap_iter_advance() cannot be called in
> iomap_read_inline_data() because of the iomap_write_begin() path, so
> handle this in iomap_readpage_iter() instead.
> 
> Reported-and-tested-by: Bo Liu <liubo03@inspur.com>
> Fixes: d9dc477ff6a2 ("iomap: advance the iter directly on buffered read")
> Cc: Brian Foster <bfoster@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---

Ugh. I'd hoped ext4 testing would have uncovered such an issue, but now
that I think of it, IIRC ext4 isn't fully on iomap yet so wouldn't have
provided this coverage. So apologies for the testing oversight on my
part and thanks for the fix.

For future reference, do you guys have any documentation or whatever to
run quick/smoke fstests against EROFS? (I assume this could be
reproduced via fstests..?).

> v1: https://lore.kernel.org/r/20250319025953.3559299-1-hsiangkao@linux.alibaba.com
> change since v1:
>  - iomap_iter_advance() directly instead of `goto done`
>    as suggested by Christoph.
> 
>  fs/iomap/buffered-io.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d52cfdc299c4..814b7f679486 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -372,9 +372,14 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
>  	struct iomap_folio_state *ifs;
>  	size_t poff, plen;
>  	sector_t sector;
> +	int ret;
>  
> -	if (iomap->type == IOMAP_INLINE)
> -		return iomap_read_inline_data(iter, folio);
> +	if (iomap->type == IOMAP_INLINE) {
> +		ret = iomap_read_inline_data(iter, folio);
> +		if (ret)
> +			return ret;
> +		return iomap_iter_advance(iter, &length);
> +	}

Technically you could use iomap_iter_advance_full() here, but since
length is already defined for other purposes it doesn't really make much
difference. LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	/* zero post-eof blocks as the page may be mapped */
>  	ifs = ifs_alloc(iter->inode, folio, iter->flags);
> -- 
> 2.43.5
> 

