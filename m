Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9B4C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 02:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E455F206DC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 02:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sg4o39Xa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCCar (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 21:30:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53454 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLCCar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 21:30:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32NwtE064627;
        Tue, 3 Dec 2019 02:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9SuIJMSBl8VUeeuPs3qIg6EDf0/i04ULRPlOkX42K3w=;
 b=sg4o39Xa6OfBGEcCZseaisAJXJvjdDUAwMRYaysPElRXJWR3xO+XcQn7i8LTZu/qgIs8
 QwXtjA0N75x2iIxjZL6K1Vm0mfUGk2TunfUgGduIXQ5qwXn1YphwHLN97ivHUuqK2Mmq
 v4Er6h4BXmGyNlaFKLQ+h1wmsxElA1Q/djHyEP72CKDN9HUeLS7lKgFITm4RoyFEEB/A
 ZPwWc4E1DJbKgoqAMj4P7RHdirwv3Ef6kkhBbs/rYiZL++mAkOToGGJ6jTFdWLv4S9gz
 kWuus+J4dL/+MZzRQRVCNoaDzNUqwkl5X97MIR742luWoDYTtZz0yESaCX89P3+EmOGN 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wkh2r43hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:30:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32NDdJ062422;
        Tue, 3 Dec 2019 02:30:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wn4qntd05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:30:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB32UgKs007923;
        Tue, 3 Dec 2019 02:30:42 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 18:30:42 -0800
Date:   Mon, 2 Dec 2019 18:30:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>
Subject: Re: [RFC PATCH] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191203023041.GH7335@magnolia>
References: <20191202173538.GD7335@magnolia>
 <20191202212140.GG2695@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202212140.GG2695@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 08:21:40AM +1100, Dave Chinner wrote:
> On Mon, Dec 02, 2019 at 09:35:38AM -0800, Darrick J. Wong wrote:
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
> ....
> > +/*
> > + * Compute the first and last inodes numbers of the inode chunk that was
> > + * preallocated for the root directory.
> > + */
> > +void
> > +xfs_ialloc_find_prealloc(
> > +	struct xfs_mount	*mp,
> > +	xfs_agino_t		*first_agino,
> > +	xfs_agino_t		*last_agino)
> > +{
> > +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> > +	xfs_agblock_t		first_bno;
> > +
> > +	/*
> > +	 * Pre-calculate the geometry of ag 0. We know what it looks like
> > +	 * because we know what mkfs does: 2 allocation btree roots (by block
> > +	 * and by size), the inode allocation btree root, the free inode
> > +	 * allocation btree root (if enabled) and some number of blocks to
> > +	 * prefill the agfl.
> > +	 *
> > +	 * Because the current shape of the btrees may differ from the current
> > +	 * shape, we open code the mkfs freelist block count here. mkfs creates
> > +	 * single level trees, so the calculation is pertty straight forward for
> 
> pretty.
> 
> > +	 * the trees that use the AGFL.
> > +	 */
> > +
> > +	/* free space by block btree root comes after the ag headers */
> > +	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
> > +
> > +	/* free space by length btree root */
> > +	first_bno += 1;
> > +
> > +	/* inode btree root */
> > +	first_bno += 1;
> > +
> > +	/* agfl */
> > +	first_bno += (2 * min(2U, mp->m_ag_maxlevels)) + 1;
> 
> min_t(xfs_agblock_t, 2, mp->m_ag_maxlevels) ?
> 
> > +
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > +		first_bno++;
> > +
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +		first_bno += min(2U, mp->m_rmap_maxlevels); /* agfl blocks */
> 
> same.

Fixed all three.

> > +		first_bno++;
> > +	}
> > +
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		first_bno++;
> > +
> > +	/*
> > +	 * If the log is allocated in the first allocation group we need to
> > +	 * add the number of blocks used by the log to the above calculation.
> > +	 *
> > +	 * This can happens with filesystems that only have a single
> > +	 * allocation group, or very odd geometries created by old mkfs
> > +	 * versions on very small filesystems.
> > +	 */
> > +	if (mp->m_sb.sb_logstart &&
> > +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0) {
> > +
> > +		/*
> > +		 * XXX(hch): verify that sb_logstart makes sense?
> > +		 */
> > +		 first_bno += mp->m_sb.sb_logblocks;
> > +	}
> > +
> > +	/*
> > +	 * ditto the location of the first inode chunks in the fs ('/')
> > +	 */
> > +	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0) {
> > +		*first_agino = XFS_AGB_TO_AGINO(mp,
> > +				roundup(first_bno, mp->m_sb.sb_unit));
> > +	} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> > +		   mp->m_sb.sb_inoalignmt > 1)  {
> > +		*first_agino = XFS_AGB_TO_AGINO(mp,
> > +				roundup(first_bno, mp->m_sb.sb_inoalignmt));
> > +	} else  {
> > +		*first_agino = XFS_AGB_TO_AGINO(mp, first_bno);
> > +	}
> > +
> > +	ASSERT(igeo->ialloc_blks > 0);
> > +
> > +	if (igeo->ialloc_blks > 1)
> > +		*last_agino = *first_agino + XFS_INODES_PER_CHUNK;
> > +	else
> > +		*last_agino = XFS_AGB_TO_AGINO(mp, first_bno + 1);
> 
> Isn't last_agino of the first inode of the next chunk? i.e. this is
> an off-by-one...

