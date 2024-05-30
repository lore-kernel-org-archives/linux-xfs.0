Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457B917545
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717109323; cv=none; b=ZWRczecAqq1tJZTSx0WIWbND1ZCp3+QxGt0Az5OBhrh4xyGkm+OmDEguwrqsL7Og0yam0AtxwlA7p7mTt5m4nZy4ty8zesNyXVj9ENSRxoqxc6+fWSEP4vnAFA85c2bconPzDKPDkCIOpp25crbAdQLQVxF4e0S5+znYYST2mEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717109323; c=relaxed/simple;
	bh=a0eQjS1u18BtvPOF8/PG1nh5v2ahfeRnLfJ6jowHwbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9ED9oNG5i43bzQhahhcaXIcZ1qK7lspuly2Wv7/AEiAo9wAxNsA21iCqypZkgmz2g42z9bAVMMErK3llGPsBM26RXRP9xxVnq8n0PqKdDT5Le68lFsvvfsVWWBEZMAQ7IHi0XSBRy+85m/H0N72ldyYYM2ULijl0Ybw0VVKm7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pe/s/K7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pe/s/K7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996A2C2BBFC;
	Thu, 30 May 2024 22:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717109322;
	bh=a0eQjS1u18BtvPOF8/PG1nh5v2ahfeRnLfJ6jowHwbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pe/s/K7x0uqY82uDwvGz9/+jgNgXOVQ1Tv4fdeVJDjJ+gx7VFWRnPJNghlpdx72g/
	 iucgbcXLlcMk1gyJXMCVAVpTNKAzqX+Rf3sHZawhRQ7yAAOMqeUjKfg32yRtGUgVJg
	 ClIAqqxwieoFWz/5hkW1+offnN/v2HUHJMn3tw/gKYKdIOACYTTQUhQggzoqv/jUd/
	 Pd66yuhJPvRowDfBiIILjwvjGHDw2PWWaCPnuLgmnzww1QnNdp6ZKTV8uywIGvSMDa
	 cnjc7bID/WtJoMzlreL4QRKinofu3tXDsYfo4BDIS/IqKCaRe9sL5dNQZ5f+VOGGmo
	 cP6/fTwXCYDBA==
Date: Thu, 30 May 2024 15:48:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@redhat.com
Subject: Re: [PATCH 2/2] xfs_io: Fix do not loop through uninitialized var
Message-ID: <20240530224842.GA52987@frogsfrogsfrogs>
References: <20240530223819.135697-1-preichl@redhat.com>
 <20240530223819.135697-3-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530223819.135697-3-preichl@redhat.com>

On Fri, May 31, 2024 at 12:38:19AM +0200, Pavel Reichl wrote:
> Red Hat's covscan checker found the following issue:
> 
> xfsprogs-6.4.0/io/parent.c:115:2: var_decl: Declaring variable "count" without initializer.
> xfsprogs-6.4.0/io/parent.c:134:2: uninit_use: Using uninitialized value "count".
> 
> Currently, jdm_parentpaths() returns EOPNOTSUPP and does not initialize
> the count variable. The count variable is subsequently used in a for
> loop, which leads to undefined behavior. Fix this by returning from the
> check_parents() function immediately after checking the return value of
> the jdm_parentpaths() function.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

I'm waiting on Carlos to take the xfsprogs 6.9 stuff so that I can
resend the new parent pointer code[1] for 6.10 which blows away the last
of the old SGI pptr code.

--D

[1] https://lore.kernel.org/linux-xfs/170405006341.1804688.11009892277015794783.stgit@frogsfrogsfrogs/

> ---
>  io/parent.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io/parent.c b/io/parent.c
> index 8f63607f..93f40997 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -112,7 +112,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
>  	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
>  {
>  	int error, i;
> -	__u32 count;
> +	__u32 count = 0;
>  	parent_t *entryp;
>  
>  	do {
> @@ -126,7 +126,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
>  			       (unsigned long long) statp->bs_ino,
>  				strerror(errno));
>  			err_status++;
> -			break;
> +			return;
>  		}
>  	} while (error == ERANGE);
>  
> -- 
> 2.45.1
> 
> 
