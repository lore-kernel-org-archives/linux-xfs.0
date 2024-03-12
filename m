Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24295142907
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 21:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710278433; cv=none; b=ir5oBaqpUoL6pMKPyTQ9+G0c4VFPMxjYPLgZn6GNa4u1dZsEpp0Ug/fWqxR8xQOShMbZrHQF4BPHCVcaYKkQbof4CfGRenFDpE4L0p6y3/MI/KR98XYm39wffDobeEyc1lyJ+T3z9NycoSUjq3/WT+3bnArzcICeozIu39MKln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710278433; c=relaxed/simple;
	bh=h9/tykMqzC/MHdurxfvsjwQoU9rUsCfJZy5CMXXdlRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rS2Syku6X0qCimDL222Z6J9l9hQP8irIwSF9pvIJbmDNuU4kvfVO+cyav0GHHXR5nX9vPjm/nxPYoe2QpOnYIkWTdO85IoYiL02Iz35JZ0Om7mNztB28iVGcOf0iqXDLsFRy1lsJU20MRWIb7UrPaquE5QKYsC1jP7M9Ym5xFWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bkDLcWSI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bkDLcWSI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y6mZIGyETUk24GFzYvumESxUxxGrvq1+vc7oSp2F0I4=; b=bkDLcWSI/KqAL30JzYj7OiPTsc
	W8Bl8WaaPWYP3Sb0tV9iQ3TURI0NOfFH+gzx4dk7Q04Strk5CUHU7crz6wlX6GkNdOXv3YZb4SPFC
	sfPWIwNTUmIxftQpTIqBDizwMs8rFmpzNhjIxNOfZIB/1BxnkD1u1RrG3kXXLA8U2UwwsqZJh5DKQ
	AwOB5f3l8bHR8G8d1eEoLAYPOj/1d3ifIEmwSNE8G3liW2z32aWudLZwLU1nAaEZ9KjFySd5rvJ5R
	xmLaZmhS6WUOf43JzEW4Sr0m3USioLq8l/a/NNJ4OnGc1jIgq6PL7rZfdFnX+UpDbptSzTtm26veO
	SUZGCwiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk9Xv-00000007aBG-0wHY;
	Tue, 12 Mar 2024 21:20:27 +0000
Date: Tue, 12 Mar 2024 14:20:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: fix string buffer compile warnings
Message-ID: <ZfDHG7arXUYlKGcd@infradead.org>
References: <20240312161242.GA1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312161242.GA1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Funnily enough I just started looking into xfsdump warnings a few
minutes ago..

> --- a/common/global.c
> +++ b/common/global.c
> @@ -82,7 +82,7 @@ global_hdr_alloc(int argc, char *argv[])
>  
>  	/* fill in the magic number
>  	 */
> -	strncpy(ghdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ);
> +	memcpy(ghdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ);

This chunk and all the other ones switching to memcpy where we have
a fixed size look good and impossible to improve on to me.

> -	sprintf(question,
> +	snprintf(question, sizeof(question),
>  		 "pre-erase (-%c) option specified "
>  		 "and non-blank media encountered:\n"
>  		 "please confirm media erase "
> diff --git a/invutil/fstab.c b/invutil/fstab.c

For this and a few others that just s(n)printf I wonder if just
switching to asprintf and dynamically allocating the buffer is
the right thing to do.  That's a GNU/BSD extension, but we probably
don't care about anything else.

> index 88d849e..56132e1 100644
> --- a/invutil/fstab.c
> +++ b/invutil/fstab.c
> @@ -149,7 +149,7 @@ fstab_select(WINDOW *win, node_t *current, node_t *list)
>  int
>  fstab_highlight(WINDOW *win, node_t *current, node_t *list)
>  {
> -    static char txt[256];
> +    static char txt[512];

And for put_info_line/put_line I suspect just passing a format
string is the best thing to do, as this avoids the extra
snprintf and buffer entirely.  That's in fact what I had just started
on.

