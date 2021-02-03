Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD43C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 14:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534F264F5D
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 14:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhBCOZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:25:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232888AbhBCOZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 09:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612362249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qOtj94FDdrrRU7Xd/4+ZJ0aJDEnJPu672FDlSdVKQzw=;
        b=Y4BYgFoLFJhsFrZHf279jwZXtz3QTb03pfALwd1iC+4gQ62YG69qFWuRtmuz3y7d3f3t6Y
        QDIfxDREW4tL/l4HycybKqOISP+SQauEMwYuvPlR+1R4Oykej+Pdiop7s/9NAvjj+/jnQ1
        wy4doVWr+9rZueiTGfKxkY0qrajLLWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-wEXN5kYpMJaUsijZ8eA3Wg-1; Wed, 03 Feb 2021 09:24:07 -0500
X-MC-Unique: wEXN5kYpMJaUsijZ8eA3Wg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3216CE649;
        Wed,  3 Feb 2021 14:24:05 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C1E410016FF;
        Wed,  3 Feb 2021 14:24:01 +0000 (UTC)
Date:   Wed, 3 Feb 2021 09:23:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v6 7/7] xfs: add error injection for per-AG resv failure
 when shrinkfs
Message-ID: <20210203142359.GC3647012@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-8-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126125621.3846735-8-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 08:56:21PM +0800, Gao Xiang wrote:
> per-AG resv failure after fixing up freespace is hard to test in an
> effective way, so directly add an error injection path to observe
> such error handling path works as expected.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c       | 5 +++++
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 2 ++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c6e68e265269..5076913c153f 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -23,6 +23,7 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_health.h"
>  #include "xfs_error.h"
> +#include "xfs_errortag.h"
>  #include "xfs_bmap.h"
>  #include "xfs_defer.h"
>  #include "xfs_log_format.h"
> @@ -559,6 +560,10 @@ xfs_ag_shrink_space(
>  	be32_add_cpu(&agf->agf_length, -len);
>  
>  	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> +
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
> +		err2 = -ENOSPC;
> +

Seems reasonable, but I feel like this could be broadened to serve as a
generic perag reservation error tag. I suppose we might not be able to
use it on a clean mount, but perhaps it could be reused for growfs and
remount. Hm?

Brian

>  	if (err2) {
>  		be32_add_cpu(&agi->agi_length, len);
>  		be32_add_cpu(&agf->agf_length, len);
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6ca9084b6934..5fd71a930b68 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -40,6 +40,7 @@
>  #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
>  #define XFS_ERRTAG_BMAP_FINISH_ONE			26
>  #define XFS_ERRTAG_AG_RESV_CRITICAL			27
> +
>  /*
>   * DEBUG mode instrumentation to test and/or trigger delayed allocation
>   * block killing in the event of failed writes. When enabled, all
> @@ -58,7 +59,8 @@
>  #define XFS_ERRTAG_BUF_IOERROR				35
>  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> -#define XFS_ERRTAG_MAX					38
> +#define XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL		38
> +#define XFS_ERRTAG_MAX					39
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 185b4915b7bf..7bae34bfddd2 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -168,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> +XFS_ERRORTAG_ATTR_RW(shrinkfs_ag_resv_fail, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -208,6 +209,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>  	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
> +	XFS_ERRORTAG_ATTR_LIST(shrinkfs_ag_resv_fail),
>  	NULL,
>  };
>  
> -- 
> 2.27.0
> 

