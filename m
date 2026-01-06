Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD9261B8A
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767716231; cv=none; b=n+x5HIv6e7eRwuy2AmMqRl/ieti9h3QDQIxtQuJQ3DNPpeBb8LaM6wfetCGfv0ujNH5d+FkuBaIKgmDeEpKGfpsVQj8SARbEnFIH/oZAhzfux/jTzxMQfZSHmwLG+0lr3fKuRExyyvFmj32gxqeSQrIXftpHRq+VvljZM77J5iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767716231; c=relaxed/simple;
	bh=MUSvDW0IYymiop/WRtNkGM76mmpDaYsWmZPA1fiHO2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XD2TnNMxyR000hq3MikYuhYdtjNXks8IDiXumC5XGACIxy0S5kK8VS7kCgUEQwyGueOMqXeHpnZ1bRz7aJuxuGLixTdfnvAcnUyIQIGBEtkl7m4gtj74XFDYS1XNwf940OOxuyRZtaBFLHF4mf7qTJ7Sf0ceTflsi0X3UdypnAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tb14Mq66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tb14Mq66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C94C116C6;
	Tue,  6 Jan 2026 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767716230;
	bh=MUSvDW0IYymiop/WRtNkGM76mmpDaYsWmZPA1fiHO2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tb14Mq66GxzrLbB5o0QdSdHTqa4wwa/tipSojmVFGpvp8nwFjmdg7f1jd7uBJdW+p
	 /b2oIV1NOhh7kt5pbZQs3TrjW6WMPFq8klRcPq77nC/DlT55g5AM2qf5Q35kOdv507
	 zacw1gvpN555paLL7pcVAY4EJ+ffI83OHE5/6KI2bhv1YEA7+8fy+qXYTcZtn5m7ms
	 pJUIun55BSgGw8gyRuMRWtWXASMvYIhFtPsAE2jh+RetThWAF+ttbDXim8zSbk1Azp
	 mRt4+c3M+NlL7aNwXjKcCww3GZOGNnivataJsjuNZnb5rPXBLLEFC39VHWOEF2M5Xa
	 /I4Qv4ESeieOQ==
Date: Tue, 6 Jan 2026 08:17:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 2/6] mkfs: remove unnecessary return value affectation
Message-ID: <20260106161710.GC191501@frogsfrogsfrogs>
References: <20251220025326.209196-1-dlemoal@kernel.org>
 <20251220025326.209196-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-3-dlemoal@kernel.org>

On Sat, Dec 20, 2025 at 11:53:22AM +0900, Damien Le Moal wrote:
> The function report_zones() in mkfs/xfs_mkfs.c is a void function. So
> there is no need to set the variable ret to -EIO before returning if
> fstat() fails.
> 
> Fixes: 2e5a737a61d3 ("xfs_mkfs: support creating file system with zoned RT devices")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

LGTM,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index bc6a28b63c24..550fc011b614 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2589,10 +2589,8 @@ report_zones(
>  		exit(1);
>  	}
>  
> -	if (fstat(fd, &st) < 0) {
> -		ret = -EIO;
> +	if (fstat(fd, &st) < 0)
>  		goto out_close;
> -	}
>  	if (!S_ISBLK(st.st_mode))
>  		goto out_close;
>  
> -- 
> 2.52.0
> 
> 
