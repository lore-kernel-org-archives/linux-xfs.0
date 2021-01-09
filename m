Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CD9C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 01:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF04623A79
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 01:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbhAIBmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 20:42:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAIBmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 20:42:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1091eVrj170895;
        Sat, 9 Jan 2021 01:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5amVmDT9b6OU/6z8E8SpSay60mSOdd+71bZ4xfe4bbU=;
 b=cXkC1GT5i9JKlbpesYaG/HLoqcGGBzUwdxFsni+zPNrYYmJYdPeZE7SGbUsOYl+c8SfT
 xt2Ocd2ThudDHc93DGWjphQxz163ELsNMrzmVsNrZIQsDw2LUHIDWzo53oo3ukxNBCUH
 Fo8lxzR8sNippOt8QD9kYJUO3LuBgZ/NpIE+RyGOHPN7fY7H9+ezJUSOd8Dpp8b5QkZp
 GluwUCnsveJh85kUrP6gO3FzoI+FKxF/9xTskj7XuUWshyX1MSNUVYMQD5195tXDux6d
 ZqnOrG1UBTAOvQTeRli5740VJsXGT183sjHoTU6KRbEFRgVcCKrVtKokGpu4JprKn0l7 jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmkg8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 01:41:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1091YxKG138590;
        Sat, 9 Jan 2021 01:39:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1fd7wqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 01:39:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1091dnj3017081;
        Sat, 9 Jan 2021 01:39:49 GMT
