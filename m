Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA8E37A83A;
	Thu,  2 Jul 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783006468; cv=none; b=ODibkau6suPRB4RLgbS+Ju+zeWW0hB9S1iZlGMcI3OyDXs5TkSIZA1JW8Cq9ri3IKuAna4FuYQrUDKzQYJisI9nsotiDS1meKqmmbP5TCK+MS/4ZuyV4LhBApjJ4cG9s3q4B6b6lAm2VIu2XQSZwB1ELinG1SydgNgjVam0YYHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783006468; c=relaxed/simple;
	bh=gJwFdSToEpU5oEhjnM3eAHYN2M2sngYJnGxs6qz6wac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2MbzsyegL8nWRktp0Wps3zOqQKYMzPZmE2QfCpPy3JYtd2/SzT9EBngHDR/TVajJQ1Okp4DTOvNy3ouQ8afV55LhOBHEWnli0BAfmRiEYGk3R/Bvw6g5m43jnaMzs2anGzvgFFTXJX+xIPZZCCdnTzXZuxsP48gDl9Qo2TLFDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCBYz+SU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCBYz+SU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39E071F000E9;
	Thu,  2 Jul 2026 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006467;
	bh=gnPPqJYMij9eGIw+OczowLR1AhEfARJCNvgf9wr7i9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LCBYz+SUFMa2YM4LmwCQY7Pq1XIWSvX7mSZW12hXqjVNO1I5vPC4AZ/YnWK5IhImd
	 RWHaK33axAWVGGmcB10vTZnJonEkfWmJ5OnMCr75viMz++/w/Jh/laCipeeMtraXFy
	 wEIzobKfbrg2LiZyB8iPizCY7v29lBAUnGkKXKXxfnN69+EJt1M+j1urCxjjgJi1Bs
	 rWDdERVlDQ6yNQsjJ+EcX+9sEW/oS/vV4EMq4GaKcXJghTuM1wvX6Jy1Zpvr+mNcbr
	 FrMDc8ZeYPDmOZEWjXaSDBI2eN+CX8AtgCKwN9zCRTwACXwmILDMCZr5dvMIupGbFQ
	 nOX7Fzo6NW13g==
Date: Thu, 2 Jul 2026 08:34:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Subject: Re: [PATCH] xfs: serialize zoned sysfs reads against unmount
Message-ID: <20260702153426.GC9392@frogsfrogsfrogs>
References: <20260702150133.2408523-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702150133.2408523-1-zzzccc427@gmail.com>

On Thu, Jul 02, 2026 at 11:01:33PM +0800, Cen Zhang wrote:
> The zoned sysfs kobject is removed late in xfs_unmountfs(), after
> xfs_unmount_zones() has torn down the zone allocator.  A read of
> nr_open_zones can therefore enter through the still-live sysfs kobject
> and dereference mp->m_zone_info after xfs_free_zone_info() has freed it.
> 
> Serialize the nr_open_zones show method against unmount with s_umount.
> If unmount already owns the write side, fail the sysfs read before
> touching m_zone_info.  If the sysfs read gets in first, the unmount path
> must wait until the read has copied zi_nr_open_zones.  Also return
> -ENODEV if the zoned sysfs node is visible before zone information is
> available.

Shouldn't we tear down the sysfs files that access m_zone_info before
freeing it?

--D

> Validation reproduced this kernel report:
> BUG: KASAN: slab-use-after-free in nr_open_zones_show+0x86/0x90
> The buggy address belongs to the object at ffff88810b177800 which belongs
> to the cache kmalloc-1k of size 1024
> The buggy address is located 160 bytes inside of freed 1024-byte region
> [ffff88810b177800, ffff88810b177c00)
> Read of size 4
> Call trace:
>   print_report+0xcd/0x620
>   nr_open_zones_show+0x86/0x90 (fs/xfs/xfs_sysfs.c:724)
>   srso_alias_return_thunk+0x5/0xfbef5
>   __virt_addr_valid+0x20c/0x410
>   kasan_report+0xdd/0x110
>   sysfs_kf_seq_show+0x1bd/0x380
>   seq_read_iter+0x40f/0x11b0
>   lock_release+0xba/0x260
>   mark_held_locks+0x40/0x70
>   vfs_read+0x717/0xce0
>   __up_read+0x319/0x900
>   ksys_read+0xf8/0x1c0
>   do_user_addr_fault+0x3d0/0xbc0
>   trace_hardirqs_on_prepare+0x23/0xf0
>   do_syscall_64+0xc8/0x530 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x74/0x7c
> Allocated by task stack:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   __kasan_kmalloc+0xaa/0xb0
>   __kmalloc_cache_noprof+0x205/0x460
>   xfs_mount_zones+0x34c/0x2650
>   xfs_mountfs+0x1b97/0x1eb0
>   xfs_fs_fill_super+0xf2b/0x18a0
>   get_tree_bdev_flags+0x310/0x590
>   vfs_get_tree+0x8d/0x2e0
>   __x64_sys_fsconfig+0x61c/0xbc0
>   do_syscall_64+0xc8/0x530 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x74/0x7c
> Freed by task stack:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   kasan_save_free_info+0x3b/0x60
>   __kasan_slab_free+0x5f/0x80
>   kfree+0x20e/0x4c0
>   xfs_unmountfs+0x2fd/0x390
>   xfs_fs_put_super+0x60/0x110
>   generic_shutdown_super+0x143/0x4b0
>   kill_block_super+0x3b/0x90
>   xfs_kill_sb+0x12/0x50
>   deactivate_locked_super+0xa7/0x160
>   cleanup_mnt+0x218/0x420
>   task_work_run+0x11a/0x1f0
>   exit_to_user_mode_loop+0x13c/0x4f0
>   do_syscall_64+0x4a9/0x530 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x74/0x7c
> 
> Fixes: 62c89988dc19 ("xfs: expose the number of open zones in sysfs")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>  fs/xfs/xfs_sysfs.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 676777064c2d..1fe0014c8567 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -725,9 +725,21 @@ nr_open_zones_show(
>  	struct kobject		*kobj,
>  	char			*buf)
>  {
> -	struct xfs_zone_info	*zi = zoned_to_mp(kobj)->m_zone_info;
> +	struct xfs_mount	*mp = zoned_to_mp(kobj);
> +	struct xfs_zone_info	*zi;
> +	ssize_t			ret;
> +
> +	if (!down_read_trylock(&mp->m_super->s_umount))
> +		return -ENODEV;
> +
> +	zi = mp->m_zone_info;
> +	if (zi)
> +		ret = sysfs_emit(buf, "%u\n", READ_ONCE(zi->zi_nr_open_zones));
> +	else
> +		ret = -ENODEV;
> +	up_read(&mp->m_super->s_umount);
>  
> -	return sysfs_emit(buf, "%u\n", READ_ONCE(zi->zi_nr_open_zones));
> +	return ret;
>  }
>  XFS_SYSFS_ATTR_RO(nr_open_zones);
>  
> -- 
> 2.43.0
> 
> 
