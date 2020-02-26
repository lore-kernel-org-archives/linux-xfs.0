Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19639C4BA21
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBC0924653
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HT1ilAs0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBZUh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:37:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgBZUh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:37:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QKO7Ep168118;
        Wed, 26 Feb 2020 20:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZzWRiH5Hs/AnuEnwY8bGqjn9t9KlNCHFb6rNoaf1wVU=;
 b=HT1ilAs08CixjYzIF+hRebfdx1yvj1nMBCgu8YnCnPuhlV9Zc8S6P1Hjd994vqor08UI
 tbuowNP+QqVOw2mj9jug0cMNoI7etnAoMLYVQk+nKJ/FPO5Q0x90zlHhIdILA7Mh2mE2
 TIrpCvyv08eIFnFTffTDMgaWCPCEE20s1yTIq6JNIqJamM0o5+540U/5K4/WCOYUGl/F
 ty4xxtQTKgjL+oeBjh8rJW5ZrPhL1hZV7TboKmQ6cvzS7fos4/3ciL09pCkMRxwMck6X
 71KJlWFg5dO52ymTPKf9+UkzpnNxS+k+I5GqMWdD5dqhEYynqL9864UuIG1lT7vpva6r EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ydybcg59x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 20:37:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QKMj9t063602;
        Wed, 26 Feb 2020 20:37:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ydcsamq8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 20:37:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QKbKgq022081;
        Wed, 26 Feb 2020 20:37:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 12:37:20 -0800
Date:   Wed, 26 Feb 2020 12:37:19 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 31/32] xfs: only allocate the buffer size actually needed
 in __xfs_set_acl
Message-ID: <20200226203719.GK8045@magnolia>
References: <20200226202306.871241-1-hch@lst.de>
 <20200226202306.871241-32-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226202306.871241-32-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 12:23:05PM -0800, Christoph Hellwig wrote:
> No need to allocate the max size if we can just allocate the easily
> known actual ACL size.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_acl.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 552258399648..5807f11aed3e 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -187,16 +187,11 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	args.namelen = strlen(args.name);
>  
>  	if (acl) {
> -		args.valuelen = XFS_ACL_MAX_SIZE(ip->i_mount);
> +		args.valuelen = XFS_ACL_SIZE(acl->a_count);
>  		args.value = kmem_zalloc_large(args.valuelen, 0);
>  		if (!args.value)
>  			return -ENOMEM;
> -
>  		xfs_acl_to_disk(args.value, acl);
> -
> -		/* subtract away the unused acl entries */
> -		args.valuelen -= sizeof(struct xfs_acl_entry) *
> -			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>  	}
>  
>  	error = xfs_attr_set(&args);
> -- 
> 2.24.1
> 
