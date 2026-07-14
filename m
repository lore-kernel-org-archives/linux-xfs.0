Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F3244C648
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 19:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057887; cv=none; b=MN2s4WnOyu2wfkS/ZEziYz3qXZuRbVq6wh4u1xS846dryJvHRHu9spszPU1LBOBEIHtpVajv3fn+KaAOGpsUvXM7JbcM2W0LO0JbFvOvsqZDiYqr2Hj1QTTFaiQX1Ydwwjk5/S/hp7vdK52POhdYNF86y4SjnVzCzTaFXd0VRSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057887; c=relaxed/simple;
	bh=yukM397LZltzi5163/DHsBLaTdSp0eZKTS5UeMevtcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWpDF5GtXDbnM/wTnYqiMre6D0Ge05enQkMosHqCoIeLBer6GrWLU7INW/zHRtQSOorezuAVnR0WDpkdKbecv79sJGH+opJ1R4y+C6ZPI+mFpp2zsNFV4dddoFQ0eh5r1DlugsiT4X0ioOA0UEDzEezKrYe81DbwLz1C8gwMigk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nq3Eoe6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nq3Eoe6U"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 28A731F000E9;
	Tue, 14 Jul 2026 19:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784057886;
	bh=qe2X+svMI+++kgEdQRc9vJXylXpYREm9+yoX4d2Miuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nq3Eoe6UlVb2I49wAnIu4iBTCHvIC9LZxO4ZhxK1puplhX97Mdvdf0wI6ST42ohJq
	 6SydQtrjxm7buopIsmT0HWLxljtflPzUa1JSvPiac9ZSybo+YzMmdLUvAS9s1H4w6Q
	 rYYHIourg+eAO6CmYhCsHPtbmvxrVXbx3m52e08Z35rqD4t3D2o98hPin1VEa/w210
	 V93ksg2ivktxPnfH0quuxUJ3iIUYEh3BUpyckmw9IkWjjh/aZYZu8NWvJ1+ITLGbEO
	 NflZ8+Ediv/OzD5FQdUGjMzmg9CwJ20bz2oYYwNwQvclOdWnBgmzX7RLq7MALbD72N
	 vcp0UO+o4ktvw==
Date: Tue, 14 Jul 2026 12:38:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: aalbersh@kernel.org, pankaj.raghav@linux.dev, linux-xfs@vger.kernel.org,
	Zhang Yi <yi.zhang@huaweicloud.com>, hch@lst.de,
	gost.dev@samsung.com
Subject: Re: [PATCH v2] fiemap: add a nosync option
Message-ID: <20260714193805.GH7380@frogsfrogsfrogs>
References: <20260714192921.2528965-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714192921.2528965-1-p.raghav@samsung.com>

On Tue, Jul 14, 2026 at 09:29:21PM +0200, Pankaj Raghav wrote:
> io/fiemap adds FIEMAP_FLAG_SYNC by default. There are some test cases
> where adding this flag might have an undesired side effect on the
> results [1].
> 
> Add an option that does not pass FIEMAP_FLAG_SYNC flag.
> 
> [1] https://lore.kernel.org/linux-xfs/ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
> Changes since v1:
> - Change '-s' to '-e' to match xfs_bmap (Christoph).
> 
>  io/fiemap.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index b41f71bf..b2e89b95 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -36,6 +36,7 @@ fiemap_help(void)
>  " -a -- prints the attribute fork map instead of the data fork.\n"
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>  " -n -- query n extents.\n"
> +" -e -- do not use FIEMAP_FLAG_SYNC.\n"

Needs an xfs_io(8) manpage update, but otherwise this looks good to me.

--D

>  " -v -- Verbose information\n"
>  " offset is the starting offset to map, and is optional.  If offset is\n"
>  " specified, mapping length may (optionally) be specified as well."
> @@ -242,7 +243,7 @@ fiemap_f(
>  
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  
> -	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
> +	while ((c = getopt(argc, argv, "aln:ev")) != EOF) {
>  		switch (c) {
>  		case 'a':
>  			fiemap_flags |= FIEMAP_FLAG_XATTR;
> @@ -253,6 +254,10 @@ fiemap_f(
>  		case 'n':
>  			max_extents = atoi(optarg);
>  			break;
> +		case 'e':
> +			/* nosync */
> +			fiemap_flags &= ~(FIEMAP_FLAG_SYNC);
> +			break;
>  		case 'v':
>  			vflag++;
>  			break;
> @@ -393,7 +398,7 @@ fiemap_init(void)
>  	fiemap_cmd.argmin = 0;
>  	fiemap_cmd.argmax = -1;
>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
> +	fiemap_cmd.args = _("[-alev] [-n nx] [offset [len]]");
>  	fiemap_cmd.oneline = _("print block mapping for a file");
>  	fiemap_cmd.help = fiemap_help;
>  
> 
> base-commit: e80b048d87fdc5735e0d03ae29b497b402ea8bbe
> -- 
> 2.51.2
> 
> 
