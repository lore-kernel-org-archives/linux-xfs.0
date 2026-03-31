Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE3937AA9E
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774949734; cv=none; b=OpW/KK8FFLZclTpJGoYl2JBPcoJcVBr2Q4GRwu7ZOOsxFZ/R1SYOImmhEwBd07cyyt0sZDcrViZlOKqRLtxEpOeaGcz0xpacnCf0drINxPFVZf9PZORaISQP2wQbsG0pF8MXn8KsTKB/L2SfGB2eV0TbBzR+bLDPCSD4uaIvelo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774949734; c=relaxed/simple;
	bh=jC+nY9VOqqdiNneLeFhyYVJq/Sqjnm51qnl1iR/ikiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TJ6pmyiOc9F4/qa6e57X7BWUcvVgJpxnAQ50v/G/z9W4ao9A5FxPcFACsarcu6AapJLpXjiYhkKpeBWXs4NmWYdDi6SdHiNnIOy9QVTWNx6houTyuMgddxPhZAuqiKIMprQpg/KRoMUkSbshJxRF4Qlsk/dfYzl/UE6VHvxf+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0oECxxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0oECxxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B3FC2BCB0;
	Tue, 31 Mar 2026 09:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949734;
	bh=jC+nY9VOqqdiNneLeFhyYVJq/Sqjnm51qnl1iR/ikiY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T0oECxxdaa5Hq9OdCNabhLV0Z0F8nBK7lkIKsV0q0uT2Zk9KPHdnlNF3fu2pDDvQy
	 Qn6KYo1MtBWS/bRtSaYNl2eCWM7hN65sIKCLghddCK1zAyIwhgrduC9xVtKaywhio0
	 /jzDUVWlTmsRfxsjYi143tKaAtM0kqmGeqBhZGWQHrrWISTKLvraTHH1kGFaviACyB
	 mc8fmiJAcM+NfMXSXojEaDYi4kTDtIEqZlPCiwKDGKtEHkzHYMRmYqo0Ln8rpdgJbY
	 zVkA9lE7EXJ4ZosMF5p0NhdU5NMTATnI2vDryKwaf63NMcyqfpN7OLA8IDPeIujmJo
	 WHnnGq33E0piQ==
Message-ID: <c2d53f91-f0dc-4d11-b11b-28a9a2a48e4d@kernel.org>
Date: Tue, 31 Mar 2026 18:35:31 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] xfs: expose the number of open zones in sysfs
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054111.3855818-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:40, Christoph Hellwig wrote:
> Add a sysfs attribute for the current number of open zones so that it
> can be trivially read from userspace in monitoring or testing software.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/admin-guide/xfs.rst |  4 ++++
>  fs/xfs/xfs_sysfs.c                | 13 +++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 746ea60eed3f..eb3085421276 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -550,6 +550,10 @@ For zoned file systems, the following attributes are exposed in:
>  	is limited by the capabilities of the backing zoned device, file system
>  	size and the max_open_zones mount option.
>  
> +  nr_open_zones			(Min:  1  Default:  Varies  Max:  UINTMAX)
> +	This read-only attribute exposes the current number of open zones
> +	used by the file system.
> +
>    zonegc_low_space		(Min:  0  Default:  0  Max:  100)
>  	Define a percentage for how much of the unused space that GC should keep
>  	available for writing. A high value will reclaim more of the space
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 6c7909838234..43a02c622b6d 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -13,6 +13,7 @@
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_mount.h"
> +#include "xfs_zone_priv.h"
>  #include "xfs_zones.h"
>  
>  struct xfs_sysfs_attr {
> @@ -718,6 +719,17 @@ max_open_zones_show(
>  }
>  XFS_SYSFS_ATTR_RO(max_open_zones);
>  
> +static ssize_t
> +nr_open_zones_show(
> +	struct kobject		*kobj,
> +	char			*buf)
> +{
> +	struct xfs_zone_info	*zi = zoned_to_mp(kobj)->m_zone_info;
> +
> +	return sysfs_emit(buf, "%u\n", zi->zi_nr_open_zones);

Since this is not an atomic, don't we need to copy this field into a local
variable under spin_lock(&zi->zi_open_zones_lock) ?


> +}
> +XFS_SYSFS_ATTR_RO(nr_open_zones);
> +
>  static ssize_t
>  zonegc_low_space_store(
>  	struct kobject		*kobj,
> @@ -751,6 +763,7 @@ XFS_SYSFS_ATTR_RW(zonegc_low_space);
>  
>  static struct attribute *xfs_zoned_attrs[] = {
>  	ATTR_LIST(max_open_zones),
> +	ATTR_LIST(nr_open_zones),
>  	ATTR_LIST(zonegc_low_space),
>  	NULL,
>  };


-- 
Damien Le Moal
Western Digital Research
