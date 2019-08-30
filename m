Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772D6C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4898C21721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XI5qcx7S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfH3Fjt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:39:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbfH3Fjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:39:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U5dEHZ189185;
        Fri, 30 Aug 2019 05:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Qq6jwZ95/VCzbf8MTVTBoT6xqQG43KMlrdM3Ju4DRCk=;
 b=XI5qcx7SPwl5Ogx+0wRdDZAGLwwN3bPXIDsFYxFWA3FqV1sUtTanp2i4xeXitINKZ3NB
 h4CcLK1NaW2jGasUfTLwDBmGjbPSXQhrHmbfCx2UMrUMrrwtTbcQWxL9LkUkQWOcBTtG
 XtaVC/81SnGHayiuAElfjHCeyBvFxOoW0iqSK/IVl5u5nCbdB0m9rIs7AOl8M4emSP/W
 Gu8H9/tYhtCKLdJucHDSqCr4JH0610mopRwJMRFmzEsAGY41rWHwDCYrqS/l5jS5Qd5c
 pBf/lWZx7PoWSIrY0Mn3w/1qe1IqQtThay8SGu6fbiU2VLrC+Pyywoko4GWsbNjbKYhQ pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2upwufg00x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 05:39:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U5cAqw141957;
        Fri, 30 Aug 2019 05:39:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2unvu11qmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 05:39:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7U5dkal012253;
        Fri, 30 Aug 2019 05:39:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 22:39:46 -0700
Date:   Thu, 29 Aug 2019 22:39:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Initialize label array properly
Message-ID: <20190830053945.GX5354@magnolia>
References: <20190830053707.GA69101@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830053707.GA69101@LGEARND20B15>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300059
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 02:37:07PM +0900, Austin Kim wrote:
> In case kernel stack variable is not initialized properly,
> there is a risk of kernel information disclosure.
> 
> So, initialize 'char label[]' array with null characters.

Got a testcase for this?  At least a couple other filesystems implement
this ioctl too, which means they all should be checked/tested on a
regular basis.

--D

> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 9ea5166..09b3bee 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2037,7 +2037,7 @@ xfs_ioc_setlabel(
>  	char			__user *newlabel)
>  {
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	char			label[XFSLABEL_MAX + 1];
> +	char			label[XFSLABEL_MAX + 1] = {0};
>  	size_t			len;
>  	int			error;
>  
> -- 
> 2.6.2
> 
