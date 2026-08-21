Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3F55695
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 23:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787354654; cv=none; b=lCpq5nmJkAgUe03y0DR921u76v25jv+L1fRNpxcRcT2wm3zIfCEsoPYI+LSqvf7wlChLO4VMgc8DN07+LYuDD2SNlwxXoQJYJEsIUF7cbNOZijMrAirJX7eTJDl9YaWbNi3s0bYnfz9N6eV/HIsCBgfAD0CnxcH1B6zudYHv15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787354654; c=relaxed/simple;
	bh=mrf6d3gJvP7HT1BkvnmBJkNKjkTJzg+/ZEuPikVmtZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/HzkfJS4yWpmaxgUe+qg2vrPX106EzLIk72hhVpupYaZkzSqfrwws9sa3/BQgULGZ4m3SDZWVw9BBM9ncxFSxVLj/ksu6eJ+CQZuhTKTiVQpQDezeuYKo0roM8wdo02y383ChFfkoewHWL9HtQyY1rxZM6+vqT9clCNWvQ16SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BENC2ocK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BENC2ocK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C7201F000E9;
	Fri, 21 Aug 2026 23:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787354652;
	bh=y8zGpPxXTh53jhszOHFCM3y8nUwAMXcW9dSqJ8Raoq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BENC2ocK54NJselEdWcEatxbk2ehQfxXiwxZnn1qxriOEzpkodK//d8/wwp2fJ60N
	 Ucxpf+V9yUjfm90QEgHSwT6FlEVHNc5Iffw4zGKdfN4zRSFSpWwoPDKdz0qdQcze9y
	 SWmEDKo3XzjtQT+qvay6dXAA/PMQiIjVKgz+xZP03CCok7NmOxn+BnEB9LBnTqUBSv
	 oga2i4G7jeTeHCnWQnO9+c35oLDam3vRLxSNl6Y7PVVSeYus8Nto5+5sW+db+JXfuX
	 E05DKJisuofszbdj/jOwgvo5SYNlCUrQyyHnmCmO26TppSuyjh9DmiXLT11Wq8vxNn
	 AlBHJ9F4CGHiw==
Date: Fri, 21 Aug 2026 16:24:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix reclaimed page accounting in xfs_buf_free
Message-ID: <20260821232412.GM6072@frogsfrogsfrogs>
References: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>

On Fri, Aug 21, 2026 at 05:03:37PM -0500, Eric Sandeen wrote:
> To obtain nr. of pages in "size" bytes, we need howmany(size, PAGE_SIZE)
> not howmany(size, PAGE_SHIFT). This over-reports reclaim by orders of
> magnitude, up to 4096x on a 64k page system.
> 
> Fixes: e2874632a621 ("xfs: use vmalloc instead of vm_map_area for buffer backing memory")
> Cc: stable@vger.kernel.org # v6.15+
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Yikes.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1a5340baeabf..8256c1d13ce2 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -139,7 +139,7 @@ xfs_buf_free(
>  	ASSERT(list_empty(&bp->b_lru));
>  
>  	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
> -		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
> +		mm_account_reclaimed_pages(howmany(size, PAGE_SIZE));
>  
>  	if (is_vmalloc_addr(bp->b_addr))
>  		vfree(bp->b_addr);
> 
> 
