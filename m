Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DDEC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20CE72075F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJk5k9lj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgESQS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:18:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbgESQSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:18:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGHOj5195651;
        Tue, 19 May 2020 16:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=KjGI2rJcL43jkbPPCXQbA4FcfJl+4/Icmw/ihII9jS4=;
 b=jJk5k9ljX/1LzGi3ouQCZH1vIKvh5kVCYMNZ6wVNpYOuq1/KeF+9FYSheVATIsY/Lg1q
 WX2Xs3uW4uSrT24dWoAoKcOpUOEt2hNHyGFFJIFgVPz6aZKq+bC845CJvcGdlmNLrsoj
 KivYG/DWaP5LbEFBFrv8MGMUh9Cinr3OfKGK1Sm6c7wZJOtbbWPWf/Z0sIL7sgza9eyO
 /xjEC5sqZ1Hfw3ShOVbpLY04988hvqrfbc87HN0xskvinMaJDPbLFAYpPsYDlqwoK3YS
 RFsvdO5/TMH0PSSmmRNo/y91j/ht4ekdFNz7hEk9oEoFgUpClzVziaOKpqw8bbneEhoI ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tnea8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 16:18:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGIOLF159360;
        Tue, 19 May 2020 16:18:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm5909p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 16:18:41 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JGIeEa010193;
        Tue, 19 May 2020 16:18:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:18:40 -0700
Date:   Tue, 19 May 2020 09:18:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/6] xfs: always return -ENOSPC on project quota
 reservation failure
Message-ID: <20200519161837.GK17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <d1853cc9-f478-789d-a9f0-63cd87284828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1853cc9-f478-789d-a9f0-63cd87284828@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 01:49:14PM -0500, Eric Sandeen wrote:
> XFS project quota treats project hierarchies as "mini filesysems" and
> so rather than -EDQUOT, the intent is to return -ENOSPC when a quota
> reservation fails, but this behavior is not consistent.
> 
> The only place we make a decision between -EDQUOT and -ENOSPC
> returns based on quota type is in xfs_trans_dqresv().
> 
> This behavior is currently controlled by whether or not the
> XFS_QMOPT_ENOSPC flag gets passed into the quota reservation.  However,
> its use is not consistent; paths such as xfs_create() and xfs_symlink()
> don't set the flag, so a reservation failure will return -EDQUOT for
> project quota reservation failures rather than -ENOSPC for these sorts
> of operations, even for project quota:
> 
> # mkdir mnt/project
> # xfs_quota -x -c "project -s -p mnt/project 42" mnt
> # xfs_quota -x -c 'limit -p isoft=2 ihard=3 42' mnt
> # touch mnt/project/file{1,2,3}
> touch: cannot touch ‘mnt/project/file3’: Disk quota exceeded
> 
> We can make this consistent by not requiring the flag to be set at the
> top of the callchain; instead we can simply test whether we are
> reserving a project quota with XFS_QM_ISPDQ in xfs_trans_dqresv and if
> so, return -ENOSPC for that failure.  This removes the need for the
> XFS_QMOPT_ENOSPC altogether and simplifies the code a fair bit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Random thoughts on this patch and the previous one--

I like the part where these two patches actually make xfs consistent
about returning EDQUOT for user/group quota, and ENOSPC for project.
Annoyingly, it looks like f2fs/ext4 return EDQUOT for project quotas,
and fstests definitely trips a few regressions over the changing error
message.

So we have a bit of a mess wrt what the expected behavior is when you
run out of project quota.  In theory XFS has precedence since it was
there first, though somewhat eroded due to the inconsistencies that
weren't fixed until now.  OTOH, does that just mean ext4/f2fs are
broken?

What do others think?  The patch submitter probably ought to start a
fsdevel thread about this. ;)

For the kernel patch, I'll say:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |  1 -
>  fs/xfs/xfs_qm.c                |  9 +++------
>  fs/xfs/xfs_trans_dquot.c       | 16 +++++-----------
>  3 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index b2113b17e53c..56d9dd787e7b 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -100,7 +100,6 @@ typedef uint16_t	xfs_qwarncnt_t;
>  #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
>  #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
>  #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
> -#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
>  
>  /*
>   * flags to xfs_trans_mod_dquot to indicate which field needs to be
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c225691fad15..591779aa2fd0 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1808,7 +1808,7 @@ xfs_qm_vop_chown_reserve(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	uint64_t		delblks;
> -	unsigned int		blkflags, prjflags = 0;
> +	unsigned int		blkflags;
>  	struct xfs_dquot	*udq_unres = NULL;
>  	struct xfs_dquot	*gdq_unres = NULL;
>  	struct xfs_dquot	*pdq_unres = NULL;
> @@ -1849,7 +1849,6 @@ xfs_qm_vop_chown_reserve(
>  
>  	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
>  	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
> -		prjflags = XFS_QMOPT_ENOSPC;
>  		pdq_delblks = pdqp;
>  		if (delblks) {
>  			ASSERT(ip->i_pdquot);
> @@ -1859,8 +1858,7 @@ xfs_qm_vop_chown_reserve(
>  
>  	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
>  				udq_delblks, gdq_delblks, pdq_delblks,
> -				ip->i_d.di_nblocks, 1,
> -				flags | blkflags | prjflags);
> +				ip->i_d.di_nblocks, 1, flags | blkflags);
>  	if (error)
>  		return error;
>  
> @@ -1878,8 +1876,7 @@ xfs_qm_vop_chown_reserve(
>  		ASSERT(udq_unres || gdq_unres || pdq_unres);
>  		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
>  			    udq_delblks, gdq_delblks, pdq_delblks,
> -			    (xfs_qcnt_t)delblks, 0,
> -			    flags | blkflags | prjflags);
> +			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
>  		if (error)
>  			return error;
>  		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 2c3557a80e69..2c07897a3c37 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -711,7 +711,7 @@ xfs_trans_dqresv(
>  
>  error_return:
>  	xfs_dqunlock(dqp);
> -	if (flags & XFS_QMOPT_ENOSPC)
> +	if (XFS_QM_ISPDQ(dqp))
>  		return -ENOSPC;
>  	return -EDQUOT;
>  }
> @@ -751,15 +751,13 @@ xfs_trans_reserve_quota_bydquots(
>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
>  	if (udqp) {
> -		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
> -					(flags & ~XFS_QMOPT_ENOSPC));
> +		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
>  		if (error)
>  			return error;
>  	}
>  
>  	if (gdqp) {
> -		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
> -					(flags & ~XFS_QMOPT_ENOSPC));
> +		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
>  		if (error)
>  			goto unwind_usr;
>  	}
> @@ -804,16 +802,12 @@ xfs_trans_reserve_quota_nblks(
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
> -	if (XFS_IS_PQUOTA_ON(mp))
> -		flags |= XFS_QMOPT_ENOSPC;
>  
>  	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
> -				XFS_TRANS_DQ_RES_RTBLKS ||
> -	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
> -				XFS_TRANS_DQ_RES_BLKS);
> +	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
> +	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
>  
>  	/*
>  	 * Reserve nblks against these dquots, with trans as the mediator.
> -- 
> 2.17.0
> 
