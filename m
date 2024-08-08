Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223F34A33
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723129522; cv=none; b=E4fZOUEs6P2iWtX8tBC9PWdzeGYowkFmgEWlbzlwbpv+oaOBe7oPdoMPlDO3rmaCs5ECT5mgEMYLhz+VXRbwuoHOcc9yMLlGQshEyNzeqGCMDFQKVAQmCSbGQ4Nj3iJmYKmxaePEtNvjCG6Sw+1ymEmQXMhtjIyXiwOO5Cq/of4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723129522; c=relaxed/simple;
	bh=Gh0/rHhGgq8m6tGdd49CQE+dpXG7XLoNvG2LNkUMVN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbAyO+C85WI4+vKQ+akX+zDLS+YPT/+d2ZeqkxW/B9+p2urBHAOu9eZa8HB3MZYU2ps4YKK1UeKpEoQgVcQvDpdauDV7lexN453+tRdbbYCQRoYSOIApAATDOM+vHeKAAiI4kQrRE4qe4CMz5wJLdcZhnQCzmYqi49wQjVSOaRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhmZ5HUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhmZ5HUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90913C32782;
	Thu,  8 Aug 2024 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723129521;
	bh=Gh0/rHhGgq8m6tGdd49CQE+dpXG7XLoNvG2LNkUMVN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhmZ5HUkSwLF3Q7f/uJlQkkY5WU/0Sv72QqdgHGZsx/FEyEfnYs5/1lZMwdIHJ1sL
	 p4kmrKzNxJ+NEU6nQPLO99vVTRSU9NWLw5gKpC63lgyuaKJTlasda993iD2ULLx96B
	 fGbkUji77p5jiATqteUSVA/DQMPjo+8oSoMpL4Gca4srM/TwUoQk2yf4QIClUF3fF8
	 wi0f7HZ1eFj7864kXQTSbUGHPkeGQRTVtp69rwYI5RSDpN9j18+MqX2kqVBhUsAoVr
	 vxljvprW+NtTnftw0VnIf7+zWnIiL1CIYfdC/h2KS5Jx3J1QY1WfJ3e8p1Tbd6FGOS
	 K6n7YWriTnQNw==
Date: Thu, 8 Aug 2024 08:05:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] man: Update unit for fsx_extsize and fsx_cowextsize
Message-ID: <20240808150521.GO6051@frogsfrogsfrogs>
References: <20240808074833.1984856-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808074833.1984856-1-john.g.garry@oracle.com>

On Thu, Aug 08, 2024 at 07:48:33AM +0000, John Garry wrote:
> The values in fsx_extsize and fsx_cowextsize are in units of bytes, and not
> filesystem blocks, so update.
> 
> In addition, the default cowextsize is 32 filesystem blocks, not 128, so
> fix that as well.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Yep, that's been wrong for a while. :(

Thanks for fixing the docs,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
> index 2c626a7e..25a9ba79 100644
> --- a/man/man2/ioctl_xfs_fsgetxattr.2
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -40,7 +40,7 @@ below for more information.
>  .PP
>  .I fsx_extsize
>  is the preferred extent allocation size for data blocks mapped to this file,
> -in units of filesystem blocks.
> +in units of bytes.
>  If this value is zero, the filesystem will choose a default option, which
>  is currently zero.
>  If
> @@ -62,9 +62,9 @@ is the project ID of this file.
>  .PP
>  .I fsx_cowextsize
>  is the preferred extent allocation size for copy on write operations
> -targeting this file, in units of filesystem blocks.
> +targeting this file, in units of bytes.
>  If this field is zero, the filesystem will choose a default option,
> -which is currently 128 filesystem blocks.
> +which is currently 32 filesystem blocks.
>  If
>  .B XFS_IOC_FSSETXATTR
>  is called with
> -- 
> 2.31.1
> 
> 
