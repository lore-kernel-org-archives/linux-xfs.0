Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13E3202F7B;
	Tue, 22 Apr 2025 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745323828; cv=none; b=NvqWqVhnxgrem5uMKrrC8QzbONRVgcw/v9kQyYXeXVlfsFOLaJtkcxqVdzBp1rT1pz+OA7u/E9dl2FYh8rHu2ufFs0dW31/Y2xgF7IKF2nb4DbtOlIEx+Wrb6z5Gxf0Oqe4YFGNkAnQZBnB0bmlVsnTeBJmf0CLdkMzRTHx0gaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745323828; c=relaxed/simple;
	bh=gn8U39yE8fPjRVht2QyZ2B6L1GURwrgsQ9paV7eDdQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDFAecRMsnvOLd3JUmFUP+sCp8D1ej+JNUZWtZGJI2qx4qLW13d1phVb9hfmgnR1uh8VTnTuuPMqCxS3vVe9dd20HHX7q7kGAnQyBz1ma+9urwdrbrEstcqLQQ+1Mo4PSA0+8Hv0YPeN1E10mlRlJAsGD2ygFnjyvsfx9K66eiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZT4Cge2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZT4Cge2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B8BC4CEE9;
	Tue, 22 Apr 2025 12:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745323827;
	bh=gn8U39yE8fPjRVht2QyZ2B6L1GURwrgsQ9paV7eDdQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aZT4Cge28FVq4lBf7Vgmk87GoOawUeOjQcs2I4YLEAoiTJX6hMegOF4kqJg93zQlF
	 oFDhbX8eCzap/igxTecFcGgXle9spH1gIhecrCrWSRcVsXNakaAmYIdu49NX4d305+
	 Ce8RTw0gEkRa4E/e9YOva7T83TIYDK8kCtJwH2bM/pacs5TN4Nwq7HJ9fK9SMkV2Qs
	 1xuwQEnHC4KxDU0hcm9OfNEow3XPgvYFzZIRfumYlTQJZvl9y/n5zp0w3DgRSu/6qN
	 BK7uQKVQfeGOIdpzdIFDdd1Vj+qmIblzYRIu457YI10Ae403Cjshhm9Qs18HK8V9SA
	 yEStyec9WPZ5w==
Date: Tue, 22 Apr 2025 14:10:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, 
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Message-ID: <dhowchhm6zfb3hir76tmbmunadqobbkmgaa5uardswon2keggy@3bgfjikvj5sf>
References: <_RxmFF7sLGc26Wr0UDPdK5Mxv9AicUnbJ2I5Cji6QZiiHz5pr9uYx7Zk8xOeDutTUsJvS143LlYYxoitgsEEGA==@protonmail.internalid>
 <20250422114854.14297-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422114854.14297-1-hans.holmberg@wdc.com>

On Tue, Apr 22, 2025 at 11:50:07AM +0000, Hans Holmberg wrote:
> Remove the duplicated section and while at it, turn spaces into tabs.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Sounds good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Hans, I'm adding a Fixes tag before merging if you don't mind me editing the
patch before applying.

Fixes: c7b67ddc3c9 ("xfs: document zoned rt specifics in admin-guide")


> ---
> 
> This fixes up the warning reported by Stephen Rothwell for linux-next
> 
>  Documentation/admin-guide/xfs.rst | 29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 3e76276bd488..5becb441c3cb 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -562,7 +562,7 @@ The interesting knobs for XFS workqueues are as follows:
>  Zoned Filesystems
>  =================
> 
> -For zoned file systems, the following attribute is exposed in:
> +For zoned file systems, the following attributes are exposed in:
> 
>    /sys/fs/xfs/<dev>/zoned/
> 
> @@ -572,23 +572,10 @@ For zoned file systems, the following attribute is exposed in:
>  	is limited by the capabilities of the backing zoned device, file system
>  	size and the max_open_zones mount option.
> 
> -Zoned Filesystems
> -=================
> -
> -For zoned file systems, the following attributes are exposed in:
> -
> - /sys/fs/xfs/<dev>/zoned/
> -
> - max_open_zones                 (Min:  1  Default:  Varies  Max:  UINTMAX)
> -        This read-only attribute exposes the maximum number of open zones
> -        available for data placement. The value is determined at mount time and
> -        is limited by the capabilities of the backing zoned device, file system
> -        size and the max_open_zones mount option.
> -
> - zonegc_low_space               (Min:  0  Default:  0  Max:  100)
> -        Define a percentage for how much of the unused space that GC should keep
> -        available for writing. A high value will reclaim more of the space
> -        occupied by unused blocks, creating a larger buffer against write
> -        bursts at the cost of increased write amplification.  Regardless
> -        of this value, garbage collection will always aim to free a minimum
> -        amount of blocks to keep max_open_zones open for data placement purposes.
> +  zonegc_low_space		(Min:  0  Default:  0  Max:  100)
> +	Define a percentage for how much of the unused space that GC should keep
> +	available for writing. A high value will reclaim more of the space
> +	occupied by unused blocks, creating a larger buffer against write
> +	bursts at the cost of increased write amplification.  Regardless
> +	of this value, garbage collection will always aim to free a minimum
> +	amount of blocks to keep max_open_zones open for data placement purposes.
> --
> 2.34.1
