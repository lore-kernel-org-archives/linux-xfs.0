Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91514305E1F
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 20:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262354; cv=none; b=IK905GUw2AEr9z8N9xFqpqspMni0FkT2mwZwhQ877LX6kRs3C+930uKQNoPJeNJjPGyG7rz/501sB/6n/HQbKwKwzf32ArrhMzSVuXvnlTcdHgbxvaSKRZKAdF1TUCfcYpCPqPr7yailVCirFpLynDyD262PZpX2D97K1xDMMFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262354; c=relaxed/simple;
	bh=NZ6KkeAdDpxKukNqgXuiVF6jBTh12rTV3bIUzfWIAUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0fYpb/2otnGDp6ocGrgMSEoD8XaPXyUJFAUgcRLTausVGuaBCQQiXKfFRr2tZbzBrqAnGO9CpkXgMqVzPFyzVdSjhEtq7spz/Tr0Ju4YfzTlS54FyH7dlEVGH6+J2Q43Njn1tIBB07s/EVbhMPem21BxeJ+VsreZAjoLjxbZfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUg7sBin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUg7sBin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224C2C4CEF7;
	Wed, 11 Mar 2026 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773262354;
	bh=NZ6KkeAdDpxKukNqgXuiVF6jBTh12rTV3bIUzfWIAUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oUg7sBincf8GxKgflJGFzyYOsWHNcZHBew40C0cWEazcncMLcIYFRuOROvpGNzrjH
	 O9r5ZhxVOFcQIwl+u5aUtgG+9IH+4U5pBGlZNYY0fiB6GX0CXgbntNM0ssUk13zDjx
	 Y4tbg9UGi+L5Gigo5W75GrXEo+4bIlfc53RmLPd9Csl0A76GzUomMg8UCXh6BaE9Sz
	 p0+Bl2Qse0UDie6o3rPk5/l/svL3uv+7iQmg+YZWsa9om3/4kIMEl3pzB3Trq4W1a0
	 1xC/RMXprnGCqJdOskxrwUiKISIvXE83RbL+cRt66L41dy7a0AvQP9zNu0Hr4oMJRE
	 DnM4hnQ+m42dg==
Date: Wed, 11 Mar 2026 13:52:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] io: print more realtime subvolume related information in
 statfs
Message-ID: <20260311205233.GC1770774@frogsfrogsfrogs>
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

Sounds like a good idea! Sorry I didn't think to add rgextents/count
when I added metadir.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
> 
> 
