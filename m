Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7792D46B4
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764951577; cv=none; b=qPCuRsxCDjbmx+7Kltsu4pSFEeInUV3ieq3BCfrPrNoyoZSggamRW80fIJe72BkC9aVx84dUoQWSKFUgX8ti1fC5mwlYfugM2NLT1oBFgmS0YXaphzW+znoaOXx1xTQysiuanAOhSU9uCfkYuMT3oRAXY8sp5xWBy5BqWvzoWt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764951577; c=relaxed/simple;
	bh=z2Qgm8RVr72jhZjWJUbh4Wgi+6fiF2c++LRTV2u5t9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksquzU6f8khARaMsiKIMQvVpnJC+wbHBkRSqoDTlTsbunp9AK8IpP+tIbMTic3DXoo3jIY+UQsdfFrDK1jogxKIK8jL2XVO6zjkpguTZI/6E77stbEh4T4GQv6do7UIByTmxWhP5xNF53++imTrFAbhgmhdF6RheXX4O+XB3oGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSXH4A7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSXH4A7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AD7C4CEF1;
	Fri,  5 Dec 2025 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764951575;
	bh=z2Qgm8RVr72jhZjWJUbh4Wgi+6fiF2c++LRTV2u5t9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dSXH4A7syW1lSe1aY1ppm+7aTDNKwiNhiP3Nbe8NYxZBJosTVia2cGBZNr74vvZZ/
	 WvuP3nBoc9zPlBS1AQZi1bBe65EsO8tC39FrRwrpnw/XyEQxXBPK+Jh0Rt8A+hMceh
	 UZXJeSyQrlz2/ELhU6Za4vC2swdwNPq85P5HGIGWU8E2f715pK6vZm8F+ZPKgHXISt
	 OLCQrlpweYzbEeYuSL0qQPCwxgrQ4g26cXf5HO1F1FH7X8s1RkdipFinaXYPJvgqRM
	 ujSAriAk9Dy42Jpc2DZob3nB+SaZ8gJ0kdu4npKRf4u6mdt5uyWTJs8gPQNFZvyjEv
	 7IZKdOrThENVQ==
Date: Fri, 5 Dec 2025 08:19:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to
 ioctl()
Message-ID: <20251205161934.GO89472@frogsfrogsfrogs>
References: <20251205143154.366055-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251205143154.366055-2-aalbersh@kernel.org>

On Fri, Dec 05, 2025 at 03:31:48PM +0100, Andrey Albershteyn wrote:
> From: Arkadiusz Miśkiewicz <arekm@maven.pl>
> 
> xfsprogs 6.17.0 has broken project quota due to incorrect argument
> passed to FS_IOC_FSSETXATTR ioctl(). Instead of passing struct fsxattr,
> struct file_attr was passed.
> 
> # LC_ALL=C /usr/sbin/xfs_quota -x -c "project -s -p /home/xxx 389701" /home
> Setting up project 389701 (path /home/xxx)...
> xfs_quota: cannot set project on /home/xxx: Invalid argument
> Processed 1 (/etc/projects and cmdline) paths for project 389701 with
> recursion depth infinite (-1).
> 
> ioctl(5, FS_IOC_FSSETXATTR, {fsx_xflags=FS_XFLAG_PROJINHERIT|FS_XFLAG_HASATTR, fsx_extsize=0, fsx_projid=0, fsx_cowextsize=389701}) = -1 EINVAL (Invalid argument)
> 
> There seems to be a double mistake which hides the original ioctl()
> argument bug on old kernel with xfsprogs built against it. The size of
> fa_xflags was also wrong in xfsprogs's linux.h header. This way when
> xfsprogs is compiled on newer kernel but used with older kernel this bug
> uncovers.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  include/linux.h     | 2 +-
>  libfrog/file_attr.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index cea468d2b9..3ea9016272 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -214,7 +214,7 @@
>   * fsxattr
>   */
>  struct file_attr {
> -	__u32	fa_xflags;
> +	__u64	fa_xflags;

Ouch, that's bad!  Thanks for fixing that...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	__u32	fa_extsize;
>  	__u32	fa_nextents;
>  	__u32	fa_projid;
> diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> index c2cbcb4e14..6801c54588 100644
> --- a/libfrog/file_attr.c
> +++ b/libfrog/file_attr.c
> @@ -114,7 +114,7 @@
>  
>  	file_attr_to_fsxattr(fa, &fsxa);
>  
> -	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
> +	error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
>  	close(fd);
>  
>  	return error;
> 
> 
