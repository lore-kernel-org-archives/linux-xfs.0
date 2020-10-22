Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57FBC388F2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B454206B6
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N8BsS1gE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508036AbgJVFpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:45:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48352 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438071AbgJVFpU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:45:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M5jIBK113761;
        Thu, 22 Oct 2020 05:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZCdqMGAGQvfbwc2MO1WaB0OBuK8tw8A89LxZscm+qD4=;
 b=N8BsS1gEGO6n8i0WDFXRUN9Cpfa4MYK726m2Dv6BotR6vQNC+vgk8CjgY2lF/h9xXD2G
 vwZhVA65Yf833InQaJyqDpa7X22yPY6MbDZBmOR/IAKKR5eH/Mie6Hc57+SjpV6YW0cv
 NSUsB4sMZFG9g2Ynd3MTD5GTjKwNj5JYsrs8xhUxbKQsodkqbJlEV2YJALXsWipDQC1b
 Gaeu7DtK2uVLvmsB13OxkNK2EexLFOLJXwSauMNaeL93nh1ePpe1WOvR5c100AMoFsNO
 B65/JRLa0ctjup6DMVOloOCr7iPvM2Yn2Pl5jlWRTQdm8WTufxtbDIt0Ufh3oDp9RHJF dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16m84b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 05:45:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M5j0a7131653;
        Thu, 22 Oct 2020 05:45:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 348ahycndc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 05:45:17 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09M5jGGi007659;
        Thu, 22 Oct 2020 05:45:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 22:45:15 -0700
Date:   Wed, 21 Oct 2020 22:45:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] repair: Protect bad inode list with mutex
Message-ID: <20201022054515.GM9832@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220039
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 04:15:32PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To enable phase 6 parallelisation, we need to protect the bad inode
> list from concurrent modification and/or access. Wrap it with a
> mutex and clean up the nasty typedefs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/methinks the typedef removal ought to be a separate commit,
but otherwise:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  repair/dir2.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index eabdb4f2d497..23333e59a382 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -20,40 +20,50 @@
>   * Known bad inode list.  These are seen when the leaf and node
>   * block linkages are incorrect.
>   */
> -typedef struct dir2_bad {
> +struct dir2_bad {
>  	xfs_ino_t	ino;
>  	struct dir2_bad	*next;
> -} dir2_bad_t;
> +};
>  
> -static dir2_bad_t *dir2_bad_list;
> +static struct dir2_bad	*dir2_bad_list;
> +pthread_mutex_t		dir2_bad_list_lock = PTHREAD_MUTEX_INITIALIZER;
>  
>  static void
>  dir2_add_badlist(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	struct dir2_bad	*l;
>  
> -	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
> +	l = malloc(sizeof(*l));
> +	if (!l) {
>  		do_error(
>  _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
> -			sizeof(dir2_bad_t), ino);
> +			sizeof(*l), ino);
>  		exit(1);
>  	}
> +	pthread_mutex_lock(&dir2_bad_list_lock);
>  	l->next = dir2_bad_list;
>  	dir2_bad_list = l;
>  	l->ino = ino;
> +	pthread_mutex_unlock(&dir2_bad_list_lock);
>  }
>  
>  int
>  dir2_is_badino(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	struct dir2_bad	*l;
> +	int		ret = 0;
>  
> -	for (l = dir2_bad_list; l; l = l->next)
> -		if (l->ino == ino)
> -			return 1;
> -	return 0;
> +	pthread_mutex_lock(&dir2_bad_list_lock);
> +	for (l = dir2_bad_list; l; l = l->next) {
> +		if (l->ino == ino) {
> +			ret = 1;
> +			break;
> +		}
> +	}
> +	pthread_mutex_unlock(&dir2_bad_list_lock);
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.28.0
> 
