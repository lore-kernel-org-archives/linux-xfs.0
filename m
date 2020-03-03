Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33C8C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 23:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B77820848
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 23:06:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cN/wE/Q7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCCXGq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:06:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgCCXGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 18:06:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023MsB7L152676;
        Tue, 3 Mar 2020 23:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=v8iJMTJrVlQBdjHfEY7YpRw7q9HiJvBdyZt8msxCLD0=;
 b=cN/wE/Q7Zo4wB1apIndHTM0z4c1m6qWLsMG7/W7cpJ3VEEX+Dx/41dFEquT56npM5xR8
 DdWYxBrTd0gP6s2u0xWBkBon5WimdcLO+0T1npJ2/19NVvv75p4bi+xG5iiaeTYI1gp0
 BHsCahA99c6S6HG53c/QLPWCrKmnpswedzqKf9feSGV1IiinCnkOqtp3oc+jlwIZeFAR
 pMMk0W5PEImyPJJ+nk9u5kwULdM2XfEEPAWxOr8UxMNNfQfnUZ0tH6DrlXY9H1WRlrwU
 EwCR+hOkMU0fQG+gK3NjqNlo+oADXp7SVXWVZJuTXzMyyLLmao4GMXUeDHfLWUivexb0 xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yffcujkpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 23:06:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023MqV5Q117114;
        Tue, 3 Mar 2020 23:06:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yg1p5pg6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 23:06:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023N6e8o020305;
        Tue, 3 Mar 2020 23:06:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 15:06:40 -0800
Date:   Tue, 3 Mar 2020 15:06:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: scrub should mark dir corrupt if entry points
 to unallocated inode
Message-ID: <20200303230639.GI8045@magnolia>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294096213.1730101.1870315264682758950.stgit@magnolia>
 <20200303223907.GX10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303223907.GX10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 09:39:07AM +1100, Dave Chinner wrote:
> On Fri, Feb 28, 2020 at 05:49:22PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xchk_dir_check_ftype, we should mark the directory corrupt if we try
> > to _iget a directory entry's inode pointer and the inode btree says the
> > inode is not allocated.  This involves changing the IGET call to force
> > the inobt lookup to return EINVAL if the inode isn't allocated; and
> > rearranging the code so that we always perform the iget.
> 
> There's also a bug fix in this that isn't mentioned...
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/dir.c |   43 ++++++++++++++++++++++++++-----------------
> >  1 file changed, 26 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> > index 54afa75c95d1..a775fbf49a0d 100644
> > --- a/fs/xfs/scrub/dir.c
> > +++ b/fs/xfs/scrub/dir.c
> > @@ -39,9 +39,12 @@ struct xchk_dir_ctx {
> >  	struct xfs_scrub	*sc;
> >  };
> >  
> > -/* Check that an inode's mode matches a given DT_ type. */
> > +/*
> > + * Check that a directory entry's inode pointer directs us to an allocated
> > + * inode and (if applicable) the inode mode matches the entry's DT_ type.
> > + */
> >  STATIC int
> > -xchk_dir_check_ftype(
> > +xchk_dir_check_iptr(
> >  	struct xchk_dir_ctx	*sdc,
> >  	xfs_fileoff_t		offset,
> >  	xfs_ino_t		inum,
> > @@ -52,13 +55,6 @@ xchk_dir_check_ftype(
> >  	int			ino_dtype;
> >  	int			error = 0;
> >  
> > -	if (!xfs_sb_version_hasftype(&mp->m_sb)) {
> > -		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> > -			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> > -					offset);
> > -		goto out;
> > -	}
> > -
> >  	/*
> >  	 * Grab the inode pointed to by the dirent.  We release the
> >  	 * inode before we cancel the scrub transaction.  Since we're
> > @@ -66,17 +62,30 @@ xchk_dir_check_ftype(
> >  	 * eofblocks cleanup (which allocates what would be a nested
> >  	 * transaction), we can't use DONTCACHE here because DONTCACHE
> >  	 * inodes can trigger immediate inactive cleanup of the inode.
> > +	 *
> > +	 * We use UNTRUSTED here so that iget will return EINVAL if we have an
> > +	 * inode pointer that points to an unallocated inode.
> 
> "We use UNTRUSTED here to force validation of the inode number
> before we look it up. If it fails validation for any reason we will
> get -EINVAL returned and that indicates a corrupt directory entry."

Ok, changed.

> >  	 */
> > -	error = xfs_iget(mp, sdc->sc->tp, inum, 0, 0, &ip);
> > +	error = xfs_iget(mp, sdc->sc->tp, inum, XFS_IGET_UNTRUSTED, 0, &ip);
> > +	if (error == -EINVAL) {
> > +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> > +		return -EFSCORRUPTED;
> > +	}
> >  	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
> >  			&error))
> >  		goto out;
> 
> Also:
> 	if (error == -EINVAL)
> 		error = -EFSCORRUPTED;

Also changed.

> 
> >  
> > -	/* Convert mode to the DT_* values that dir_emit uses. */
> > -	ino_dtype = xfs_dir3_get_dtype(mp,
> > -			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
> > -	if (ino_dtype != dtype)
> > -		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> > +	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> > +		/* Convert mode to the DT_* values that dir_emit uses. */
> > +		ino_dtype = xfs_dir3_get_dtype(mp,
> > +				xfs_mode_to_ftype(VFS_I(ip)->i_mode));
> > +		if (ino_dtype != dtype)
> > +			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> > +	} else {
> > +		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
> > +			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
> > +					offset);
> > +	}
> 
> What is this fixing? xfs_dir3_get_dtype() always returned DT_UNKNOWN
> for !hasftype filesystems, so I'm guessing this fixes validation
> against dtype == DT_DIR for "." and ".." entries, but didn't we
> already check this in xchk_dir_actor() before it calls this
> function?

Oh, right, we already checked those, so we can get rid of the !hasftype
code entirely.  Good catch!

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
