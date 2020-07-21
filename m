Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F2AC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1EF82080D
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lWIOr/ac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgGUA5X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:57:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgGUA5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:57:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0vGku061376;
        Tue, 21 Jul 2020 00:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=E6rypuJnDqi/YMnBQDH9lKc3+pjYem73xVXLhkS1eaw=;
 b=lWIOr/acNgbAKbnq1OfNEirt33hMfPFQJTKocpZ3iGckmebr16NHvpGZv1RQBLRmRVWC
 jOSS+BDznVd3+fDAwwcb2le8nt4Yd56rzx7eJ7D4AESvd5fP8LC0f5yC5arYQ/DgeQTX
 isi5o1bojwiXH0ioj7iJVNt5hhm3BUzv+DLd6qR/Q7KtRjUX1gYspw8NxRcJlrbBor6i
 +MkKnEtYLEWonT3LnH+HAb5LJJapkeaEWDxc0lhmVqRnoMqB1/F0WoXZx+jiVaT1M9th
 Ffax3c9cUeQnK/bGGGSqQewJXD060yJE9bkfOQlwyjWXCPeZNZpLp1fpcbaAKEsUgvpZ yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1ma160-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 00:57:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0r09B090711;
        Tue, 21 Jul 2020 00:55:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32dnmq94au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 00:55:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0tAPg021804;
        Tue, 21 Jul 2020 00:55:10 GMT
Received: from localhost (/10.159.141.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 00:55:09 +0000
Date:   Mon, 20 Jul 2020 17:55:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: don't double check dir2 sf parent in phase 4
Message-ID: <20200721005508.GX3151642@magnolia>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-3-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=1 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:34AM -0400, Brian Foster wrote:
> The shortform parent ino verification code runs once in phase 3
> (ino_discovery == true) and once in phase 4 (ino_discovery ==
> false). This is unnecessary and leads to duplicate error messages if
> repair replaces an invalid parent value with zero because zero is
> still an invalid value. Skip the check in phase 4.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  repair/dir2.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index cbbce601..caf6963d 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -480,6 +480,9 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
>  	 * check parent (..) entry
>  	 */
>  	*parent = libxfs_dir2_sf_get_parent_ino(sfp);
> +	if (!ino_discovery)
> +		return 0;

I feel like this ought to have a comment explaining why we skip only the
parent check in phase 4:

/*
 * If this function is called during inode discovery (phase 3), it will
 * set a bad sf dir parent pointer to the root directory.  This fixes
 * the directory enough to pass the inode fork verifier in phase 6 when
 * we try to reset the parent pointer to the correct value.  There is no
 * need to re-check the parent pointer during phase 4.
 */

With that added,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +
>  
>  	/*
>  	 * if parent entry is bogus, null it out.  we'll fix it later .
> -- 
> 2.21.3
> 
