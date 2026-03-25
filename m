Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5B23A75B2;
	Wed, 25 Mar 2026 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452140; cv=none; b=GfJNnj/VOXaKnjFbuijXDnse2akunZ1H85UlDoQIQ+M4txi8i8qgpYgZuZvxut+GeYuKFezX3scPSZSJ3qb1P381rQ9FBAeFOCyiXXhRYt9eZYhYgYEtF38aXJ85PUKM+h/Iv7cUAMuzeUgXUo6LtxllzqQzvfGqb6tX2eidcOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452140; c=relaxed/simple;
	bh=K70/iUlpRZAOKn0Fz5AcQZ11ZiymDqiF6xc5xts1zDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFyMzg83HZRYYLGqG1Z2b6Tp8Wa33KAYP9qxNChylYa9Kq9+8loYsPdIDk1BaUDCT2uW2mzks9RWTtdKUCAW3X03uuZY08no3wt+702FAa1sOp2VHnL0DLQh1VhdXSVk7S8/fMh9Oh4RLri0U7iSeD6RftLg7X/8XjYTmeLNEyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRdmiY+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iRdmiY+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2871DC4CEF7;
	Wed, 25 Mar 2026 15:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452140;
	bh=K70/iUlpRZAOKn0Fz5AcQZ11ZiymDqiF6xc5xts1zDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iRdmiY+gVs/BAYlfVZ+bRRGKClVEZtzaMQDThHS6TzUuh0ewVIoBidmiThoTC3hSJ
	 CnFyvh6Z6AmXkJrsnD40gFQ0eh5S0pOJ+7gXqKavMV/hETMixTrTnzR21+47eqtxyo
	 iTyuX8ebexWhlEiyLEtwP0MSuIGbGSk1+TFXzwNsXIbrKwUJaTCqofTfWryGr6fvLK
	 pjUFokjmmP2AV9x2oVQUhWbAJcp/cFoCKZILqWIIhPcUti+YkXEsdhUlAFgGL/LZtT
	 i6VjLQ5w1DmL5NP2Zl9+Y14EBT5im4vSy7/IMjFw0UJdfsJ6eEd89x9W3g0M4cUiNh
	 hYNTOIoGAhoTA==
Date: Wed, 25 Mar 2026 08:22:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Message-ID: <20260325152219.GS6223@frogsfrogsfrogs>
References: <20260325124312.26349-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325124312.26349-1-hans.holmberg@wdc.com>

On Wed, Mar 25, 2026 at 01:43:12PM +0100, Hans Holmberg wrote:
> Start gc if the agressiveness of zone garbage collection is changed
> by the user (if the file system is not read only).
> 
> Without this change, the new setting will not be taken into account
> until the gc thread is woken up by e.g. a write.
> 
> Cc: <stable@vger.kernel.org> # v6.15
> Fixes: 845abeb1f06a8a ("xfs: add tunable threshold parameter for triggering zone GC")
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
> 
> v2:
> - Added a new helper to wake up the gc thread in stead of unparking it,
>   which is required to make this work properly.
> - Added protection against races with unmounts as sysfs gets torn down
>   after the zone info struct is freed. This also avoids unneded
>   wakeups during remount.
> - Added fixes and stable cc tags as provided by Darrick.
> 
> v1: https://lore.kernel.org/linux-xfs/20260320130256.35225-1-hans.holmberg@wdc.com/
> 
>  fs/xfs/xfs_sysfs.c      |  7 ++++++-
>  fs/xfs/xfs_zone_alloc.h |  4 ++++
>  fs/xfs/xfs_zone_gc.c    | 17 +++++++++++++++++
>  3 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 6c7909838234..4527119b2961 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -14,6 +14,7 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_mount.h"
>  #include "xfs_zones.h"
> +#include "xfs_zone_alloc.h"
>  
>  struct xfs_sysfs_attr {
>  	struct attribute attr;
> @@ -724,6 +725,7 @@ zonegc_low_space_store(
>  	const char		*buf,
>  	size_t			count)
>  {
> +	struct xfs_mount	*mp = zoned_to_mp(kobj);
>  	int			ret;
>  	unsigned int		val;
>  
> @@ -734,7 +736,10 @@ zonegc_low_space_store(
>  	if (val > 100)
>  		return -EINVAL;
>  
> -	zoned_to_mp(kobj)->m_zonegc_low_space = val;
> +	if (mp->m_zonegc_low_space != val) {
> +		mp->m_zonegc_low_space = val;
> +		xfs_zone_gc_wakeup(mp);
> +	}
>  
>  	return count;
>  }
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index 4db02816d0fd..8b2ef98c81ef 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -51,6 +51,7 @@ int xfs_mount_zones(struct xfs_mount *mp);
>  void xfs_unmount_zones(struct xfs_mount *mp);
>  void xfs_zone_gc_start(struct xfs_mount *mp);
>  void xfs_zone_gc_stop(struct xfs_mount *mp);
> +void xfs_zone_gc_wakeup(struct xfs_mount *mp);
>  #else
>  static inline int xfs_mount_zones(struct xfs_mount *mp)
>  {
> @@ -65,6 +66,9 @@ static inline void xfs_zone_gc_start(struct xfs_mount *mp)
>  static inline void xfs_zone_gc_stop(struct xfs_mount *mp)
>  {
>  }
> +static inline void xfs_zone_gc_wakeup(struct xfs_mount *mp)
> +{
> +}
>  #endif /* CONFIG_XFS_RT */
>  
>  #endif /* _XFS_ZONE_ALLOC_H */
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 0ff710fa0ee7..a8f71231f351 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -1171,6 +1171,23 @@ xfs_zone_gc_stop(
>  		kthread_park(mp->m_zone_info->zi_gc_thread);
>  }
>  
> +void
> +xfs_zone_gc_wakeup(
> +	struct xfs_mount	*mp)
> +{
> +	struct super_block      *sb = mp->m_super;
> +
> +	/*
> +	 * If we are unmounting the file system we must not try to
> +	 * wake gc as m_zone_info might have been freed already.
> +	 */
> +	if (down_read_trylock(&sb->s_umount)) {

s_umount can be held exclusively for other things (e.g. freeze attempts)
which means that you might miss a wakeup here even though the filesystem
isn't unmounting.

That's probably benign here and in the other place (inode flush) that
does this, but it's worth asking -- will it matter that there's a slight
chance that someone adjusts the value and we fail to wake up the gc
thread?

--D

> +		if (!xfs_is_readonly(mp))
> +			wake_up_process(mp->m_zone_info->zi_gc_thread);
> +		up_read(&sb->s_umount);
> +	}
> +}
> +
>  int
>  xfs_zone_gc_mount(
>  	struct xfs_mount	*mp)
> -- 
> 2.34.1
> 
> 
