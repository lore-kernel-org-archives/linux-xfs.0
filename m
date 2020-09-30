Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8114DC4727F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5DE20739
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rZrCB20k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgI3OZj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:25:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33750 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbgI3OZj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 10:25:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEPYuL065292;
        Wed, 30 Sep 2020 14:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7aqU1ljgmZuHRiPkH/kMl6wl8X9iWJThQSmfhvUcLqU=;
 b=rZrCB20kiD/0/CyoKV2cJ1TtD+lxDm9CvNMw69PC1PQOWs9gGr300fmndXk8HDXuBrZA
 K+VcSnjYkaGGaezsK74/jNAKz9xRiu2/YTSyVb4XO1+2cs93CyBG1ZyyfuFsmg/p2FQ7
 vT7u2/8O/8tElnZjp4kBM8BSkSHz0dY9iKVfM4XmBU1dzByb0Fsr2T/JX30l7LnL3S7+
 RC0TjhaL9fw+VGdu7UodGMWDGU99A6Q8I5TRgUe5VqguQKm3a0QtL8QGngZrmpkedGkJ
 wuPXICR23fVLQB9OiFD43IV5epp8LMXgn3Zt2TvNs+o0CiXQLvLW1gWujSs/ToATB6qb 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkm0t9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 14:25:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEJnQ6179705;
        Wed, 30 Sep 2020 14:25:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfjyrv0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 14:25:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08UEPSTv028280;
        Wed, 30 Sep 2020 14:25:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 07:25:28 -0700
Date:   Wed, 30 Sep 2020 07:25:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, nathans@redhat.com
Subject: Re: [PATCH 1/2] xfs: stats expose padding value at end of qm line
Message-ID: <20200930142527.GJ49547@magnolia>
References: <20200930063532.142256-1-david@fromorbit.com>
 <20200930063532.142256-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930063532.142256-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 04:35:31PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are 8 quota stats exposed, but:
> 
> $ grep qm /proc/fs/xfs/stat
> qm 0 0 0 1889 308893 0 0 0 0
> $
> 
> There are 9 values exposed. Code inspection reveals that the struct
> xfsstats has a hole in the structure where the values change from 32
> bit counters to 64 bit counters. pahole output:
> 
> ....
> uint32_t                   xs_qm_dquot;          /*   748     4 */
> uint32_t                   xs_qm_dquot_unused;   /*   752     4 */
> 
> /* XXX 4 bytes hole, try to pack */
> 
> uint64_t                   xs_xstrat_bytes;      /*   760     8 */

Any chance we could use BUILD_BUG_ON(offsetof(xs_xstrat_bytes) % 8 == 0)
to catch this kind of thing on 64-bit machines in the future?  Or maybe
we shift the u64 values to the start of the structure to avoid padding
holes?

Also, does 32-bit XFS have this 9th value?

--D

> ....
> 
> Fix this by defining an "end of 32 bit variables" variable that
> we then use to define the end of the quota line. This will then
> ensure that we print the correct number of values regardless of
> structure layout.
> 
> However, ABI requirements for userspace parsers mean we cannot
> remove the output that results from this hole, so we also need to
> explicitly define this unused value until such time that we actually
> add a new stat that makes the output meaningful.
> 
> And now we have a defined end of 32bit variables, update the  stats
> union to be sized to match all the 32 bit variables correctly.
> 
> Output with this patch:
> 
> $ grep qm /proc/fs/xfs/stat
> qm 0 0 0 326 1802 0 6 3 0
> $
> 
> Reported-by: Nathan Scott <nathans@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_stats.c |  2 +-
>  fs/xfs/xfs_stats.h | 15 +++++++++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index f70f1255220b..3409b273f00a 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -51,7 +51,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
>  		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>  		/* we print both series of quota information together */
> -		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
> +		{ "qm",			xfsstats_offset(xs_end_of_32bit_counts)},
>  	};
>  
>  	/* Loop over all stats groups */
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 34d704f703d2..861acf84cb3c 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -133,6 +133,17 @@ struct __xfsstats {
>  	uint32_t		xs_qm_dqwants;
>  	uint32_t		xs_qm_dquot;
>  	uint32_t		xs_qm_dquot_unused;
> +	uint32_t		xs_qm_zero_until_next_stat_is_added;
> +
> +/*
> + * Define the end of 32 bit counters as a 32 bit variable so that we don't
> + * end up exposing an implicit structure padding hole due to the next counters
> + * being 64bit values. If the number of coutners is odd, this fills the hole. If
> + * the number of coutners is even the hole is after this variable and the stats
> + * line will terminate printing at this offset and not print the hole.
> + */
> +	uint32_t		xs_end_of_32bit_counts;
> +
>  /* Extra precision counters */
>  	uint64_t		xs_xstrat_bytes;
>  	uint64_t		xs_write_bytes;
> @@ -143,8 +154,8 @@ struct __xfsstats {
>  
>  struct xfsstats {
>  	union {
> -		struct __xfsstats	s;
> -		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
> +		struct __xfsstats s;
> +		uint32_t	a[xfsstats_offset(xs_end_of_32bit_counts)];
>  	};
>  };
>  
> -- 
> 2.28.0
> 
