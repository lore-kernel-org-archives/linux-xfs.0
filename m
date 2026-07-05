Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709F225413;
	Sun,  5 Jul 2026 03:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783221747; cv=none; b=WdDLKzYWBpfzbiHZJl2vso48kfFwRXITqAR3Eim6bFRhIn5pxkk8+Lt6ulks2FNhhnZ4xw+wSjkaEnZml3pco1kdJq5ZOlPAT0h7fVdYtzaHkuDMDn0RqaFUcYyOBq6uSh6JTaK0wxe+8oBZ7ajeZf6NEU/IBlGuHHMozaiQOog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783221747; c=relaxed/simple;
	bh=fClVKrIyEKvZiIs6HhvgBEBvtUL5AMhzmARtY7M7wd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qP+WFtOQMxsa4FYdmMdiG4ERvPabzAtOPzK8GORmOFXpAXle3AQK/BETRlaIUjXiUdRQDhSEhWz+YbiBJNU7M8P+rsbXXPeCNxq5tjcyw2sxOnJ+IPA0tO7KXMBbLvpkR6J52uyUxNuimltwVLY9ndekqoY9pSGjZIdLcsJzCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPPsmmmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPPsmmmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078311F000E9;
	Sun,  5 Jul 2026 03:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783221745;
	bh=NH1iST/6h+wbC9ipva/YD6N36WmJHEz9sJK6wNfp5K8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZPPsmmmgBP4wl8BAxIx+bSfyp1WSp14Reo9XzqesotyI+RkQGgRnTLqKXH4cIzz1V
	 6Yv0ymoZOV24Qk9IoKfzScdnyWQPnm9Y2YqpA+TgCW/0wd/pEdeBwPaNYvDEXb0JLr
	 t3EvH9Y3D8DPV+80i77V2rkz+WS8qRISNPBx62ovln08NiJSNpw7K8EZZ1sESj6ObS
	 uCswHGlCLbPbT+d2Z8oCxUrIgUxFlhV4xf6BPzx9XascgmhbXiAijbE7sz6DxI96kI
	 7HMr/w3Iq0am227LY0jAYwDnZ0E0Sz8AOHSKP9RDWsIblv4/IImUQMAjcU/e8pmJnU
	 7mI40LGe/JYXA==
Message-ID: <51965467-4fd7-4d85-8382-9f8928ec718b@kernel.org>
Date: Sun, 5 Jul 2026 12:22:23 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: tear down zoned sysfs before freeing zone info
To: Cen Zhang <zzzccc427@gmail.com>, Carlos Maiolino <cem@kernel.org>,
 Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com
References: <20260705024100.3398090-1-zzzccc427@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260705024100.3398090-1-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/5/26 11:41, Cen Zhang wrote:
> The zoned sysfs directory is currently registered as part of the generic
> per-mount sysfs setup, but the data it exposes has a narrower lifetime.
> mp->m_zone_info is allocated later by xfs_mount_zones() and freed by
> xfs_unmount_zones(), while the zoned sysfs kobject remains registered
> until xfs_mount_sysfs_del() runs near the end of xfs_unmountfs().
> 
> A read of nr_open_zones can therefore enter through the still-live sysfs
> kobject after xfs_unmount_zones() has freed mp->m_zone_info, leading to a
> use-after-free in nr_open_zones_show().
> 
> Make the zoned sysfs lifetime match the zone allocator lifetime.  Create
> the zoned sysfs directory only after xfs_mount_zones() succeeds, and
> remove it before xfs_unmount_zones() frees m_zone_info during unmount and
> mount failure cleanup.

[...]

> Tear down the zoned sysfs directory before freeing m_zone_info instead of
> serializing nr_open_zones_show() with s_umount.

Hmmm... What if the user already has entered the show function but gets
preempted before referencing the zone info and umount proceeds ? That problem
remains, no ?

> 
>  fs/xfs/xfs_mount.c | 10 +++++++++-
>  fs/xfs/xfs_sysfs.c | 28 +++++++++++++++++-----------
>  fs/xfs/xfs_sysfs.h |  2 ++
>  3 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index be90c7b03994..2dcb10bc6187 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1178,6 +1178,9 @@ xfs_mountfs(
>  		error = xfs_mount_zones(mp);
>  		if (error)
>  			goto out_rtunmount;
> +		error = xfs_zoned_sysfs_init(mp);
> +		if (error)
> +			goto out_unmount_zones;

Why not call this in xfs_mount_zones() ?

>  	}
>  
>  	/*
> @@ -1233,6 +1236,9 @@ xfs_mountfs(
>   out_agresv:
>  	xfs_fs_unreserve_ag_blocks(mp);
>  	xfs_qm_unmount_quotas(mp);
> +	if (xfs_has_zoned(mp))
> +		xfs_zoned_sysfs_del(mp);

And this as the first thing in xfs_unmount_zones() ?

Another simpler approach could be to simply call xfs_mount_sysfs_del() earlier
in xfs_unmountfs(). Though that may have other implications and I have not
checked details.

-- 
Damien Le Moal
Western Digital Research
