Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6206BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3602220678
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Al+fvzf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAUSnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:43:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbgAUSnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:43:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISZ6K013091;
        Tue, 21 Jan 2020 18:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=n2ygIXdOwXFpHDKwRZfEgZsqWE20ZZx4mFVVJiSNoS0=;
 b=Al+fvzf51CFiXlr71l/UuKXda3liSyrDPsI2KDZdwJsEYVueIh0HYuBVAvhmnwvkxRzq
 1rFvARVjEMzD6j98Yqw1kt8X+CpSsvaEjA/olj/ApV3JUcEcABbWuE30v2dXVavkGkjk
 JEUGoDBXO+bFN/nJyCoiOcyasX8K38CxNOWkuBLDJ2Qpyb2OAHfQrfAHCvryoeInEJ5C
 BuzViIjpgTDzxA68Asb1oqlsYqY8LUqIu9Qzg03sv/WelN1WoOS/5DQZgoi5jSGQHOw5
 yOCCg0YSJPFr17iAPTTHXkPFu7GBtazt0P0OmXqvmqxEwkgnYBoiHujXVgnHy9HLcd+y Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuf5bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:43:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISujj086569;
        Tue, 21 Jan 2020 18:43:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpefdn1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:43:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LIhmK6016032;
        Tue, 21 Jan 2020 18:43:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:43:48 -0800
Date:   Tue, 21 Jan 2020 10:43:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 22/29] xfs: lift common checks into xfs_ioc_attr_list
Message-ID: <20200121184346.GV8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-23-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-23-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=985
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:44AM +0100, Christoph Hellwig wrote:
> Lift the flags and bufsize checks from both callers into the common code
> in xfs_ioc_attr_list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c   | 19 ++++++++++---------
>  fs/xfs/xfs_ioctl32.c |  9 ---------
>  2 files changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 639abd2bd723..a3a6c6882c6f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -362,6 +362,16 @@ xfs_ioc_attr_list(
>  	struct xfs_attrlist		*alist;
>  	int				error;
>  
> +	if (bufsize < sizeof(struct xfs_attrlist) ||
> +	    bufsize > XFS_XATTR_LIST_MAX)
> +		return -EINVAL;
> +
> +	/*
> +	 * Reject flags, only allow namespaces.
> +	 */
> +	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
> +		return -EINVAL;
> +
>  	/*
>  	 * Validate the cursor.
>  	 */
> @@ -416,15 +426,6 @@ xfs_attrlist_by_handle(
>  		return -EPERM;
>  	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
> -	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
> -		return -EINVAL;
> -
> -	/*
> -	 * Reject flags, only allow namespaces.
> -	 */
> -	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
> -		return -EINVAL;
>  
>  	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index feb7bf07f315..840d17951407 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -366,15 +366,6 @@ xfs_compat_attrlist_by_handle(
>  	if (copy_from_user(&al_hreq, arg,
>  			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
>  		return -EFAULT;
> -	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
> -	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
> -		return -EINVAL;
> -
> -	/*
> -	 * Reject flags, only allow namespaces.
> -	 */
> -	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
> -		return -EINVAL;
>  
>  	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
> -- 
> 2.24.1
> 
