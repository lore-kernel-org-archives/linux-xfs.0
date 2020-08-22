Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C10C433E3
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B43F20825
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YMuBwE3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHVHgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgHVHgC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:36:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7C3C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HXivGO1fJRiZYbcgz5FC2j/QXGVo6BgSqkfBWaJIg+U=; b=YMuBwE3lpMG0HnsS//LaBaHHFG
        jnailNwyQ3zeZAjZlyoUIwbkHXQc8BxK5BD90tUbWp4xFJItqPzxrIIwqpkLq8GMIgmmADUGafczt
        l5vNTlSmyTzIp4jnFfcKvKFLd44RSH2QMahJzUr5NfoCankNqZWiMumMMPRg21d/KbFvsUEZwkK4i
        WPGWg96jGWL0w08yR9Rq6a5WuSi/+gkoeIU59JEwq6MhruXl+Y19SnPfPPmernZWBotma7D+Vb6dx
        BHooyvScorrvIX9MCGzHMaucWAlaRs6xGl1bdpIpE/7gXaH8e2FjXtRbVTzeVtpsuGVP/GzuWLATY
        BupFKsRg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9O4G-0002G7-Hp; Sat, 22 Aug 2020 07:36:00 +0000
Date:   Sat, 22 Aug 2020 08:36:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 10/11] xfs: enable bigtime for quota timers
Message-ID: <20200822073600.GJ1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797595474.965217.7111215541487615114.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797595474.965217.7111215541487615114.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:12:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable the bigtime feature for quota timers.  We decrease the accuracy
> of the timers to ~4s in exchange for being able to set timers up to the
> bigtime maximum.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  |   32 ++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_format.h     |   27 ++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_quota_defs.h |    3 ++-
>  fs/xfs/xfs_dquot.c             |   25 +++++++++++++++++++++----
>  fs/xfs/xfs_dquot.h             |    3 ++-
>  fs/xfs/xfs_ondisk.h            |    7 +++++++
>  fs/xfs/xfs_qm.c                |    2 ++
>  fs/xfs/xfs_qm_syscalls.c       |    9 +++++----
>  fs/xfs/xfs_trans_dquot.c       |    6 ++++++
>  9 files changed, 101 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 7f5291022b11..f5997fbdd308 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -69,6 +69,13 @@ xfs_dquot_verify(
>  	    ddq_type != XFS_DQTYPE_GROUP)
>  		return __this_address;
>  
> +	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
> +	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> +		return __this_address;
> +
> +	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
> +		return __this_address;
> +
>  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
>  		return __this_address;
>  
> @@ -296,7 +303,15 @@ xfs_dquot_from_disk_timestamp(
>  	time64_t		*timer,
>  	__be32			dtimer)
>  {
> -	*timer = be32_to_cpu(dtimer);
> +	uint64_t		t;
> +
> +	if (!timer || !(ddq->d_type & XFS_DQTYPE_BIGTIME)) {
> +		*timer = be32_to_cpu(dtimer);

I don't think setting *time makes any sense if time is NULL..

> +		return;
> +	}
> +
> +	t = be32_to_cpu(dtimer);
> +	*timer = t << XFS_DQ_BIGTIME_SHIFT;

Why not:

	*timer = (time64_t)be32_to_cpu(dtimer) << XFS_DQ_BIGTIME_SHIFT;

or (with my previous suggestion):

	return (time64_t)be32_to_cpu(dtimer) << XFS_DQ_BIGTIME_SHIFT;

?

> @@ -1227,13 +1227,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DQTYPE_USER		0x01		/* user dquot record */
>  #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
>  #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
> +#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */
>  
>  /* bitmask to determine if this is a user/group/project dquot */
>  #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
>  				 XFS_DQTYPE_PROJ | \
>  				 XFS_DQTYPE_GROUP)
>  
> -#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
> +#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK | \
> +				 XFS_DQTYPE_BIGTIME)
>  
>  /*
>   * XFS Quota Timers
> @@ -1270,6 +1272,29 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DQ_GRACE_MIN	((int64_t)0)
>  #define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
>  
> +/*
> + * When bigtime is enabled, we trade a few bits of precision to expand the
> + * expiration timeout range to match that of big inode timestamps.  The grace
> + * periods stored in dquot 0 are not shifted, since they record an interval,
> + * not a timestamp.
> + */
> +#define XFS_DQ_BIGTIME_SHIFT	(2)
> +#define XFS_DQ_BIGTIME_SLACK	((int64_t)(1ULL << XFS_DQ_BIGTIME_SHIFT) - 1)
> +
> +/*
> + * Smallest possible quota expiration with big timestamps, which is
> + * Jan  1 00:00:01 UTC 1970.
> + */
> +#define XFS_DQ_BIGTIMEOUT_MIN		(XFS_DQ_TIMEOUT_MIN)
> +
> +/*
> + * Largest supported quota expiration with traditional timestamps, which is
> + * the largest bigtime inode timestamp, or Jul  2 20:20:25 UTC 2486.  The field

This adds and > 80 char line.
