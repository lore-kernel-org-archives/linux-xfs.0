Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334E6C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 00:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F53F600AA
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 00:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhHaAtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 20:49:51 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:46090 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236374AbhHaAtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 20:49:50 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 2173F10C066;
        Tue, 31 Aug 2021 10:48:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mKrxL-006tCr-2u; Tue, 31 Aug 2021 10:48:51 +1000
Date:   Tue, 31 Aug 2021 10:48:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 03/11] xfs: Set up infrastructure for log atrribute
 replay
Message-ID: <20210831004851.GT3657114@dread.disaster.area>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824224434.968720-4-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=0-oJNXjUqvzmqmRTwqwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 03:44:26PM -0700, Allison Henderson wrote:
> +/*
> + * Allocate and initialize an attri item.  Caller may allocate an additional
> + * trailing buffer of the specified size
> + */
> +STATIC struct xfs_attri_log_item *
> +xfs_attri_init(
> +	struct xfs_mount		*mp,
> +	int				buffer_size)
> +
> +{
> +	struct xfs_attri_log_item	*attrip;
> +	uint				size;
> +
> +	size = sizeof(struct xfs_attri_log_item) + buffer_size;
> +	attrip = kvmalloc(size, KM_ZERO);
> +	if (attrip == NULL)
> +		return NULL;

kvmalloc() takes GFP flags. I think you want GFP_KERNEL | __GFP_ZERO
here.

Also, buffer size is taken directly from on-disk without bounds/length
validation, meaning this could end up being an attacker controlled
memory allocation, so .....

> +STATIC int
> +xlog_recover_attri_commit_pass2(
> +	struct xlog                     *log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item        *item,
> +	xfs_lsn_t                       lsn)
> +{
> +	int                             error;
> +	struct xfs_mount                *mp = log->l_mp;
> +	struct xfs_attri_log_item       *attrip;
> +	struct xfs_attri_log_format     *attri_formatp;
> +	char				*name = NULL;
> +	char				*value = NULL;
> +	int				region = 0;
> +	int				buffer_size;
> +
> +	attri_formatp = item->ri_buf[region].i_addr;
> +
> +	/* Validate xfs_attri_log_format */
> +	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
> +	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
> +	    attri_formatp->alfi_value_len != 0)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	buffer_size = attri_formatp->alfi_name_len +
> +		      attri_formatp->alfi_value_len;
> +
> +	attrip = xfs_attri_init(mp, buffer_size);
> +	if (attrip == NULL)
> +		return -ENOMEM;

There needs to be a lot better validation of the attribute
name/value lengths here.  Also, memory allocation failure here will
abort recovery, so it might be worth adding a comment here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
