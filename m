Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCDFC35249
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20DEF2085B
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HsE5G0gu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgBEF2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 00:28:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgBEF2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 00:28:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155SoHm122030;
        Wed, 5 Feb 2020 05:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=tIXYbiQ+yxoNT4Aa6VSSyiUhWA6aNQyRCaSNG54vC64=;
 b=HsE5G0gu1zEk6NYnJ295OPCRCyLF/YZIA0ADCJ3DuuIWtvVkV6KeRqPvzmIa99vQZNd3
 yOqWkfKz73rMoLImWrM56O9u3mUXxljtzldtKvIgPMW4y9kfNQqYSfu9qcj+ZGlj0ETJ
 ATdYb9X9UdANzUzVskyytOhDOA4RzQPDQ3mli881zyuBA6fndOTcZVp8F7c/DeUiomPR
 6yl+LMGI79sQhZBpZpSiK/h0fKz7/R08n1d4TUtZ/NOj7qKun0Nq84EW7rMpyZeM7DZQ
 YajKEpbs4xACl2GzIjLBIEwGrYPWKBp3vthdcE1CsW1EUHboe7u1altdv3P5VB9kVA4K MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xykbp0s4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:28:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155Smgr068532;
        Wed, 5 Feb 2020 05:28:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xykc43ch3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:28:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0155SibN029121;
        Wed, 5 Feb 2020 05:28:45 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 21:28:44 -0800
Subject: Re: [PATCH 1/4] libxfs: re-sort libxfs_api_defs.h defines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086357391.2079557.7271114884346251108.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <82b5ccf7-c147-8df6-5c03-ef5dc6db341a@oracle.com>
Date:   Tue, 4 Feb 2020 22:28:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086357391.2079557.7271114884346251108.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2/4/20 5:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Re-fix the sorting in this file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/libxfs_api_defs.h |    9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index c7fa1607..6e09685b 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -93,6 +93,7 @@
>   #define xfs_dqblk_repair		libxfs_dqblk_repair
>   #define xfs_dquot_verify		libxfs_dquot_verify
>   
> +#define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
>   #define xfs_free_extent			libxfs_free_extent
>   #define xfs_fs_geometry			libxfs_fs_geometry
>   #define xfs_highbit32			libxfs_highbit32
> @@ -118,13 +119,16 @@
>   #define xfs_perag_put			libxfs_perag_put
>   #define xfs_prealloc_blocks		libxfs_prealloc_blocks
>   
> +#define xfs_read_agf			libxfs_read_agf
>   #define xfs_refc_block			libxfs_refc_block
> +#define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
>   #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
>   #define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
>   #define xfs_refcount_get_rec		libxfs_refcount_get_rec
>   #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
>   
>   #define xfs_rmap_alloc			libxfs_rmap_alloc
> +#define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
>   #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
>   #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
>   #define xfs_rmap_compare		libxfs_rmap_compare
> @@ -176,9 +180,6 @@
>   #define xfs_verify_rtbno		libxfs_verify_rtbno
>   #define xfs_zero_extent			libxfs_zero_extent
>   
> -#define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
> -#define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
> -#define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
> -#define xfs_read_agf			libxfs_read_agf
> +/* Please keep this list alphabetized. */
>   
>   #endif /* __LIBXFS_API_DEFS_H__ */
> 
