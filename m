Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BB3C2BB1D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 18:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4930920739
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 18:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vkfRt7Mo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgCKSXo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 14:23:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730677AbgCKSXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 14:23:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BIMghh080216;
        Wed, 11 Mar 2020 18:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aRVsGVOekcoc5qS49EfQnrUpzVkvg+GeXYO7E0ACEco=;
 b=vkfRt7Moc8rJ2fqxkPH8uWRXiVX2aLsr8lizrRFW+eCOAbqFtEbdjQD3daDv8BcgaVG+
 MGwxYt0IDOSPQR1H9cUP8RiT6uFUUq5h0KKMV/FRwDXKU2OOJ8N0PfeF6Mgb5GJ5fGvP
 iLnM0ABj3UpRZmBRpaLTLCIO1XUMHBRy3IUcY8NVplSoKCep9QHArPYg2AAXcUkojYda
 YxmHx/jzBQis5TQPfi6qLcCI6Toiz5OF0pQYqSqCG/cF51fWXm40O16nqt+ceQ84s41M
 mo57/eqLdVqgKgVexFyfn4D+zEQmR7MKSh10r8hpkzG2Opd4sFbYjazt77ouYHM7hV2W vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v68g3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 18:23:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BIKTNM157899;
        Wed, 11 Mar 2020 18:21:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yp8q14607-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 18:21:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02BILcvi003081;
        Wed, 11 Mar 2020 18:21:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 11:21:37 -0700
Date:   Wed, 11 Mar 2020 11:21:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200311182136.GH8045@magnolia>
References: <20200311093552.25354-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311093552.25354-1-tiwai@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110105
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 10:35:52AM +0100, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().

> Signed-off-by: Takashi Iwai <tiwai@suse.de>

The 'c' in 'scnprintf' means that it returns the number of bytes written
into the buffer (not including the \0) instead of the number of bytes
that /would/ have been written provided there was enough space, right?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_stats.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 113883c4f202..f70f1255220b 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -57,13 +57,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  	/* Loop over all stats groups */
>  
>  	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
> -		len += snprintf(buf + len, PATH_MAX - len, "%s",
> +		len += scnprintf(buf + len, PATH_MAX - len, "%s",
>  				xstats[i].desc);
>  		/* inner loop does each group */
>  		for (; j < xstats[i].endpoint; j++)
> -			len += snprintf(buf + len, PATH_MAX - len, " %u",
> +			len += scnprintf(buf + len, PATH_MAX - len, " %u",
>  					counter_val(stats, j));
> -		len += snprintf(buf + len, PATH_MAX - len, "\n");
> +		len += scnprintf(buf + len, PATH_MAX - len, "\n");
>  	}
>  	/* extra precision counters */
>  	for_each_possible_cpu(i) {
> @@ -72,9 +72,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
>  	}
>  
> -	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
> +	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
>  			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
> -	len += snprintf(buf + len, PATH_MAX-len, "debug %u\n",
> +	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
>  #if defined(DEBUG)
>  		1);
>  #else
> -- 
> 2.16.4
> 
