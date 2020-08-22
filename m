Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9CFC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D791E20724
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cr2mt7wF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgHVHOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgHVHOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:14:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4670C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k+emLHVV9NhQtE4V9/5aKHVKzvZ1URky5DzqUjA+g3I=; b=Cr2mt7wFSgCVXg5B+DOaekBLrO
        REEYAPvBJa1OVOODj/MOolBqRFOBwxHzWtNwDRts0wU7HpiECjoJdNY85BLatlAIRli/l5YGo8/u7
        Qeb3axy1RpXye0VK1pygyoNL1i+uvxnYurTW+bcc7azaDnuiv6n7BxHt0O4elFmV9y2co6r5mbeTW
        ZlNgpL6ZdDUv8fjla2qVC+AbzZigLfzIMb27uTEQ/5ZJcV1pJTFlb2paTxf7BiOwnW7pICtQE98Nm
        nEt1Z66pzHt7Pn8ghdEqDgqKU2iu6cCvZcovyWrEwRZ/sFfGLb0zeeqE3rgwUkk+FlNb2zPGM7UGM
        Pm0Qn41g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9Njf-0000aO-0O; Sat, 22 Aug 2020 07:14:43 +0000
Date:   Sat, 22 Aug 2020 08:14:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
Message-ID: <20200822071442.GB1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797590052.965217.10856208107922013686.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797590052.965217.10856208107922013686.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:11:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define explicit limits on the range of quota grace period expiration
> timeouts and refactor the code that modifies the timeouts into helpers
> that clamp the values appropriately.  Note that we'll deal with the
> grace period timer separately.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
>  fs/xfs/xfs_dquot.c         |   13 ++++++++++++-
>  fs/xfs/xfs_dquot.h         |    2 ++
>  fs/xfs/xfs_ondisk.h        |    2 ++
>  fs/xfs/xfs_qm_syscalls.c   |    9 +++++++--
>  5 files changed, 45 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b1b8a5c05cea..ef36978239ac 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1197,6 +1197,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  
>  #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
>  
> +/*
> + * XFS Quota Timers
> + * ================
> + *
> + * Quota grace period expiration timers are an unsigned 32-bit seconds counter;
> + * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
> + * of zero means that the quota limit has not been reached, and therefore no
> + * expiration has been set.
> + */
> +
> +/*
> + * Smallest possible quota expiration with traditional timestamps, which is
> + * Jan  1 00:00:01 UTC 1970.
> + */
> +#define XFS_DQ_TIMEOUT_MIN	((int64_t)1)
> +
> +/*
> + * Largest possible quota expiration with traditional timestamps, which is
> + * Feb  7 06:28:15 UTC 2106.
> + */
> +#define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
> +
>  /*
>   * This is the main portion of the on-disk representation of quota information
>   * for a user.  We pad this with some more expansion room to construct the on
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bcd73b9c2994..2425b1c30d11 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -98,6 +98,16 @@ xfs_qm_adjust_dqlimits(
>  		xfs_dquot_set_prealloc_limits(dq);
>  }
>  
> +/* Set the expiration time of a quota's grace period. */
> +void
> +xfs_dquot_set_timeout(
> +	time64_t		*timer,
> +	time64_t		value)
> +{
> +	*timer = clamp_t(time64_t, value, XFS_DQ_TIMEOUT_MIN,
> +					  XFS_DQ_TIMEOUT_MAX);
> +}

Why doesn't this just return the value?  That would seem like
a much more natural calling convention to me.
