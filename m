Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2C79F5
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 05:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066669; cv=none; b=XBiGgGcck39T1Ilk+qh2EqnBUsgrmS2QFb7ZgsG/5RmG6Ehc3XC9aeLPGzvG9PK81FKrO+UYTabShUTyrhm7vs5KW601ZbwZ9ZOv3AUV8d26aB/JZOAEO1c87T/c8cSy4RTobCjjHa/+t0IlRIvdyyVAAlF0d7oXfPjjr0ostJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066669; c=relaxed/simple;
	bh=jh+nyUQcCO2ZhTqIMZJj0WXQ+/RpbMx7lTunBab+yZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TMlosiNoYGy8JQp3zpsNmsuPeu3FJFtDfg7g6n3HQpkYxB5K6KDqTLAH22f9S12APpt+bEj7S1El395hq3hstKD8+KUHoZbieMZwFZqk+SFaCBz1C54kSTPS1SF2QrZho0oS7Yw0ECBhpVHVwLQLVferStwbN+VF7OFWoJ86Vv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvRlkeRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvRlkeRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64B1C4CEE5;
	Tue,  4 Mar 2025 05:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741066668;
	bh=jh+nyUQcCO2ZhTqIMZJj0WXQ+/RpbMx7lTunBab+yZQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jvRlkeRjkXE2ivOVtxypHOW9nA2vpxbi+0FFBCTbG0oWR4OMlz0so1dxKFAnV2lGT
	 4IB2MFmLocMBf7zP2fN1YOng1dNosaAWYqDC4y0WJRv8fMH+aDDFGNP2v8XC/dIIRv
	 vd2PhNKBneuISpoYYkQL6cieJt6hHeEeHc36XGn5CeGliElEi6bvsvi5Ka5QTyxIbf
	 eQ+pU90rpNx+d57CcbeKidBsst5eRm310ZtO5GQjLWUEwN7yaVopg6nzmTtaUnxUZI
	 IkfDouefNkP4oDgs5zKmeQRmZ6FuiU6/chW9M1HUrZBmASzRyjHxPcYRglWZ6dZIdJ
	 2+BQ5rGWLsslA==
Message-ID: <b6055154-4d72-4e8a-a6c0-21e01e68329d@kernel.org>
Date: Tue, 4 Mar 2025 14:37:46 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: support for zoned devices v4
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20250226185723.518867-1-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/27/25 03:56, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds support for zoned devices:
> 
>     https://zonedstorage.io/docs/introduction/zoned-storage
> 
> to XFS. It has been developed for and tested on both SMR hard drives,
> which are the oldest and most common class of zoned devices:
> 
>    https://zonedstorage.io/docs/introduction/smr
> 
> and ZNS SSDs:
> 
>    https://zonedstorage.io/docs/introduction/zns
> 
> It has not been tested with zoned UFS devices, as their current capacity
> points and performance characteristics aren't too interesting for XFS
> use cases (but never say never).
> 
> Sequential write only zones are only supported for data using a new
> allocator for the RT device, which maps each zone to a rtgroup which
> is written sequentially.  All metadata and (for now) the log require
> using randomly writable space. This means a realtime device is required
> to support zoned storage, but for the common case of SMR hard drives
> that contain random writable zones and sequential write required zones
> on the same block device, the concept of an internal RT device is added
> which means using XFS on a SMR HDD is as simple as:
> 
> $ mkfs.xfs /dev/sda
> $ mount /dev/sda /mnt
> 
> When using NVMe ZNS SSDs that do not support conventional zones, the
> traditional multi-device RT configuration is required.  E.g. for an
> SSD with a conventional namespace 1 and a zoned namespace 2:
> 
> $ mkfs.xfs /dev/nvme0n1 -o rtdev=/dev/nvme0n2
> $ mount -o rtdev=/dev/nvme0n2 /dev/nvme0n1 /mnt
> 
> The zoned allocator can also be used on conventional block devices, or
> on conventional zones (e.g. when using an SMR HDD as the external RT
> device).  For example using zoned XFS on normal SSDs shows very nice
> performance advantages and write amplification reduction for intelligent
> workloads like RocksDB.
> 
> Some work is still in progress or planned, but should not affect the
> integration with the rest of XFS or the on-disk format:
> 
>  - support for quotas
>  - support for reflinks - the I/O path already supports them, but
>    garbage collection currently isn't refcount aware and would unshare
>    them, rendering the feature useless
>  - more scalable garbage collection victim selection
>  - various improvements to hint based data placement
> 
> To make testing easier a git tree is provided that has the required
> iomap changes that we merged through the VFS tree, this code and a
> few misc patches that make VM testing easier:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-zoned
> 
> The matching xfsprogs is available here:
> 
>     git://git.infradead.org/users/hch/xfsprogs.git xfs-zoned

I ran this several times doing short runs and a long run over the weekend on a
30TB SMR HDD, doing random sized buffered writes, read and readwrite IOs to
randomly sized files.

Working great for me. So:

Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
