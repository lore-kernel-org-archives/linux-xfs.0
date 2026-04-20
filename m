Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8EE33F5AE
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700078; cv=none; b=uh2bik4Ka6GCIlove9ADNlUGfFn5SmHwLvJSG+wRQhDcWq6Bz46n/qKGvz+9nv5jfCmGHN6pkks2VT6Wjt3SYQzbCW1nHqt2iPNQa7za2QHi9OErxmhxBgX5e/6xKWzDE8rquq4JtOyM4AY+FZ3ZdAdTDzrgX/3aMgkXoIoDeKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700078; c=relaxed/simple;
	bh=gHtEVz+Lx2ARgiZ5Yoi6T9zIhdvxv2pGbZzn+hsfNHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcfL1W9tooPAaY0Ps5QoLQHjKy3wxU30hoceKxsInHv1m0P918T4uF7H2xp6258ovt+2uzjoOR0+j83rfa9rMyUzgFKhFMfdNcINAevA7FXauDLrqMpZVwyrHSHm7oqpQ6wzYaFS4cT0p5hbfksgzR72BCHjwXHdgEdwxndsgro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8wba88j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8wba88j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD0CC19425;
	Mon, 20 Apr 2026 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776700078;
	bh=gHtEVz+Lx2ARgiZ5Yoi6T9zIhdvxv2pGbZzn+hsfNHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K8wba88jj5DHWqvZKN9HwzR6z7+jU71qhcod2wK2E4+wDdWfFeWmeLvtte0TmfrMS
	 h6ke/sdmCuxRWpDoMFERNQMIEcyF7tfn/v17Y/B532AnkC/yKGirY8NRy2u2OGMvyl
	 KM9XYdv+55eeD3S72SEpA4VKMfvPLcTFwHZdHbs1IkFTyOR9EgRa9V2etZm8gh+PKj
	 p0QwaguFKlxESbqdaSN92LOqnILAeu42Ymq62aDSirt/ECU+L4pJT/8HbsqBiNW4ka
	 kxo0QJWNBA9LQkKo5naKun9dCSrR017U7tpuaY5Sy1GqcxQB6tR1rGVHNXdPgPTPEM
	 xE4Kvw4oTbOXw==
Message-ID: <41e7ced6-90c0-423a-9a90-4bfa263bdb31@kernel.org>
Date: Mon, 20 Apr 2026 17:47:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] xfs: expose the current zonegc required status in
 sysfs
To: Niklas Cassel <cassel@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-xfs@vger.kernel.org
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-6-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260420135011.624587-6-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/20 15:50, Niklas Cassel wrote:
> The current zonegc required status is currently available in
> /proc/<pid>/mountstats (which contains stats for all mounted zoned XFS
> filesystems), under "RT GC required:".
> 
> Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/zonegc_required for the same.
> This makes it trivial for monitoring software to read the value, for a
> specific filesystem, without any complex parsing.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

As is, I think this is OK, but I wonder if we should not instead call the
attribute zonegc_running and use xfs_is_zonegc_running() to test the
XFS_OPSTATE_ZONEGC_RUNNING flag for the attribute value ?

The reasoning here is that the GC thread also does zone reset for zones with all
blocks invalidated, and in such case we may start the GC thread even when
xfs_zoned_need_gc() is false.

And I think it is more interesting to see if the GC thread is running, so doing IOs.

Thoughts ?

> ---
>  Documentation/admin-guide/xfs.rst |  4 ++++
>  fs/xfs/xfs_sysfs.c                | 11 +++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index be0d3f5e8b4c4..87ead41aa86c4 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -565,3 +565,7 @@ For zoned file systems, the following attributes are exposed in:
>  	bursts at the cost of increased write amplification.  Regardless
>  	of this value, garbage collection will always aim to free a minimum
>  	amount of blocks to keep max_open_zones open for data placement purposes.
> +
> +  zonegc_required		(Min:  0  Default:  Varies  Max:  1)
> +	This read-only attribute exposes if GC is currently required by the file
> +	system.
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 312bae4cf70fd..1e1ee020df001 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -777,11 +777,22 @@ zonegc_low_space_show(
>  }
>  XFS_SYSFS_ATTR_RW(zonegc_low_space);
>  
> +static ssize_t
> +zonegc_required_show(
> +	struct kobject		*kobj,
> +	char			*buf)
> +{
> +	return sysfs_emit(buf, "%d\n",
> +			xfs_zoned_need_gc(zoned_to_mp(kobj)));
> +}
> +XFS_SYSFS_ATTR_RO(zonegc_required);
> +
>  static struct attribute *xfs_zoned_attrs[] = {
>  	ATTR_LIST(max_open_zones),
>  	ATTR_LIST(nr_free_zones),
>  	ATTR_LIST(nr_open_zones),
>  	ATTR_LIST(zonegc_low_space),
> +	ATTR_LIST(zonegc_required),
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(xfs_zoned);


-- 
Damien Le Moal
Western Digital Research
