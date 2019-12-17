Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAE2C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 11:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 643C721739
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 11:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFlYwbDl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfLQLck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:32:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45365 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727461AbfLQLck (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 06:32:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576582358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FN9Ynne1HwT6bHuM9DoEp1HZNDTAH1DoOUxxjaifr3s=;
        b=iFlYwbDl19Uk9KncDXEFBjz6zi+2kPL8qxyR9gyUemDmvNvEWVpPOB+LjXZ6aGvciLOrWq
        ujdx2mvfgTiQ11OWKSAMdZKfLYvW4NKEvpiF3mZ479l3mahnhQ4lk4JZhoxg4Yzcv8Cy4T
        BGuVNl9VgaNIHy64maMme4dEOLSRBpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-g7w9rs5ePH-_T8T4m4czUA-1; Tue, 17 Dec 2019 06:32:35 -0500
X-MC-Unique: g7w9rs5ePH-_T8T4m4czUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A54F8024EA;
        Tue, 17 Dec 2019 11:32:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8205C1000325;
        Tue, 17 Dec 2019 11:32:33 +0000 (UTC)
Date:   Tue, 17 Dec 2019 06:32:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191217113231.GA48778@bfoster>
References: <20191216000541.GE99884@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216000541.GE99884@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 15, 2019 at 04:05:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> and swidth values could cause xfs_repair to fail loudly.  The problem
> here is that repair calculates the where mkfs should have allocated the
> root inode, based on the superblock geometry.  The allocation decisions
> depend on sunit, which means that we really can't go updating sunit if
> it would lead to a subsequent repair failure on an otherwise correct
> filesystem.
> 
> Port the computation code from xfs_repair and teach mount to avoid the
> ondisk update if it would cause problems for repair.  We allow the mount
> to proceed (and new allocations will reflect this new geometry) because
> we've never screened this kind of thing before.
> 
> [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> 
> Reported-by: Alex Lyakas <alex@zadara.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: actually check the alignment check function return value
> v2: v2: refactor the agfl length calculations, clarify the fsgeometry ioctl
> behavior, fix a bunch of the comments and make it clearer how we compute
> the rootino location
> ---
>  fs/xfs/libxfs/xfs_alloc.c  |   18 ++++++--
>  fs/xfs/libxfs/xfs_ialloc.c |   70 +++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    1 
>  fs/xfs/xfs_mount.c         |   99 +++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_trace.h         |   21 +++++++++
>  5 files changed, 175 insertions(+), 34 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 988cde7744e6..7b4e76c75c58 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2909,3 +2909,73 @@ xfs_ialloc_setup_geometry(
>  	else
>  		igeo->ialloc_align = 0;
>  }
> +
> +/*
> + * Compute the location of the root directory inode that is laid out by mkfs.
> + * The @sunit parameter will be copied from the superblock if it is negative.
> + */
> +xfs_ino_t
> +xfs_ialloc_calc_rootino(
> +	struct xfs_mount	*mp,
> +	int			sunit)
> +{
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	xfs_agblock_t		first_bno;
> +
> +	if (sunit < 0)
> +		sunit = mp->m_sb.sb_unit;
> +
> +	/*
> +	 * Pre-calculate the geometry of AG 0.  We know what it looks like
> +	 * because libxfs knows how to create allocation groups now.
> +	 *
> +	 * first_bno is the first block in which mkfs could possibly have
> +	 * allocated the root directory inode, once we factor in the metadata
> +	 * that mkfs formats before it.  Namely, the four AG headers...
> +	 */
> +	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
> +
> +	/* ...the two free space btree roots... */
> +	first_bno += 2;
> +
> +	/* ...the inode btree root... */
> +	first_bno += 1;
> +
> +	/* ...the initial AGFL... */
> +	first_bno += xfs_alloc_min_freelist(mp, NULL);
> +
> +	/* ...the free inode btree root... */
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		first_bno++;
> +
> +	/* ...the reverse mapping btree root... */
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		first_bno++;
> +
> +	/* ...the reference count btree... */
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		first_bno++;
> +
> +	/*
> +	 * ...and the log, if it is allocated in the first allocation group.
> +	 *
> +	 * This can happens with filesystems that only have a single

s/happens/happen/

> +	 * allocation group, or very odd geometries created by old mkfs
> +	 * versions on very small filesystems.
> +	 */
> +	if (mp->m_sb.sb_logstart &&
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
> +		 first_bno += mp->m_sb.sb_logblocks;
> +
> +	/*
> +	 * Now round first_bno up to whatever allocation alignment is given
> +	 * by the filesystem or was passed in.
> +	 */
> +	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
> +		first_bno = roundup(first_bno, sunit);
> +	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +			mp->m_sb.sb_inoalignmt > 1)
> +		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
> +
> +	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 323592d563d5..72b3468b97b1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
...
> @@ -359,15 +359,55 @@ xfs_readsb(
>  	return error;
>  }
>  
> +/*
> + * If the sunit/swidth change would move the precomputed root inode value, we
> + * must reject the ondisk change because repair will stumble over that.
> + * However, we allow the mount to proceed because we never rejected this
> + * combination before.  Returns true to update the sb, false otherwise.
> + */
> +static inline int
> +xfs_check_new_dalign(
> +	struct xfs_mount	*mp,
> +	int			new_dalign,
> +	bool			*update_sb)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	xfs_ino_t		calc_ino;
> +
> +	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
> +	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
> +
> +	if (sbp->sb_rootino == calc_ino) {
> +		*update_sb = true;
> +		return 0;
> +	}
> +
> +	xfs_warn(mp,
> +"Cannot change stripe alignment; would require moving root inode.");
> +
> +	/*
> +	 * XXX: Next time we add a new incompat feature, this should start
> +	 * returning -EINVAL to fail the mount.  Until then, spit out a warning
> +	 * that we're ignoring the administrator's instructions.
> +	 */
> +	xfs_warn(mp, "Skipping superblock stripe alignment update.");
> +	*update_sb = false;
> +	return 0;
> +}

I ran a quick test changing swidth (not sunit) and otherwise using mkfs
defaults:

[root@localhost ~]# mkfs.xfs -f /dev/test/scratch -dsunit=8,swidth=8
meta-data=/dev/test/scratch      isize=512    agcount=16, agsize=245760 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=1      swidth=1 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@localhost ~]# mount /dev/test/scratch /mnt/
[root@localhost ~]# stat -c %i /mnt/
128
[root@localhost ~]# umount  /mnt/
[root@localhost ~]# mount /dev/test/scratch /mnt/ -o sunit=8,swidth=16

I see the following trace output on the mount above, which suggests this
would have moved rootino:

<...>-1007  [002] ...1   516.719543: xfs_check_new_dalign: dev 253:4 new_dalign 1 sb_rootino 128 calc_rootino 80

But if I start with that geometry, that's not what I see from mkfs:

[root@localhost ~]# mkfs.xfs -f /dev/test/scratch -dsunit=8,swidth=16
meta-data=/dev/test/scratch      isize=512    agcount=16, agsize=245759 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3932144, imaxpct=25
         =                       sunit=1      swidth=2 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@localhost ~]# mount /dev/test/scratch /mnt/
