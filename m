Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C4E3B2FEA
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 09:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223074; cv=none; b=Hyk95Xi1FL4u2Vru7ICptSk0DWcWMkn+zX/QYowNQTpyTRWX5GobrDv3IuOD56XaqIKySWMSR78T6sZWa4yDqCn9SDz48ZqYVPdG9N3EPbxamvac54N7RH2/XwM5RBHxVaCnJcXsT0wEh+NvX9BS4yNXYIThzneJ7a4hM1F1ZzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223074; c=relaxed/simple;
	bh=PsWTd1zwdFmUgfDJdyI5NZisg4UZQNJU4bPkO7fL3SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YS8/D/GLRCeUxBzHn7NKBROKuOSh+VCAO8ySSZwVgDXhojdlaN0OC1qjv5HPp1yooteTit5A/OfDqNs959V8sLzzh5bk1tvs+Pzh1Lp70B5MR94wmnKsh+1VEE00uMPK/jRa+xXyDCEs/zt3oLmt+3WujXUkuGGxPqIiBBigC58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ancQrfAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ancQrfAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5776C4CEF7;
	Wed, 11 Mar 2026 09:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773223073;
	bh=PsWTd1zwdFmUgfDJdyI5NZisg4UZQNJU4bPkO7fL3SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ancQrfAJjjKYhmYoV1yxXoxgDCqIlFGw2xg6PyIwYtTBxViu5b46IKQT9W26Tohiu
	 lx1bsHP1/w9sK6JDG6cI2Aq9FbzXHDJtwHFFRpUe+pqjbVDId8B7axJ1KlLHz+Q3js
	 zmx7yXS/akDaghf0pz71IHa4cjs+sW1RAv/KT/Ri45GYk75BpcagwE9XizVmXfxO2+
	 s2arQJfeDcrt6m256SrGSULbXh9oSzO19IMLZfETQll39l42uRrXAi3S4jPusESJuA
	 +9aJHN4ztNN7NnnTbgm5S4ojo0rMBuhpVEk7efSoQaMkuu/rj8EtPu395SaDtduL9U
	 2g1LtfgwlKzGg==
Date: Wed, 11 Mar 2026 10:57:50 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] io: print more realtime subvolume related information in
 statfs
Message-ID: <abE8lO6oe-vEIQ4j@nidhogg.toxiclabs.cc>
References: <20260311092634.995699-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311092634.995699-1-hch@lst.de>

On Wed, Mar 11, 2026 at 10:26:27AM +0100, Christoph Hellwig wrote:
> The statfs call report information from the fs geometry structure.
> Add the fields added for realtime group and zoned device support to
> this output.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  io/stat.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/io/stat.c b/io/stat.c
> index c1085f14eade..e3b3574e0416 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -282,6 +282,12 @@ statfs_f(
>  			printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
>  			printf(_("geom.sunit = %u\n"), fsgeo.sunit);
>  			printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> +			printf(_("geom.rgextents = %u\n"), fsgeo.rgextents);
> +			printf(_("geom.rgcount = %u\n"), fsgeo.rgcount);
> +			printf(_("geom.rtstart = %llu\n"),
> +				(unsigned long long)fsgeo.rtstart);
> +			printf(_("geom.rtreserved = %llu\n"),
> +				(unsigned long long)fsgeo.rtreserved);
>  		}
>  	}
>  
> -- 
> 2.47.3

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
