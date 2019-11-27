Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68D9C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 00:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B89B720665
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 00:40:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UC+wGmtI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfK0AkO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:40:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49496 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfK0AkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 19:40:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR0TIsU133896;
        Wed, 27 Nov 2019 00:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qwAJYYhc+2apV2BZSnNmZvNjZkIwKPlbt0kclhGm3Gw=;
 b=UC+wGmtI52suis53ttT6tA8Rqys8tFY3DL7J6DpDcsnmEzP5yFZOL/SIGEMOI3BA+znC
 NDhOlYbMoqeh8mk1GbShaGx+CBKu8Uk/nXmVGKmJsuwt+gebVc+UGhu+54bhEfzDoaqP
 lBHIZbnPfo24SyPJ6sVQxolIHw5yeJ5NNytmccjgEi7LadlH8Is0u5lNP3fugFmhFu3q
 GTZ1xG1KPOrbfo9Uf0joWG3pDmjhda8LNzTi2nQ7RDztgYYcnDy93mZtH1HZsTdQ4+iI
 faCQmOaqzmBvY9nsMTuKK47UK6YONN6dF0bPcv9HQbX4lE7cNm6LEaj+oXEjqx70Fp+X Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wevqqa3k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 00:38:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR0TABK095372;
        Wed, 27 Nov 2019 00:36:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wgwutjvc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 00:36:31 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAR0aUgr023734;
        Wed, 27 Nov 2019 00:36:30 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 16:36:30 -0800
Date:   Tue, 26 Nov 2019 16:36:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/2] xfs: don't check for AG deadlock for realtime files
 in bunmapi
Message-ID: <20191127003628.GQ6219@magnolia>
References: <cover.1574799066.git.osandov@fb.com>
 <89ad24852d1d14fcf834a9551fec503c24d31b44.1574799066.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89ad24852d1d14fcf834a9551fec503c24d31b44.1574799066.git.osandov@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 12:13:29PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Commit 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi") added
> a check in __xfs_bunmapi() to stop early if we would touch multiple AGs
> in the wrong order. However, this check isn't applicable for realtime
> files. In most cases, it just makes us do unnecessary commits. However,
> without the fix from the previous commit ("xfs: fix realtime file data
> space leak"), if the last and second-to-last extents also happen to have
> different "AG numbers", then the break actually causes __xfs_bunmapi()
> to return without making any progress, which sends
> xfs_itruncate_extents_flags() into an infinite loop.
> 
> Fixes: 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6f8791a1e460..a11b6e7cb35f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5300,7 +5300,7 @@ __xfs_bunmapi(
>  		 * Make sure we don't touch multiple AGF headers out of order
>  		 * in a single transaction, as that could cause AB-BA deadlocks.
>  		 */
> -		if (!wasdel) {
> +		if (!wasdel && !isrt) {
>  			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
>  			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
>  				break;
> -- 
> 2.24.0
> 
