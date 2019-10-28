Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC95CA9EC2
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D35FE20717
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E+8fQPqc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfJ1QeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:34:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729420AbfJ1QeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:34:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTOQs037273;
        Mon, 28 Oct 2019 16:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=zmU7kPvnp42nP8pAKVM/xTTNU9YGxsxK6VoyFwosjKE=;
 b=E+8fQPqcBwX5EJN3YvuVrbYtqDoosdtWUgk8ENaDf7wy68XzBErEpepWQEgdYhS97gfj
 ir5HbdLHuMA7lbp+ea4KWH32H2C7EZOaFAaz+b2gXdP+5sf46xfsrV9VpDe3z4RkW2eF
 xdDNKdMxTNkybmkXnq9jMdsx7PXruyT1uVXreyh4Ebky0tvuBr89lLyjuR2LADTePgSi
 z/hHmVQ1EYkOJNfShsbeZgpIn6tQkmdGJEu5fVKHT6b0z6z5wlQEld2CMgfLBuHOCyq9
 CwSs2GdwW7GAGJeJkWZtXvjybeM1NDo7Oj8ByRwOWLfvH7xfDSdtTxf97Avp26OAqUcu 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vvumf82qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:33:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTJtd096849;
        Mon, 28 Oct 2019 16:33:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vvyn00uqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:33:56 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SGXtqB030603;
        Mon, 28 Oct 2019 16:33:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:33:54 -0700
Date:   Mon, 28 Oct 2019 09:33:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: Sanity check flags of Q_XQUOTARM call
Message-ID: <20191028163353.GI15222@magnolia>
References: <20191023103719.28117-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023103719.28117-1-jack@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 23, 2019 at 12:37:19PM +0200, Jan Kara wrote:
> Flags passed to Q_XQUOTARM were not sanity checked for invalid values.
> Fix that.
> 
> Fixes: 9da93f9b7cdf ("xfs: fix Q_XQUOTARM ioctl")
> Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_quotaops.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> Strictly speaking this may cause user visible regression
> (invalid flags are no longer getting ignored) but in this particular
> case I think we could get away with it.
> 
> 
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index cd6c7210a373..c7de17deeae6 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -201,6 +201,9 @@ xfs_fs_rm_xquota(
>  	if (XFS_IS_QUOTA_ON(mp))
>  		return -EINVAL;
>  
> +	if (uflags & ~(FS_USER_QUOTA | FS_GROUP_QUOTA | FS_PROJ_QUOTA))
> +		return -EINVAL;
> +
>  	if (uflags & FS_USER_QUOTA)
>  		flags |= XFS_DQ_USER;
>  	if (uflags & FS_GROUP_QUOTA)
> -- 
> 2.16.4
> 
