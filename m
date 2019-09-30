Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA99C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 21:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 187302075D
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 21:30:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O52EU3DF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfI3VaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:30:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58074 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfI3VaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 17:30:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UI9iVi127541;
        Mon, 30 Sep 2019 18:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=t/bvhCVX+N6wX4ZDnQrMjVuXBVRJNjLCEkUgV1kt2RI=;
 b=O52EU3DF0yoWg4BaPg4x690+6ApNz6pIMs5sXju08RrpnijI5SAfVsdMx8CvX/tnz8ce
 vBIYCB7CC+2LAvvAvHgRodO4f8p+hOPqQKmoIfu1AuPpjvm9KTSuhB8woqrBf0d6SzbU
 IM8pxqiob5OjNMP53e9IYnIvSmppmK+m4D2sGaY1hvsAicHTYqcBV5DzMIZZhzeWl0gG
 PWWxqegukx5m29b0JbTgSz3o8v8AbAGnntFa3X0WNZWjF0Mrdt0uUBilRBqqwS8Dr/US
 2A8zvPnCWapNt9jHX5PE6YOhKmujGf2Xp47jP6AZt1SuhwVVC49sS8GLvrktr9W540+C lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rh0yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:24:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UIDnUv175731;
        Mon, 30 Sep 2019 18:24:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vah1j815h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:24:42 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UIOgJ9005614;
        Mon, 30 Sep 2019 18:24:42 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 11:24:42 -0700
Date:   Mon, 30 Sep 2019 11:24:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused flags arg from xfs_get_aghdr_buf()
Message-ID: <20190930182441.GD13108@magnolia>
References: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f4d86a1-0cb9-f859-b120-34d1b511942f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 10:46:42AM -0500, Eric Sandeen wrote:
> The flags op is always passed as zero, so remove it.
> 
> (xfs_buf_get_uncached takes flags to support XBF_NO_IOACCT for
> the sb, but that should never be relevant for xfs_get_aghdr_buf)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5de296b34ab1..14fbdf22b7e7 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -28,12 +28,11 @@ xfs_get_aghdr_buf(
>  	struct xfs_mount	*mp,
>  	xfs_daddr_t		blkno,
>  	size_t			numblks,
> -	int			flags,
>  	const struct xfs_buf_ops *ops)
>  {
>  	struct xfs_buf		*bp;
>  
> -	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, flags);
> +	bp = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0);
>  	if (!bp)
>  		return NULL;
>  
> @@ -345,7 +344,7 @@ xfs_ag_init_hdr(
>  {
>  	struct xfs_buf		*bp;
>  
> -	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, 0, ops);
> +	bp = xfs_get_aghdr_buf(mp, id->daddr, id->numblks, ops);
>  	if (!bp)
>  		return -ENOMEM;
>  
> 
