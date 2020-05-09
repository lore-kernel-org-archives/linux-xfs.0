Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A663BC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADD52184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="acuYWQbV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEIRGm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:06:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44926 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:06:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H4vAT128631;
        Sat, 9 May 2020 17:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GGIVvj5C3IZRhOQqk/hI8bG3pSgyY7FLATCgBxXMhyg=;
 b=acuYWQbVlTBusL9JqhSzS32ZfSm/ga0PzLOrwml4JHUYOlYp8gkcIRJ0xErJY0y+p9ry
 7eYTVCnreGQ/1VkiIwrtgcqg3F8kPNZrJ3l/GX3qY/xjQhBnJk3D76cUPsY8TEesrIIM
 uc4k6E6tUic2AgoukDv5tMDSydpE4Oexb3kqrRXBGr9bRJoDP/FHZJPmkYyt8KkdmvnR
 A3Lpzcdwh6yaMJKpOKGg5e7oGe39BSnaULh5bf2dAQYsi9iIVnAzCbmnHbAXcmzEz/lO
 oXfFnXgE0bWqdlWZ4nnkFsggCMrSr0lnwAkPui8KgeLPlux+hvd9NVpAbx6G5huziNOL Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30x0gh80f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:06:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H5IdQ162098;
        Sat, 9 May 2020 17:06:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30wx186ay0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:06:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049H6aeP016471;
        Sat, 9 May 2020 17:06:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:06:35 -0700
Date:   Sat, 9 May 2020 10:06:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] db: fix a comment in scan_freelist
Message-ID: <20200509170634.GP6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-3-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 suspectscore=1 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:19PM +0200, Christoph Hellwig wrote:
> XFS_BUF_TO_AGFL_BNO has been renamed to open coded xfs_buf_to_agfl_bno.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/check.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/check.c b/db/check.c
> index c9bafa8e..09f8f6c9 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -4075,7 +4075,7 @@ scan_freelist(
>  		return;
>  	}
>  
> -	/* open coded XFS_BUF_TO_AGFL_BNO */
> +	/* open coded xfs_buf_to_agfl_bno */
>  	state.count = 0;
>  	state.agno = seqno;
>  	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
> -- 
> 2.26.2
> 
