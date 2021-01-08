Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1092C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F8723A80
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbhAHVVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:21:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729211AbhAHVVD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 16:21:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108L9AW0016200;
        Fri, 8 Jan 2021 21:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8zpSsjvJVaiKMwYBXgiTKd85NrDcNI/LAt8HG+tQgzo=;
 b=UEOOdskS1etAOf2FEWD4M2ak0GlpRlxEzQOyN2NotXWDofgvsUOFVDz4ZuAYQYKRXZwS
 Pl91lBLcLwPdryC0jk8DdUvzsgzzXsKE8ANFfICmuZYgXi5ZizPMD0PUeck+0zEDnRT6
 H+hqMzwJ0lzzO9V/t5jaHwSE/LQNRDZaE7NNBF7C7DLPC0c0wHKgIbLjNR/nH1gUgE5D
 Iw1sXqmMkA2MZjK+SbRTB6wbyNAOIDKcuGTOWl/eew+vKKBOgrOCco0Ks+OcdnilnXhf
 3koM9gCQwp1ThB05sFc6teZGQYoSCw1BFY8nwMyVIaVI38PZ5dSckzMBGHNAXD0m7O5O 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35wepmjyr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 21:20:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108LAZ42191597;
        Fri, 8 Jan 2021 21:20:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35v4rfr0gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 21:20:18 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 108LKHAV025786;
        Fri, 8 Jan 2021 21:20:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 21:20:17 +0000
Date:   Fri, 8 Jan 2021 13:20:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 3/4] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <20210108212016.GR38809@magnolia>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108190919.623672-4-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 09, 2021 at 03:09:18AM +0800, Gao Xiang wrote:
> Move out related logic for initializing new added AGs to a new helper
> in preparation for shrinking. No logic changes.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 74 +++++++++++++++++++++++++++-------------------

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  1 file changed, 44 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 6c5f6a50da2e..a792d1f0ac55 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -20,6 +20,49 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
> +static int
> +xfs_resizefs_init_new_ags(
> +	xfs_mount_t		*mp,
> +	struct aghdr_init_data	*id,
> +	xfs_agnumber_t		oagcount,
> +	xfs_agnumber_t		nagcount,
> +	xfs_rfsblock_t		*delta)
> +{
> +	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
> +	int			error;
> +
> +	/*
> +	 * Write new AG headers to disk. Non-transactional, but need to be
> +	 * written and completed prior to the growfs transaction being logged.
> +	 * To do this, we use a delayed write buffer list and wait for
> +	 * submission and IO completion of the list as a whole. This allows the
> +	 * IO subsystem to merge all the AG headers in a single AG into a single
> +	 * IO and hide most of the latency of the IO from us.
> +	 *
> +	 * This also means that if we get an error whilst building the buffer
> +	 * list to write, we can cancel the entire list without having written
> +	 * anything.
> +	 */
> +	INIT_LIST_HEAD(&id->buffer_list);
> +	for (id->agno = nagcount - 1;
> +	     id->agno >= oagcount;
> +	     id->agno--, *delta -= id->agsize) {
> +
> +		if (id->agno == nagcount - 1)
> +			id->agsize = nb - (id->agno *
> +					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> +		else
> +			id->agsize = mp->m_sb.sb_agblocks;
> +
> +		error = xfs_ag_init_headers(mp, id);
> +		if (error) {
> +			xfs_buf_delwri_cancel(&id->buffer_list);
> +			return error;
> +		}
> +	}
> +	return xfs_buf_delwri_submit(&id->buffer_list);
> +}
> +
>  /*
>   * growfs operations
>   */
> @@ -74,36 +117,7 @@ xfs_growfs_data_private(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * Write new AG headers to disk. Non-transactional, but need to be
> -	 * written and completed prior to the growfs transaction being logged.
> -	 * To do this, we use a delayed write buffer list and wait for
> -	 * submission and IO completion of the list as a whole. This allows the
> -	 * IO subsystem to merge all the AG headers in a single AG into a single
> -	 * IO and hide most of the latency of the IO from us.
> -	 *
> -	 * This also means that if we get an error whilst building the buffer
> -	 * list to write, we can cancel the entire list without having written
> -	 * anything.
> -	 */
> -	INIT_LIST_HEAD(&id.buffer_list);
> -	for (id.agno = nagcount - 1;
> -	     id.agno >= oagcount;
> -	     id.agno--, delta -= id.agsize) {
> -
> -		if (id.agno == nagcount - 1)
> -			id.agsize = nb -
> -				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> -		else
> -			id.agsize = mp->m_sb.sb_agblocks;
> -
> -		error = xfs_ag_init_headers(mp, &id);
> -		if (error) {
> -			xfs_buf_delwri_cancel(&id.buffer_list);
> -			goto out_trans_cancel;
> -		}
> -	}
> -	error = xfs_buf_delwri_submit(&id.buffer_list);
> +	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.27.0
> 
