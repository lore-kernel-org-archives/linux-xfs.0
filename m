Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52C32222DE
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739478005; cv=none; b=DE8rn+IUYVBuzhCDTUYBEdkvf+qUcVE0mBxS9fbE8KJLQupXirbnQKKy9ro5FS1aviAsiiKBUbI0UvPC5y0xBa9BkEVc6ZTF1dp77KdD2KGLvSUCHlqSAPK1OU74QMjtpIMpkVsaLKKl9pmQ0Cdk/iksIQ+J54MgblLcWfDq5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739478005; c=relaxed/simple;
	bh=hGHSmQFmh+aErL+MVEzp+uJZZMXL6jbi+sb71QaZGUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhgHDlCooBXn6dl3Irb0zNwGlNAOH6Ps4fVwIOBkd/wHAAuRe1LjjH8FLwU2qwPR/VsUcBhwaS9Bpn873LisXnIAmmEOGftPOBrUgKIfqNGFglbEKRu0LjzTIiJ7D1pKIbpE8kemUmBbTFvmZ7lhsEz405dGtP1clPyV2tmnjuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVYEtqUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVYEtqUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACE0C4CED1;
	Thu, 13 Feb 2025 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739478005;
	bh=hGHSmQFmh+aErL+MVEzp+uJZZMXL6jbi+sb71QaZGUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SVYEtqUoGUMYOH2DDxnj1euTUsdvoHJRCs93ZrMjVT2U8mCol2IlOaST4GW13+tO+
	 4IwMNZYMLO2060kYRWBFUzKrIc7BdAc+YI9na5t5skBAYqlMf+SGiphTU5xANoMQOX
	 FQRl30TP+U4J8MgB7pzvRmB0tL16glK6TpoSh/rbnj4taAJvSqf+Yj6WPRihcCKh7l
	 GDDZ65ypAsooT2xuhL6jxt6HwJSvHX8M4FcRuuNMqSCl+sWx5ZWO4YpCA50FkRjyrs
	 teawqflfMmmTmuJIGJTVeJtJ5yztiDXUJ/wUh/tXWdpT87w91tibaAjgvuqcSYW0OA
	 8030yERFrd/TQ==
Date: Thu, 13 Feb 2025 12:20:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 10/10] gitignore: ignore a few newly generated files
Message-ID: <20250213202004.GP21808@frogsfrogsfrogs>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
 <20250213-update-release-v4-10-c06883a8bbd6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213-update-release-v4-10-c06883a8bbd6@kernel.org>

On Thu, Feb 13, 2025 at 09:14:32PM +0100, Andrey Albershteyn wrote:
> These files are generated from corresponding *.in templates.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  .gitignore | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 756867124a021b195a10fc2a8a598f16aa6514c4..5d971200d5bfb285e680427de193f81d8ab77c06 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -65,12 +65,14 @@ cscope.*
>  /mdrestore/xfs_mdrestore
>  /mkfs/fstyp
>  /mkfs/mkfs.xfs
> +/mkfs/xfs_protofile
>  /quota/xfs_quota
>  /repair/xfs_repair
>  /rtcp/xfs_rtcp
>  /spaceman/xfs_spaceman
>  /scrub/xfs_scrub
>  /scrub/xfs_scrub_all
> +/scrub/xfs_scrub_all.timer
>  /scrub/xfs_scrub_fail
>  /scrub/*.cron
>  /scrub/*.service
> 
> -- 
> 2.47.2
> 
> 
