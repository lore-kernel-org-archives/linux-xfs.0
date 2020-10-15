Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8073C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D87322240
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTAU6msp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgJOSDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:03:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33860 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgJOSDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 14:03:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHsgrr098922;
        Thu, 15 Oct 2020 18:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UjQtyGLa5GSGcbPjiLiynVGeuOPFlXKKwBFINglINvY=;
 b=UTAU6mspawSkiA/zJK0whSkWyXcqhHpRjk5t8P4x+2/cqWt5LmOoegqQo+DglBzR1PBM
 q29RVsWBa94PLL2fIdR47fu30NprdigQ4QpZpkvA3twlFm8eERv6+NT4cc/uSzvaOhjw
 67KxdLdnrQHnu1/P+G4SDqqvH1RN1tayH67c7cNuOTeMLTcb1/8+WJwhqWuppPzrulJU
 a1hOruN/Iz44uohxo+QKmaAFB/Lx8vDzZPWNUOcF5zAS7emr/tZHwLM67B+LJx+LetSu
 IQlph5DyOa8CmTM99q5ntPlzG3JnH9GzzPRK/SJ7xEKdoxLSafRa/A1Ge38clGfBM4Mz PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 346g8gkc3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:03:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHtoEf114043;
        Thu, 15 Oct 2020 18:01:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 343phrdppy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 18:01:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FI1goJ030404;
        Thu, 15 Oct 2020 18:01:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 11:01:42 -0700
Date:   Thu, 15 Oct 2020 11:01:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/27] libxfs: add a buftarg cache shrinker implementation
Message-ID: <20201015180141.GZ9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-25-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=5
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a list_lru scanner that runs from the memory pressure detection
> to free an amount of the buffer cache that will keep the cache from
> growing when there is memory pressure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/buftarg.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
> index 6c7142d41eb1..8332bf3341b6 100644
> --- a/libxfs/buftarg.c
> +++ b/libxfs/buftarg.c
> @@ -62,6 +62,19 @@ xfs_buftarg_setsize_early(
>  	return xfs_buftarg_setsize(btp, bsize);
>  }
>  
> +static void
> +dispose_list(
> +	struct list_head	*dispose)
> +{
> +	struct xfs_buf		*bp;
> +
> +	while (!list_empty(dispose)) {
> +		bp = list_first_entry(dispose, struct xfs_buf, b_lru);
> +		list_del_init(&bp->b_lru);
> +		xfs_buf_rele(bp);
> +	}
> +}
> +
>  /*
>   * Scan a chunk of the buffer cache and drop LRU reference counts. If the
>   * count goes to zero, dispose of the buffer.
> @@ -70,6 +83,13 @@ static void
>  xfs_buftarg_shrink(
>  	struct xfs_buftarg	*btc)
>  {
> +	struct list_lru		*lru = &btc->bt_lru;
> +	struct xfs_buf		*bp;
> +	int			count;
> +	int			progress = 16384;
> +	int			rotate = 0;
> +	LIST_HEAD(dispose);
> +
>  	/*
>  	 * Make the fact we are in memory reclaim externally visible. This
>  	 * allows buffer cache allocation throttling while we are trying to
> @@ -79,6 +99,37 @@ xfs_buftarg_shrink(
>  
>  	fprintf(stderr, "Got memory pressure event. Shrinking caches!\n");
>  
> +	spin_lock(&lru->l_lock);
> +	count = lru->l_count / 50;	/* 2% */

If I'm reading this correctly, we react to a memory pressure event by
trying to skim 2% of the oldest disposable buffers off the buftarg LRU?
And every 16384 loop iterations we'll dispose the list even if we
haven't gotten our 2% yet?  How did you arrive at 2%?

(Also, I'm assuming that some of these stderr printfs will at some point
get turned into tracepoints or dbg_printf or the like?)

--D

> +	fprintf(stderr, "cache size before %ld/%d\n", lru->l_count, count);
> +	while (count-- > 0 && !list_empty(&lru->l_lru)) {
> +		bp = list_first_entry(&lru->l_lru, struct xfs_buf, b_lru);
> +		spin_lock(&bp->b_lock);
> +		if (!atomic_add_unless(&bp->b_lru_ref, -1, 1)) {
> +			atomic_set(&bp->b_lru_ref, 0);
> +			bp->b_state |= XFS_BSTATE_DISPOSE;
> +			list_move(&bp->b_lru, &dispose);
> +			lru->l_count--;
> +		} else {
> +			rotate++;
> +			list_move_tail(&bp->b_lru, &lru->l_lru);
> +		}
> +
> +		spin_unlock(&bp->b_lock);
> +		if (--progress == 0) {
> +			fprintf(stderr, "Disposing! rotated %d, lru %ld\n", rotate, lru->l_count);
> +			spin_unlock(&lru->l_lock);
> +			dispose_list(&dispose);
> +			spin_lock(&lru->l_lock);
> +			progress = 16384;
> +			rotate = 0;
> +		}
> +	}
> +	spin_unlock(&lru->l_lock);
> +
> +	dispose_list(&dispose);
> +	fprintf(stderr, "cache size after %ld, count remaining %d\n", lru->l_count, count);
> +
>  	/*
>  	 * Now we've free a bunch of memory, trim the heap down to release the
>  	 * freed memory back to the kernel and reduce the pressure we are
> -- 
> 2.28.0
> 
