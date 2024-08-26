Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB238173
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 00:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724632884; cv=none; b=BzOSh4o8OWlPvXxcPz6q1U99ji3ZlAN/Yrvwp9HmUMrZE7T3JDzJp03rDN61R2W3O6ZD7Djlo/yGg1UOu/+VkLD+daE8SvzRCChUxvqoCvcxYKKSUGfA7IdgShev7Xp8gv8g3BQGp13FTVKbXctiTB2BukF4IsmFCtYHgi4gEXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724632884; c=relaxed/simple;
	bh=o2PW1d8736xPykpvB4g/mN7kJMuj7CmAK4nL1ZtC/5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6t4aGzomaoEiK6Hw7AKP5Qj8bznKFwF5Qgo/5ZsfmAViDXJXXq6Ik/ywq1L/ytlYU69abxakdtRwnDfFLkJVpUNAq/7cL/rX6nyRlQZ5JiTh/vg0SQHybqCXu4/hyG0bX2qCyAElxrJJjNjNGFKu8BDAe++tsy+qJmfTLXyJcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xCYFtCs/; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xCYFtCs/"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-27020fca39aso3295107fac.0
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 17:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724632882; x=1725237682; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7DMbYBIrFQl1aapLSWN3XjGpKIQeE1PNhdv2Ds9ngr0=;
        b=xCYFtCs/yYhpNgMPXd6DQT12l5wpqQF7C4RLnju1jThZDRcN40iFhR5/sTJOuEY2ZJ
         mqUAONtsdOWiaNU+LbnV0ihAnEsNGKnCxumF+T+2Rs7eDyf+ho+Pq0ug7UtQu3716qHx
         1uFVBySLP5Y9UfO8AOkIkHFMvlZDZkYVgCzRkWNZYpa3sM5j1+4YmFmQ93FJfvmYyLjY
         R2loOtxeMQUTu123LGtTp414autTpnZcFPR2QlBquIpq2kI7tTIBs1T/Ra4zVFG8eMK+
         r1uUYBxbyFoXKJUtGLIXAxuuvo3Y4CHbPuygHFcpValLmplIhaJq6B0dxpuHayIXwQ/4
         VTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724632882; x=1725237682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DMbYBIrFQl1aapLSWN3XjGpKIQeE1PNhdv2Ds9ngr0=;
        b=jpItR6wdZaZLajJ5/JHuV4/LqzBDSjVP8QgCngKgp+Q2S9s64e4SUBZjAtKY/H5V0C
         ci9IU+p2R4SShdhIPmCE1/WixbiZ7z/nU/aZR8PmHD6Yp0RiV+/uwlMN2/lkkMbLee6C
         RnSK0H9lTG1N7nz/BFEyFclSkV+ocebh2IV1HocnVry5qPq+fOEtWj0ybkv16DYeuCeg
         2lS0yhlX0I+220SgUBc7InLGlGaaE6jqrQifuR+xGkX7qkGz3XXhJh/KtCk7/5oQ0OLI
         xAnzHSY88e6n8vKmRdZ9sEjcpGBex5TdFItszx9G/XROwr4m4BHOrG6ckUVICQNAst/P
         ULZw==
X-Forwarded-Encrypted: i=1; AJvYcCWGFITo+6iRFCoHOMMHYb4gpflnemHHaAG/jsv5cRplUAnm60ZLDXuUiBKKkHLAP/xI/cGx8KfvCYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAW6rvlrPstyrRk8sRJRIP7Zo4v12u9bCd0vQnPi37UzfgEgPN
	a6XM8Ylp5FaKueFdUPNM+oZBgbxJ5jAAs1UuHa/SNKOtakFpX5xnz0vlaX9t4JU=
