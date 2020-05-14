Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0B7C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 11:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A3A2206DA
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 11:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZoycGbj4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgENLoi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 07:44:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725925AbgENLoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 07:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589456676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3s87ye72wv1aoKKmQFzjbT4xLBbWIhdX2UeDXTIFKs=;
        b=ZoycGbj4B7xsIeZGgjwIwwF8tvnZJPi+Oh65aBK4QDaLCxp61uMGKpk6iIDmHAJ1SW303O
        vk/ZTV45zxwidtXxTCK3/rs8yt0yPGQ18YdbPf8t0qyxrd1c4Qz/qwcj7G5Lhws06cWKrk
        99e28pjNGCt55ztxfRuwE+y2oKMRT8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-Qn0FNxYlPTiQsbSASRhb0Q-1; Thu, 14 May 2020 07:44:34 -0400
X-MC-Unique: Qn0FNxYlPTiQsbSASRhb0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC42F8FBC0E
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2020 11:43:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D1DB1A923;
        Thu, 14 May 2020 11:43:53 +0000 (UTC)
Date:   Thu, 14 May 2020 07:43:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V2] xfs: always return -ENOSPC on project quota
 reservation failure
Message-ID: <20200514114351.GA50441@bfoster>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
 <535795f0-6eef-37d0-45de-f268e15a9b9f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535795f0-6eef-37d0-45de-f268e15a9b9f@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 12:39:00PM -0500, Eric Sandeen wrote:
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
> ---

Thanks for the update.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: Change title and changelog to clearly reflect the bug and behavior
> change, which wasn't really identified as a bug and behavior change until
> Brian carefully reviewed V1.  :)
> 
> No patch changes.
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
> 
> 
> 

