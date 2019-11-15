Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803C1C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AE6820732
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bzg0ZrGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKOTiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 14:38:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOTiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 14:38:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFJY806118406;
        Fri, 15 Nov 2019 19:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=QyTanHk/SVJ0Oe4j2oYFOA8Zo3H8Yl/i7gusfJRHeTY=;
 b=Bzg0ZrGY70og8mPVx6/RIV3bKbKaE5Lp38XBA1lCMKuXWKlp5stP+J9aCQyYB539ZNvl
 Wa4kfo3ftbm34veUexl7WEnSwfj8VNjyBUnSF47yhyqrXSjgQc48V9QnJdjFe6Wtokox
 hLA8/SuuKqawQCEXOlx4njy8N2Irukhsfe5enBdIJ/ghhBC1Sb1qOEWsxBOaPNTM6xH6
 lR2CQBa7IvMeBvc1kz8I+eJtGzX4cobxNtSKPki0JsNyWmJnHK/Eaqoto/MBw5NTc/MA
 0HICtiIuy8xEWwN895xOE4028ml0doDV01S4m0kJyxXktM7dbLtsXNYoxj9WBPH/hGng Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w9gxpn7y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 19:38:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFJc2XK136261;
        Fri, 15 Nov 2019 19:38:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w9h0ntb4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 19:38:15 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAFJcEHV012080;
        Fri, 15 Nov 2019 19:38:14 GMT
Received: from localhost (/10.159.141.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Nov 2019 11:38:13 -0800
Date:   Fri, 15 Nov 2019 11:38:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: remove stray libxfs whitespace
Message-ID: <20191115193813.GQ6219@magnolia>
References: <57d4cc5d-6ec5-6977-1903-17a285202d79@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57d4cc5d-6ec5-6977-1903-17a285202d79@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9442 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9442 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 01:35:31PM -0600, Eric Sandeen wrote:
> Not quite sure how these crept in but now's as good a time as any
> to remove stray newline deltas vs. the kernel code.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 5dba5fbc..6ca43c73 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -755,6 +755,7 @@ struct xfs_scrub_metadata {
>  #  define XFS_XATTR_LIST_MAX 65536
>  #endif
>  
> +
>  /*
>   * ioctl commands that are used by Linux filesystems
>   */
> @@ -825,7 +826,6 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
>  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
>  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
> -
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  /* reflink ioctls; these MUST match the btrfs ioctl definitions */
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index fbdce4d6..4859b739 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -15,6 +15,7 @@
>  #include "xfs_ialloc.h"
>  #include "xfs_dir2.h"
>  
> +
>  /*
>   * Check that none of the inode's in the buffer have a next
>   * unlinked field of 0.
> diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
> index 3a09ee76..7fa0c184 100644
> --- a/libxfs/xfs_trans_inode.c
> +++ b/libxfs/xfs_trans_inode.c
> @@ -11,6 +11,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  
> +
>  /*
>   * Add a locked inode to the transaction.
>   *
> 
