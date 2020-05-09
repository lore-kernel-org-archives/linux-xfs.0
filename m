Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1213AC47247
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36D224954
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="muxu82NL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgEIRLi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:11:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:11:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GxcJR047058;
        Sat, 9 May 2020 17:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=g1WECvT1YsKrJOOnKmu40lZ8GzQyRroBinpi6/jDjeA=;
 b=muxu82NLeF7wngTBgQ6IvcNIOlQIjDLnRRcj+D1SERp9MOnRMwC6HEyZ2RDd24CEHkbp
 1ocLGRu+gcHEzUIRZpyp+DUjEDhomCXDjm/UYHKU+97bxJ0iZNGXAS8+9qBBoRftOrgv
 ttH5nSJAQ1uKQd5HznPnVQAY1Cw1SOt2uiKOynAkBpNLT+YOy0WrTaHrXSV8fhHluVQl
 FG6zu7kkKXzsvghgObQctmuTrMqd0/VYAY7IU7olX//rA5h9RBqriMSTbQ6iHb21LvZ0
 iNIYb7tmfDEyEIvYsab4OgETbg65aEnPhOW14TEUVkW1SmiBpkedJbGczUknxMWzLiF/ 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30wmfm17mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:11:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H4BWH178525;
        Sat, 9 May 2020 17:09:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30wx11dy6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:09:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049H9VFS019224;
        Sat, 9 May 2020 17:09:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:09:30 -0700
Date:   Sat, 9 May 2020 10:09:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] db: ensure that create and replace are exclusive in
 attr_set_f
Message-ID: <20200509170927.GT6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-7-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:23PM +0200, Christoph Hellwig wrote:
> Clear the other flag when applying the create or replace option,
> as the low-level libxfs can't handle both at the same time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/attrset.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/db/attrset.c b/db/attrset.c
> index e3575271..b86ecec7 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -99,9 +99,11 @@ attr_set_f(
>  		/* modifiers */
>  		case 'C':
>  			args.attr_flags |= XATTR_CREATE;
> +			args.attr_flags &= ~XATTR_REPLACE;
>  			break;
>  		case 'R':
>  			args.attr_flags |= XATTR_REPLACE;
> +			args.attr_flags &= ~XATTR_CREATE;
>  			break;
>  
>  		case 'n':
> -- 
> 2.26.2
> 
