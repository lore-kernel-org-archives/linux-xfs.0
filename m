Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5128C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 16:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D97E2077B
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 16:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GwaAqPUc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfLDQvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 11:51:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37936 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDQvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 11:51:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GTM9i180429;
        Wed, 4 Dec 2019 16:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Z7nPd6IqlL1YBgDZMV1yv4pCe8asSrOMlT4tp6PnOmM=;
 b=GwaAqPUcoOXPZLTirWE22FqSgCLN9dyEwZ9b+896FZJdmDwBT6oPLDVYgBpY4Tr8h5Sd
 +g2/Dq3tURi7GwEiZ0L5SEr+efBOb3cdWWPGIsB4QWt3yYAc8sjbYRnku6g732o56vlj
 jqBCCTEQlTIcr7L1tSRVEcgKhiCAwngvqCTEAEpB1p1IFwbNMvTQohw4cLzn3t8KVf0h
 BThmpFWkQGTsCwHQoYptWcfngfsU3ihn89gwTJSV0gl1jIGytetnd4Q+RGAIPYXACJlt
 G7lNR52dc+kepCdVMYcU3hI4RKXHzwSN6EyuD5symGgjHxw6m042ipv5+e6Xtj2Grmg7 sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wkfuuftvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 16:51:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GY8Y2087912;
        Wed, 4 Dec 2019 16:51:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wp20cmgn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 16:51:46 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB4GpiSY016805;
        Wed, 4 Dec 2019 16:51:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 08:51:44 -0800
Date:   Wed, 4 Dec 2019 08:51:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>
Subject: Re: [RFC PATCH] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191204165142.GQ7335@magnolia>
References: <20191202173538.GD7335@magnolia>
 <20191202212140.GG2695@dread.disaster.area>
 <20191203023041.GH7335@magnolia>
 <20191203212136.GK2695@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203212136.GK2695@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 08:21:36AM +1100, Dave Chinner wrote:
> On Mon, Dec 02, 2019 at 06:30:41PM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 03, 2019 at 08:21:40AM +1100, Dave Chinner wrote:
> > > On Mon, Dec 02, 2019 at 09:35:38AM -0800, Darrick J. Wong wrote:
> > > > diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> > > > index 323592d563d5..9d9fe7b488b8 100644
> > > > --- a/fs/xfs/libxfs/xfs_ialloc.h
> > > > +++ b/fs/xfs/libxfs/xfs_ialloc.h
> > > > @@ -152,5 +152,7 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
> > > >  
> > > >  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
> > > >  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> > > > +void xfs_ialloc_find_prealloc(struct xfs_mount *mp, xfs_agino_t *first_agino,
> > > > +		xfs_agino_t *last_agino);
> > > >  
> > > >  #endif	/* __XFS_IALLOC_H__ */
> > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > index 7b35d62ede9f..d830a9e13817 100644
> > > > --- a/fs/xfs/xfs_ioctl.c
> > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > @@ -891,6 +891,9 @@ xfs_ioc_fsgeometry(
> > > >  
> > > >  	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
> > > >  
> > > > +	fsgeo.sunit = mp->m_sb.sb_unit;
> > > > +	fsgeo.swidth = mp->m_sb.sb_width;
> > > 
> > > Why?
> > 
> > This was in keeping with Alex' suggestion to use the sunit values incore
> > even if we don't update the superblock.
> 
> Not sure about that. If we are getting the geometry for the purposes
> of working out where something is on disk (e.g. the root inode :),
> then we need what is in the superblock, not what is in memory...
> 
> > > > +		if (sbp->sb_unit == mp->m_dalign &&
> > > > +		    sbp->sb_width == mp->m_swidth)
> > > > +			return 0;
> > > > +
> > > > +		old_su = sbp->sb_unit;
> > > > +		old_sw = sbp->sb_width;
> > > > +		sbp->sb_unit = mp->m_dalign;
> > > > +		sbp->sb_width = mp->m_swidth;
> > > > +		xfs_ialloc_find_prealloc(mp, &first, &last);
> > > 
> > > We just chuck last away? why calculate it then?
> > 
> > Hmmm.  Repair uses it to silence the "inode chunk claims used block"
> > error if an inobt record points to something owned by XR_E_INUSE_FS* if
> > the inode points to something in that first chunk.  Not sure /why/ it
> > does that; it seems to have done that since the creation of the git
> > repo.
> 
> Hysterical raisins that have long since decomposed, I'm guessing....

<nod> I'll nuke it then.

> > Frankly, I'm not convinced that's the right behavior; the root inode
> > chunk should never collide with something else, period.
> 
> *nod*
> 
> I suspect the way repair uses the last_prealloc_ino can go away,
> especially as the inode number calculated is not correct in the
> first place...
> 
> > > And why not just
> > > pass mp->m_dalign/mp->m_swidth into the function rather than setting
> > > them in the sb and then having to undo the change? i.e.
> > > 
> > > 		rootino = xfs_ialloc_calc_rootino(mp, mp->m_dalign, mp->m_swidth);
> > 
> > <shrug> The whole point was to create a function that computes where the
> > first allocated inode chunk should be from an existing mountpoint and
> > superblock, maybe the caller should make a copy, update the parameters,
> > and then pass the copy into this function?
> 
> That's a whole lot of cruft that we can avoid just by passing in
> our specific stripe alignment.
> 
> What we need to kow is whether a specific stripe geometry will
> result in the root inode location changing, and so I'm of the
> opinion we should just write a function that calculates the location
> based on the supplied geometry and the caller can do whatever checks
> it needs to with the inode number returned.
> 
> That provides what both repair and the kernel mount validation
> requires...

Done.

> 
> > > Should this also return EINVAL, as per above when the DALIGN sb
> > > feature bit is not set?
> > 
> > I dunno.  We've never rejected these mount options before, which makes
> > me a little hesitant to break everybody's scripts, even if it /is/
> > improper behavior that leads to repair failure.  We /do/ have the option
> > that Alex suggested of modifying the incore values to change the
> > allocator behavior without committing them to the superblock, which is
> > what this patch does.
> > 
> > OTOH the manual pages say that you're not supposed to do this, which
> > might be a strong enough reason to start banning it.
> > 
> > Thoughts?
> 
> On second thoughts, knowing that many users have put sunit/swidth in
> their fstab, we probably shouldn't make it return an error as that
> may make their systems unbootable.

For now I'll add an XXX comment about how the next time we add a new
incompat feature we should make it start returning EINVAL if that
feature is enabled.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
