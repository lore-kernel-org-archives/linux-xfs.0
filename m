Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A64232368
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866731; cv=none; b=X5NqAwjGi1W5Mdr67OXgCvmnxLlHq3ip8ThuGRBbbbLJAg4EG8EbHntTI9l0yD9cjxAameI7pv+IU441qeNMcfluScY3sJo0z2hp8BOQBLu6fJGkr2O9BA2Db7JjTpI8JjLDn3qhExSUDaj9AM3X1FIiPJneKUpOipDm7xXkakk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866731; c=relaxed/simple;
	bh=7/DX8HN3rWf4QRwYNksfMwFMCU5cDeW7CkFS9cPAnKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mi4SbeqhI/DfGFDMc70LO2c7+alSn1EDTppCP+DUKDwrSnKs8OTpbQzc7tBNlXXfILqUwlXSf3RL1NilsxGnYzfThFuTgQEqorjB3bcMFl+dqfB4hXez2+AomTeWfF9jw4u5v6Rzi/QfSh+2WY6f8+hJO97/jR3xmAXlFiAbviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwA0OUWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwA0OUWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880BFC4CEE4;
	Tue, 18 Feb 2025 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739866730;
	bh=7/DX8HN3rWf4QRwYNksfMwFMCU5cDeW7CkFS9cPAnKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lwA0OUWkMtJVqu8CI8bTqwrz6DZ8hZBtqR7eRsrlZKfSwJFe5e3klJ/37gdGKXnxB
	 iH5qsFj4N7zg6adwpVpnvU4vbBwBO5YExtoawr+ToPZHmLJMss3F8IWKxSC6VNGqFg
	 gtFi4By35JzQRc3bP/0bNsFmB64t451EvNu2VUUtndEmpEVcdU2GLRVOuFkFyj09h2
	 YYvWivPu4bwBFdjWuhAGilIsjYr+ZICmVsM/tx75Q2Ubv1d8mR7FV2Myd2CHX69x1u
	 1Epj5PDvZfp9AAxIYyBlbTSU+XzAMKgIYVZUK2vPg5kXscGRtcT17EaPCU9SplbKLs
	 102t1tYX7GiiQ==
Date: Tue, 18 Feb 2025 09:18:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: Fix mismatched return type of filesize()
Message-ID: <xtoocdorovfnttkgtuq6qkzaazqtszlnaa6voiphh6ofnri2w6@agad5vuhxtmx>
References: <-uT7HOcTG_xe8v8U0_5OQg6ll9vJyYEFQeSs_2FwUHujx116vYRcX2iovzoJvkN8K9zDDmQxQWB6H1CDLiOVdw==@protonmail.internalid>
 <20250217155043.78452-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217155043.78452-1-preichl@redhat.com>

On Mon, Feb 17, 2025 at 04:50:43PM +0100, Pavel Reichl wrote:
> The function filesize() was declared with a return type of 'long' but
> defined with 'off_t'. This mismatch caused build issues due to type
> incompatibility.
> 
> This commit updates the declaration to match the definition, ensuring
> consistency and preventing potential compilation errors.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good, perhaps add:

Fixes: 73fb78e5ee8 ("mkfs: support copying in large or sparse files")

?

Otherwise,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  mkfs/proto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 6dd3a200..981f5b11 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
>  static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
>  static int newregfile(char **pp, char **fname);
>  static void rtinit(xfs_mount_t *mp);
> -static long filesize(int fd);
> +static off_t filesize(int fd);
>  static int slashes_are_spaces;
> 
>  /*
> --
> 2.48.1
> 
> 
