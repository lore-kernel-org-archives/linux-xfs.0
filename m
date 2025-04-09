Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0550D1DFFD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 20:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231647; cv=none; b=T9OeC0OvEaaJyO1iwnpP4iWlRuCdk1jquT6u93glZRYd4Vvv/yZu/SN+KCDEndGYKaJIrKAvKkFXJVoVDVT/B17UTJ23AOfii57kNfE7Wz3hTBGNj+cRZZkpgFE2YKqXvwrHpEpbyLfx2RcAN5rGiJ8AozjMZdRrIJLOhefEGRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231647; c=relaxed/simple;
	bh=Q4AdmR/ATduj8SksL3poEcHRAcc0dlBFx7nJRrqaRU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOhi2IrHclY7LYFZHOtrHujmrRs1cFjFQ9RJGyvHT6qvPR7B1qeaFGfIcBurH68XbCjUoTpsKcqZqlmK/3y1oAXL4uETejjtEb3Xsc7CZrAiOo6aYTVMTzte/0l6b+FQ5CFA/IODtb9eRgfeAaCWGHq1QWgC+w05oKTyUkqFDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thRhhhxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thRhhhxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEB9C4CEE9;
	Wed,  9 Apr 2025 20:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744231646;
	bh=Q4AdmR/ATduj8SksL3poEcHRAcc0dlBFx7nJRrqaRU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thRhhhxq0FoeDSFMzjzAiHlmiF9QI5xQ+IJk9Dr/SlWkwQimJQt1x5wze5uOernQ9
	 2BdycQOQLFbiGxIYSIWHLvnvWiC4b3A8R/G9dMG6OL8+W0S/JcVXFj9LNymnqCkvKw
	 4vSVf67U7DZAkBcSFsXKc/GBCr5YqUW8AygQyk45Mum1FvJ6Us59HAqwx1U+ppCkHk
	 SKo479Yt2NR0H6aApAL9kUtpAKtfNNZTOBeZsc5G0DwZ8SCShmYlOwB4zar48nPby/
	 TSd2GQbRxvS/D9P/HcV/u41CAutyh0LIOc20U/1jIl5o1jQhP4RVZN6n4duGWOMuBg
	 ofCnbLlk8Kovw==
Date: Wed, 9 Apr 2025 13:46:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/45] xfs_io: don't re-query geometry information in
 fsmap_f
Message-ID: <20250409204646.GR6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-40-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-40-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:42AM +0200, Christoph Hellwig wrote:
> But use the information store in "file".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  io/fsmap.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 6a87e8972f26..3cc1b510316c 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -166,9 +166,9 @@ static void
>  dump_map_verbose(
>  	unsigned long long	*nr,
>  	struct fsmap_head	*head,
> -	bool			*dumped_flags,
> -	struct xfs_fsop_geom	*fsgeo)
> +	bool			*dumped_flags)
>  {
> +	struct xfs_fsop_geom	*fsgeo = &file->geom;
>  	unsigned long long	i;
>  	struct fsmap		*p;
>  	int			agno;
> @@ -395,7 +395,6 @@ fsmap_f(
>  	struct fsmap		*p;
>  	struct fsmap_head	*head;
>  	struct fsmap		*l, *h;
> -	struct xfs_fsop_geom	fsgeo;
>  	long long		start = 0;
>  	long long		end = -1;
>  	int			map_size;
> @@ -470,17 +469,6 @@ fsmap_f(
>  		end <<= BBSHIFT;
>  	}
>  
> -	if (vflag) {
> -		c = -xfrog_geometry(file->fd, &fsgeo);
> -		if (c) {
> -			fprintf(stderr,
> -				_("%s: can't get geometry [\"%s\"]: %s\n"),
> -				progname, file->name, strerror(c));
> -			exitcode = 1;
> -			return 0;
> -		}
> -	}

This leads to a regression on ext4:

# xfs_io -c 'fsmap -vvvvvv' /opt/
Floating point exception

which is a divide by zero in the line:

	agno = p->fmr_physical / bperag;

because bperag is 0 on ext4.  The current behavior is slightly less
unfriendly:

# xfs_io -c 'fsmap -vvvvvv' /opt/
xfs_io: can't get geometry ["/opt/"]: Inappropriate ioctl for device

because the xfrog_geometry() call here fails.

--D

> -
>  	map_size = nflag ? nflag : 131072 / sizeof(struct fsmap);
>  	head = malloc(fsmap_sizeof(map_size));
>  	if (head == NULL) {
> @@ -531,7 +519,7 @@ fsmap_f(
>  			break;
>  
>  		if (vflag)
> -			dump_map_verbose(&nr, head, &dumped_flags, &fsgeo);
> +			dump_map_verbose(&nr, head, &dumped_flags);
>  		else if (mflag)
>  			dump_map_machine(&nr, head);
>  		else
> -- 
> 2.47.2
> 
> 
