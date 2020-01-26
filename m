Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9B9C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B67B206F0
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:12:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qvCWlWdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAZWMx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:12:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgAZWMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:12:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QM7wjZ024687;
        Sun, 26 Jan 2020 22:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Q3po7TRT97VyNszallbNqUME4RP46L85Zedmd3gxmbI=;
 b=qvCWlWdCx33P0llPyk1SmLWNWjjZp/xsyWKmJGe1JQcFKVa+uqH34B2rfxTvycti2gDs
 Mx8XyRIAZMynFGENctAalIKvowLVcn23pDzsCbpRupjTKH9i7W0C3tJnQwtlEcxv9mt6
 KPASMk0y8PYlWSyNdeUIVpDhQVduEOsOeOzc9Sv5CtNzMfxp+O3M33UeLx34dlq9U7C+
 0JjXy+XAYPO9NhpazasuWVFU15RrvUvZtzonf5r4EnTGgSOBbk3+yY9spz2Xex2JI3Qr
 Rp6aPNXE3pcd1DCtnkvI8WSoN/ljX7EqBvC/cPPcn46oLvQbWUhxrWtjHjLpFNoANNI8 Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xrdmq4f75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:12:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QM8u8Q150443;
        Sun, 26 Jan 2020 22:12:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xryu82rt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:12:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QMCnOS017814;
        Sun, 26 Jan 2020 22:12:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:12:49 -0800
Date:   Sun, 26 Jan 2020 14:12:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfsprogs: remove the ENABLE_GETTEXT substitution in
 platform_defs.h.in
Message-ID: <20200126221248.GD3447196@magnolia>
References: <20200126113541.787884-1-hch@lst.de>
 <20200126113541.787884-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126113541.787884-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 26, 2020 at 12:35:37PM +0100, Christoph Hellwig wrote:
> ENABLE_GETTEXT is already defined on the command line if enabled, no
> need to duplicate it in platform_defs.h.in.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable, though I wonder

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/platform_defs.h.in | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index 1f7ceafb..6cc56e31 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -36,8 +36,6 @@ typedef struct filldir		filldir_t;
>  typedef unsigned short umode_t;
>  #endif
>  
> -/* Define if you want gettext (I18N) support */
> -#undef ENABLE_GETTEXT
>  #ifdef ENABLE_GETTEXT
>  # include <libintl.h>
>  # define _(x)                   gettext(x)
> -- 
> 2.24.1
> 
