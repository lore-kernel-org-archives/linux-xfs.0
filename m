Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18DBC2D0DC
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 21:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7176121582
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 21:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="er48ye2V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgABVTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 16:19:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34076 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgABVTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 16:19:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002LJGDQ063953;
        Thu, 2 Jan 2020 21:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wQWI6rGG8iRthSSAU6s0X4ZVP0zhyoR9NBJBla87pS0=;
 b=er48ye2VODcibFuLXZ8fyAL40vaKCU2OwwO9bF+JFllcK1eZTNqf5E+AHro3Td9fILJ9
 +1/B20f7kdX3pDhrnbuSwf2ECC7JRM8DEe0sDboNWpYTxqKaZ5Q/Bu3gaKL/Ww5ysSdI
 J7RX5NV9LOpqtuIj/bz7R3JPlw7VfILKOCKl8MUJnsTRkQ57rlR86qhuwh1gRwmkADMA
 1EsViLb3S0MLxtqDo5jG6/tXcP+28Pqyv3rqXIjOEoO7mH0tbMgFI8cmdbKZneL1nsEf
 AT3aZFbEkfJWJYXw9whz0+V0oUdTADYQ1ReHzBNQBGnGEyM4qJBriu07kcH2LVq7k+/N 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqsfy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 21:19:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002LC6vq190058;
        Thu, 2 Jan 2020 21:17:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8gut5mcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 21:17:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 002LH8LU000947;
        Thu, 2 Jan 2020 21:17:08 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 13:17:08 -0800
Subject: Re: [PATCH 1/1] xfs_repair: fix totally broken unit conversion in
 directory invalidation
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <157784163017.1371001.12249848065995361338.stgit@magnolia>
 <157784163634.1371001.9270275500137619667.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e890e671-fb53-012b-906e-e9908b45a7e7@oracle.com>
Date:   Thu, 2 Jan 2020 14:17:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <157784163634.1371001.9270275500137619667.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/31/19 6:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Your humble author forgot that xfs_dablk_t has the same units as
> xfs_fileoff_t, and totally screwed up the directory buffer invalidation
> loop in dir_binval.  Not only is there an off-by-one error in the loop
> conditional, but the unit conversions are wrong.
> 
> Fix all this stupidity by adding a for loop macro to take care of these
> details for us so that everyone can iterate all logical directory blocks
> (xfs_dir2_db_t) that start within a given bmbt record.
> 
> The pre-5.5 xfs_da_get_buf implementation mostly hides the off-by-one
> error because dir_binval turns on "don't complain if no mapping" mode,
> but on dirblocksize > fsblocksize filesystems the incorrect units can
> cause us to miss invalidating some blocks, which can lead to other
> buffer cache errors later.
> 
> Fixes: f9c559f4e4fb4 ("xfs_repair: invalidate dirty dir buffers when we zap a  directory")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
This one looks ok to me.  Thanks!

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   repair/phase6.c |   10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 91d208a6..a11712a2 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1276,7 +1276,7 @@ dir_binval(
>   	struct xfs_ifork	*ifp;
>   	struct xfs_da_geometry	*geo;
>   	struct xfs_buf		*bp;
> -	xfs_dablk_t		dabno, end_dabno;
> +	xfs_dablk_t		dabno;
>   	int			error = 0;
>   
>   	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> @@ -1286,11 +1286,9 @@ dir_binval(
>   	geo = tp->t_mountp->m_dir_geo;
>   	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>   	for_each_xfs_iext(ifp, &icur, &rec) {
> -		dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
> -				geo->fsbcount - 1);
> -		end_dabno = xfs_dir2_db_to_da(geo, rec.br_startoff +
> -				rec.br_blockcount);
> -		for (; dabno <= end_dabno; dabno += geo->fsbcount) {
> +		for (dabno = roundup(rec.br_startoff, geo->fsbcount);
> +		     dabno < rec.br_startoff + rec.br_blockcount;
> +		     dabno += geo->fsbcount) {
>   			bp = NULL;
>   			error = -libxfs_da_get_buf(tp, ip, dabno, -2, &bp,
>   					whichfork);
> 
