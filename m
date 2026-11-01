Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793501795;
	b=3fgJlviiZ2nFYrZ2SUV8ryyLpXvtRsplWLnPJ5o9xJ7dVDSi1/Qosc7O79DiVfars6g2
	 imC+l11TU9bkmByimYpFbgH85LdfzYeYCbRSkruTVa+Rr2kWMx+HR0WsSFbLWUH2bEjn4
	 +QZksrb6NXRc5FRg0MdH5mB+KRT8v6N7EQYIgm/O9EIVqWi1LnyK2h+Mbt/jHbg0v4p9K
	 KPOQ51XjwI/tbYn6ERD79K6BOu+ZUjZoVRTN04QN2FfuHzTkZdEEifdKMssqfJ8LCnmuP
	 Q/zUVcrK5JLp45mQcyl+hnR3tzy13NcNpwRU368ftjMwEYY1goL3iR6sBIwa1bW7OlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793501795;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=V3mO2oJ9wvsyKjU2ihhIv9+VvyGcAnmDb2trz7FBpaI=;
	b=JvhjYxzhTcNxwBBwvayCWGLXUMTw7o+TjP9FIaEESgLmBeqcgkbIfkyjuff0GKMxzPcM
	 OrifX/AndFxa+cK64p5djPy/1iVT1ojPGCYyfcMmt14kP5/ebGvpB12V0DM/B27RAzCDU
	 h0Bqq9u9O8k/ye2+8aCZ2FV5rSIhIE4I3n2xSZNRjdooXTW89/SuXJ8NXzOQ67iuyT7Zx
	 WEmtP3rZor+WRlC1Nivw7oxRys+hPo5HLBKAy/xe4Gq78evSA285/SPONDUujHIRSzp1Y
	 ZP139+izvqiLEbg5tbp4nGAdAz2yZ4cREkz5wrAKAPNGMRTVlJnwSDguVizX6gEg94w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=d1dbxGOQ;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388E606A332
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 02:56:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F388E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=d1dbxGOQ
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso18882485e9.0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Oct 2026 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793501792; x=1794106592; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V3mO2oJ9wvsyKjU2ihhIv9+VvyGcAnmDb2trz7FBpaI=;
        b=d1dbxGOQENePeinCh7PuomEmARdqfoQnLYj0EU2dsmG4bDBe6mtaZDcIFxTJcwv5Qt
         PjFnpISJsKmVeoojSUxx4CRWDiyDCa44QwL3JlPP//w7WnwLKKWNM3u4UdLMmNi3dsp8
         hA6FJYDzw6KKrnHzVYpsX3Gv04wRbmkREt76YrZjzkg7/t7HfsECrMpjCT2tfXtOa4BX
         841sc8J92WQ/YSQgfnnkfCmyBxxrfqLTzhfC/zR3bwYSu51judWYj9L7q+9RbcwryTaQ
         mdSwCdSM5yH3kJRuSuleLMLhLrUmc7Fd027D7dRD2/vfY8TfIJ/FVbi2AEKc5+m2aOUM
         LaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793501792; x=1794106592;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V3mO2oJ9wvsyKjU2ihhIv9+VvyGcAnmDb2trz7FBpaI=;
        b=nZ9xZ1czyW2fOYltVxrBZOuBr+2VSWzrvmq7Vask9D9edWG6qDaWBWuWM3PlTobvkQ
         c48RUobrCicSsGeEd0tKKip7gHDt9Bw1n2+42jvM1Z6+wIsaIqrvIRSDiATKTdRUNZyK
         Omk2jjnjHeZU2fW5utscYtrzZfYju7JPNGHIWAgS1IVs9oHzpkFsAwwmj2nnj7Feh9Hf
         lV6aFZKB6bWoDEuJxinJp6Yem6XMyL9vdgHq++EEjD8lgtBLDDYsuLiWVzSh9mbYLNgz
         iC1oRPB4MA32kn248b/hDKBHK9E+1KbeFMAag5Jqx2MpJC8djjxrtCoJ2pD2YAV3l5g2
         XxRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzblliSo5ssxPdwNo48djN434MZML91t2ID6RssiJXv1eLKZ8eyM+neG1oYzpcbgZHctuRHi9VlltQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYK0+gLOhWsCwOm6unLUQaDufteP+PCp5YGkCus+g262XEWOTNnr
	dMhmUq9zfcg13HSraIfD/yIQG60yVzqWXsqYqOPcNy3uPXEX4pkPYk59mUD+1o4moy0=
