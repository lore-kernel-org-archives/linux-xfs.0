Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D4A10F2
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 00:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765325253; cv=none; b=ap3iKA6skbR/JYcZRFHoPWJNKi18UxtuWta+WT/fHYlbJTGP9W/Z/r3BnMhqUOXXlhIf/+wDMA+SYrbNfREOZZY5TqHgHBVdlOhP+oxvLVR77Q2dU5lmjGXpTua/Sw5dWayRlMNQ4OpZpj7MtW4XYb8hRFu0N3auavdQmAreZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765325253; c=relaxed/simple;
	bh=dm6yXBWvFXlSED+jK8vxc0tM7Ga9cU+Ln2n7iLCGfKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnqfHTgK8XoQY3bfCzJNtq9J0E4UWKdfSuVnZvaetR03YYch8TgcmqIughMGtkXVBRW/ffdXJTKESW8y/P1K9wr1z+spjVxnWDhs6a3GCNpG394KG6gRWL9fhIrUks8z++/5C2R+ABGqQftTHcLV/0KulEN5N9XzU5s3oNVLkok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ot43YjBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot43YjBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1BAC4CEF5;
	Wed, 10 Dec 2025 00:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765325252;
	bh=dm6yXBWvFXlSED+jK8vxc0tM7Ga9cU+Ln2n7iLCGfKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ot43YjBKFNzb+YD2lsgRg+tOyMMFJM76ph+/7wLgKd8+ON8cLElU683KdcZZTY39G
	 7FQUTJ6OUlvXSzxLsdF87QeSM1LjdC7AcXB2Wj50CgLibiralQsWFXhtqUjF0eF+Gs
	 ZXfXjP0q+WP6JK2YgUYM39aP/R9sc7RfB1NSlODg/0ZGrHz4FTtaGtw/mlFE0BoSQl
	 8LnYA1Zlu1QFJgy/TMhWVxwScGIayfCdQppQVGw9y/PX7HC/sRqnY3r+Qu41iZluLo
	 zZVhB9Jhj+jf95XGOjBCoWzIViP7wIbPj9yhLYqRBEIqA33/dmxc4TJ7oTLnABxA4h
	 4vbeWmLc+xwlQ==
Date: Tue, 9 Dec 2025 16:07:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org, aalbersh@redhat.com
Subject: Re: [PATCH v2 1/1] mdrestore: fix restore_v2() superblock length
 check
Message-ID: <20251210000732.GL89492@frogsfrogsfrogs>
References: <20251209225852.1536714-1-preichl@redhat.com>
 <20251209225852.1536714-2-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209225852.1536714-2-preichl@redhat.com>

On Tue, Dec 09, 2025 at 11:58:52PM +0100, Pavel Reichl wrote:
> On big-endian architectures (e.g. s390x), restoring a filesystem from a
> v2 metadump fails with "Invalid superblock disk address/length". This is
> caused by restore_v2() treating a superblock extent length of 1 as an
> error, even though a length of 1 is expected because the superblock fits
> within a 512-byte sector.
> 
> On little-endian systems, the same raw extent length bytes that represent
> a value of 1 on big-endian are misinterpreted as 16777216 due to byte
> ordering, so the faulty check never triggers there and the bug is hidden.
> 
> Fix the issue by using an endian-correct comparison of xme_len so that
> the superblock extent length is validated properly and consistently on
> all architectures.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index f10c4bef..b6e8a619 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -437,7 +437,7 @@ restore_v2(
>  	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  
> -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> +	if (xme.xme_addr != 0 || be32_to_cpu(xme.xme_len) != 1 ||
>  	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
>  			XME_ADDR_DATA_DEVICE)
>  		fatal("Invalid superblock disk address/length\n");
> -- 
> 2.52.0
> 
