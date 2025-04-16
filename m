Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13746205AA1
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744818015; cv=none; b=tzEEw6f5ZOi3vlCbZodhDijqZ0sbxI4FbtRzsv+ZoHYjgzgNTglP1mKcJH95897gltmbIt0M7JD1nEPEhJubU9MNFGzFySHe9lxtB2uccse6N3+u2ohguENMABXOah9QKAjXOhZ74q58pIznGaBJdmGqlPusGl0pNoEdsYOXuzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744818015; c=relaxed/simple;
	bh=WpD2Iji+FIUm/s39t4wNdHYExQeyQhgCsHutt0nXo8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDDf/n7s6nYDnK0NOY5Nl2pTqIfFBzpRQ/yMeNuoctdRpeyBb3Kf9krB2f233H5XSwv5zbqAXz+/dGo3x+vJboTJSMKQIwT2yGMoJdh2jeN7AFgTG9c0i0LI0ruCM69rOg+Ut9L4thrdQ6qnHz7F8hUMOE8C4HTf+kh8Pv0M4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sADqPBP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sADqPBP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7B1C4CEE2;
	Wed, 16 Apr 2025 15:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744818014;
	bh=WpD2Iji+FIUm/s39t4wNdHYExQeyQhgCsHutt0nXo8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sADqPBP8LTPm4ODxkX64ZGYe/th4d9C57/MxI9yG+aUTBQJR+TCHtBzKo47wU/Q5/
	 VP1MpBSGIBRjJzDC0QJxudz697dpfFGDPGk8L9Kkuvpvhq+ySkJavSvv9WGaYcTi85
	 ozb20TaX0xZmshMFhz6MxFg3DXO7h3FuAb/047bHBfgg/lVV4VGgN0wGkzy8tEWDNY
	 oSTEfqbUCsi+hcH5vopXk+uo1wgqkQ24+dab4hr72jiiv7oKUBEJGm0YV+yAGPhrUb
	 5KTxfw6jQaLalBwU3K05XxT1JGCRmy+9Qzr5VomkRMqT2EnHH9GbWZu6KEtUEcnfMD
	 XJ5/Hj1VZtfQQ==
Date: Wed, 16 Apr 2025 08:40:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH] xfs_profile: fix permission octet when suid/guid is set
Message-ID: <20250416154013.GF25675@frogsfrogsfrogs>
References: <20250416123508.900340-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416123508.900340-1-luca.dimaio1@gmail.com>

On Wed, Apr 16, 2025 at 02:35:00PM +0200, Luca Di Maio wrote:
> When encountering suid or sgid files, we already set the `u` or `g` property
> in the prototype file.
> Given that proto.c only supports three numbers for permissions, we need to
> remove the redundant information from the permission, else it was incorrectly
> parsed.
> 
> Before:
> 
>     wall                                    --g2755 0 0 rootfs/usr/bin/wall
>     sudo                                    -u-4755 0 0 rootfs/usr/bin/sudo
> 
> This wrongly generates (suid + 475 permissions):
> 
>     -r-Srwxr-x. 1 root root 514704 Apr 16 11:56 /usr/bin/su
> 
> 
> After:
> 
>     wall                                    --g755 0 0 rootfs/usr/bin/wall
>     sudo                                    -u-755 0 0 rootfs/usr/bin/sudo
> 
> This correctly generates (suid + 755 permissions):
> 
>     -rwsr-xr-x 1 root root 514704 Apr 16 11:56 /usr/bin/su
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  mkfs/xfs_protofile.in | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
> index e83c39f..9672ca3 100644
> --- a/mkfs/xfs_protofile.in
> +++ b/mkfs/xfs_protofile.in
> @@ -43,7 +43,13 @@ def stat_to_str(statbuf):
>  	else:
>  		sgid = '-'
> 
> +	# We already register suid in the proto string, no need
> +	# to also represent it into the octet
>  	perms = stat.S_IMODE(statbuf.st_mode)
> +	if suid == 'u':
> +		perms = perms & ~stat.S_ISUID
> +	if sgid == 'g':
> +		perms = perms & ~stat.S_ISGID

Hmm.  The mode parser only pays attention to positions 3-5 in the mode
string:

	val = 0;
	for (i = 3; i < 6; i++) {
		if (mstr[i] < '0' || mstr[i] > '7') {
			fprintf(stderr, _("%s: bad format string %s\n"),
				progname, mstr);
			exit(1);
		}
		val = val * 8 + mstr[i] - '0';
	}
	mode |= val;

so I think xfs_protofile should be masking more:

	perms = stat.S_IMODE(statbuf.st_mode) & 0o777

because otherwise we leak the sticky bit (S_ISVTX) into the protofile.

--D

>  	return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
>  			statbuf.st_gid)
> 2.49.0
> 