X-Google-Smtp-Source: AGHT+IGJZMZnvnGrwAmbpkuVSCtQ2G5tPh3+KR3K9FNeQMb2S2FalKEsk4T4FVkKcYVW6fftt8Wb7w==
X-Received: by 2002:a05:6870:b52c:b0:26c:5312:a145 with SMTP id 586e51a60fabf-273e647682bmr10593196fac.16.1724632881822;
        Sun, 25 Aug 2024 17:41:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434231152sm6344826b3a.18.2024.08.25.17.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 17:41:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siNnK-00CmGD-2h;
	Mon, 26 Aug 2024 10:41:18 +1000
Date: Mon, 26 Aug 2024 10:41:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs: hide metadata inodes from everyone because
 they are special
Message-ID: <ZsvPLoxe9UEZZKuM@dread.disaster.area>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085312.57482.9340127129544109933.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085312.57482.9340127129544109933.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:04:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Metadata inodes are private files and therefore cannot be exposed to
> userspace.  This means no bulkstat, no open-by-handle, no linking them
> into the directory tree, and no feeding them to LSMs.  As such, we mark
> them S_PRIVATE, which stops all that.

Can you merge this back up into the initial iget support code?

> 
> While we're at it, put them in a separate lockdep class so that it won't
> get confused by "recursive" i_rwsem locking such as what happens when we
> write to a rt file and need to allocate from the rt bitmap file.  The
> static function that we use to do this will be exported in the rtgroups
> patchset.

Stale commit message? There's nothing of the sort in this patch....

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/tempfile.c |    8 ++++++++
>  fs/xfs/xfs_iops.c       |   15 ++++++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
> index 177f922acfaf1..3c5a1d77fefae 100644
> --- a/fs/xfs/scrub/tempfile.c
> +++ b/fs/xfs/scrub/tempfile.c
> @@ -844,6 +844,14 @@ xrep_is_tempfile(
>  	const struct xfs_inode	*ip)
>  {
>  	const struct inode	*inode = &ip->i_vnode;
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	/*
> +	 * Files in the metadata directory tree also have S_PRIVATE set and
> +	 * IOP_XATTR unset, so we must distinguish them separately.
> +	 */
> +	if (xfs_has_metadir(mp) && (ip->i_diflags2 & XFS_DIFLAG2_METADATA))
> +		return false;

Why do you need to check both xfs_has_metadir() and the inode flag
here? The latter should only be set if the former is set, yes?
If it's the other way around, then we have an on-disk corruption...

>  	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
>  		return true;

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1cdc8034f54d9..c1686163299a0 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -42,7 +42,9 @@
>   * held. For regular files, the lock order is the other way around - the
>   * mmap_lock is taken during the page fault, and then we lock the ilock to do
>   * block mapping. Hence we need a different class for the directory ilock so
> - * that lockdep can tell them apart.
> + * that lockdep can tell them apart.  Directories in the metadata directory
> + * tree get a separate class so that lockdep reports will warn us if someone
> + * ever tries to lock regular directories after locking metadata directories.
>   */
>  static struct lock_class_key xfs_nondir_ilock_class;
>  static struct lock_class_key xfs_dir_ilock_class;
> @@ -1299,6 +1301,7 @@ xfs_setup_inode(
>  {
>  	struct inode		*inode = &ip->i_vnode;
>  	gfp_t			gfp_mask;
> +	bool			is_meta = xfs_is_metadata_inode(ip);
>  
>  	inode->i_ino = ip->i_ino;
>  	inode->i_state |= I_NEW;
> @@ -1310,6 +1313,16 @@ xfs_setup_inode(
>  	i_size_write(inode, ip->i_disk_size);
>  	xfs_diflags_to_iflags(ip, true);
>  
> +	/*
> +	 * Mark our metadata files as private so that LSMs and the ACL code
> +	 * don't try to add their own metadata or reason about these files,
> +	 * and users cannot ever obtain file handles to them.
> +	 */
> +	if (is_meta) {
> +		inode->i_flags |= S_PRIVATE;
> +		inode->i_opflags &= ~IOP_XATTR;
> +	}

No need for a temporary variable here.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
