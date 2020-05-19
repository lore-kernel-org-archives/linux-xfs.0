Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D13C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A042020756
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fj67Dgai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgESQWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:22:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgESQWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:22:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGHNCl195608;
        Tue, 19 May 2020 16:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nuLblMsBSTd3yhr8jshf8v+xFoWN9dCFbj5aeWguTGA=;
 b=Fj67DgaiThz1jIJj6DZ/8++UruYkp4OTxzjMDg/20sGB0/M0JUJ1imH3V2Hbgi9X0KmW
 OQGJ6hTS7CuBUhS+VDWlEaPkHGFlz8XBYJYmxfcPOiZdxuCyTluw5sJKdqmJWjVhyglw
 b+2pFlMevVXTDbT99+fe+KDZIZFE8NiY1Gz+B74JFXG/qKEe4EJqYnXKjjab7QIe+up/
 Hf3oLB057jYGSx6gcskTI9My1S5jLqtwWIciX0Yy1+SEc8lVlSRXGGVACzlYjsBojdFr
 IWDTl+ouLjCO7qSLjA1dKRyDSu5eeWqs1lxPqfo5gT0xBUeTFP7Qj8cxADqzhkp24nl7 gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tneawq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 16:22:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGMOY0174316;
        Tue, 19 May 2020 16:22:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm59bnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 16:22:34 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JGMXjD013698;
        Tue, 19 May 2020 16:22:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:22:33 -0700
Date:   Tue, 19 May 2020 09:22:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] xfs: group quota should return EDQUOT when prj quota
 enabled
Message-ID: <20200519162232.GL17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <70119485-992a-641d-93ab-a9d41f9618d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70119485-992a-641d-93ab-a9d41f9618d5@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 01:48:46PM -0500, Eric Sandeen wrote:
> Long ago, group & project quota were mutually exclusive, and so
> when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
> is exceeded") when project quota was enabled, we only needed to
> disable it again for user quota.
> 
> When group & project quota got separated, this got missed, and as a
> result if project quota is enabled and group quota is exceeded, the
> error code returned is incorrectly returned as ENOSPC not EDQUOT.
> 
> Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
> quota when we try to reserve the space.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index d1b9869bc5fa..2c3557a80e69 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -758,7 +758,8 @@ xfs_trans_reserve_quota_bydquots(
>  	}
>  
>  	if (gdqp) {
> -		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
> +		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
> +					(flags & ~XFS_QMOPT_ENOSPC));
>  		if (error)
>  			goto unwind_usr;
>  	}
> -- 
> 2.17.0
> 
