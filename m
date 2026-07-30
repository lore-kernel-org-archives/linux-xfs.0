Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8494119EA;
	Thu, 30 Jul 2026 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411015; cv=none; b=pRgAnloNL7w8XoShrSKK9uJV8OgeYqz002sbGJayEV9089bBftFqTFzV5/fG6L397IoEVtxAi51qJcpdE18l3BKGszPg9BhySuk0rDZqYNuQ3GJRRLKDbmtV37l9tMdirJRilKetAyKWFLm6+NlBpZ3akY36L1qgymzbZG/LtYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411015; c=relaxed/simple;
	bh=0BxZDPhDpXS00Vl4nm3zEji/Jknz1W+OY9t143i8SXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0HaO0eFvrSC9DLqLsaNMbgVzVn78hmTCsdkJTKjE6GmwkcPSMFgvRkEopQf8GZyvKjAMkeZsEkyx/n0w8wrP4j6y3iOQCIQb6B7aWtD8FKI2VALwhgHCSMzf7LA53pAAkuSW0o/LdO5uuldQk95Uzz6nlJUckrFR0HtCycaQ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yY9MAl94; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yY9MAl94"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7E3WjTqOxyq8PzWbZVzrVz6yRyB88jrD20H/QQn0zTo=; b=yY9MAl94XvRoQSluJr5IV6cT2Q
	ucenO9RU4Ep4YVVsysIdmfgWA+EPly6uvuZsVo2xOQySqm6235dp9HmoBtBzKGUIDy1usJPdA3t4a
	PrhZY63hq7b3WifYyHSvYT1wtJ0twK26pFknMQNnjHHsLfuqE7GfnMeqAAcL14k2RFALamoXktQye
	7VuQK2mWeEO75sxp65Vy53MPbguymxgMCODk+SqYJjG2OHSVBl7+j9uVE1aUeKa4O8JMosjm9w/cG
	gund7oht+DyyC34AA7K0XVa8dEkd+huMql1V0Z9t7GIO3JqvSOjImQjPxA3JTIio5Qrm0h+A7Dz3t
	TaTI/ovg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpOxi-0000000ALtu-40bt;
	Thu, 30 Jul 2026 11:30:07 +0000
Date: Thu, 30 Jul 2026 04:30:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, djwong@kernel.org, hch@infradead.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
Message-ID: <ams1vhkIBQOXQI_l@infradead.org>
References: <20260722133844.2900030-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722133844.2900030-1-yun.zhou@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 22, 2026 at 09:38:44PM +0800, Yun Zhou wrote:
> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> xfs_trans_commit(), which flushes the CIL push workqueue internally.
> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> lock these buffers to fail them, causing a deadlock:
> 
>   setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>   CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> 
> Remove the xfs_trans_bhold() calls so that commit releases the buffer
> locks normally.  After the sync commit, re-acquire the buffers via
> mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
> 
> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
> Changes in v2:
> - Remove the bp variable and pass xfs_trans_getsb(tp) directly to
>   xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
> - Convert xfs_log_rtsb() stub from macro to inline function to avoid
>   the need for (void) casting (Christoph).
> ---
>  fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
>  fs/xfs/libxfs/xfs_sb.c      | 39 ++++++++++++++++++-------------------
>  2 files changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index c0b9f9f2c413..fca2eb74908c 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>  # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
>  # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
>  # define xfs_update_rtsb(bp, sb_bp)	((void)0)
> -# define xfs_log_rtsb(tp, sb_bp)	(NULL)
> +static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
> +		const struct xfs_buf *sb_bp)
> +{
> +	return NULL;
> +}
>  # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
>  #endif /* CONFIG_XFS_RT */
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..929677ad95b4 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1470,36 +1470,35 @@ xfs_sync_sb_buf(
>  	bool			update_rtsb)
>  {
>  	struct xfs_trans	*tp;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
>  
>  	xfs_log_sb(tp);
> +	if (update_rtsb)
> +		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
>  	xfs_trans_set_sync(tp);

No new here, but I don't think the transaction reservation is correct
here.  If we're writing both the sb and rtsb buffers, we need a log
reservation for two buffers, not just for one.  Separate patch,
though.

>
>  	error = xfs_trans_commit(tp);
>  	if (error)
> +		return error;
> +
> +	/* Re-acquire and write the sb and rtsb to disk. */
> +	xfs_buf_lock(mp->m_sb_bp);
> +	xfs_buf_hold(mp->m_sb_bp);
> +	error = xfs_bwrite(mp->m_sb_bp);
> +	xfs_buf_relse(mp->m_sb_bp);
> +	if (error)
> +		return error;
> +
> +	if (update_rtsb && mp->m_rtsb_bp) {
> +		xfs_buf_lock(mp->m_rtsb_bp);
> +		xfs_buf_hold(mp->m_rtsb_bp);
> +		error = xfs_bwrite(mp->m_rtsb_bp);
> +		xfs_buf_relse(mp->m_rtsb_bp);
> +	}

I don't think we need an extra hold here for both buffers, just
a lock/unlock, or am I missing something?

Anyway, the fix itself looks good, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

