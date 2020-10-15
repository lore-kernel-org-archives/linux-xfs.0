Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A164EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A2FA22254
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LSgKjDNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389979AbgJORJX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:09:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58836 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389725AbgJORJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 13:09:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FH4NJE100568;
        Thu, 15 Oct 2020 17:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FcwaZQxsvwoNahJy2ZfETdvv8q1p1D9bbJnJAqEofuE=;
 b=LSgKjDNq49hPEWQ5pVCZl7W8RR4Z+sWQn1/b676Of5aa+Gz2yUPpMub2Arfpz1ZnRbuq
 or4Uj6Y4/JbQObgyXot0WlywOQdCWUoJKBR7RiDmwIz5jiz6D2dRJAc1AEZMU4AGu+my
 2F2TjWRBAyHX/zg2RShgs8n18iUh/AyT427YBUoHgGuwBLr7i10PvF8KSl0Yqt4I7DfL
 Jfmkb2uiWzyMqvW+5qVi3t2XEaoHaYBtxi0TeJXjQpab90LShWM3d4kIv6WM5AItish3
 OM+sTpjE/lq4g3reRIqe5OB5tGq0mdNIMPLxKvVCv2aBXbtg3dOh8A8kvyijpKsIgN+k ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3434wkwvnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 17:09:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FH5Nvx089936;
        Thu, 15 Oct 2020 17:09:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 343pv23ycj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 17:09:20 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FH9Ite029816;
        Thu, 15 Oct 2020 17:09:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 10:09:18 -0700
Date:   Thu, 15 Oct 2020 10:09:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/27] libxfs: add kernel-compatible completion API
Message-ID: <20201015170917.GU9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-11-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=1 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150113
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:38PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is needed for the kernel buffer cache conversion to be able
> to wait on IO synchrnously. It is implemented with pthread mutexes
> and conditional variables.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/Makefile     |  1 +
>  include/completion.h | 61 ++++++++++++++++++++++++++++++++++++++++++++
>  include/libxfs.h     |  1 +
>  libxfs/libxfs_priv.h |  1 +
>  4 files changed, 64 insertions(+)
>  create mode 100644 include/completion.h
> 
> diff --git a/include/Makefile b/include/Makefile
> index f7c40a5ce1a1..98031e70fa0d 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -12,6 +12,7 @@ LIBHFILES = libxfs.h \
>  	atomic.h \
>  	bitops.h \
>  	cache.h \
> +	completion.h \
>  	hlist.h \
>  	kmem.h \
>  	list.h \
> diff --git a/include/completion.h b/include/completion.h
> new file mode 100644
> index 000000000000..92194c3f1484
> --- /dev/null
> +++ b/include/completion.h
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2019 RedHat, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef __LIBXFS_COMPLETION_H__
> +#define __LIBXFS_COMPLETION_H__
> +
> +/*
> + * This implements kernel compatible completion semantics. This is slightly
> + * different to the way pthread conditional variables work in that completions
> + * can be signalled before the waiter tries to wait on the variable. In the
> + * pthread case, the completion is ignored and the waiter goes to sleep, whilst
> + * the kernel will see that the completion has already been completed and so
> + * will not block. This is handled through the addition of the the @signalled
> + * flag in the struct completion.

Hmm... do any of the existing pthread_cond_t users need these semantics?

I suspect the ones in scrub/vfs.c might actually be vulnerable to the
signal-before-wait race that this completion structure solves.

In any case, seeing as this primitive isn't inherent to the xfs disk
format, maybe these new concurrency management things belong in libfrog?

--D

> + */
> +struct completion {
> +	pthread_mutex_t		lock;
> +	pthread_cond_t		cond;
> +	bool			signalled; /* for kernel completion behaviour */
> +	int			waiters;
> +};
> +
> +static inline void
> +init_completion(struct completion *w)
> +{
> +	pthread_mutex_init(&w->lock, NULL);
> +	pthread_cond_init(&w->cond, NULL);
> +	w->signalled = false;
> +}
> +
> +static inline void
> +complete(struct completion *w)
> +{
> +	pthread_mutex_lock(&w->lock);
> +	w->signalled = true;
> +	pthread_cond_broadcast(&w->cond);
> +	pthread_mutex_unlock(&w->lock);
> +}
> +
> +/*
> + * Support for mulitple waiters requires that we count the number of waiters
> + * we have and only clear the signalled variable once all those waiters have
> + * been woken.
> + */
> +static inline void
> +wait_for_completion(struct completion *w)
> +{
> +	pthread_mutex_lock(&w->lock);
> +	if (!w->signalled) {
> +		w->waiters++;
> +		pthread_cond_wait(&w->cond, &w->lock);
> +		w->waiters--;
> +	}
> +	if (!w->waiters)
> +		w->signalled = false;
> +	pthread_mutex_unlock(&w->lock);
> +}
> +
> +#endif /* __LIBXFS_COMPLETION_H__ */
> diff --git a/include/libxfs.h b/include/libxfs.h
> index caf4a5139469..d03ec8aeaf5c 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -19,6 +19,7 @@
>  #include "libfrog/radix-tree.h"
>  #include "atomic.h"
>  #include "spinlock.h"
> +#include "completion.h"
>  
>  #include "xfs_types.h"
>  #include "xfs_fs.h"
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index e134f65c5dd1..5cbc4fe69732 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -49,6 +49,7 @@
>  #include "libfrog/radix-tree.h"
>  #include "atomic.h"
>  #include "spinlock.h"
> +#include "completion.h"
>  
>  #include "xfs_types.h"
>  #include "xfs_arch.h"
> -- 
> 2.28.0
> 
