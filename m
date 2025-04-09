Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E381DFFD
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225305; cv=none; b=XHCooOr9fZKesycoEnjtwWQKgCDvlKavqL8h8wExbhpxr0bxTEWXczRj0duptj4Sdh03MkVAigCJVkzebThMIAlWowoQKtyIsiWbokb05C9kyN7PjpRVwJgn8/1R6Z87pl2jN8mClsWA3eD03U36uRzmkAUxLG/Qocx+fpamTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225305; c=relaxed/simple;
	bh=S8PwiqWr3PsT3JT8Kw6zRiWU/98j4bZN2jbmpMxC4So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQstC1iZi7fhrdvbhTbTLCNew/uWPmxpPAbTxao7uuigGmJAXq8CHRRjewgccxw7rzrmCO1QuTckgb2vQWQP7ROytwBNOLMFPzy9gYbA6IVJ4+cC9VJWFNj0Znnyb5BMOgcg8W/ZkXuAzy12HLChSfpQ56bnjR4qCE2z7SAA3po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMKf5cmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMKf5cmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA048C4CEE2;
	Wed,  9 Apr 2025 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744225304;
	bh=S8PwiqWr3PsT3JT8Kw6zRiWU/98j4bZN2jbmpMxC4So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZMKf5cmItV5vaKAAoZ2HkggZ6seqGv8YCckFgGNQpKWcCVJVziesEbdTxy5ZSbQD9
	 X1bTnnIgsr9ismyOnpFKABePnpe/GkCqSKXJzTe3RZ0UsuwpPxq1CkIGY3iVzw/VUK
	 Kd9gqU49tMspTLHLX6T1t0bZX62ch1jLVzXpIJFIgJR173O0bVsGEmekdLbuowAE1l
	 InWtLzyajTiG5qhtSChjqAIRVl//5u002e48S9pzVC2SgUCDdFs0DxfpmA8ko7Bs/i
	 U5lY2aAuFF5KG1SMCAjGBLljdbxaSYl0IGKhMFEf8Jk4cpducHbE0fDweitz8H2Xas
	 p8OuA4WNf/gOw==
Date: Wed, 9 Apr 2025 12:01:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/45] libfrog: report the zoned geometry
Message-ID: <20250409190144.GJ6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-36-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-36-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:38AM +0200, Christoph Hellwig wrote:
> Also fix up to report all the zoned information in a separate line,
> which also helps with alignment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Could all these xfs_report_geom should be a single patch?
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/fsgeom.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 5c4ba29ca9ac..b4107b133861 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -70,7 +70,8 @@ xfs_report_geom(
>  "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
>  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
> -"         =%-22s rgcount=%-4d rgsize=%u extents, zoned=%d\n"),
> +"         =%-22s rgcount=%-4d rgsize=%u extents\n"
> +"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"),
>  		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
>  		"", geo->sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> @@ -86,7 +87,8 @@ xfs_report_geom(
>  		!geo->rtblocks ? _("none") : rtname ? rtname : _("internal"),
>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents,
> -		"", geo->rgcount, geo->rgextents, zoned);
> +		"", geo->rgcount, geo->rgextents,
> +		"", zoned, geo->rtstart, geo->rtreserved);
>  }
>  
>  /* Try to obtain the xfs geometry.  On error returns a negative error code. */
> -- 
> 2.47.2
> 
> 
