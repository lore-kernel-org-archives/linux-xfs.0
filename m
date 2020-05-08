Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D85C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 13:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF44320870
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 13:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hqE4iM9+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgEHNCH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 09:02:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33161 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730060AbgEHNCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 09:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588942921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ONdPozqZOOlCBXC3lN/lW5HSYHuVHn9/PWe+3yeyDVY=;
        b=hqE4iM9+qxzFOTUi9pb7oSVPMgln8I4SDN2MsPzhH0KvDyFY3ip8C0WUWNaoLpe8LNjEKg
        soTsLNNOAmWTlgALmyQG8X0WSWfekcxCLiF03FRBg8pFEgEJ5TCoergdKKzby9ECvPICw7
        QdXrI4HiEEpwYPruJVECKY7MT3l3vj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-x_StFPEFPjS-ckMEfeEQ4g-1; Fri, 08 May 2020 09:02:00 -0400
X-MC-Unique: x_StFPEFPjS-ckMEfeEQ4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73297EC1A6
        for <linux-xfs@vger.kernel.org>; Fri,  8 May 2020 13:01:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13F645D9CA;
        Fri,  8 May 2020 13:01:56 +0000 (UTC)
Date:   Fri, 8 May 2020 09:01:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
Message-ID: <20200508130154.GC27577@bfoster>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 11:00:34PM -0500, Eric Sandeen wrote:
> The only place we return -EDQUOT, and therefore need to make a decision
> about returning -ENOSPC for project quota instead, is in xfs_trans_dqresv().
> 
> So there's no reason to be setting and clearing XFS_QMOPT_ENOSPC at higher
> levels; if xfs_trans_dqresv has failed, test if the dqp we were were handed
> is a project quota and if so, return -ENOSPC instead of EDQUOT.  The
> complexity is just a leftover from when project & group quota were mutually
> exclusive and shared some codepaths.
> 
> The prior patch was the trivial bugfix, this is the slightly more involved
> cleanup.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Hmm so what about callers that don't pass QMOPT_ENOSPC? For example, it
looks like various xfs_trans_reserve_quota() calls pass a pdqp but don't
set the flag. Is the intent to change behavior such that -ENOSPC is
unconditional for project quota reservation failures?

Brian

> 
> Patch 1 was the trivial bugfix, this is the slightly more involved cleanup.
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

