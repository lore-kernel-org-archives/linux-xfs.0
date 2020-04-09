Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7E9C2BA2B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 00:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B902084D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 00:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FBqFlCZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgDIAF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 20:05:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgDIAF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 20:05:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03903t06031453;
        Thu, 9 Apr 2020 00:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KCDI7Op2L1rW8SlRhgb0eW6WaDhGAZ9Z3LJ/olV1/y0=;
 b=FBqFlCZUMQ5u4VgndXvpdDJfQrqKtm6A7yXpnM86sXMDfHx4uKtfKMQ76fo5amKWC2Ld
 WhcwFUBOkNc5VLrSA29DMyj7cBZyiV16HbgcgUp3RsBXhUCk4DMygJOY8zOntUv5nhF8
 aspBDVS6YpuoI7Fz/EpF3mLn+QtuRl+fWNhjRaqCmyvVkBFP+VFzF25Dy73lzXhQJtSj
 ErNJxtpzh/K2Fq23gco5YVgT2wPPnsaa3ThC2mcVHBQN7tW40rQo/olYXd5lkOznNqBn
 mJJ8DvUHKhcmcyhifp4KYTjGcsUwsOcpQdYEXtvaaTAqqq2tz/H0eLslSzmQp1kz2Ns2 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3091m0xgs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 00:05:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03903aYJ045744;
        Thu, 9 Apr 2020 00:05:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3091m5rr55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 00:05:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03905O8F024131;
        Thu, 9 Apr 2020 00:05:24 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 17:05:24 -0700
Subject: Re: [RFC v6 PATCH 07/10] xfs: prevent fs freeze with outstanding
 relog items
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200406123632.20873-1-bfoster@redhat.com>
 <20200406123632.20873-8-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2ba21e94-b92d-51a3-6fa6-67cc0b8d57e2@oracle.com>
Date:   Wed, 8 Apr 2020 17:05:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200406123632.20873-8-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9585 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9585 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 5:36 AM, Brian Foster wrote:
> The automatic relog mechanism is currently incompatible with
> filesystem freeze in a generic sense. Freeze protection is currently
> implemented via locks that cannot be held on return to userspace,
> which means we can't hold a superblock write reference for the
> duration relogging is enabled on an item. It's too late to block
> when the freeze sequence calls into the filesystem because the
> transaction subsystem has already begun to be frozen. Not only can
> this block the relog transaction, but blocking any unrelated
> transaction essentially prevents a particular operation from
> progressing to the point where it can disable relogging on an item.
> Therefore marking the relog transaction as "nowrite" does not solve
> the problem.
> 
> This is not a problem in practice because the two primary use cases
> already exclude freeze via other means. quotaoff holds ->s_umount
> read locked across the operation and scrub explicitly takes a
> superblock write reference, both of which block freeze of the
> transaction subsystem for the duration of relog enabled items.
> 
> As a fallback for future use cases and the upcoming random buffer
> relogging test code, fail fs freeze attempts when the global relog
> reservation counter is elevated to prevent deadlock. This is a
> partial punt of the problem as compared to teaching freeze to wait
> on relogged items because the only current dependency is test code.
> In other words, this patch prevents deadlock if a user happens to
> issue a freeze in conjunction with random buffer relog injection.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, long explanation, but makes sense :-)

Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_super.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index abf06bf9c3f3..0efa9dc70d71 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -35,6 +35,7 @@
>   #include "xfs_refcount_item.h"
>   #include "xfs_bmap_item.h"
>   #include "xfs_reflink.h"
> +#include "xfs_trans_priv.h"
>   
>   #include <linux/magic.h>
>   #include <linux/fs_context.h>
> @@ -870,6 +871,9 @@ xfs_fs_freeze(
>   {
>   	struct xfs_mount	*mp = XFS_M(sb);
>   
> +	if (WARN_ON_ONCE(atomic64_read(&mp->m_ail->ail_relog_res)))
> +		return -EAGAIN;
> +
>   	xfs_stop_block_reaping(mp);
>   	xfs_save_resvblks(mp);
>   	xfs_quiesce_attr(mp);
> 