X-Gm-Gg: AYBFou3gjiX07pTg6padC0lbcQ/AEGiJyD2TZxmrmA2UqhITr8yWBvO8kOAe/Vs8wr9
	ncbhM2zJwGftDdaEx5RTHn4q/PWisnNRn8Rm4i0VQrKbmL/S6qW2wqJuxAbvWFdd0bakZGjvWTK
	YmB6GgOVQSDETZQ+ttgWgeRFxj4/WulgPahOZFcjG6CqoU+9ePxLHArrfS+lQPCZHJy13E/QTbc
	zNBETxsuaPZLvB/4lRk3nL2Z1pPuWtJ76eqF0aT5/uwWIwK0xAsA0VfbnWG9gjeF2rEXC40L7B2
	/LG2Tthpo3hKNX1bVtGvWT3lvGcl9WZX3bKdBVzz+ZL0JevzIbDRb7UkbbeXpCRmyiUDM4rEfc6
	AWpt/pyDFxEk+dmNgL7ej/Sicu9L/ZL0gVfM2yPisBikUbb1dSwXMOfBr42hLQk2rIdSpMbFanQ
	YR0dM2nYxrWmhQG+s0tW/QdmJBdV0alDH1wkbDIEvcSKY5CnKICMnA96zcOe3NnOmeL6KjIcd3t
	Bn5/Kv7mTkaJ2K5mC7VnppdcvWA4YIrvDhn4bQHEPAWokYd3g3FGxADvmc+9Xsz4hvD3qRfg0p/
	b3LrgTQYel1Ft94wdjGFHg==
X-Received: by 2002:a05:600c:4e90:b0:4a4:f48e:78fa with SMTP id 5b1f17b1804b1-4ac175669e4mr143258175e9.12.1793501792111;
        Sat, 31 Oct 2026 19:56:32 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac194b5437sm22760079c88.13.2026.10.31.19.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 19:56:31 -0700 (PDT)
Message-ID: <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
Date: Sun, 1 Nov 2026 13:26:22 +1030
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/30 02:37, Christian Brauner 写道:
> Add btrfs_fs_rdonly() which tests BTRFS_FS_STATE_RO and use it instead
> of sb_rdonly() wherever btrfs checks for a read-only filesystem at
> runtime: the error handler, read repair, async discard, close_ctree(),
> btrfs_inc_block_group_ro(), check_inode_item(), device replace and add,
> cancelling a balance, the sysfs label and force_chunk_alloc stores, the
> qgroup PERTRANS conversions and the subvolume orphan cleanup. And check
> it next to every btrfs_root_readonly() check that guards a modification,
> e.g. in btrfs_permission(), btrfs_setattr(), btrfs_update_time(), the
> xattr and ACL handlers, btrfs_fileattr_set() and
> btrfs_remap_file_range_prep().
> 
> BTRFS_FS_STATE_RO has always been set and cleared together with
> SB_RDONLY. The remaining sb_rdonly() users are mount and remount paths
> plus btrfs_is_full_ro() which only matters for rescue mounts.
> 
> This prepares for not setting SB_RDONLY from the error handler. Until
> then the only difference is that ftruncate() and FICLONE through files
> that were opened for writing before a forced remount to read-only, e.g.
> by sysrq u, fail with EROFS now instead of modifying the filesystem.

I love the idea. This reminds me exactly why for btrfs_force_shutdown(), 
we have to manually set the fs error without marking the fs RO, to avoid 
exactly the same problem.

With that said, can you also a set_bit() call in btrfs_force_shutdown() 
to also set that flag instead of the exsting setting fs_info->fs_error?

Thanks,
Qu

> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>   fs/btrfs/acl.c          |  3 ++-
>   fs/btrfs/bio.c          |  2 +-
>   fs/btrfs/block-group.c  |  2 +-
>   fs/btrfs/dev-replace.c  |  2 +-
>   fs/btrfs/discard.c      |  2 +-
>   fs/btrfs/disk-io.c      |  4 ++--
>   fs/btrfs/fs.h           | 10 ++++++++++
>   fs/btrfs/inode.c        |  8 ++++----
>   fs/btrfs/ioctl.c        |  8 ++++----
>   fs/btrfs/messages.c     |  8 ++++----
>   fs/btrfs/qgroup.c       |  4 ++--
>   fs/btrfs/reflink.c      |  3 ++-
>   fs/btrfs/sysfs.c        |  4 ++--
>   fs/btrfs/tree-checker.c |  2 +-
>   fs/btrfs/volumes.c      |  4 ++--
>   fs/btrfs/xattr.c        |  8 ++++++--
>   16 files changed, 45 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 10a0d733bfd1..8bf11da118f7 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -107,8 +107,9 @@ int btrfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>   	int ret;
>   	struct inode *inode = d_inode(dentry);
>   	umode_t old_mode = inode->i_mode;
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>   
> -	if (btrfs_root_readonly(BTRFS_I(inode)->root))
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
>   		return -EROFS;
>   
>   	if (type == ACL_TYPE_ACCESS && acl) {
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2c6234f6182f..987f29b1ac46 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -924,7 +924,7 @@ int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *or
>   	 * The fs either mounted RO or hit critical errors, no need
>   	 * to continue repairing.
>   	 */
> -	if (unlikely(sb_rdonly(fs_info->sb)))
> +	if (unlikely(btrfs_fs_rdonly(fs_info)))
>   		return 0;
>   
>   	if (btrfs_repair_one_zone(fs_info, logical))
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 9a98e291769c..04c0c0b0c489 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -3138,7 +3138,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
>   	 * In that case we should not start a new transaction on read-only fs.
>   	 * Thus here we skip all chunk allocations.
>   	 */
> -	if (sb_rdonly(fs_info->sb)) {
> +	if (btrfs_fs_rdonly(fs_info)) {
>   		mutex_lock(&fs_info->ro_block_group_mutex);
>   		ret = inc_block_group_ro(cache, false);
>   		mutex_unlock(&fs_info->ro_block_group_mutex);
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index cdfe093e5c5c..943ce620a046 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -1115,7 +1115,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>   	int result;
>   	int ret;
>   
> -	if (sb_rdonly(fs_info->sb))
> +	if (btrfs_fs_rdonly(fs_info))
>   		return -EROFS;
>   
>   	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
> diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
> index 1c304bf473e5..e5c029813228 100644
> --- a/fs/btrfs/discard.c
> +++ b/fs/btrfs/discard.c
> @@ -86,7 +86,7 @@ static bool btrfs_run_discard_work(const struct btrfs_discard_ctl *discard_ctl)
>   						     struct btrfs_fs_info,
>   						     discard_ctl);
>   
> -	return (!(fs_info->sb->s_flags & SB_RDONLY) &&
> +	return (!btrfs_fs_rdonly(fs_info) &&
>   		test_bit(BTRFS_FS_DISCARD_RUNNING, &fs_info->flags));
>   }
>   
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c45cda4290d5..3dcacf7e4d1d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -177,7 +177,7 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
>   	struct btrfs_bio *bbio;
>   	int ret;
>   
> -	if (sb_rdonly(fs_info->sb))
> +	if (btrfs_fs_rdonly(fs_info))
>   		return -EROFS;
>   
>   	/*
> @@ -4483,7 +4483,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>   	/* Cancel or finish ongoing discard work */
>   	btrfs_discard_cleanup(fs_info);
>   
> -	if (!sb_rdonly(fs_info->sb)) {
> +	if (!btrfs_fs_rdonly(fs_info)) {
>   		/*
>   		 * The cleaner kthread is stopped, so do one final pass over
>   		 * unused block groups.
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 2dd167c32d61..024c3ec7d058 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -1194,6 +1194,16 @@ static inline int btrfs_need_cleaner_sleep(const struct btrfs_fs_info *fs_info)
>   		btrfs_fs_closing(fs_info);
>   }
>   
> +/*
> + * Check whether the filesystem is read-only. BTRFS_FS_STATE_RO is set and
> + * cleared together with SB_RDONLY on mount, on remount and when an error forces
> + * the filesystem read-only. Use this instead of sb_rdonly() at runtime.
> + */
> +static inline bool btrfs_fs_rdonly(const struct btrfs_fs_info *fs_info)
> +{
> +	return test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
> +}
> +
>   static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
>   {
>   	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index abaa33471456..415c5145fcbe 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5433,7 +5433,7 @@ static int btrfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	int ret;
>   
> -	if (btrfs_root_readonly(root))
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
>   		return -EROFS;
>   
>   	ret = setattr_prepare(idmap, dentry, attr);
> @@ -6058,7 +6058,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>   			return ERR_CAST(inode);
>   
>   		down_read(&fs_info->cleanup_work_sem);
> -		if (!sb_rdonly(inode->vfs_inode.i_sb))
> +		if (!btrfs_fs_rdonly(fs_info))
>   			ret = btrfs_orphan_cleanup(sub_root);
>   		up_read(&fs_info->cleanup_work_sem);
>   		if (ret) {
> @@ -6421,7 +6421,7 @@ static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	int dirty;
>   
> -	if (btrfs_root_readonly(root))
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
>   		return -EROFS;
>   	if (flags & IOCB_NOWAIT)
>   		return -EAGAIN;
> @@ -9316,7 +9316,7 @@ static int btrfs_permission(const struct mnt_idmap *idmap,
>   
>   	if (mask & MAY_WRITE &&
>   	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
> -		if (btrfs_root_readonly(root))
> +		if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
>   			return -EROFS;
>   		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
>   			return -EACCES;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f3e2afe221be..2063075906c8 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -291,7 +291,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
>   	u32 inode_flags;
>   	bool prop_set = false;
>   
> -	if (btrfs_root_readonly(root))
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(fs_info))
>   		return -EROFS;
>   
>   	if (fileattr_has_fsx(fa))
> @@ -2453,7 +2453,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>   	if (ret)
>   		return ret;
>   
> -	if (btrfs_root_readonly(root)) {
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info)) {
>   		ret = -EROFS;
>   		goto out;
>   	}
> @@ -3191,7 +3191,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
>   
>   	switch (p->cmd) {
>   	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
> -		if (sb_rdonly(fs_info->sb))
> +		if (btrfs_fs_rdonly(fs_info))
>   			return -EROFS;
>   		if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_DEV_REPLACE)) {
>   			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
> @@ -3927,7 +3927,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
>   		goto out;
>   	}
>   
> -	if (btrfs_root_readonly(root)) {
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(fs_info)) {
>   		ret = -EROFS;
>   		goto out;
>   	}
> diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
> index 0704be7be871..cedca4050831 100644
> --- a/fs/btrfs/messages.c
> +++ b/fs/btrfs/messages.c
> @@ -132,10 +132,10 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
>   #endif
>   
>   	/*
> -	 * Special case: if the error is EROFS, and we're already under
> -	 * SB_RDONLY, then it is safe here.
> +	 * Special case: if the error is EROFS, and we're already read-only,
> +	 * then it is safe here.
>   	 */
> -	if (error == -EROFS && sb_rdonly(sb))
> +	if (error == -EROFS && btrfs_fs_rdonly(fs_info))
>   		return;
>   
>   #ifdef CONFIG_PRINTK
> @@ -168,7 +168,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
>   	if (!(sb->s_flags & SB_BORN))
>   		return;
>   
> -	if (sb_rdonly(sb))
> +	if (btrfs_fs_rdonly(fs_info))
>   		return;
>   
>   	btrfs_discard_stop(fs_info);
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a0651fbfe778..dc96c6aca1a9 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -4658,7 +4658,7 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
>   
>   		qgroup_rsv_release(fs_info, qgroup, num_bytes,
>   				BTRFS_QGROUP_RSV_META_PREALLOC);
> -		if (!sb_rdonly(fs_info->sb))
> +		if (!btrfs_fs_rdonly(fs_info))
>   			qgroup_rsv_add(fs_info, qgroup, num_bytes,
>   				       BTRFS_QGROUP_RSV_META_PERTRANS);
>   
> @@ -4688,7 +4688,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
>   				      BTRFS_QGROUP_RSV_META_PREALLOC);
>   	trace_btrfs_qgroup_meta_convert(root, num_bytes);
>   	qgroup_convert_meta(fs_info, btrfs_root_id(root), num_bytes);
> -	if (!sb_rdonly(fs_info->sb))
> +	if (!btrfs_fs_rdonly(fs_info))
>   		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
>   }
>   
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index b5d2c094941d..de9bc8ba5028 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -857,7 +857,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>   	if (!(remap_flags & REMAP_FILE_DEDUP)) {
>   		struct btrfs_root *root_out = inode_out->root;
>   
> -		if (btrfs_root_readonly(root_out))
> +		if (btrfs_root_readonly(root_out) ||
> +		    btrfs_fs_rdonly(root_out->fs_info))
>   			return -EROFS;
>   
>   		ASSERT(inode_in->vfs_inode.i_sb == inode_out->vfs_inode.i_sb);
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 3ac1fa608d3b..c7522aafde1b 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -751,7 +751,7 @@ static ssize_t btrfs_force_chunk_alloc_store(struct kobject *kobj,
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
>   
> -	if (sb_rdonly(fs_info->sb))
> +	if (btrfs_fs_rdonly(fs_info))
>   		return -EROFS;
>   
>   	ret = kstrtobool(buf, &val);
> @@ -980,7 +980,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>   	if (!fs_info)
>   		return -EPERM;
>   
> -	if (sb_rdonly(fs_info->sb))
> +	if (btrfs_fs_rdonly(fs_info))
>   		return -EROFS;
>   
>   	/*
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 9cd79d97b9b5..6cce0e6c759e 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1325,7 +1325,7 @@ static int check_inode_item(struct extent_buffer *leaf,
>   			       "unknown incompat flags detected: 0x%x", flags);
>   		return -EUCLEAN;
>   	}
> -	if (unlikely(!sb_rdonly(fs_info->sb) &&
> +	if (unlikely(!btrfs_fs_rdonly(fs_info) &&
>   		     (ro_flags & ~BTRFS_INODE_RO_FLAG_MASK))) {
>   		inode_item_err(leaf, slot,
>   			"unknown ro-compat flags detected on writeable mount: 0x%x",
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d3e6a9b429dd..47879cc2160d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2964,7 +2964,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   	bool seeding_dev = false;
>   	bool locked = false;
>   
> -	if (sb_rdonly(sb) && !fs_devices->seeding)
> +	if (btrfs_fs_rdonly(fs_info) && !fs_devices->seeding)
>   		return -EROFS;
>   
>   	/* Forbid freezing until the device is a committed member (or unwound). */
> @@ -5297,7 +5297,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   	 * mount time if the mount is read-write. Otherwise it's still paused
>   	 * and we must not allow cancelling as it deletes the item.
>   	 */
> -	if (sb_rdonly(fs_info->sb)) {
> +	if (btrfs_fs_rdonly(fs_info)) {
>   		mutex_unlock(&fs_info->balance_mutex);
>   		return -EROFS;
>   	}
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index cbee10b6b49a..c38ddee78636 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -365,7 +365,9 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
>   				   const char *name, const void *buffer,
>   				   size_t size, int flags)
>   {
> -	if (btrfs_root_readonly(BTRFS_I(inode)->root))
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
>   		return -EROFS;
>   
>   	name = xattr_full_name(handler, name);
> @@ -409,7 +411,9 @@ static int btrfs_xattr_handler_set_security(const struct xattr_handler *handler,
>   					    const void *buffer,
>   					    size_t size, int flags)
>   {
> -	if (btrfs_root_readonly(BTRFS_I(inode)->root))
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +
> +	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
>   		return -EROFS;
>   
>   	name = xattr_full_name(handler, name);
> 

