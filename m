Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9686C2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7834720719
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ilp2sQWd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgIWQ1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:27:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49864 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQ1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:27:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGJn6x176745;
        Wed, 23 Sep 2020 16:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vepc6FzAl2FRViGvTSl5buBOjFTYUMyXN3lxApxZMcU=;
 b=Ilp2sQWdEVUYDLAXusDWUPqo3fDFADYFLw5uvLUaVxsUxY/16d1q1UpwK226pAR6NCl9
 zfqNpR2Idpj27jn/izSrn0KvXxKRIxnUjqPWxW4dV9oGiYR7fZ+nADKlGy99z/c9Xhz0
 tLFCqVtC8vAn84PPk8f1HDtpS/3LXS66M+QKso6yrTl+mzS+wlOnQbbp41eJwJ6pZf2X
 Xkg9tKAyk4ENL81+m6dVdPKiRgnUMZUK5IJLmPVDmXtvwsxCIi+KWwHtCg02Q6ooy+HU
 C8ihn6jydU2YZV8NLznwB/0W7Dthh9BuEN+L78C4FqpVU/JeXWxp4jjVANgsZftPPXgn BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33qcpu0fd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 16:27:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NGKNCT031340;
        Wed, 23 Sep 2020 16:27:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33nujpt0th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 16:27:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NGR2mA006948;
        Wed, 23 Sep 2020 16:27:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 09:27:02 -0700
Date:   Wed, 23 Sep 2020 09:27:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200923162701.GQ7955@magnolia>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922034249.20549-1-hsiangkao@aol.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=5
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> tree"), there is no m_peraglock anymore, so it's hard to understand
> the described situation since per-ag is no longer an array and no
> need to reallocate, call xfs_filestream_flush() in growfs.
> 
> In addition, the race condition for shrink feature is quite confusing
> to me currently as well. Get rid of it instead.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

I'm convinced by the discussion, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_filestream.c | 34 +---------------------------------
>  1 file changed, 1 insertion(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 1a88025e68a3..db23e455eb91 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -33,39 +33,7 @@ enum xfs_fstrm_alloc {
>  /*
>   * Allocation group filestream associations are tracked with per-ag atomic
>   * counters.  These counters allow xfs_filestream_pick_ag() to tell whether a
> - * particular AG already has active filestreams associated with it. The mount
> - * point's m_peraglock is used to protect these counters from per-ag array
> - * re-allocation during a growfs operation.  When xfs_growfs_data_private() is
> - * about to reallocate the array, it calls xfs_filestream_flush() with the
> - * m_peraglock held in write mode.
> - *
> - * Since xfs_mru_cache_flush() guarantees that all the free functions for all
> - * the cache elements have finished executing before it returns, it's safe for
> - * the free functions to use the atomic counters without m_peraglock protection.
> - * This allows the implementation of xfs_fstrm_free_func() to be agnostic about
> - * whether it was called with the m_peraglock held in read mode, write mode or
> - * not held at all.  The race condition this addresses is the following:
> - *
> - *  - The work queue scheduler fires and pulls a filestream directory cache
> - *    element off the LRU end of the cache for deletion, then gets pre-empted.
> - *  - A growfs operation grabs the m_peraglock in write mode, flushes all the
> - *    remaining items from the cache and reallocates the mount point's per-ag
> - *    array, resetting all the counters to zero.
> - *  - The work queue thread resumes and calls the free function for the element
> - *    it started cleaning up earlier.  In the process it decrements the
> - *    filestreams counter for an AG that now has no references.
> - *
> - * With a shrinkfs feature, the above scenario could panic the system.
> - *
> - * All other uses of the following macros should be protected by either the
> - * m_peraglock held in read mode, or the cache's internal locking exposed by the
> - * interval between a call to xfs_mru_cache_lookup() and a call to
> - * xfs_mru_cache_done().  In addition, the m_peraglock must be held in read mode
> - * when new elements are added to the cache.
> - *
> - * Combined, these locking rules ensure that no associations will ever exist in
> - * the cache that reference per-ag array elements that have since been
> - * reallocated.
> + * particular AG already has active filestreams associated with it.
>   */
>  int
>  xfs_filestream_peek_ag(
> -- 
> 2.24.0
> 
