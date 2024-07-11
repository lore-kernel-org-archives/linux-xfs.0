Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58435101E4
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 02:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720666415; cv=none; b=Bg9yDsGE+Q4ippZ4Nk0GpTwfWdicABw/yDyW/ulzKqJe7u5yfH+m1Dq9XcoMdwliyK9BDot2FAqwAFOSsn30BJUHCCn8ZGdwdzZt4njzBL9eSCEz/EXqHz3mYxL9s2Pa4iBv01dmheqawarCH4v7F9cx+DcuAInN3En734pjgvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720666415; c=relaxed/simple;
	bh=n55fnaXcYDBykC8RaQaIoau5eeOI3TTaSs5+pbGIDgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqBgdKaresAdL3YaUqp++qjzlMElCdZ0g8HOhhjI8SXuaJMC64mrgxup4cTEii7+Tivm60nhCC0ujIU7OaBt2O6HWKZpB3OMaZVzMKXFVbePJmVJcSB0bvOhbu9f8WzqieSpgJ4Zd3mogV0EcpTW9j1d5i1tWocJw47Cz+EOhFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBHoT1DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBHoT1DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CA8C32781;
	Thu, 11 Jul 2024 02:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720666414;
	bh=n55fnaXcYDBykC8RaQaIoau5eeOI3TTaSs5+pbGIDgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OBHoT1DGy4QIpNo9ehUFaHe5G/pmjUhqs7DiirqJbCUeJS2NXY5/p/8iV1d6rtHuF
	 V89pJMLtz7ZTqLYtVaE9o66DPdI00CN5xjf6krZyaDNWgk9PVzagjIkROG/gFRcnYc
	 CIzJkib6NjXvyZlHk8Wr4Y6KjkClyDcj+HVDUhWm/P2p0za4F6EF8T0j4Vsem+ZOO8
	 ncP6lJgS9kp0RNLzt/JsgMUj7iiJasR8M6QbkphVZRw0MiCy3f4HByCjXa3iASKa5w
	 ig04M1jH1TagfgYZqnHHqTjVVqCAD6823s04mvFFjPMBhMVN667eGsowXz7J2qCO4A
	 JYKTGfP69ZZNA==
Date: Wed, 10 Jul 2024 19:53:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use xfs set and clear mp state helpers
Message-ID: <20240711025334.GH612460@frogsfrogsfrogs>
References: <20240710103119.854653-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710103119.854653-1-john.g.garry@oracle.com>

On Wed, Jul 10, 2024 at 10:31:19AM +0000, John Garry wrote:
> Use the set and clear mp state helpers instead of open-coding.
> 
> It is noted that in some instances calls to atomic operation set_bit() and
> clear_bit() are being replaced with test_and_set_bit() and
> test_and_clear_bit(), respectively, as there is no specific helpers for
> set_bit() and clear_bit() only. However should be ok, as we are just
> ignoring the returned value from those "test" variants.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Seems pretty straightfoward to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index c211ea2b63c4..3643cc843f62 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -485,7 +485,7 @@ xfs_do_force_shutdown(
>  	const char	*why;
>  
>  
> -	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate)) {
> +	if (xfs_set_shutdown(mp)) {
>  		xlog_shutdown_wait(mp->m_log);
>  		return;
>  	}
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 817ea7e0a8ab..26b2f5887b88 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3495,7 +3495,7 @@ xlog_force_shutdown(
>  	 * If this log shutdown also sets the mount shutdown state, issue a
>  	 * shutdown warning message.
>  	 */
> -	if (!test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &log->l_mp->m_opstate)) {
> +	if (!xfs_set_shutdown(log->l_mp)) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_SHUTDOWN_LOGERROR,
>  "Filesystem has been shut down due to log error (0x%x).",
>  				shutdown_flags);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4423dd344239..1a74fe22672e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1336,7 +1336,7 @@ xlog_find_tail(
>  	 * headers if we have a filesystem using non-persistent counters.
>  	 */
>  	if (clean)
> -		set_bit(XFS_OPSTATE_CLEAN, &log->l_mp->m_opstate);
> +		xfs_set_clean(log->l_mp);
>  
>  	/*
>  	 * Make sure that there are no blocks in front of the head
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 09eef1721ef4..460f93a9ce00 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -595,7 +595,7 @@ xfs_unmount_flush_inodes(
>  	xfs_extent_busy_wait_all(mp);
>  	flush_workqueue(xfs_discard_wq);
>  
> -	set_bit(XFS_OPSTATE_UNMOUNTING, &mp->m_opstate);
> +	xfs_set_unmounting(mp);
>  
>  	xfs_ail_push_all_sync(mp->m_ail);
>  	xfs_inodegc_stop(mp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 27e9f749c4c7..904e7bf846d7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -311,9 +311,9 @@ xfs_set_inode_alloc(
>  	 * the allocator to accommodate the request.
>  	 */
>  	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
> -		set_bit(XFS_OPSTATE_INODE32, &mp->m_opstate);
> +		xfs_set_inode32(mp);
>  	else
> -		clear_bit(XFS_OPSTATE_INODE32, &mp->m_opstate);
> +		xfs_clear_inode32(mp);
>  
>  	for (index = 0; index < agcount; index++) {
>  		struct xfs_perag	*pag;
> @@ -1511,7 +1511,7 @@ xfs_fs_fill_super(
>  	 * the newer fsopen/fsconfig API.
>  	 */
>  	if (fc->sb_flags & SB_RDONLY)
> -		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> +		xfs_set_readonly(mp);
>  	if (fc->sb_flags & SB_DIRSYNC)
>  		mp->m_features |= XFS_FEAT_DIRSYNC;
>  	if (fc->sb_flags & SB_SYNCHRONOUS)
> @@ -1820,7 +1820,7 @@ xfs_remount_rw(
>  		return -EINVAL;
>  	}
>  
> -	clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> +	xfs_clear_readonly(mp);
>  
>  	/*
>  	 * If this is the first remount to writeable state we might have some
> @@ -1908,7 +1908,7 @@ xfs_remount_ro(
>  	xfs_save_resvblks(mp);
>  
>  	xfs_log_clean(mp);
> -	set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> +	xfs_set_readonly(mp);
>  
>  	return 0;
>  }
> -- 
> 2.31.1
> 
> 
