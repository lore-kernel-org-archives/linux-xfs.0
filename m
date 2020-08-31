Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47218C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 220A520866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l3Cz26Re"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgHaTMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:12:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgHaTMV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:12:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJATdk108155;
        Mon, 31 Aug 2020 19:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=n+KYOjvpxbjRYJ74rNuCqSTRqDZsvlllXFjmHbudR3k=;
 b=l3Cz26RejxRejFliSzPrDSSaubtCYuan3cEO4sVbwd3Rbgt5DdhNr9fiJ4RG/L+xWbZG
 iugU8o/94k43Jlq+qEFZbqy394i/1zi1vz+oyOUzQUOq7j/zAtn/C/JgEXU7+TR3BIxl
 jFA1QzUVhKGiy9nLzPlxWeOR5ROAGp9KS3Dk7DEAPbDU7PqQTEeDg90buiVsH9kn41FF
 JwbTsQ17KGIECwztrED+3S7ttaoNyP44RR/ttzQhUDSm9POYTjqSfjLo6VAr+qzbfY9K
 6dJQMjYOzvV6S+8iPDNxBCX8n2P2gwlhCNQaCC5BOWAV/35G2UBToyxfbC6jjk5ztXv1 Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eym01rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 19:12:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VJ4wJr135296;
        Mon, 31 Aug 2020 19:10:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380sqftb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 19:10:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VJAHMh031288;
        Mon, 31 Aug 2020 19:10:17 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 12:10:17 -0700
Date:   Mon, 31 Aug 2020 12:10:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs: remove comment about needed future work
Message-ID: <20200831191020.GR6096@magnolia>
References: <3a5c9483-954d-e045-7ebe-645250d61efe@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5c9483-954d-e045-7ebe-645250d61efe@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 02:37:17PM -0500, Eric Sandeen wrote:
> Remove comment about the need to sync this function with the
> kernel; that was mostly taken care of with:
> 
> 7b7548052 ("mkfs: use libxfs to write out new AGs")
> 
> There's maybe a little more samey-samey that we could do here,
> but it's not egregiously cut & pasted as it was before.
> 
> Signed-off-by: Eric Sandeen <sandeen2redhat.com>

Fixes: 7b7548052d12 ("mkfs: use libxfs to write out new AGs")
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385..874e40da 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3418,11 +3418,6 @@ prepare_devices(
>  
>  }
>  
> -/*
> - * XXX: this code is mostly common with the kernel growfs code.
> - * These initialisations should be pulled into libxfs to keep the
> - * kernel/userspace header initialisation code the same.
> - */
>  static void
>  initialise_ag_headers(
>  	struct mkfs_params	*cfg,
> 
