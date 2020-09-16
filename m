Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0D4C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B585320809
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sF8vYYGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgIPSq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 14:46:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgIPSqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 14:46:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GIiMGh148610;
        Wed, 16 Sep 2020 18:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GhMQX75rzfTJNKi4qFl2SQu3eKwT2hLaUQi3s8hnejw=;
 b=sF8vYYGU4pYOkgnfIdqXO6KFh4MlXaqkKkc9gV+kdR8NZGaV7fR29WReWz6lEu7DSYVF
 nN/x+aM9n/6oJ4qEovilcTSYHq+hhXDXPRvCG34T7ycCQBQQlhmXS+pYFFItpX/VsnHi
 3JLDrkthl8bebctkUBfr8Bhj0ODhZZRqbqyEG5v69vpleU49xW1VGks7EmxuqVu9qatP
 0DnZjxb+ypZOiYnEMstGSPLKo5tO2N+wyXru2P8RJ5zG16QMDpS6IHyHbPKFwqdN76RE
 1VKhJq+1TRPKFYS/UI+S4Qg6TtgzCmDQBIjVDjArnGVlWDMhQfIgOjiIw3J+Mvv7JGSQ 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dph13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 18:45:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GIjVkR121406;
        Wed, 16 Sep 2020 18:45:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33h8890ya1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 18:45:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GIjkhG012978;
        Wed, 16 Sep 2020 18:45:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 18:45:46 +0000
Date:   Wed, 16 Sep 2020 11:45:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the repeated crc verification in
 xfs_attr3_rmt_verify
Message-ID: <20200916184545.GI7955@magnolia>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-8-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-8-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=3 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=946
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=934
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:10PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We already do the crc verification before calling the xfs_attr3_rmt_verify()

Nit: The function call you're removing does not itself do crc
verification; it merely checks that the *crc feature* is set.  This
commit message needs to make this distinction, because at first I
thought "Why would you remove crc verification?"

IOWs...

"We already check that the crc feature is enabled before calling
xfs_attr3_rmt_verify(), so remove the redundant feature check in that
function."

--D

> function, and just return directly for non-crc buffers, so don't need
> to do the repeated crc verification in xfs_attr3_rmt_verify().
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 3f80cede7406..48d8e9caf86f 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -96,8 +96,6 @@ xfs_attr3_rmt_verify(
>  {
>  	struct xfs_attr3_rmt_hdr *rmt = ptr;
>  
> -	if (!xfs_sb_version_hascrc(&mp->m_sb))
> -		return __this_address;
>  	if (!xfs_verify_magic(bp, rmt->rm_magic))
>  		return __this_address;
>  	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
> -- 
> 2.20.0
> 
