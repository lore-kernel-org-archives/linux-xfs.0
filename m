Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AB137E5D5
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 20:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784061360; cv=none; b=tM47c1k9gcCzMfmt9P5/MPtvg7Z8nYjDK+R4xrhB82kAfEri0G0Y3hmu4dQyVQ+q+F8GPRutpD034z161y4Xa9rMDXYtBB20P+NOAhO7dI0ZUh41borDdjPL20v52jjfY6R3UrbD9A+pZ4YDDXz5+pfydTv0C/q5IL2yhVrd76M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784061360; c=relaxed/simple;
	bh=DCFZE4Dz/n22lgUd4vgH+IhCnnGfcVkfbxehdfnPcyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aulvh5xoW3f6WU52kZ1xDykooB7fkysW2ChsAf4zZF7su3hiBv2BebgO1RTuFqzDcjstaqfJLeUFoMJO/ZmwzR9KBXa1o2RsvP+dzTCFRT/IfECUgTq/iwqTsLchqZ0Tzzg9SpAQ7SaqMKgzTPw2NUoAUuttcZo18BSTXfCcJ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOwZoMnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOwZoMnZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 448811F000E9;
	Tue, 14 Jul 2026 20:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784061359;
	bh=e/axzbIzw+KY6GqwCPyyz9spJLbje8Ozm00GmVyf/Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HOwZoMnZj0d84dyr0MPZvaF0yxrBHnRNOiBmZ65IxmOgChqTqQfEWIxjtgizCySOQ
	 fXsYgqhOkn87a+37VDTH5mnCZM6iVddSxd95ki5EaPOxNmXAyx4f8sZJaha5jlpuwS
	 665MWwlUf++nxys1rfPYIL8IztJhhrhTNqDmE89h7tA7sBc7qgO7hSKdRYwTTRqp2v
	 63E3Uj7KGliYcMZoPP7Nf08Ialhfx5tGF7Om8VgXeL2T6nVq08bu6Gu5+w6Jsi1JsF
	 JKZKry1JKYCQfFSkzDlFbOhqrsWBfEvvAjffZUw4NpMtxfF1aFotcrAl2Ct0qZbKiz
	 tDRFjERFOlSxA==
Date: Tue, 14 Jul 2026 13:35:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: aalbersh@kernel.org, pankaj.raghav@linux.dev, hch@lst.de,
	Zhang Yi <yi.zhang@huaweicloud.com>, gost.dev@samsung.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] fiemap: add a nosync option
Message-ID: <20260714203558.GK7398@frogsfrogsfrogs>
References: <20260714203206.520348-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714203206.520348-1-p.raghav@samsung.com>

On Tue, Jul 14, 2026 at 10:32:06PM +0200, Pankaj Raghav wrote:
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
> Changes since v2:
> - Add this option to the man page (Darrick)
> - Add more information about this flag in the help.
> Changes since v1:
> - Change '-s' to '-e' to match xfs_bmap (Christoph).
> 
>  io/fiemap.c       | 9 +++++++--
>  man/man8/xfs_io.8 | 2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index b41f71bf..cf3a1b3e 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -36,6 +36,7 @@ fiemap_help(void)
>  " -a -- prints the attribute fork map instead of the data fork.\n"
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>  " -n -- query n extents.\n"
> +" -e -- obtains also delayed allocation extents by not using FIEMAP_FLAG_SYNC.\n"
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
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 61defcc3..a3ddab02 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -353,7 +353,7 @@ Prints the block mapping for the current open file. Refer to the
>  .BR xfs_bmap (8)
>  manual page for complete documentation.
>  .TP
> -.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
> +.BI "fiemap [ \-alev ] [ \-n " nx " ] [ " offset " [ " len " ]]"

Thanks!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  Prints the block mapping for the current open file using the fiemap
>  ioctl.  Options behave as described in the
>  .BR xfs_bmap (8)
> 
> base-commit: e80b048d87fdc5735e0d03ae29b497b402ea8bbe
> -- 
> 2.51.2
> 
