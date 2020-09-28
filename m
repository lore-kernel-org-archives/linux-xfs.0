Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A729C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 17:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C9502075A
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 17:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OIiQu4BE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgI1REo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:04:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgI1REo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 13:04:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SGx0aZ155388;
        Mon, 28 Sep 2020 17:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LQgvD1IbNREb2o2kDscQV4qXAsNi2e0eiqFJr5yH/nU=;
 b=OIiQu4BE6RxpOB8BNj3zFAwOMh103xKZo/OU+oD65pmvNoAHbnl36JYPFPgpUvx3aUrC
 kF77GrroOHDKSk+kQP1LVkCe9a9SBLUTsmqgiOm2LP0xz9Sk3UpAwzTuu3W/VEMKfM3u
 uucfrLERax0eNEvU1J9Y7c1zlEhKfhFBeU/3jgunTR0xSm5EGgJn8Zb3w5jOF54D4cFe
 gGuIX/cOmF5ED9aMTGTrqgZ/Up5Xk90KJTQV4RMJQtxqPm6zipWCzlkCdz+4fZzNdge+
 Kl5+Tvn19ijp6i2e1cjPJEwh6ohuPMxJoumNGlnuiNk+EFiIcDuHs/otmDIC7ox6hDlh xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9mx6q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 17:04:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SGxfhi138235;
        Mon, 28 Sep 2020 17:02:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33tfjvavdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 17:02:39 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SH2cUt005061;
        Mon, 28 Sep 2020 17:02:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 10:02:35 -0700
Date:   Mon, 28 Sep 2020 10:02:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200928170234.GB49547@magnolia>
References: <160125009588.174612.13196702491335373645.stgit@magnolia>
 <160125011691.174612.13255814016601281607.stgit@magnolia>
 <20200928061046.GG14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928061046.GG14422@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280132
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 04:10:46PM +1000, Dave Chinner wrote:
> On Sun, Sep 27, 2020 at 04:41:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_bui_item_recover, there exists a use-after-free bug with regards
> > to the inode that is involved in the bmap replay operation.  If the
> > mapping operation does not complete, we call xfs_bmap_unmap_extent to
> > create a deferred op to finish the unmapping work, and we retain a
> > pointer to the incore inode.
> > 
> > Unfortunately, the very next thing we do is commit the transaction and
> > drop the inode.  If reclaim tears down the inode before we try to finish
> > the defer ops, we dereference garbage and blow up.  Therefore, create a
> > way to join inodes to the defer ops freezer so that we can maintain the
> > xfs_inode reference until we're done with the inode.
> 
> Honest first reaction now I understand what the capture stuff is
> doing: Ewww! Gross!

Yes, the whole thing is gross.  Honestly, I wish I could go back in time
to 2016 to warn myself that we would need a way to reassemble entire
runtime transactions + dfops chains so that we could avoid all this.

> We only need to store a single inode, so the whole "2 inodes for
> symmetry with defer_ops" greatly overcomplicates the code. This
> could be *much* simpler.

Indeed, see my comment at the very end.

> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index deb99300d171..c7f65e16534f 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -12,6 +12,7 @@
> >  #include "xfs_sb.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_defer.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_trans_priv.h"
> >  #include "xfs_inode_item.h"
> > @@ -1689,3 +1690,43 @@ xfs_start_block_reaping(
> >  	xfs_queue_eofblocks(mp);
> >  	xfs_queue_cowblocks(mp);
> >  }
> > +
> > +/*
> > + * Prepare the inodes to participate in further log intent item recovery.
> > + * For now, that means attaching dquots and locking them, since libxfs doesn't
> > + * know how to do that.
> > + */
> > +void
> > +xfs_defer_continue_inodes(
> > +	struct xfs_defer_capture	*dfc,
> > +	struct xfs_trans		*tp)
> > +{
> > +	int				i;
> > +	int				error;
> > +
> > +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++) {
> > +		error = xfs_qm_dqattach(dfc->dfc_inodes[i]);
> > +		if (error)
> > +			tp->t_mountp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
> > +	}
> > +
> > +	if (dfc->dfc_inodes[1])
> > +		xfs_lock_two_inodes(dfc->dfc_inodes[0], XFS_ILOCK_EXCL,
> > +				    dfc->dfc_inodes[1], XFS_ILOCK_EXCL);
> > +	else if (dfc->dfc_inodes[0])
> > +		xfs_ilock(dfc->dfc_inodes[0], XFS_ILOCK_EXCL);
> > +	dfc->dfc_ilocked = true;
> > +}
> > +
> > +/* Release all the inodes attached to this dfops capture device. */
> > +void
> > +xfs_defer_capture_irele(
> > +	struct xfs_defer_capture	*dfc)
> > +{
> > +	unsigned int			i;
> > +
> > +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++) {
> > +		xfs_irele(dfc->dfc_inodes[i]);
> > +		dfc->dfc_inodes[i] = NULL;
> > +	}
> > +}
> 
> None of this belongs in xfs_icache.c. The function namespace tells
> me where it should be...

Agreed.  Originally this couldn't really be in libxfs because xfs_iget
has a different method signature in userspace, but now that we're just
storing the inode pointers directly, there's no need to split this
anymore.

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 0d899ab7df2e..1463c3097240 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1755,23 +1755,43 @@ xlog_recover_release_intent(
> >  	spin_unlock(&ailp->ail_lock);
> >  }
> >  
> > +static inline void
> > +xlog_recover_irele(
> > +	struct xfs_inode	*ip)
> > +{
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	xfs_irele(ip);
> > +}
> 
> Just open code it, please.
> 
> >  int
> > -xlog_recover_trans_commit(
> > +xlog_recover_trans_commit_inodes(
> >  	struct xfs_trans		*tp,
> > -	struct list_head		*capture_list)
> > +	struct list_head		*capture_list,
> > +	struct xfs_inode		*ip1,
> > +	struct xfs_inode		*ip2)
> 
> So are these inodes supposed to be locked, referenced and/or ???

ILOCK'd and referenced.

> >  {
> >  	struct xfs_mount		*mp = tp->t_mountp;
> > -	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
> > +	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp, ip1, ip2);
> >  	int				error;
> 
> That's the second time putting this logic up in the declaration list
> has made me wonder where something in this function is initilaised.
> Please move it into the code so that it is obvious.
> 
> >  
> >  	/* If we don't capture anything, commit tp and exit. */
> > -	if (!dfc)
> > -		return xfs_trans_commit(tp);
> > +	if (!dfc) {
> 
> i.e. before this line.
> 
> 	dfc = xfs_defer_capture(tp, ip1, ip2);
> 	if (!dfc) {

Ok.

> 
> > +		error = xfs_trans_commit(tp);
> > +
> > +		/* We still own the inodes, so unlock and release them. */
> > +		if (ip2 && ip2 != ip1)
> > +			xlog_recover_irele(ip2);
> > +		if (ip1)
> > +			xlog_recover_irele(ip1);
> > +		return error;
> > +	}
> 
> Not a fan of the unnecessary complexity of this.

Yeah, I got ahead of myself -- for atomic extent swapping we'll need to
be able to capture two inodes, so I went straight for the end goal.
I'll rip it out to simplify things for now, but this all will come back
in some form...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
