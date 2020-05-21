Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A16FC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46BB720721
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y/Smr07y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgEUJfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 05:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgEUJfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 05:35:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5297EC061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 02:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4UD5D/FORPDPJDJ+Xan15Cy+ykhajUYOSsc+6lLjfEQ=; b=Y/Smr07yQc7q1pT10P+jLd4IGK
        BmBcNWJJIXFjXKVDRedDLcpBzAmEYU2P755BNxO21l/YpB3ftudXXAoJObN9H8GdhuGV+Q0RkEOfU
        aIb7UxZPowjDtu5hQMl5Ap7yHKr1xX7dgjTm5GTARQt5qiSZO4w957z3nhaZ72olSrrCIqtzx5Ac3
        pRbTmGXvqzqknd77El8JjLDvpRt0GlGo+8X/m0lVczxK0+EO+wtzGm6DtrnNFXBSrqtETmWdFIDgB
        IKDNHhXEmP9HrJndaZ217NgVLczskKdeJLiPiQe+ZtcgUjMS9KDE9xTnbpq9i/aVoGQThmvvb1UH1
        QvyDwESQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbhbR-0007w6-1b; Thu, 21 May 2020 09:35:01 +0000
Date:   Thu, 21 May 2020 02:35:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: switch xfs_get_defquota to take explicit type
Message-ID: <20200521093501.GA28324@infradead.org>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
 <1590028518-6043-6-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590028518-6043-6-git-send-email-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 09:35:16PM -0500, Eric Sandeen wrote:
> xfs_get_defquota() currently takes an xfs_dquot, and from that obtains
> the type of default quota we should get (user/group/project).
> 
> But early in init, we don't have access to a fully set up quota, so
> that's not possible.  The next patch needs go set up default quota
> timers early, so switch xfs_get_defquota to take an explicit type
> and add a helper function to obtain that type from an xfs_dquot
> for the existing callers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c       |  2 +-
>  fs/xfs/xfs_qm.c          |  2 +-
>  fs/xfs/xfs_qm.h          | 28 +++++++++++++++++++++++-----
>  fs/xfs/xfs_qm_syscalls.c |  2 +-
>  fs/xfs/xfs_trans_dquot.c |  2 +-
>  5 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 714ecea..6196f7c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -75,7 +75,7 @@
>  	int			prealloc = 0;
>  
>  	ASSERT(d->d_id);
> -	defq = xfs_get_defquota(dq, q);
> +	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
>  
>  	if (defq->bsoftlimit && !d->d_blk_softlimit) {
>  		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6609b4b..ac0b5e7f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -558,7 +558,7 @@ struct xfs_qm_isolate {
>  		return;
>  
>  	ddqp = &dqp->q_core;
> -	defq = xfs_get_defquota(dqp, qinf);
> +	defq = xfs_get_defquota(qinf, xfs_dquot_type(dqp));
>  
>  	/*
>  	 * Timers and warnings have been already set, let's just set the
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 3a85040..06df406 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -113,6 +113,19 @@ struct xfs_quotainfo {
>  	return NULL;
>  }
>  
> +static inline int
> +xfs_dquot_type(struct xfs_dquot *dqp)
> +{
> +	if (XFS_QM_ISUDQ(dqp))
> +		return XFS_DQ_USER;
> +	else if (XFS_QM_ISGDQ(dqp))
> +		return XFS_DQ_GROUP;
> +	else {
> +		ASSERT(XFS_QM_ISPDQ(dqp));
> +		return XFS_DQ_PROJ;
> +	}

No real need for the elses here:

	if (XFS_QM_ISUDQ(dqp))
		return XFS_DQ_USER;
	if (XFS_QM_ISGDQ(dqp))
		return XFS_DQ_GROUP;
	ASSERT(XFS_QM_ISPDQ(dqp));
	return XFS_DQ_PROJ;

> +xfs_get_defquota(struct xfs_quotainfo *qi, int type)
>  {
>  	struct xfs_def_quota *defq;
>  
> +	switch (type) {
> +	case XFS_DQ_USER:
>  		defq = &qi->qi_usr_default;
> +		break;
> +	case XFS_DQ_GROUP:
>  		defq = &qi->qi_grp_default;
> +		break;
> +	case XFS_DQ_PROJ:
>  		defq = &qi->qi_prj_default;
> +		break;
> +	default:
> +		ASSERT(0);
>  	}
>  	return defq;

Just kill the defq variable and return directly?

	switch (type) {
	case XFS_DQ_USER:
 		return &qi->qi_usr_default;
	case XFS_DQ_GROUP:
  		return &qi->qi_grp_default;
	case XFS_DQ_PROJ:
  		return &qi->qi_prj_default;
	default:
		ASSERT(0);
		return NULL;
	}