[root@localhost ~]# stat -c %i /mnt/
128

I did notice the AG size changes slightly in the second mkfs, but it
doesn't seem to make a difference if I set it back to the original
value. Hm?

BTW, given the subtle effect of this patch and potential for varying
behavior, I wonder if we should have an fstest to format with some
different alignments and make sure mount DTRT in various cases.

Brian

> +
>  /*
>   * Update alignment values based on mount options and sb values
>   */
>  STATIC int
> -xfs_update_alignment(xfs_mount_t *mp)
> +xfs_update_alignment(
> +	struct xfs_mount	*mp)
>  {
> -	xfs_sb_t	*sbp = &(mp->m_sb);
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  
>  	if (mp->m_dalign) {
> +		bool		update_sb;
> +		int		error;
> +
>  		/*
>  		 * If stripe unit and stripe width are not multiples
>  		 * of the fs blocksize turn off alignment.
> @@ -398,28 +438,28 @@ xfs_update_alignment(xfs_mount_t *mp)
>  			}
>  		}
>  
> -		/*
> -		 * Update superblock with new values
> -		 * and log changes
> -		 */
> -		if (xfs_sb_version_hasdalign(sbp)) {
> -			if (sbp->sb_unit != mp->m_dalign) {
> -				sbp->sb_unit = mp->m_dalign;
> -				mp->m_update_sb = true;
> -			}
> -			if (sbp->sb_width != mp->m_swidth) {
> -				sbp->sb_width = mp->m_swidth;
> -				mp->m_update_sb = true;
> -			}
> -		} else {
> +		/* Update superblock with new values and log changes. */
> +		if (!xfs_sb_version_hasdalign(sbp)) {
>  			xfs_warn(mp,
>  	"cannot change alignment: superblock does not support data alignment");
>  			return -EINVAL;
>  		}
> +
> +		if (sbp->sb_unit == mp->m_dalign &&
> +		    sbp->sb_width == mp->m_swidth)
> +			return 0;
> +
> +		error = xfs_check_new_dalign(mp, mp->m_dalign, &update_sb);
> +		if (error || !update_sb)
> +			return error;
> +
> +		sbp->sb_unit = mp->m_dalign;
> +		sbp->sb_width = mp->m_swidth;
> +		mp->m_update_sb = true;
>  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
>  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> -			mp->m_dalign = sbp->sb_unit;
> -			mp->m_swidth = sbp->sb_width;
> +		mp->m_dalign = sbp->sb_unit;
> +		mp->m_swidth = sbp->sb_width;
>  	}
>  
>  	return 0;
> @@ -647,16 +687,6 @@ xfs_mountfs(
>  		mp->m_update_sb = true;
>  	}
>  
> -	/*
> -	 * Check if sb_agblocks is aligned at stripe boundary
> -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> -	 * allocator alignment is within an ag, therefore ag has
> -	 * to be aligned at stripe boundary.
> -	 */
> -	error = xfs_update_alignment(mp);
> -	if (error)
> -		goto out;
> -
>  	xfs_alloc_compute_maxlevels(mp);
>  	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>  	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> @@ -664,6 +694,17 @@ xfs_mountfs(
>  	xfs_rmapbt_compute_maxlevels(mp);
>  	xfs_refcountbt_compute_maxlevels(mp);
>  
> +	/*
> +	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
> +	 * is NOT aligned turn off m_dalign since allocator alignment is within
> +	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
> +	 * we must compute the free space and rmap btree geometry before doing
> +	 * this.
> +	 */
> +	error = xfs_update_alignment(mp);
> +	if (error)
> +		goto out;
> +
>  	/* enable fail_at_unmount as default */
>  	mp->m_fail_unmount = true;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c13bb3655e48..a86be7f807ee 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
>  DEFINE_KMEM_EVENT(kmem_realloc);
>  DEFINE_KMEM_EVENT(kmem_zone_alloc);
>  
> +TRACE_EVENT(xfs_check_new_dalign,
> +	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> +	TP_ARGS(mp, new_dalign, calc_rootino),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(int, new_dalign)
> +		__field(xfs_ino_t, sb_rootino)
> +		__field(xfs_ino_t, calc_rootino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->new_dalign = new_dalign;
> +		__entry->sb_rootino = mp->m_sb.sb_rootino;
> +		__entry->calc_rootino = calc_rootino;
> +	),
> +	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->new_dalign, __entry->sb_rootino,
> +		  __entry->calc_rootino)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

