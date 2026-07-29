Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E270455175
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339037; cv=none; b=TgXYL7C8EkjFGaBUoRYHRvbNKYyKrqWzMI4Z8CXGYmpQl8MyAACdMnTIJmmUt2Qv8McX/1h4rzAUStGmeV3K/qIpWMWWh7fKb7ZehtxRjEwQIyD0gg8IK+WpRYpsXWr5nzuJMeoY+6AL20rKnchIi4i49vV0kTiCnzS04gfS2jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339037; c=relaxed/simple;
	bh=iGTUTkbgc24iOXIbvY+q5n0vyNe21wD6VGZuiADsxnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxdxkOeMeuWTK0z6+b7Sq2493g/vej8Eet8JpGZS91FeClJ4PUPiEvbH+ViRtKWJlOBSR17Iz+fAXkujFQIbLaneAofl9fIN2xPH3UKgX8qLUDhUnNOjVRyc3kQhB4na1p8gK/sSVe+9TADV8s4T73Amm43wCHAbBx1gn6XlWsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMhDtwxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMhDtwxY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0F54F1F000E9;
	Wed, 29 Jul 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785339036;
	bh=ve0H29567MFDRywgSdLHq+NSptU3VmMw1gtrHluut20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MMhDtwxYbxt6JfQlFhhlIwYdCGSlWWAvr+JYvz8vm83bsVpfy72vJdgwDTGkDoSb2
	 xJk7IadxeCANjaqrDUHj6lgpY4AEbkLF40lMdz3UaRHN45bM8/+/+oLzvKn/cWSPWj
	 6j5cj0OZk96+UJOjeoFUOLTz+BeE6sg77GPdiRh//9AR/U2L1PNNqKoIvM5H+m99XJ
	 egXXvcm6SsRK6/3PttDLv0oeacUdkUZixA54YIZLi7QA4/BwebiSDVcb8uzIySPxId
	 Y7TwX7wFtU8I5gtYKWBF65SElV3NZaEIuXn1J6sip6eJw4wYXDuwAKyiihAR3j/xdp
	 wBowUxPYmXAew==
Date: Wed, 29 Jul 2026 08:30:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] copy: always align to at least page size
Message-ID: <20260729153035.GX2901224@frogsfrogsfrogs>
References: <20260729125902.2281706-1-hch@lst.de>
 <20260729125902.2281706-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729125902.2281706-3-hch@lst.de>

On Wed, Jul 29, 2026 at 02:58:57PM +0200, Christoph Hellwig wrote:
> The buffers used by xfs_copy need to fit the alignment of both the source
> and target.  As we can't rely on statx for more detailed information yet,
> work around this by never going below the default page size alignment.
> 
> This fixes copy an image from an xfs file systems on a NVMe device that
> only reqires dword alignment to a virtio_blk device that requires
> 512-byte alignment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Mmmmmm, fun...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  copy/xfs_copy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index ad18ceb1ac1b..5435c87dba38 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -673,6 +673,7 @@ main(int argc, char **argv)
>  	if (S_ISREG(statbuf.st_mode))
>  		source_is_file = 1;
>  
> +	wbuf_align = getpagesize();
>  	if (source_is_file && platform_test_xfs_fd(source_fd))  {
>  		if (fcntl(source_fd, F_SETFL, open_flags | O_DIRECT) < 0)  {
>  			do_log(_("%s: Cannot set direct I/O flag on \"%s\".\n"),
> @@ -685,13 +686,12 @@ main(int argc, char **argv)
>  			die_perror();
>  		}
>  
> -		wbuf_align = d.d_mem;
> +		wbuf_align = max(wbuf_align, d.d_mem);
>  		wbuf_size = min(d.d_maxiosz, 1 * 1024 * 1024);
>  		wbuf_miniosize = d.d_miniosz;
>  	} else  {
>  		/* set arbitrary I/O params, miniosize at least 1 disk block */
>  
> -		wbuf_align = getpagesize();
>  		wbuf_size = 1 * 1024 * 1024;
>  		wbuf_miniosize = -1;	/* set after mounting source fs */
>  	}
> -- 
> 2.53.0
> 
> 
