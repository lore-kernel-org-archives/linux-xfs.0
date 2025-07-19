Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12FD1DED53;
	Sat, 19 Jul 2025 05:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752902957; cv=none; b=GFKgkgUBN9+v9JzLCcnDmNEWTv1wAQPHLZJj3uScTL2ZUYvZWKpEn3d6l0KQuSh2Tjr32WvOy/S+LRqsK8xN8oA75iyGLhGSlDiiWMhbDkbLPRp946vdJcIcC2FUv32AjunKSuQhg6TKyc+n6pBCdXKNIbN92/rOC6zmWUTbqYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752902957; c=relaxed/simple;
	bh=3JLhHvIBA+ygrmNgy7eCI0/ImE+AQHhkHcblghy51uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXbxiaAdSRqGSOYc+n6d3Sj90LiDJZQwz1hdisyEusMdiKXKjJJ/J39IN23kijT3Wi99EF78FkBTQM5ceqE5vGoa7/rDWbxOn1vk2QVLbIBt9Sc4tp/HUcHksqqNUBd9cyQHQdCyk6hKXqXOwlBcb9qipWV8j+OcCJKuDgJ3XOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTAhshQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTAhshQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4782AC4CEE3;
	Sat, 19 Jul 2025 05:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752902957;
	bh=3JLhHvIBA+ygrmNgy7eCI0/ImE+AQHhkHcblghy51uk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aTAhshQnHwjgrS5AZ0+rTnlswtnzIyJ1GRsC9rMAvriu2p3z+s+/L/vsUkRL6Sw0N
	 vUl4wsRJEDuJ2eE1q/hR7vql1rEYjGv/3vXL3GCeBzsXtu7S7siNSDvqPur2qLCfVT
	 8GZUqPywvB4TfaDjf3DPxCGeCsJE9EczxoB0Rx0RqX3EemOJgo5xMDxH8D7S2ogV8n
	 7wA9oEDm7l411u35v3rYU2u7H8Y43SX2sBqbTY942H3z9hVEyTuPFJyj4gMTvTLqJq
	 tdnG0YtbGQytGVvZVaoMJQYa12frfUWgCdjs1mlruCsswgdVCJbiEqJ7K6RfLDt7V9
	 /gzeim1/FxrUw==
Date: Fri, 18 Jul 2025 22:29:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: or10n-cli <muhammad.ahmed.27@hotmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: scrub: remove unnecessary braces and fix
Message-ID: <20250719052916.GT2672049@frogsfrogsfrogs>
References: <DB6PR07MB3142A5C5EAF928BA7F71CA47BB53A@DB6PR07MB3142.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB6PR07MB3142A5C5EAF928BA7F71CA47BB53A@DB6PR07MB3142.eurprd07.prod.outlook.com>

On Sat, Jul 19, 2025 at 10:22:09AM +0500, or10n-cli wrote:
> From b8e455b79c84b4e1501ea554327672b6d391d35d Mon Sep 17 00:00:00 2001
> From: or10n-cli <muhammad.ahmed.27@hotmail.com>

WTF is "orion-cli" ?

> Date: Sat, 19 Jul 2025 10:10:42 +0500
> Subject: [PATCH] xfs: scrub: remove unnecessary braces and fix indentation
> in
>  findparent.c
> 
> This patch removes unnecessary braces around simple if-else blocks and
> fixes inconsistent indentation in fs/xfs/scrub/findparent.c to comply
> with kernel coding style guidelines.
> 
> All changes are verified using checkpatch.pl with no warnings or errors.
> 
> Signed-off-by: Muhammad Ahmed <muhammad.ahmed.27@hotmail.com>
> ---
>  fs/xfs/scrub/findparent.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
> index 84487072b6dd..9a2f25c7c2e3 100644
> --- a/fs/xfs/scrub/findparent.c
> +++ b/fs/xfs/scrub/findparent.c
> @@ -229,15 +229,12 @@ xrep_findparent_live_update(
>          */
>         if (p->ip->i_ino == sc->ip->i_ino &&
>             xchk_iscan_want_live_update(&pscan->iscan, p->dp->i_ino)) {
> -               if (p->delta > 0) {
> +               if (p->delta > 0)
>                         xrep_findparent_scan_found(pscan, p->dp->i_ino);
> -               } else {
> +               else
>                         xrep_findparent_scan_found(pscan, NULLFSINO);
> -               }
>         }
> -
>         return NOTIFY_DONE;
> -}

DID YOU EVEN COMPILE THIS???

--D

>  /*
>   * Set up a scan to find the parent of a directory.  The provided dirent
> hook
> @@ -386,7 +383,7 @@ xrep_findparent_confirm(
> 
>         /* Reject garbage parent inode numbers and self-referential parents.
> */
>         if (*parent_ino == NULLFSINO)
> -              return 0;
> +               return 0;
>         if (!xfs_verify_dir_ino(sc->mp, *parent_ino) ||
>             *parent_ino == sc->ip->i_ino) {
>                 *parent_ino = NULLFSINO;
> --
> 2.47.2
> 
