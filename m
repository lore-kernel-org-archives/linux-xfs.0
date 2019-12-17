Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B04C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 21:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 616232082E
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 21:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Huo6oAhE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfLQVkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 16:40:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfLQVks (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 16:40:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHLdEpw048962;
        Tue, 17 Dec 2019 21:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5bxnkBv08l5xMx2tWlysderSlZpIg34Dax5kFyVQ1K8=;
 b=Huo6oAhEpqs9/q+K+H3xN7afsl6jMDjQGxG5YipjqQPnhcrQEEOkUMOU++zhMCfXpEp/
 4PI9iKL7C6Rx8jsCf/F39kRdusgvg8UBpZbZ/F31iIaebAecWqwlYthnuOH09h9XHmSc
 veo3aYB/T4hngobkh7N1xTqmzeNpjrUeMaZya1q+gGCcoa8iHbAtvkbKueDM3q+KZ6cB
 6Qopt1XrKlPaCVdv8PR6zhnbpTwjFsb47rM3eVQXZf2UBmKS8QdOMGzmswuxY5aaBn/m
 EWrg1Jm/r0OJ/XDdbEVo5TOF5Rru0X7Cw9N5yhrVHW34tCSICV6bDkhpDKZvC88CGOQD HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wvqpq9hvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 21:40:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHLe35S077451;
        Tue, 17 Dec 2019 21:40:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wxm5kpf1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 21:40:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBHLefqJ012351;
        Tue, 17 Dec 2019 21:40:41 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 13:40:41 -0800
Date:   Tue, 17 Dec 2019 13:40:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191217214040.GG12766@magnolia>
References: <20191216000541.GE99884@magnolia>
 <20191217113231.GA48778@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217113231.GA48778@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 06:32:31AM -0500, Brian Foster wrote:
> On Sun, Dec 15, 2019 at 04:05:41PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> > and swidth values could cause xfs_repair to fail loudly.  The problem
> > here is that repair calculates the where mkfs should have allocated the
> > root inode, based on the superblock geometry.  The allocation decisions
> > depend on sunit, which means that we really can't go updating sunit if
> > it would lead to a subsequent repair failure on an otherwise correct
> > filesystem.
> > 
> > Port the computation code from xfs_repair and teach mount to avoid the
> > ondisk update if it would cause problems for repair.  We allow the mount
> > to proceed (and new allocations will reflect this new geometry) because
> > we've never screened this kind of thing before.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> > 
> > Reported-by: Alex Lyakas <alex@zadara.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v3: actually check the alignment check function return value
> > v2: v2: refactor the agfl length calculations, clarify the fsgeometry ioctl
> > behavior, fix a bunch of the comments and make it clearer how we compute
> > the rootino location
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c  |   18 ++++++--
> >  fs/xfs/libxfs/xfs_ialloc.c |   70 +++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_ialloc.h |    1 
> >  fs/xfs/xfs_mount.c         |   99 +++++++++++++++++++++++++++++++-------------
> >  fs/xfs/xfs_trace.h         |   21 +++++++++
> >  5 files changed, 175 insertions(+), 34 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 988cde7744e6..7b4e76c75c58 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2909,3 +2909,73 @@ xfs_ialloc_setup_geometry(
> >  	else
> >  		igeo->ialloc_align = 0;
> >  }
> > +
> > +/*
> > + * Compute the location of the root directory inode that is laid out by mkfs.
> > + * The @sunit parameter will be copied from the superblock if it is negative.
> > + */
> > +xfs_ino_t
> > +xfs_ialloc_calc_rootino(
> > +	struct xfs_mount	*mp,
> > +	int			sunit)
> > +{
> > +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> > +	xfs_agblock_t		first_bno;
> > +
> > +	if (sunit < 0)
> > +		sunit = mp->m_sb.sb_unit;
> > +
> > +	/*
> > +	 * Pre-calculate the geometry of AG 0.  We know what it looks like
> > +	 * because libxfs knows how to create allocation groups now.
> > +	 *
> > +	 * first_bno is the first block in which mkfs could possibly have
> > +	 * allocated the root directory inode, once we factor in the metadata
> > +	 * that mkfs formats before it.  Namely, the four AG headers...
> > +	 */
> > +	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
> > +
> > +	/* ...the two free space btree roots... */
> > +	first_bno += 2;
> > +
> > +	/* ...the inode btree root... */
> > +	first_bno += 1;
> > +
> > +	/* ...the initial AGFL... */
> > +	first_bno += xfs_alloc_min_freelist(mp, NULL);
> > +
> > +	/* ...the free inode btree root... */
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		first_bno++;
> > +
> > +	/* ...the reverse mapping btree root... */
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		first_bno++;
> > +
> > +	/* ...the reference count btree... */
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		first_bno++;
> > +
> > +	/*
> > +	 * ...and the log, if it is allocated in the first allocation group.
> > +	 *
> > +	 * This can happens with filesystems that only have a single
> 
> s/happens/happen/

Fixed, thanks.

> > +	 * allocation group, or very odd geometries created by old mkfs
> > +	 * versions on very small filesystems.
> > +	 */
> > +	if (mp->m_sb.sb_logstart &&
> > +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
> > +		 first_bno += mp->m_sb.sb_logblocks;
> > +
> > +	/*
> > +	 * Now round first_bno up to whatever allocation alignment is given
> > +	 * by the filesystem or was passed in.
> > +	 */
> > +	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
> > +		first_bno = roundup(first_bno, sunit);
> > +	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> > +			mp->m_sb.sb_inoalignmt > 1)
> > +		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
> > +
> > +	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> > index 323592d563d5..72b3468b97b1 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.h
> > +++ b/fs/xfs/libxfs/xfs_ialloc.h
> ...
> > @@ -359,15 +359,55 @@ xfs_readsb(
> >  	return error;
> >  }
> >  
> > +/*
> > + * If the sunit/swidth change would move the precomputed root inode value, we
> > + * must reject the ondisk change because repair will stumble over that.
> > + * However, we allow the mount to proceed because we never rejected this
> > + * combination before.  Returns true to update the sb, false otherwise.
> > + */
> > +static inline int
> > +xfs_check_new_dalign(
> > +	struct xfs_mount	*mp,
> > +	int			new_dalign,
> > +	bool			*update_sb)
> > +{
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> > +	xfs_ino_t		calc_ino;
> > +
> > +	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
> > +	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
> > +
> > +	if (sbp->sb_rootino == calc_ino) {
> > +		*update_sb = true;
> > +		return 0;
> > +	}
> > +
> > +	xfs_warn(mp,
> > +"Cannot change stripe alignment; would require moving root inode.");
> > +
> > +	/*
> > +	 * XXX: Next time we add a new incompat feature, this should start
> > +	 * returning -EINVAL to fail the mount.  Until then, spit out a warning
> > +	 * that we're ignoring the administrator's instructions.
> > +	 */
> > +	xfs_warn(mp, "Skipping superblock stripe alignment update.");
> > +	*update_sb = false;
> > +	return 0;
> > +}
> 
> I ran a quick test changing swidth (not sunit) and otherwise using mkfs
> defaults:
> 
> [root@localhost ~]# mkfs.xfs -f /dev/test/scratch -dsunit=8,swidth=8
> meta-data=/dev/test/scratch      isize=512    agcount=16, agsize=245760 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=3932160, imaxpct=25
>          =                       sunit=1      swidth=1 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> [root@localhost ~]# mount /dev/test/scratch /mnt/
> [root@localhost ~]# stat -c %i /mnt/
> 128
> [root@localhost ~]# umount  /mnt/
> [root@localhost ~]# mount /dev/test/scratch /mnt/ -o sunit=8,swidth=16
> 
> I see the following trace output on the mount above, which suggests this
> would have moved rootino:
> 
> <...>-1007  [002] ...1   516.719543: xfs_check_new_dalign: dev 253:4 new_dalign 1 sb_rootino 128 calc_rootino 80
> 
> But if I start with that geometry, that's not what I see from mkfs:
> 
> [root@localhost ~]# mkfs.xfs -f /dev/test/scratch -dsunit=8,swidth=16
> meta-data=/dev/test/scratch      isize=512    agcount=16, agsize=245759 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=3932144, imaxpct=25
>          =                       sunit=1      swidth=2 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> [root@localhost ~]# mount /dev/test/scratch /mnt/
> [root@localhost ~]# stat -c %i /mnt/
> 128
> 
> I did notice the AG size changes slightly in the second mkfs, but it
> doesn't seem to make a difference if I set it back to the original
> value. Hm?

Aha, I discovered a bug in this patch -- the sunit mount option value
has to be converted from BB to FSB before setting up the ialloc
geometry.  If the fs was formatted with a stripe unit of 1FSB the
incorrect units being and'd with inoalign_mask would cause the ialloc
geometry computation to set ialloc_align to zero, which would then make
the calc_rootino function output wrong values.

> BTW, given the subtle effect of this patch and potential for varying
> behavior, I wonder if we should have an fstest to format with some
> different alignments and make sure mount DTRT in various cases.

I /do/ have an fstest, but it didn't cover the su=1fsb case.  I'll
update it and send both v4 patch and test once this goes through
fstests.

--D

> Brian
> 
> > +
> >  /*
> >   * Update alignment values based on mount options and sb values
> >   */
> >  STATIC int
> > -xfs_update_alignment(xfs_mount_t *mp)
> > +xfs_update_alignment(
> > +	struct xfs_mount	*mp)
> >  {
> > -	xfs_sb_t	*sbp = &(mp->m_sb);
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> >  
> >  	if (mp->m_dalign) {
> > +		bool		update_sb;
> > +		int		error;
> > +
> >  		/*
> >  		 * If stripe unit and stripe width are not multiples
> >  		 * of the fs blocksize turn off alignment.
> > @@ -398,28 +438,28 @@ xfs_update_alignment(xfs_mount_t *mp)
> >  			}
> >  		}
> >  
> > -		/*
> > -		 * Update superblock with new values
> > -		 * and log changes
> > -		 */
> > -		if (xfs_sb_version_hasdalign(sbp)) {
> > -			if (sbp->sb_unit != mp->m_dalign) {
> > -				sbp->sb_unit = mp->m_dalign;
> > -				mp->m_update_sb = true;
> > -			}
> > -			if (sbp->sb_width != mp->m_swidth) {
> > -				sbp->sb_width = mp->m_swidth;
> > -				mp->m_update_sb = true;
> > -			}
> > -		} else {
> > +		/* Update superblock with new values and log changes. */
> > +		if (!xfs_sb_version_hasdalign(sbp)) {
> >  			xfs_warn(mp,
> >  	"cannot change alignment: superblock does not support data alignment");
> >  			return -EINVAL;
> >  		}
> > +
> > +		if (sbp->sb_unit == mp->m_dalign &&
> > +		    sbp->sb_width == mp->m_swidth)
> > +			return 0;
> > +
> > +		error = xfs_check_new_dalign(mp, mp->m_dalign, &update_sb);
> > +		if (error || !update_sb)
> > +			return error;
> > +
> > +		sbp->sb_unit = mp->m_dalign;
> > +		sbp->sb_width = mp->m_swidth;
> > +		mp->m_update_sb = true;
> >  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
> >  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> > -			mp->m_dalign = sbp->sb_unit;
> > -			mp->m_swidth = sbp->sb_width;
> > +		mp->m_dalign = sbp->sb_unit;
> > +		mp->m_swidth = sbp->sb_width;
> >  	}
> >  
> >  	return 0;
> > @@ -647,16 +687,6 @@ xfs_mountfs(
> >  		mp->m_update_sb = true;
> >  	}
> >  
> > -	/*
> > -	 * Check if sb_agblocks is aligned at stripe boundary
> > -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> > -	 * allocator alignment is within an ag, therefore ag has
> > -	 * to be aligned at stripe boundary.
> > -	 */
> > -	error = xfs_update_alignment(mp);
> > -	if (error)
> > -		goto out;
> > -
> >  	xfs_alloc_compute_maxlevels(mp);
> >  	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> >  	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> > @@ -664,6 +694,17 @@ xfs_mountfs(
> >  	xfs_rmapbt_compute_maxlevels(mp);
> >  	xfs_refcountbt_compute_maxlevels(mp);
> >  
> > +	/*
> > +	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
> > +	 * is NOT aligned turn off m_dalign since allocator alignment is within
> > +	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
> > +	 * we must compute the free space and rmap btree geometry before doing
> > +	 * this.
> > +	 */
> > +	error = xfs_update_alignment(mp);
> > +	if (error)
> > +		goto out;
> > +
> >  	/* enable fail_at_unmount as default */
> >  	mp->m_fail_unmount = true;
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index c13bb3655e48..a86be7f807ee 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
> >  DEFINE_KMEM_EVENT(kmem_realloc);
> >  DEFINE_KMEM_EVENT(kmem_zone_alloc);
> >  
> > +TRACE_EVENT(xfs_check_new_dalign,
> > +	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> > +	TP_ARGS(mp, new_dalign, calc_rootino),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(int, new_dalign)
> > +		__field(xfs_ino_t, sb_rootino)
> > +		__field(xfs_ino_t, calc_rootino)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->new_dalign = new_dalign;
> > +		__entry->sb_rootino = mp->m_sb.sb_rootino;
> > +		__entry->calc_rootino = calc_rootino;
> > +	),
> > +	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->new_dalign, __entry->sb_rootino,
> > +		  __entry->calc_rootino)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> 
