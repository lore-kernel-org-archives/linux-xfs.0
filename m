Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F36BE7FD8
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 10:44:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D74728F8033
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 08:44:11 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CEseJcEyEVZG63EY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 08:44:10 -0800 (PST)
Date: Mon, 2 Feb 2015 08:44:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use generic percpu counters for inode counter
Message-ID: <20150202164409.GA695@infradead.org>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422826983-29570-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 4cf335b..7bfa527 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -357,7 +357,8 @@ __xfs_sb_from_disk(
>  	to->sb_rextslog = from->sb_rextslog;
>  	to->sb_inprogress = from->sb_inprogress;
>  	to->sb_imax_pct = from->sb_imax_pct;
> -	to->sb_icount = be64_to_cpu(from->sb_icount);
> +	if (percpu_counter_initialized(&to->sb_icount))
> +		percpu_counter_set(&to->sb_icount, be64_to_cpu(from->sb_icount));

Why would the percpu counter not be initialized here?  Oh, I guess
this is for xfs_sb_verify().  But why can't xfs_mount_validate_sb simply
operate on the disk endian SB to avoid that whole issue?

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6015f54..df5ec55 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1127,13 +1127,13 @@ xfs_mod_incore_sb_unlocked(
>  	 */
>  	switch (field) {
>  	case XFS_SBS_ICOUNT:
> +		/* deltas are +/-64, hence the large batch size of 128. */
> +		__percpu_counter_add(&mp->m_sb.sb_icount, delta, 128);
> +		if (percpu_counter_compare(&mp->m_sb.sb_icount, 0) < 0) {
>  			ASSERT(0);
> +			percpu_counter_add(&mp->m_sb.sb_icount, -delta);
>  			return -EINVAL;
>  		}
>  		return 0;
>  	case XFS_SBS_IFREE:
>  		lcounter = (long long)mp->m_sb.sb_ifree;
> @@ -1288,8 +1288,11 @@ xfs_mod_incore_sb(
>  	int			status;
>  
>  #ifdef HAVE_PERCPU_SB
> -	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
> +	ASSERT(field < XFS_SBS_IFREE || field > XFS_SBS_FDBLOCKS);
>  #endif
> +	if (field == XFS_SBS_ICOUNT)
> +		return xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
> +

Why is this multiplexd through xfs_mod_incore_sb_unlocked while needing
a different locking context?  Shouldn't we simply use a different helper
for this case?

>  	xfs_icsb_cnts_t *cntp;
>  	int		i;
>  
> +	i = percpu_counter_init(&mp->m_sb.sb_icount, 0, GFP_KERNEL);
> +	if (i)
> +		return ENOMEM;
> +
>  	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
> -	if (mp->m_sb_cnts == NULL)
> +	if (!mp->m_sb_cnts) {
> +		percpu_counter_destroy(&mp->m_sb.sb_icount);
>  		return -ENOMEM;
> +	}
>  
>  	for_each_online_cpu(i) {

Reusing a variable for both an errno value and a loop iterator is
not very readable, just add an additional "error" variabe.

Also percpu_counter_init returns a proper egative errno value, no need
to turn that into the incorrect postive ENOMEM.

Additionally should this use goto unwining?

>  	if (idelta) {
> -		error = xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT,
> -						 idelta, rsvd);
> +		error = xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, idelta, rsvd);

Why go through xfs_mod_incore_sb here instead of directly jumping to
the function that does the work?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
