Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA09BC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8D022082C
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITs6OnN7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392138AbfIFDhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:37:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43408 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XuXX074305
        for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2019 03:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=m7wsSsnonNu8UQ+1fk5QTU7TboZkC9l/uaRiwbNfLAo=;
 b=ITs6OnN7jbeNc0lxhG9AYxImTz/wjeiLPbXQBlk5vOPISpOS9xg3MAWeim+mBJCrDjM0
 zxVJLrP41Fec1bf2iN09akOC0HN0qyPRBDjB9Q5m0E1uiJH+4wui4XpzQyUWvofH+JuY
 tR9r711dz7/s/eC9WkMWgK/a7apDsdFvoYJw7I0gCrxwzQuCGA7MOGaKxn1g7MILkaVy
 qPxLKzbzi3gM6lLVMfOC8h8V6UrbeJReI5UB8GIOKBM2BG0sqlZdwC9PTLq3c10MX5kp
 aEe4it/XXYYPpb7wVbGVeEFDbnN/kjPSMMDJxaacnK9S4/1gAP9zaQRKNDHW2341TGJ9 mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uuf51g388-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2019 03:37:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XTfJ188609
        for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2019 03:37:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2utpmc7626-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2019 03:37:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863bZNx015664
        for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2019 03:37:35 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:35 -0700
Date:   Thu, 5 Sep 2019 20:37:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 03/19] xfs: Add xfs_dabuf defines
Message-ID: <20190906033734.GS2229799@magnolia>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-4-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:21PM -0700, Allison Collins wrote:
> This patch adds two new defines XFS_DABUF_MAP_NOMAPPING and
> XFS_DABUF_MAP_HOLE_OK.  This helps to clean up hard numbers and
> makes the code easier to read
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.h | 3 +++
>  fs/xfs/libxfs/xfs_da_btree.c  | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 7b74e18..536a290 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -16,6 +16,9 @@ struct xfs_da_state_blk;
>  struct xfs_inode;
>  struct xfs_trans;
>  
> +#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
> +#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */
> +
>  /*
>   * Used to keep a list of "remote value" extents when unlinking an inode.
>   */
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 129ec09..2b94685 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2534,7 +2534,8 @@ xfs_dabuf_map(
>  	 * Caller doesn't have a mapping.  -2 means don't complain
>  	 * if we land in a hole.
>  	 */
> -	if (mappedbno == -1 || mappedbno == -2) {
> +	if (mappedbno == XFS_DABUF_MAP_NOMAPPING ||
> +	    mappedbno == XFS_DABUF_MAP_HOLE_OK) {

Er... convert the users of -1 and -2 too, please...

--D

>  		/*
>  		 * Optimize the one-block case.
>  		 */
> -- 
> 2.7.4
> 
