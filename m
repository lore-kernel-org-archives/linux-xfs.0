Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6152CC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DD12184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q9XNrkjl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgEIRLP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:11:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:11:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H8lYQ131048;
        Sat, 9 May 2020 17:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Vk+NwDSv2P1mEHi4e9vorg11fc6X0UR3wK6DrI8lX1Q=;
 b=Q9XNrkjl4jGYs/ygJJDUjeqw0EFtxkBDta+a9NM2mJo/Bo8PvnLzPpFhKhpfglqVwHuG
 cr7JsipDEjpJhqH4NPE5fAHdsJn0xuh9/vITKGmmNxFpQHCJ9FdeMakipYZjsyMxp8ct
 Z+dipgWXYYshZpS0BmqI2hEuop7iIfLG5U/WwLRVDk9Ml2vI6bir6pn3rJys9745zj+v
 n0OFcxAADZKFw227aPqZEldLSFez789uzLTgEDhNyVsKNfr9GLmqvtQAfIFqHCxQqiSr
 YQaCbeL5XwL1l+++l6B//9FR7OD7t+A+YKixxWrCQP9+puGJrmt0v1Kjwt9w2lXaP5ea 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x0gh80n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:11:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H7bnA015835;
        Sat, 9 May 2020 17:09:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30wwxb6rn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:09:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049H9AlD032328;
        Sat, 9 May 2020 17:09:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:09:10 -0700
Date:   Sat, 9 May 2020 10:09:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] db: validate name and namelen in attr_set_f and
 attr_remove_f
Message-ID: <20200509170909.GS6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-6-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 suspectscore=2 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:22PM +0200, Christoph Hellwig wrote:
> libxfs has stopped validating these parameters internally, so do it
> in the xfs_db commands.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

IIRC the VFS checks these parameters so that libxfs doesn't have to,
right?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/attrset.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/db/attrset.c b/db/attrset.c
> index 0a464983..e3575271 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -130,7 +130,16 @@ attr_set_f(
>  	}
>  
>  	args.name = (const unsigned char *)argv[optind];
> +	if (!args.name) {
> +		dbprintf(_("invalid name\n"));
> +		return 0;
> +	}
> +
>  	args.namelen = strlen(argv[optind]);
> +	if (args.namelen >= MAXNAMELEN) {
> +		dbprintf(_("name too long\n"));
> +		return 0;
> +	}
>  
>  	if (args.valuelen) {
>  		args.value = memalign(getpagesize(), args.valuelen);
> @@ -216,7 +225,16 @@ attr_remove_f(
>  	}
>  
>  	args.name = (const unsigned char *)argv[optind];
> +	if (!args.name) {
> +		dbprintf(_("invalid name\n"));
> +		return 0;
> +	}
> +
>  	args.namelen = strlen(argv[optind]);
> +	if (args.namelen >= MAXNAMELEN) {
> +		dbprintf(_("name too long\n"));
> +		return 0;
> +	}
>  
>  	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
>  			&xfs_default_ifork_ops)) {
> -- 
> 2.26.2
> 
