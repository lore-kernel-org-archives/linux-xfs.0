Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05151E1A20
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744215116; cv=none; b=Up2a469DI/F+J2+OpxKgMcLQ7pgFFgT61RGo6BXf+ZoEMtpvPcXS+DPwWq15nWd7gqt6iIj6hbNYP9Whc1qI+K34ltHUgHE6TMkGwhNYf+QO1nRQ+dizC7EPwQQkWwbDZQaw785TPVWvJDFgRwJyqkGcNXM1SuEw2cSp00RqFl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744215116; c=relaxed/simple;
	bh=S/uS2+zKPuMoHa5MJEa+XAjQvc6OKh2yKFVjnfvU88I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yl06R+4VUPZf+jRADw+0FifIxt5vpdXPkctjPLKYJkVSdfXD7Jz3pI8tfe0lzt9j3XHTpB/4xdnAS4osda8W1xOBQjEay2UFOiuLgaShzSKkerm3xRRXMZBNDaVsLDX451TDSzllYiIO6XpOIECOF9HbB8HXdc4rzHqxWjMFNB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SE7XKM10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SE7XKM10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F983C4CEE2;
	Wed,  9 Apr 2025 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744215116;
	bh=S/uS2+zKPuMoHa5MJEa+XAjQvc6OKh2yKFVjnfvU88I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SE7XKM100mqXH6MsAbcq74M6gBiQSVCgYv5MEqi+jE3/Z0v1ENGioEQl1bhejbOYO
	 aw/RKHHo2OTCwV08KAUULSmas6YkMw4M+wvuBXqD4NDAZ8EIG/1AUHRUL4a2owkd01
	 U9tDwWFO/5WG8mDLk9YzdnUqgFJ+uilqhtZ9RUnu6ina7K1Em+JnyCPAWp+4IaEcDR
	 Tl4hsY5kBJCtN/wi07EDxECGShOWXFrbY4Uo7Kf2uzcatg2RYpNQx60u0C25IPC3JZ
	 ynilvbthgQGhptnrlfuvbsTAplcVpIxHSgc1kSqwcWlPXx3qJ3XobNTqBVr13NAsQl
	 O4gIGuP0twskA==
Date: Wed, 9 Apr 2025 09:11:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/45] xfs_repair: fix the RT device check in
 process_dinode_int
Message-ID: <20250409161155.GD6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-29-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-29-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:31AM +0200, Christoph Hellwig wrote:
> Don't look at the variable for the rtname command line option, but
> the actual file system geometry.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/dinode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 7bdd3dcf15c1..0c559c408085 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -3265,8 +3265,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  			flags &= XFS_DIFLAG_ANY;
>  		}
>  
> -		/* need an rt-dev for the realtime flag! */
> -		if ((flags & XFS_DIFLAG_REALTIME) && !rt_name) {
> +		/* need an rt-dev for the realtime flag */
> +		if ((flags & XFS_DIFLAG_REALTIME) &&
> +		    !mp->m_rtdev_targp) {

If we're going to check the fs geometry, then why not check
mp->m_sb.sb_rextents != 0?

--D

>  			if (!uncertain) {
>  				do_warn(
>  	_("inode %" PRIu64 " has RT flag set but there is no RT device\n"),
> -- 
> 2.47.2
> 
> 
