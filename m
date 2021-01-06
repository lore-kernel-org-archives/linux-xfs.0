Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427F5C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 00:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7C822CE3
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 00:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbhAFA3d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 19:29:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbhAFA3d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 19:29:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1060BX8E028975;
        Wed, 6 Jan 2021 00:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EkPe0heBsp8m9sFhXuxOZ6kBNmNO64xJtro6FLJce8E=;
 b=vFLsXI6FSlEIJFSIhpMSR4hdCfp35/b3snQL1hJrlKeQswX9Spjvjeh6smM4INzUit0Y
 BNjUbbVWIo7+bAjQN8Du/xY9kMVG2O4W/TjBxU67wU0YIea8z7FPfQo7W9jV8tCs5XS5
 hZZmo9kk5RQ+ZABGLaXWvUhAWxPpYONCtVae+NKJi05nS5VIxzrwDA0hhjRP1mPuNVPC
 PrccSQS2LVKxl/fmH8It8BmOdMPUsMFGD9fALpnEqVs3JfXHjeSVdfT47xAWRNSAXD8T
 SRLD2tFGUgSkWCd+X8QELTozhMb9n1kdvqzsEJ6UC3zip7DcpZXJmER8/5LevRu6nJUg bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35tgsku9xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 00:28:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1060AmBm031943;
        Wed, 6 Jan 2021 00:26:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35v1f98sge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 00:26:47 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1060Qiqo005665;
        Wed, 6 Jan 2021 00:26:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 00:26:44 +0000
Date:   Tue, 5 Jan 2021 16:26:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210106002643.GC6918@magnolia>
References: <20210104194437.GJ38809@magnolia>
 <20210105221247.GD331610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105221247.GD331610@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050139
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 09:12:47AM +1100, Dave Chinner wrote:
> On Mon, Jan 04, 2021 at 11:44:37AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When overlayfs is running on top of xfs and the user unlinks a file in
> > the overlay, overlayfs will create a whiteout inode and ask xfs to
> > "rename" the whiteout file atop the one being unlinked.  If the file
> > being unlinked loses its one nlink, we then have to put the inode on the
> > unlinked list.
> > 
> > This requires us to grab the AGI buffer of the whiteout inode to take it
> > off the unlinked list (which is where whiteouts are created) and to grab
> > the AGI buffer of the file being deleted.  If the whiteout was created
> > in a higher numbered AG than the file being deleted, we'll lock the AGIs
> > in the wrong order and deadlock.
> > 
> > Therefore, grab all the AGI locks we think we'll need ahead of time, and
> > in the correct order.
> > 
> > Reported-by: wenli xie <wlxie7296@gmail.com>
> > Tested-by: wenli xie <wlxie7296@gmail.com>
> > Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> 
> Hmmm.
> 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b7352bc4c815..dd419a1bc6ba 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * For the general case of renaming files, lock all the AGI buffers we need to
> > + * handle bumping the nlink of the whiteout inode off the unlinked list and to
> > + * handle dropping the nlink of the target inode.  We have to do this in
> > + * increasing AG order to avoid deadlocks.
> > + */
> > +static int
> > +xfs_rename_lock_agis(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*wip,
> > +	struct xfs_inode	*target_ip)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_buf		*bp;
> > +	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
> > +	int			error;
> > +
> > +	if (wip)
> > +		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
> > +
> > +	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
> > +		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
> > +
> > +	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
> > +	    agi_locks[0] > agi_locks[1])
> > +		swap(agi_locks[0], agi_locks[1]);
> > +
> > +	if (agi_locks[0] != NULLAGNUMBER) {
> > +		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	if (agi_locks[1] != NULLAGNUMBER) {
> > +		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * xfs_rename
> >   */
> > @@ -3130,6 +3172,10 @@ xfs_rename(
> >  		}
> >  	}
> >  
> > +	error = xfs_rename_lock_agis(tp, wip, target_ip);
> > +	if (error)
> > +		return error;
> > +
> >  	/*
> >  	 * Directory entry creation below may acquire the AGF. Remove
> >  	 * the whiteout from the unlinked list first to preserve correct
> > 
> 
> So the comment below this new hunk is all about AGI vs AGF ordering
> and how we do the unlink first to grab the AGI before the AGF. But
> noew we are adding explicit AGI locking for the case where unlink
> list locking is required, thereby largely invalidating the need
> for special casing the unlink list removal right up front.

Yeah.  If I had my way I'd refactor the bumplink/droplink operations
into deferred log items so that we wouldn't have to think so hard about
locking order.  That's a /lot/ of extra code though.

> Next question: The target_ip == NULL case below this (the
> xfs_dir_repace() case) does this:
> 
> 	/*
> 	 * Check whether the replace operation will need to allocate
> 	 * blocks.  This happens when the shortform directory lacks
> 	 * space and we have to convert it to a block format directory.
> 	 * When more blocks are necessary, we must lock the AGI first
> 	 * to preserve locking order (AGI -> AGF).
> 	 */
> 	if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> 		error = xfs_read_agi(mp, tp,
> 				XFS_INO_TO_AGNO(mp, target_ip->i_ino),
> 				&agibp);
> 		if (error)
> 			goto out_trans_cancel;
> 	}
> 
> IOWs, if we are actually locking AGIs up front, this can go away,
> yes?

Right.

> Seems to me that we should actually do a proper job of formalising
> the locking in the rename code, not hack another special case into
> it and keep all the other special case hacks that could go away if
> the whole AGI/AGF locking order thing were done up front....

Hm.  I don't know how you'd do explicit AGF locking up front because the
AG is selected by the block allocator.  I think we can set t_firstblock
to trick the allocator into skipping the AGs before max(wip, target_ip),
but I don't see how we could get any closer than that?

I guess the downside is that locking the AGIs ahead of time means that
our allocation choices are severely constrained if either inode is in
the last AG.  We could try to reduce the likelihood of that by making
xfs_ialloc_ag_select start in AG 0 for whiteout creations since
RENAME_WHITEOUT is the only creation path, I think.  But that would
still leave us vulnerable to ENOSPC shutdowns if the last AGs are
totally full.

--D

> And with it formalised, we can then think about how to get rid of
> those lock order dependecies altogether....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
