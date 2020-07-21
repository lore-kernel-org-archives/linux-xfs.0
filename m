Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EB5C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 00:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0ED20792
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 00:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vyXaaj4f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgGVA35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 20:29:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGVA35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 20:29:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNXYJV162369
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WP8s9jLPlJwO9k5FOKUOgPhbNPsFTIYwoV1J+1R0i4A=;
 b=vyXaaj4fNtSU91BO2zYyPZpHAz+AwZMBaM16p7MPuWmOsA+PBRmTLzQ4QJwiw2IXcdtw
 UG3FO3ZE+RUIEg1lyq2cGSiZS3GgGk33vPGCWii3wWlT2YJbB9F++eeEHWlIEfxRdwNG
 hgowEawTZpor3Hd7vX2NYwzUfQocMH1vCJ9rCS6AcLBHqj8ovdVqToTWz7I7ZmTFWRLm
 gWrUllYRT9+ovGT9GzHjXgNTEye1oPp5l3ZjJLonsOFYIW0umV+euAl3bw1oJLd1LJM0
 N4LEfASZMGNAXFrIM6U12SBO+NPdS3Mc07dTC0amNqB5udEJSoox1IlCyp94dau/E+Yt Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6ksmdbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:38:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNc16C186836
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:38:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32e9dhshnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:38:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06LNcV0v006299
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:38:31 GMT
Received: from localhost (/10.159.147.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 16:38:31 -0700
Date:   Tue, 21 Jul 2020 16:38:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 14/25] xfs: Remove xfs_trans_roll in
 xfs_attr_node_removename
Message-ID: <20200721233830.GJ3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721001606.10781-15-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 05:15:55PM -0700, Allison Collins wrote:
> A transaction roll is not necessary immediately after setting the
> INCOMPLETE flag when removing a node xattr entry with remote value
> blocks. The remote block invalidation that immediately follows setting
> the flag is an in-core only change. The next step after that is to start
> unmapping the remote blocks from the attr fork, but the xattr remove
> transaction reservation includes reservation for full tree splits of the
> dabtree and bmap tree. The remote block unmap code will roll the
> transaction as extents are unmapped and freed.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Urrrk.  The analysis is correct here, but whoooee was it hard to find.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1a78023..f1becca 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1148,10 +1148,6 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> -
>  		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
> -- 
> 2.7.4
> 
