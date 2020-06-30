Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0DDC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 084CA2053B
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KTiT0tIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgF3VFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:05:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbgF3VFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 17:05:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UL1MCc097063
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OfX0PC5u7aCJeewaEjGmz/6dfugPEugiMRoOVQbAST4=;
 b=KTiT0tIfSUR4nWi3s52oBdtQyTPHpuIaI+Td4e7nvCosmRuXpsX7R2KZmk+vklpwg+fl
 XwkborpPE6I8h03SXV76LYGkVpYx2UWkV/r82uM/a/l1UY8jMt8NH9586qONji0BBwHI
 GUdjqZ8VsU+ZPcusIwhf6hXgNlS24IA/RE+8MgPQNremIxv3e1tjelhC/8fpPjfMbTLw
 2cpH4CYzEoG9bMBUG9AmWYr+uL/hRRp76MKqtIRlRYwvzdiIwNIeqRG45ZTNpltVUNww
 UjG6WOl/N5osytA8JVmBD0JnkOMKWx3BAhHcf5ksskAzsozK562mY3z6r0Xzs20MQEJq VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbn4ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UL2iDD195317
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg14dp79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:29 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UL5SLM002070
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:05:28 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 21:05:28 +0000
Subject: Re: [PATCH 1/2] xfs: rtbitmap scrubber should verify written extents
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353169466.2864648.10518851810473831328.stgit@magnolia>
 <159353170100.2864648.5747092047346568608.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5e502f76-3ca9-0db2-9640-943cce587751@oracle.com>
Date:   Tue, 30 Jun 2020 14:05:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353170100.2864648.5747092047346568608.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:41 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ensure that the realtime bitmap file is backed entirely by written
> extents.  No holes, no unwritten blocks, etc.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, makes sense to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/scrub/rtbitmap.c |   40 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index c642bc206c41..c777c98c50c3 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -13,6 +13,7 @@
>   #include "xfs_trans.h"
>   #include "xfs_rtalloc.h"
>   #include "xfs_inode.h"
> +#include "xfs_bmap.h"
>   #include "scrub/scrub.h"
>   #include "scrub/common.h"
>   
> @@ -58,6 +59,41 @@ xchk_rtbitmap_rec(
>   	return 0;
>   }
>   
> +/* Make sure the entire rtbitmap file is mapped with written extents. */
> +STATIC int
> +xchk_rtbitmap_check_extents(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_bmbt_irec	map;
> +	xfs_rtblock_t		off;
> +	int			nmap;
> +	int			error = 0;
> +
> +	for (off = 0; off < mp->m_sb.sb_rbmblocks;) {
> +		if (xchk_should_terminate(sc, &error) ||
> +		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +			break;
> +
> +		/* Make sure we have a written extent. */
> +		nmap = 1;
> +		error = xfs_bmapi_read(mp->m_rbmip, off,
> +				mp->m_sb.sb_rbmblocks - off, &map, &nmap,
> +				XFS_DATA_FORK);
> +		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
> +			break;
> +
> +		if (nmap != 1 || !xfs_bmap_is_written_extent(&map)) {
> +			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
> +			break;
> +		}
> +
> +		off += map.br_blockcount;
> +	}
> +
> +	return error;
> +}
> +
>   /* Scrub the realtime bitmap. */
>   int
>   xchk_rtbitmap(
> @@ -70,6 +106,10 @@ xchk_rtbitmap(
>   	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>   		return error;
>   
> +	error = xchk_rtbitmap_check_extents(sc);
> +	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +		return error;
> +
>   	error = xfs_rtalloc_query_all(sc->tp, xchk_rtbitmap_rec, sc);
>   	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
>   		goto out;
> 
