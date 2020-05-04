Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E32C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1809D206C0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DbtHhZ2L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgEDTCU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 15:02:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgEDTCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 15:02:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J0eU6164392
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fif4VJUaDUFMcQKJFg1XUggMlYeewIBtyoYB7EJCfNw=;
 b=DbtHhZ2LyZ0YQkJwst3LvPkvGGy03r8xxc0iZf4bAzQ42GXM9ylVD2ZwdyzQ+6TsQc5m
 1FPs7UpMkMGHO5XfKXS6+r1FvqhwaIlveHnlRSJ8vxqATcsVICKwpGsGy/UodlKyB6lT
 0rg7J7GbtKaaVm75MPBdXDoDKCuzZzgT3oaukg54QfAnTYZfoz9LCuJ7x6oYK9DHNKae
 U0SD1wICr89CcfnD+ohiqcbeiMVU9ieewz0+rxqaz5XBEeToYK1KdFFzszujxfkUuHOa
 T7iX6TRn67Ne7TscQ28p0BTReJj3z1epk6auwFsf3IDTsE+U5NA0MY8V22RfEKiUTE85 jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r0u4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:02:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044IwWH7095219
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:00:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjwhhsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:00:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044J0HDQ024045
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:00:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:00:17 -0700
Date:   Mon, 4 May 2020 12:00:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 18/24] xfs: Add helper function
 xfs_attr_node_removename_rmt
Message-ID: <20200504190016.GE5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-19-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:10PM -0700, Allison Collins wrote:
> This patch adds another new helper function
> xfs_attr_node_removename_rmt. This will also help modularize
> xfs_attr_node_removename when we add delay ready attributes later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c8226c6..ab1c9fa 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1216,6 +1216,24 @@ int xfs_attr_node_removename_setup(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_attr_node_removename_rmt (

xfs_attr_node_remove_rmt?

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int			error = 0;
> +
> +	error = xfs_attr_rmtval_remove(args);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Refill the state structure with buffers, the prior calls released our
> +	 * buffers.
> +	 */
> +	return xfs_attr_refillstate(state);
> +}
> +
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1244,15 +1262,7 @@ xfs_attr_node_removename(
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			goto out;
> -
> -		/*
> -		 * Refill the state structure with buffers, the prior calls
> -		 * released our buffers.
> -		 */
> -		error = xfs_attr_refillstate(state);
> +		error = xfs_attr_node_removename_rmt(args, state);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 
