Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A5872626;
	Wed,  7 May 2025 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746651977; cv=none; b=AZhSHhrqwvCzSvoQP9o7lhDxIiwMDrn+szdG2Y0T8SXsLE0FzyznJna8nABt06/GKbNCMeD0T0YzGRgTjzDL6I10iORGFu9S9onmw7nKCJSQ8e+45iKkeUmeD5n05Pt1E6Qbf2d1tOEXlaq24C2/Fd+pmgqAz/klDi1iH5iSVC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746651977; c=relaxed/simple;
	bh=fgQormryc833GtM65mwcs9/Lcx5QQdToRYycs+E3iH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYdhPZS2Mrn1wJGQh0ybG3jQNCKkvRaW1u/lXQVmir4PA+ysiPeMJ10/ily5kd2Fg/th/77woWYTPK36ZAt/sx4JgFpeibyxwoU1iBWCzNXUxG6TV8eLW+QtIu+kcUra2BCbA4wDHl1NSRpw2b/kBEoGkJ66cvR9/t6x2g2YafA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fa0R4wOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fa0R4wOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406B1C4CEE2;
	Wed,  7 May 2025 21:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746651975;
	bh=fgQormryc833GtM65mwcs9/Lcx5QQdToRYycs+E3iH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fa0R4wOcDE3QoesIyyjMNW1ZK0yB/gZDLcrfHdO+1kz8s5BxE3Nt1k46FrIGctTmg
	 kxGN0IzYQAOxhHNGN5Vq8F9TgyD4XxOm/hdqRjXd1r55v3h3IPSIeCblyE8NW1FlS6
	 pYR4ZxNa03xtMke1JAWOEoBycOEVZl2Ovlg/Lvbhh9xQR/CfFa4K7/UZU6ThrtVWjL
	 jpaS0lzwU0w1SJ2jKQv/MWhkT6eznT0zvCi0yrzlN7wxISH4usYIXlH3J4JZneA4vU
	 rn4t95xrHH7eAYwPntqvyMlcCF2+vdZmTV+7rRmtH1yOt8BygIvJd9jfCj1j+Wl4bm
	 1qQpsp5PyKI6A==
Date: Wed, 7 May 2025 14:06:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] common: add a _filter_rgno helper
Message-ID: <20250507210614.GH25675@frogsfrogsfrogs>
References: <20250507051249.3898395-1-hch@lst.de>
 <20250507051249.3898395-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507051249.3898395-2-hch@lst.de>

On Wed, May 07, 2025 at 07:12:21AM +0200, Christoph Hellwig wrote:
> Based on the existing _filter_agno helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 39650bac6c23..98f50e6dc04b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2274,3 +2274,13 @@ _scratch_find_rt_metadir_entry() {
>  
>  	return 1
>  }
> +
> +# extract the realtime grou number from xfs_bmap output
> +_filter_rgno()
> +{
> +	# the rg number is in column 4 of xfs_bmap output
> +	perl -ne '
> +		$rg = (split /\s+/)[4] ;
> +		if ($rg =~ /\d+/) {print "$rg "} ;
> +	'
> +}

Er... maybe this should be called _filter_bmap_gno (and go in
common/filter) and then we can change the one caller of _filter_agno?

--D

> -- 
> 2.47.2
> 
> 
