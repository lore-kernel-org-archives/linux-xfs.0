Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298E20C490
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 21:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739483142; cv=none; b=Wud2p1g1USqX4kGEFnhUj4XH/mWihV6fEpSYqenkbz7jcUHuI6QmtdS4fvltqQCqn9bmhjNHoBp0wLHOl6C9LtW85cjW8YIx2i9lMoyNDzYlMZxEa7Xi2SXJ32im6+6Ul4M+S0BTOxNtIH+lQhs5xgBUeXTQxWnFNmDWESVRph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739483142; c=relaxed/simple;
	bh=R3uTjuHPDPEMB7/wkt9/e8oNsJP6nJPUs+jy0+Fd13w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fctA7ansEwdamndSt9U2xKwq0ExpLUVbVXhyd1No/HUvLuI3+srxaxBNb1xq/qzIOxsF4Vt1RZyUl8UY8dsfj8cru/NRqzF9/THwJ442awYs/uvjP3NyzRvNQtOOhtGF2Nlqo70KfUKJhEo/YouqrXpJIGvDjsZ4q1IUfmlQ2xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGAy48JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGAy48JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66CFC4CED1;
	Thu, 13 Feb 2025 21:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739483141;
	bh=R3uTjuHPDPEMB7/wkt9/e8oNsJP6nJPUs+jy0+Fd13w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mGAy48JUCFXF+TKoZpdFtUSU/NXnObQDnsBlojLqGg+LtXbMxujMCMVmll0JH2l36
	 w8WGHkMK6Ed/CFiEo/7o1u2pjg/36RS0l24rQ/A8gdqLTMALgwwlChbrkgdrbzyNAt
	 4ruwdcVj74RwnNnO3lJtVOCM/JtE3kQ5OjLHZ7S3YWXlXLEoF3gALJgNsE4UKdr2SV
	 /UPv6zHmz1HrxzgJpvSVsmQ5GBVtlHlCdwrpphauPJ158KIqh5zJ07TbBF1AFytI4g
	 ajHBG2O32WXfjjjhaKfchUdy53PM8PaXFPa0B1ZyXBpnFWaPcwE6DTR+AET/jsNLmc
	 zJTD//6hgkbWQ==
Date: Thu, 13 Feb 2025 13:45:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 09/10] libxfs-apply: drop Cc: to stable release list
Message-ID: <20250213214541.GQ21808@frogsfrogsfrogs>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
 <20250213-update-release-v4-9-c06883a8bbd6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213-update-release-v4-9-c06883a8bbd6@kernel.org>

On Thu, Feb 13, 2025 at 09:14:31PM +0100, Andrey Albershteyn wrote:
> These Cc: tags are intended for kernel commits which need to be
> backported to stable kernels. Maintainers of stable kernel aren't
> interested in xfsprogs syncs.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tools/libxfs-apply | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 097a695f942bb832c2fb1456a0fd8c28c025d1a6..e9672e572d23af296dccfe6499eda9b909f44afd 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -254,6 +254,7 @@ fixup_header_format()
>  		}
>  		/^Date:/ { date_seen=1; next }
>  		/^difflib/ { next }
> +		/[Cc]{2}: <?stable@vger.kernel.org>?.*/ { next }

You might want to ignore the angle brackets, because some people do:

Cc: stable@vger.kernel.org

which is valid rfc822 even if SubmittingPatches says not to do that.
Annoyingly, other parts of the documentation lay that out as an example.

		/[Cc]{2}:.*stable@vger.kernel.org/ { next }

<shrug>

--D

>  
>  		// {
>  			if (date_seen == 0)
> 
> -- 
> 2.47.2
> 
> 