Received: from localhost (/10.159.135.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 17:39:49 -0800
Date:   Fri, 8 Jan 2021 17:39:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     wenli xie <wlxie7296@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        chiluk@ubuntu.com, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210109013948.GT6918@magnolia>
References: <20210108015648.GP6918@magnolia>
 <20210108151858.GB893097@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108151858.GB893097@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090008
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 10:18:58AM -0500, Brian Foster wrote:
> On Thu, Jan 07, 2021 at 05:56:48PM -0800, Darrick J. Wong wrote:
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
> > in order of increasing AG number per the locking rules.  Set
> > t_firstblock so that a subsequent directory block allocation never tries
> > to grab a lower-numbered AGF than the AGIs we grabbed.
> > 
> 
> I don't see this patch do anything with t_firstblock... Even so, is that
> necessary? I thought we had to lock AGIs before AGFs and always in agno
> order, but not necessarily lock an AGF >= previously locked AGIs. Hm?

Oops, heh.  Yeah, I'd added chunks to prevent block allocation, but on
further analysis I don't think that was necessary.

> > Reduce the likelihood that a directory expansion will ENOSPC by starting
> > with AG 0 when allocating whiteout files.
> > 
> > Reported-by: wenli xie <wlxie7296@gmail.com>
> > Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: Make it more obvious that we're grabbing all the AGI locks ahead of
> > the AGFs, and hide functions that we don't need to export anymore.
> > ---
> >  fs/xfs/libxfs/xfs_dir2.h    |    2 --
> >  fs/xfs/libxfs/xfs_dir2_sf.c |    2 +-
> >  fs/xfs/xfs_inode.c          |   57 ++++++++++++++++++++++++++++++-------------
> >  3 files changed, 41 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > index e55378640b05..d03e6098ded9 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.h
> > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > @@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
> >  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
> >  				struct xfs_name *name, xfs_ino_t ino,
> >  				xfs_extlen_t tot);
> > -extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> > -				xfs_ino_t inum);
> >  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> >  				struct xfs_name *name, xfs_ino_t inum,
> >  				xfs_extlen_t tot);
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index 2463b5d73447..8c4f76bba88b 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > @@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
> >  /*
> >   * Check whether the sf dir replace operation need more blocks.
> >   */
> > -bool
> > +static bool
> >  xfs_dir2_sf_replace_needblock(
> >  	struct xfs_inode	*dp,
> >  	xfs_ino_t		inum)
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b7352bc4c815..528152770dc9 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3000,6 +3000,24 @@ xfs_rename_alloc_whiteout(
> >  	return 0;
> >  }
> >  
> > +/* Decide if we need to lock the target IP's AGI as part of a rename. */
> > +static inline bool
> > +xfs_rename_lock_target_ip(
> > +	struct xfs_inode	*src_ip,
> > +	struct xfs_inode	*target_ip)
> > +{
> > +	unsigned int		tgt_nlink = VFS_I(target_ip)->i_nlink;
> > +	bool			src_is_dir = S_ISDIR(VFS_I(src_ip)->i_mode);
> > +
> > +	/*
> > +	 * We only need to lock the AGI if the target ip will end up on the
> > +	 * unlinked list.
> > +	 */
> > +	if (src_is_dir)
> > +		return tgt_nlink == 2;
> 
> IIUC, we can't rename dirs over nondirs and vice versa. I.e.:
> 
> # mv dir file
> mv: overwrite 'file'? y
> mv: cannot overwrite non-directory 'file' with directory 'dir'
> # mv -T file dir
> mv: overwrite 'dir'? y
> mv: cannot overwrite directory 'dir' with non-directory
> 
> That means that if src_is_dir is true, target must either be NULL or an
> empty directory for the rename to succeed, right? If so, have we already
> enforced that by this point? I'm wondering if we need to check the link
> count == 2 in this case or could possibly just reduce the logic to
> (tgt_nlink == 1 || src_is_dir) And if so, whether that still warrants an
> inline helper (where I suppose we could still assert that nlink == 2).

Hm.  I /think/ it's true that we can't ever rename atop an existing
directory, so I think this cna go away:

$ mkdir /tmp/xx
$ touch /tmp/yy
$ strace -s99 -e renameat ./src/renameat2 /tmp/yy /tmp/xx
renameat(AT_FDCWD, "/tmp/yy", AT_FDCWD, "/tmp/xx") = -1 EISDIR (Is a directory)

--D

> Brian
> 
> > +	return tgt_nlink == 1;
> > +}
> > +
> >  /*
> >   * xfs_rename
> >   */
> > @@ -3017,7 +3035,7 @@ xfs_rename(
> >  	struct xfs_trans	*tp;
> >  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
> >  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> > -	struct xfs_buf		*agibp;
> > +	int			i;
> >  	int			num_inodes = __XFS_SORT_INODES;
> >  	bool			new_parent = (src_dp != target_dp);
> >  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> > @@ -3130,6 +3148,27 @@ xfs_rename(
> >  		}
> >  	}
> >  
> > +	/*
> > +	 * Lock the AGI buffers we need to handle bumping the nlink of the
> > +	 * whiteout inode off the unlinked list and to handle dropping the
> > +	 * nlink of the target inode.  We have to do this in increasing AG
> > +	 * order to avoid deadlocks, and before directory block allocation
> > +	 * tries to grab AGFs.
> > +	 */
> > +	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
> > +		if (inodes[i] == wip ||
> > +		    (inodes[i] == target_ip &&
> > +		     xfs_rename_lock_target_ip(src_ip, target_ip))) {
> > +			struct xfs_buf	*bp;
> > +			xfs_agnumber_t	agno;
> > +
> > +			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
> > +			error = xfs_read_agi(mp, tp, agno, &bp);
> > +			if (error)
> > +				goto out_trans_cancel;
> > +		}
> > +	}
> > +
> >  	/*
> >  	 * Directory entry creation below may acquire the AGF. Remove
> >  	 * the whiteout from the unlinked list first to preserve correct
> > @@ -3182,22 +3221,6 @@ xfs_rename(
> >  		 * In case there is already an entry with the same
> >  		 * name at the destination directory, remove it first.
> >  		 */
> > -
> > -		/*
> > -		 * Check whether the replace operation will need to allocate
> > -		 * blocks.  This happens when the shortform directory lacks
> > -		 * space and we have to convert it to a block format directory.
> > -		 * When more blocks are necessary, we must lock the AGI first
> > -		 * to preserve locking order (AGI -> AGF).
> > -		 */
> > -		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> > -			error = xfs_read_agi(mp, tp,
> > -					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
> > -					&agibp);
> > -			if (error)
> > -				goto out_trans_cancel;
> > -		}
> > -
> >  		error = xfs_dir_replace(tp, target_dp, target_name,
> >  					src_ip->i_ino, spaceres);
> >  		if (error)
> > 
> 
