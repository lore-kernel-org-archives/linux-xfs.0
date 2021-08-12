Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500A5C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 12:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223096104F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 12:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhHLMOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 08:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbhHLMOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 08:14:02 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2094DC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 05:13:37 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id s184so8106747ios.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 05:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TXzKJD95CHCkM3frVIzsFhs0VzamBe4ojrGVnH5mN68=;
        b=e6z057aaf1V2f3MFH5yE1I6ppursvXULxqdVmg2Lr4/YMCq2gEY2VG5Oumq81uYDMl
         t8Dy5BJ9CUqBe//T+k/CBwkw3aytlE881tSdqbVuBNqdA5Zt4IUAT9EbSdU8OAXo+QI+
         gVU/yjPXpZ3eVxKwl16qm4DgEZQ0mpeo/oLNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TXzKJD95CHCkM3frVIzsFhs0VzamBe4ojrGVnH5mN68=;
        b=J9mPKTPY1KlMLQCLbYQEUle8xjnjceQrDbZfwC+OGc0ru4IB7Aw+6NDidAaX2YrTxg
         iZJVpfxwHjK817E+XLgeFYfuTGk328r3oUFQywiQ8KK6dQ+7CpuK3y0WMH0SSLgqEVU/
         qgOQuLvAfVEWMLtnvXu6smRQkqgtTGjW/UKnc1qzkHvIUMhlmnQnwyQgN+vmLi7lIWPM
         OfQL8tgDuU3dBkpWa1JCl2il7VXMIyHqOP3Q4JFZY6LdFoMYuKP/H0p17sVH5bafnA7r
         6HpNVrdhliBAS4hQIC0+WiKUcGbFw3mi+Pu9in+yeyba5dlebOM1tiyq1KpcUG9C8tX1
         pOkA==
X-Gm-Message-State: AOAM530YsqXUaW8sIXV+TUCXMD8K0rjKY54kyCLr1YoDWR1mifIZgBdZ
        wFYYk/3lg4Ef6gAQbvqCgY6TnKYAAaIoRg==
X-Google-Smtp-Source: ABdhPJwuXFwOHwTuGxWezj3KZB3Q10h9YC0EVXhOSZ8o1wLgedzLRJfzavzEcLDucQSi+sKnKdIqyw==
X-Received: by 2002:a05:6602:158f:: with SMTP id e15mr2772241iow.15.1628770416288;
        Thu, 12 Aug 2021 05:13:36 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id n10sm1411784ile.82.2021.08.12.05.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 05:13:35 -0700 (PDT)
Subject: Re: [PATCH 3/3] xfs: remove the xfs_dqblk_t typedef
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-4-hch@lst.de>
From:   Alex Elder <elder@ieee.org>
Message-ID: <6ef97bf0-cc59-e930-d302-f15c31ea21f3@ieee.org>
Date:   Thu, 12 Aug 2021 07:13:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812084343.27934-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/21 3:43 AM, Christoph Hellwig wrote:
> Remove the few leftover instances of the xfs_dinode_t typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Fix the description:  s/xfs_dinode_t/xfs_dqblk_t/

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_format.h    | 4 ++--
>  fs/xfs/xfs_dquot.c            | 2 +-
>  fs/xfs/xfs_qm.c               | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 6766417d5ba448..7691e44d38b9ac 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -22,7 +22,7 @@ xfs_calc_dquots_per_chunk(
>  	unsigned int		nbblks)	/* basic block units */
>  {
>  	ASSERT(nbblks > 0);
> -	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
> +	return BBTOB(nbblks) / sizeof(struct xfs_dqblk);
>  }
>  
>  /*
> @@ -127,7 +127,7 @@ xfs_dqblk_repair(
>  	 * Typically, a repair is only requested by quotacheck.
>  	 */
>  	ASSERT(id != -1);
> -	memset(dqb, 0, sizeof(xfs_dqblk_t));
> +	memset(dqb, 0, sizeof(struct xfs_dqblk));
>  
>  	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
>  	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5819c25c1478d0..61e454e4381e42 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1411,7 +1411,7 @@ struct xfs_disk_dquot {
>   * This is what goes on disk. This is separated from the xfs_disk_dquot because
>   * carrying the unnecessary padding would be a waste of memory.
>   */
> -typedef struct xfs_dqblk {
> +struct xfs_dqblk {
>  	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
>  	char			dd_fill[4];/* filling for posterity */
>  
> @@ -1421,7 +1421,7 @@ typedef struct xfs_dqblk {
>  	__be32		  dd_crc;	/* checksum */
>  	__be64		  dd_lsn;	/* last modification in log */
>  	uuid_t		  dd_uuid;	/* location information */
> -} xfs_dqblk_t;
> +};
>  
>  #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c301b18b7685b1..a86665bdd4afb5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -471,7 +471,7 @@ xfs_dquot_alloc(
>  	 * Offset of dquot in the (fixed sized) dquot chunk.
>  	 */
>  	dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
> -			sizeof(xfs_dqblk_t);
> +			sizeof(struct xfs_dqblk);
>  
>  	/*
>  	 * Because we want to use a counting completion, complete
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 2bef4735d03031..95fdbe1b7016da 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -850,7 +850,7 @@ xfs_qm_reset_dqcounts(
>  	 */
>  #ifdef DEBUG
>  	j = (int)XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) /
> -		sizeof(xfs_dqblk_t);
> +		sizeof(struct xfs_dqblk);
>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>  #endif
>  	dqb = bp->b_addr;
> 

