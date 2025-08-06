Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114BF3595C
	for <linux-xfs@vger.kernel.org>; Wed,  6 Aug 2025 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754466423; cv=none; b=FQYsuundJcvjEdKZ2MjZcINqXdajDuT4Sg/wJmDP+uXbyeTofXbeMLuE7WElnbOQB4E3wcrNJvdV8fAooM4OiHqDXyQ4LRkuEXXOf39a8JoLbcEgr0+Y1WgbxjyICSpxjKtdaJwBGXjr92r6pg+bqdkUZfUNTBNMReLJNleEdgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754466423; c=relaxed/simple;
	bh=8kawdRBdsXz3+3xizYpEeVNx3nD7+1oJzB4k5IIgGDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Llj1N70FN8rZ7iA0iZUIxzlZsV03nclyAX2mJAqg6KqldC8Di+gx3kr7vKoLhArJYDYmC6QQPKoNb2/+4wOwwEcwwBHja3zFG4zUe76wwX2Ir5ux/ZM08MBEGqjRXudNIEv551mJoQejQcFvhah2fM0oOu0yiO8CZLuGNXbEtTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HN0gDh8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HN0gDh8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89287C4CEF6;
	Wed,  6 Aug 2025 07:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754466422;
	bh=8kawdRBdsXz3+3xizYpEeVNx3nD7+1oJzB4k5IIgGDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HN0gDh8khvV6HkC8Gt8uWycEvkxxFlP+JMaGqsKYDeABGtaioxWsgdwWSF8dHIkPB
	 Hn2H54IBEm64HGMY1VWbDpM2JdqvDSzesKM2ZGdjmktsKEQW+YUD6lVVipsqh/ImFv
	 F2RRDPP86e9JiK3YfnV5zJrZ/nhcTiYO/uzZiBscTD+ydMa1542pcgs38lay2gR2gz
	 RaLOxzbcMdnqQ6Uhc7NQKDLMRS8dBXDxPxVbbz++Z9RKGuS90wejgqX4EY37mk2mQV
	 hj92OQFqcQvNY7Q6B6VdBac2vPEEWAXT0kZtbFcU4CnFj88nXVIU/hmijqMgicrrHC
	 2e8acPKDyTJMg==
Date: Wed, 6 Aug 2025 09:46:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
Message-ID: <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806043449.728373-1-dlemoal@kernel.org>

On Wed, Aug 06, 2025 at 01:34:49PM +0900, Damien Le Moal wrote:
> Enabling XFS realtime subvolume (XFS_RT) is mandatory to support zoned
> block devices. If CONFIG_BLK_DEV_ZONED is enabled, automatically select
> CONFIG_XFS_RT to allow users to format zoned block devices using XFS.
> 
> Also improve the description of the XFS_RT configuration option to
> document that it is reuired for zoned block devices.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/Kconfig | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index ae0ca6858496..c77118e96b82 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -5,6 +5,7 @@ config XFS_FS
>  	select EXPORTFS
>  	select CRC32
>  	select FS_IOMAP
> +	select XFS_RT if BLK_DEV_ZONED

This looks weird to me.
Obligating users to enable an optional feature in xfs if their
kernel are configured with a specific block dev feature doesn't
sound the right thing to do.
What if the user doesn't want to use XFS RT devices even though
BLK_DEV_ZONED is enabled, for whatever other purpose?

Forcing enabling a filesystem configuration because a specific block
feature is enabled doesn't sound the right thing to do IMHO.

>  	help
>  	  XFS is a high performance journaling filesystem which originated
>  	  on the SGI IRIX platform.  It is completely multi-threaded, can
> @@ -116,6 +117,15 @@ config XFS_RT
>  	  from all other requests, and this can be done quite transparently
>  	  to applications via the inherit-realtime directory inode flag.
> 
> +	  This option is mandatory to support zoned block devices.

What if a user wants to use another filesystem for ZBDs instead of XFS, but
still want to have XFS enabled? I haven't followed ZBD work too close,
but looking at zonedstorage.io, I see that at least btrfs also supports
zoned storage.
So, what if somebody wants to have btrfs enabled to use zoned storage,
but also provides xfs without RT support?

Again, I don't think forcefully enabling XFS_RT is the right thing to
do.

> For these
> +	  devices, the realtime subvolume must be backed by a zoned block
> +	  device and a regular block device used as the main device (for
> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
> +	  containing conventional zones at the beginning of its address space,
> +	  XFS will use the disk conventional zones as the main device and the
> +	  remaining sequential write required zones as the backing storage for
> +	  the realtime subvolume.
> +
>  	  See the xfs man page in section 5 for additional information.

		Does it? Only section I see mentions of zoned storage is
		the mkfs man page. Am I missing something?

Carlos

> 
>  	  If unsure, say N.
> --
> 2.50.1
> 
