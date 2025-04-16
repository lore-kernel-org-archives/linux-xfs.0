Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8DF212D61
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820894; cv=none; b=sSVgWTH673nDs4uh7r4HHG+M7ERMIuSkVJs8oNGjxNEuGO89EpC4n1Ux/uSgsgod5iQpeAS86X5ggAh8xefitYzUy1NqQTd2TZlLTz+L0nypE0bIbTLafNzjU8rQa61/NkHtFddJQNqNCRBkn68BmecO+QvMRk9DxMAId81nb0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820894; c=relaxed/simple;
	bh=i9n3Lc4yvfbhHxRal/gHjYSbs9RTe1U21qnCzltYMlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXlRQpz0uzZxW1f5HH2SNx3RbA0BLTVtq1xCmiTIrq9ziRG/4duUVO+59rhynTUqFZAQ4/xdRIThvm2WaXkX4+7VC3mux5c8ITxUmCANePUjOrkle1rq2nU2B6rJLvIclD1rv1jH8jBJceyr4ckoLFpJOJ7riO2iAwcVdCfXmxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2c//zpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2c//zpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C063C4CEE2;
	Wed, 16 Apr 2025 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744820893;
	bh=i9n3Lc4yvfbhHxRal/gHjYSbs9RTe1U21qnCzltYMlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G2c//zpcvCWWEC3dLoZgAoRtjXf/XvwolGXMeTUA4mgDCflEqmzB0WeExaKgFHy62
	 CbwiUkV0S7gir/QGiQ+84HdwLQzrSu6NN6cWeBeHxJ1N13TxTyb0uj8ApFGQWHfj4d
	 bhhkQ7UwLms+NHUuTuO50JIE4kRdlMMdkguHB/BWRbA76zkaVillOuoNEWPUCbtKZx
	 TUcEy410MaqJ2OMvB4PjCH6PzygnF205DhrLrLR/wqiKDgJLz++DNl/IaYZFPE16Q1
	 GIGkLDnW02NOGgpIrfR9+VqW6Sc4SZgr267fJ7IBbPOP7IXS/Uik0PBCoR/DOhgUfE
	 D4CH35up3W3lA==
Date: Wed, 16 Apr 2025 09:28:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH v2] xfs_profile: fix permission octet when suid/guid is
 set
Message-ID: <20250416162812.GL25675@frogsfrogsfrogs>
References: <20250416161422.964167-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416161422.964167-1-luca.dimaio1@gmail.com>

On Wed, Apr 16, 2025 at 06:14:13PM +0200, Luca Di Maio wrote:
> When encountering suid or sgid files, we already set the `u` or `g` property
> in the prototype file.
> Given that proto.c only supports three numbers for permissions, we need to
> remove the redundant information from the permission, else it was incorrectly
> parsed.
> 
> [v1] -> [v2]
> Improve masking as suggested
> 
> Co-authored-by: Luca Di Maio <luca.dimaio1@gmail.com>
> Co-authored-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>

The subject line should say "xfs_protofile", not "xfs_profile".

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_protofile.in | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
> index e83c39f..9418e7f 100644
> --- a/mkfs/xfs_protofile.in
> +++ b/mkfs/xfs_protofile.in
> @@ -43,7 +43,9 @@ def stat_to_str(statbuf):
>  	else:
>  		sgid = '-'
> 
> -	perms = stat.S_IMODE(statbuf.st_mode)
> +	# We already register suid in the proto string, no need
> +	# to also represent it into the octet
> +	perms = stat.S_IMODE(statbuf.st_mode) & 0o777
> 
>  	return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
>  			statbuf.st_gid)
> --
> 2.49.0
> 
