Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACC6C35280
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A032F2070B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YRRr1F6W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfJHQLl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:11:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHQLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 12:11:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98FsNTn151354;
        Tue, 8 Oct 2019 16:11:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Ts9iEYYkWgJOosja85Tf8Pby3cUDzmAKQW/I4H8Di78=;
 b=YRRr1F6WhSmYDgDQDWDZ7mPqmBFLek/oF80r7/Qqu3QiVwyqdHty7xiOGZTENydcY23n
 Kvjd2IJXvwpiF2vUCaR5PB1msp8o4JslpLXHXs8PKeDHPY3Q2YBhB92Cvagnhv10dVwi
 yAchq9BeWZKOLCXxE8snO0EdfeE6ROtMoopQIbqcQJm0xN1+BY70uQFG3FLkleLk2eSO
 ND610vPQzgnnYv1Lep/STT3egnm1RoWc+KR9BbfzxoV8qc9KFVoTAHFjh84y/Hd3WfIM
 QztEgg8hQ6leqKhcZx0hUzczl0/Qy6F4CSFvRwkzOxFwToxYC1XcnPzZ0yI0hc/oID6s lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vektre4f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 16:11:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98Fqf1T090119;
        Tue, 8 Oct 2019 16:11:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vgeuy7ucm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 16:11:28 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x98GBRwu023972;
        Tue, 8 Oct 2019 16:11:27 GMT
Received: from localhost (/10.159.136.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 16:11:27 +0000
Date:   Tue, 8 Oct 2019 09:11:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: remove broken error handling on failed attr
 sf to leaf change
Message-ID: <20191008161126.GD13108@magnolia>
References: <20191007131938.23839-1-bfoster@redhat.com>
 <20191007131938.23839-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007131938.23839-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:19:37AM -0400, Brian Foster wrote:
> xfs_attr_shortform_to_leaf() attempts to put the shortform fork back
> together after a failed attempt to convert from shortform to leaf
> format. While this code reallocates and copies back the shortform
> attr fork data, it never resets the inode format field back to local
> format. Further, now that the inode is properly logged after the
> initial switch from local format, any error that triggers the
> recovery code will eventually abort the transaction and shutdown the
> fs. Therefore, remove the broken and unnecessary error handling
> code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 36c0a32cefcf..1b956c313b6b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -831,28 +831,13 @@ xfs_attr_shortform_to_leaf(
>  
>  	bp = NULL;
>  	error = xfs_da_grow_inode(args, &blkno);
> -	if (error) {
> -		/*
> -		 * If we hit an IO error middle of the transaction inside
> -		 * grow_inode(), we may have inconsistent data. Bail out.
> -		 */
> -		if (error == -EIO)
> -			goto out;
> -		xfs_idata_realloc(dp, size, XFS_ATTR_FORK);	/* try to put */
> -		memcpy(ifp->if_u1.if_data, tmpbuffer, size);	/* it back */
> +	if (error)
>  		goto out;
> -	}
>  
>  	ASSERT(blkno == 0);
>  	error = xfs_attr3_leaf_create(args, blkno, &bp);
> -	if (error) {
> -		/* xfs_attr3_leaf_create may not have instantiated a block */
> -		if (bp && (xfs_da_shrink_inode(args, 0, bp) != 0))
> -			goto out;
> -		xfs_idata_realloc(dp, size, XFS_ATTR_FORK);	/* try to put */
> -		memcpy(ifp->if_u1.if_data, tmpbuffer, size);	/* it back */
> +	if (error)
>  		goto out;
> -	}
>  
>  	memset((char *)&nargs, 0, sizeof(nargs));
>  	nargs.dp = dp;
> -- 
> 2.20.1
> 