Yep.  It's also an off-by-one error in repair...

> > +}
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> > index 323592d563d5..9d9fe7b488b8 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.h
> > +++ b/fs/xfs/libxfs/xfs_ialloc.h
> > @@ -152,5 +152,7 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
> >  
> >  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
> >  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> > +void xfs_ialloc_find_prealloc(struct xfs_mount *mp, xfs_agino_t *first_agino,
> > +		xfs_agino_t *last_agino);
> >  
> >  #endif	/* __XFS_IALLOC_H__ */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 7b35d62ede9f..d830a9e13817 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -891,6 +891,9 @@ xfs_ioc_fsgeometry(
> >  
> >  	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
> >  
> > +	fsgeo.sunit = mp->m_sb.sb_unit;
> > +	fsgeo.swidth = mp->m_sb.sb_width;
> 
> Why?

This was in keeping with Alex' suggestion to use the sunit values incore
even if we don't update the superblock.

> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index fca65109cf24..0323a89256c7 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -368,6 +368,11 @@ xfs_update_alignment(xfs_mount_t *mp)
> >  	xfs_sb_t	*sbp = &(mp->m_sb);
> >  
> >  	if (mp->m_dalign) {
> > +		uint32_t	old_su;
> > +		uint32_t	old_sw;
> > +		xfs_agino_t	first;
> > +		xfs_agino_t	last;
> > +
> >  		/*
> >  		 * If stripe unit and stripe width are not multiples
> >  		 * of the fs blocksize turn off alignment.
> > @@ -398,24 +403,38 @@ xfs_update_alignment(xfs_mount_t *mp)
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
> > +		old_su = sbp->sb_unit;
> > +		old_sw = sbp->sb_width;
> > +		sbp->sb_unit = mp->m_dalign;
> > +		sbp->sb_width = mp->m_swidth;
> > +		xfs_ialloc_find_prealloc(mp, &first, &last);
> 
> We just chuck last away? why calculate it then?

Hmmm.  Repair uses it to silence the "inode chunk claims used block"
error if an inobt record points to something owned by XR_E_INUSE_FS* if
the inode points to something in that first chunk.  Not sure /why/ it
does that; it seems to have done that since the creation of the git
repo.

Frankly, I'm not convinced that's the right behavior; the root inode
chunk should never collide with something else, period.

> And why not just
> pass mp->m_dalign/mp->m_swidth into the function rather than setting
> them in the sb and then having to undo the change? i.e.
> 
> 		rootino = xfs_ialloc_calc_rootino(mp, mp->m_dalign, mp->m_swidth);

<shrug> The whole point was to create a function that computes where the
first allocated inode chunk should be from an existing mountpoint and
superblock, maybe the caller should make a copy, update the parameters,
and then pass the copy into this function?

> 		if (sbp->sb_rootino != rootino) {
> 			.....
> 		}
> > +
> > +		/*
> > +		 * If the sunit/swidth change would move the precomputed root
> > +		 * inode value, we must reject the ondisk change because repair
> > +		 * will stumble over that.  However, we allow the mount to
> > +		 * proceed because we never rejected this combination before.
> > +		 */
> > +		if (sbp->sb_rootino != XFS_AGINO_TO_INO(mp, 0, first)) {
> > +			sbp->sb_unit = old_su;
> > +			sbp->sb_width = old_sw;
> > +			xfs_warn(mp,
> > +	"cannot change alignment: would require moving root inode");
> 
> "cannot change stripe alignment: ..." ?

Ok.

> Should this also return EINVAL, as per above when the DALIGN sb
> feature bit is not set?

I dunno.  We've never rejected these mount options before, which makes
me a little hesitant to break everybody's scripts, even if it /is/
improper behavior that leads to repair failure.  We /do/ have the option
that Alex suggested of modifying the incore values to change the
allocator behavior without committing them to the superblock, which is
what this patch does.

OTOH the manual pages say that you're not supposed to do this, which
might be a strong enough reason to start banning it.

Thoughts?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
