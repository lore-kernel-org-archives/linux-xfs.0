Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2CA472090
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 11:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039395; cv=none; b=pfxNXOmuBSNOZW3AWMrj1n3xvwiX2o6FrDMTfqJe/IC5A7pmMXqiQudeLduaE0GGRlrobpFw/w75x0rVn2EcS3aFVTNABAM2xjDolHjZUHL/eN3e1CWm34Vd0Bz9wlcsZpg2VgjuoPon70AN9gMWIharFbhKk/VPzEaLCcvbzqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039395; c=relaxed/simple;
	bh=9wVP9A0L3zRtyRS9v22DCUXa2arSdWhipEy27nVx2Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvFeC0AG1IASkjWMzgLFq2LEsSqCZ2oC+4oDKSvX9I/5WAJXw4Jmw46c34Cn6tM1EAlnXuJ5n9ozwnbiI7/rLOSEusTT4Ez7/kcFYJPKFNxTfOphWvzEBhyPwivhXmjxHYs26txcLOOwkgTTZMbmxFrmS7Cj2L9ki7AAGsUsIHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXKi96Ji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXKi96Ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D041F000FF;
	Thu, 10 Sep 2026 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039393;
	bh=v50RFKo0o6bfIQ+cQjU94qkW5uFA6lWlCaZ4jvMj2V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fXKi96Ji4JfAD/jtitwh2CLbd5tkTt6zkKXIZL9RvS/8XXQ0pgGiYXiz4VchdNZ0i
	 bt6oj0AtHF/3AJgnip3y5e4IE/tkfa/KEGJtFf43rrJSDc1pAOvlnJIJ1kq2E2Zqnk
	 dZHFJE9yxnnJou9/UUD+sudfh2c79Z3KwrB54E+sB6Tp2v0s83N3l0iRk85Jz7atrf
	 RN4JTF3/k3MwgChsOZo4CJlF1ZtWhqr68mqtwBPE3v0Qb19npu8wNSN22T2P4wyida
	 SjhquU59kyPJDCpdRDwWR8maRZRWZ7mp79F8ZpJ4r+7+4SUL8F6L/EGMdpOcPJpZBj
	 U9dBWEFW2j/tg==
Date: Thu, 10 Sep 2026 13:23:09 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] mkfs: allow specification of default options via
 configuration file
Message-ID: <aqKS26rODvx78JP6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>

On 2026-09-08 23:02:35, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ted asked for the ability to set default mkfs options, but to retain the
> ability respecify options via a separate configuration file or cli
> options.  This would be useful for running fstests with the default
> featureset of (say) Linux 5.15 LTS, while still allowing individual
> testcases to provide their own overrides.  It's certainly less messy
> than what Ted does today, which is a bash script that copies the desired
> config file and changes things.
> 
> Cc: tytso@mit.edu
> Cc: hch@infradead.org
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  man/man8/mkfs.xfs.8.in |   16 ++++-
>  mkfs/xfs_mkfs.c        |  158 ++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 151 insertions(+), 23 deletions(-)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index fb62d579a26a2d..d915e72330304b 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -152,10 +152,22 @@ .SH OPTIONS
>  .BI \-c " configuration_file_option"
>  This option specifies the files that mkfs configuration will be obtained from.
>  The valid
> -.I configuration_file_option
> -is:
> +.I configuration_file_options
> +are:
>  .RS 1.2i
>  .TP
> +.BI defaults= name
> +Default configuration options will be sourced from the file specified by the
> +.I name
> +option string.
> +This option can be use either an absolute or relative path to the configuration
> +file to be read.
> +Sample configuration files can be found in @mkfs_cfg_dir@.

Shouldn't this also mention makecfg?

Otherwise, looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
