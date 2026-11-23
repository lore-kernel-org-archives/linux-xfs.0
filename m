Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458570;
	b=h9ursOij24rW65IDYBs/x0T7NFfjw2mA5GqTbQlGbmcYaOuwe+/UuBPFiaPrIAbV3Ml2
	 KDZeODjC7yL4g4XiovqG+7ej1j+0x2sM+V/HUHDYzATKddbQIOCJiwS9n7Djex3zaY/6z
	 NrtpfVaDgmD24vyWoM7Qy48iLCa1rA5mH9neueONlS7hCCIu0/tzMwf/hiuAvVbTIKZv/
	 y+YVgdE7bBmjBk6QjoPP6FzksEToiN43Ji6Jcf0HW5gyT3hhTvFaqA23MO0yq/JA7IBdH
	 fxAeo/U5fI7r+Aw4vYyLKI4LcPlCbxfwsOE8+3KLug/KmQYzTxnMNMLUQW8wn8dZLvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458570;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=9FVwijSS/u13QVeqTyKKb8D3NxGid/P0YoVWsdCD+gc=;
	b=JPj/bxoyYxREc8Mw9wOc5AXaBeWEcSdp09XdOBMLD4Lb5pXIDj4sax0zBtZmvBVLHv9B
	 08qQnqfElFtgOI+FJTxLO9YZpqI6h0LHwsRgPKKaaXwTOvs+1kjTVFBbEY3phEPBz4hU2
	 kpR6yVkBdH46wfu+V6Xi+nOZxGPyfU04MvfgIchm8NNrWfTHo5924Eup6oRqmxj1CSHa2
	 LWs+ZLoFitIDXMxNerHuRgxq+qbiFzkOf0xfFGGId+HfVA94yb9bP+40Mryq27F6dJzdz
	 eStDDtHkitDfD/dNcB1xCnt8gcR2HULAYAHoHAfdv3vDShjJ4gGP0k4WD5Wn6QNMBNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NDD4CU9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045A8606A321;
	Mon, 23 Nov 2026 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NDD4CU9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055991F000D4;
	Mon, 23 Nov 2026 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795458569;
	bh=9FVwijSS/u13QVeqTyKKb8D3NxGid/P0YoVWsdCD+gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NDD4CU9tZCHQTX1HQBApcgQ+eam+hqAHxUI9qI/9mGXglS7mQT1hKWvGrgug09ScD
	 6KL3xrvKyyoGdTDVm0TKXPRaqDvVSTAuLii8Xnb50ADdtPYwSLomTKW5O4R7MopqL0
	 hmoTytl71lpc6l4gpm6Udlh0Tv9JFWAjkk48xUmadw7zpqzTtcVD3l8jcVVjK6ITTo
	 CzytHyWLoy7SOqes2pqIXH9Ez/2RWKJv6WBKZ7W4zcQwcA7V4i+nOYlWaJOOPAmQmw
	 QD5Hw+VQlqxQGa4ZCt4fKCmqu2r2/Hmep3LNmY/DpjJXTcHWED+vFqzaIiV25VoP8f
	 i/GQv0ik7KxAw==
Date: Tue, 24 Nov 2026 02:29:20 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 06/21] fstests: add _require_unique_f_fsid() helper
Message-ID: <awSDxwVociDn6649@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <523304ad35666548443b910955ae7d3a1669ae5a.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523304ad35666548443b910955ae7d3a1669ae5a.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:32PM +0800, Anand Jain wrote:
> Add a helper to check if the target filesystem supports unique f_fsid
> tracking across cloned or snapshot instances.
> 
> Certain filesystems like XFS, Btrfs, and F2FS ensure unique f_fsid
> identifiers per filesystem instance. However, Ext4 derives its f_fsid
> directly from its superblock UUID, which leads to identical f_fsid
> values on cloned images until the UUID is manually modified by userspace.
> 
> Introduce _require_unique_f_fsid() to allow test cases requiring strict
> f_fsid uniqueness to skip gracefully on unsupported filesystems.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 0fcc1a614ad1..37b32b498c80 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -6417,6 +6417,33 @@ _require_fanotify_ioerrors()
>  	_notrun "$FSTYP does not support fanotify ioerrors"
>  }
>  
> +# Skip the test if the filesystem does not enforce unique f_fsids
> +# natively. Checking this dynamically requires recreating a clone
> +# layout, so we use a static lookup based on FSTYP.
> +#
> +# Across all filesystems, a UUID collision causes libblkid tools to return
> +# non-deterministic device mappings. It is ultimately the responsibility
> +# of the userspace utility or use-case to enforce uniqueness when a clone
> +# diverges. For details, see mailing list thread discussions:
> +#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
> +_require_unique_f_fsid()
> +{
> +	case "$FSTYP" in
> +	ext*)
> +		# Ext4 derives f_fsid from the superblock UUID, meaning
> +		# clones share the same f_fsid until their UUIDs
> +		# diverge.
> +		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
> +		;;
> +	*)
> +		# Conversely, XFS, Btrfs, and F2FS ensure f_fsid remains
> +		# unique per filesystem instance (often by deriving it
> +		# from the UUID and underlying block device.)
> +		;;
> +	esac
> +}
> +
> +
>  # Computes a percentage of the available space in a filesystem and
>  # returns that quantity in MB. The percentage must not contain a percent
>  # sign ("%").
> -- 
> 2.43.0
> 
