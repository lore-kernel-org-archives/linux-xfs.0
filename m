Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BE0C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55F620657
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m8kcJw8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgHSAz1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:55:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHSAz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:55:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0mLd5171034;
        Wed, 19 Aug 2020 00:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J/yS6/tViJG3M4c/j0uYpVr2K9Lcn7A35sgJf6bxBec=;
 b=m8kcJw8uR1Pck80wVPXiRSrkWzv08cO95e59LlAG+4Fwpo3TlPvUCxBZOo3IzXaFjNDo
 /t6Bp5Vhm0uI3z7iEsntRCkBBzgHQkP0Aqqs8ITqpHFZtMlaaKXjNAKfL3Bhuv2eoW1j
 J1I24p+sTpHi5D8ijI2hdZiCQ3+eSWeB5uKHW0RyeDFDhJzkefrd0qDY/s9KCNSyaR66
 +OiEHDycLJpQdgHEqAaRE9Yb4gcleNMSYwUA/p762g2A3SuyzPun6Meaoqx4Su+jO8Cb
 dioOWEv0FLehny+HhHf5MqCAy14RHttFu3Q465UDfHw6uqCceYfKQQuoOfmdEtaqo+5l nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74r7ypm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:55:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0sGHR171330;
        Wed, 19 Aug 2020 00:55:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfsh7e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:55:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0tIqA009093;
        Wed, 19 Aug 2020 00:55:18 GMT
Received: from localhost (/10.159.129.94) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 18 Aug 2020 17:54:06 -0700
MIME-Version: 1.0
Message-ID: <20200819005403.GB6096@magnolia>
Date:   Tue, 18 Aug 2020 17:54:03 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH v4 1/3] xfs: get rid of unused pagi_unlinked_hash
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
 <20200818133015.25398-2-hsiangkao@redhat.com>
In-Reply-To: <20200818133015.25398-2-hsiangkao@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 09:30:13PM +0800, Gao Xiang wrote:
> pagi_unlinked_hash is unused since no backref infrastructure now.
> (it's better to fold it into original patchset.)
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Yes, this should be folded into the other patch that gets rid of the
rest of the rhash code.  Dave?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.h | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c35a6c463529..98109801a995 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -372,13 +372,6 @@ typedef struct xfs_perag {
>  
>  	/* reference count */
>  	uint8_t			pagf_refcount_level;
> -
> -	/*
> -	 * Unlinked inode information.  This incore information reflects
> -	 * data stored in the AGI, so callers must hold the AGI buffer lock
> -	 * or have some other means to control concurrency.
> -	 */
> -	struct rhashtable	pagi_unlinked_hash;
>  } xfs_perag_t;
>  
>  static inline struct xfs_ag_resv *
> -- 
> 2.18.1
> 
