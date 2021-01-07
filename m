Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFA3C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E09B23443
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbhAGTmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:42:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbhAGTmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:42:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JZYML156356;
        Thu, 7 Jan 2021 19:41:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OTfWhLr0kFgPEHmxnrlpqr33awbNi2WzkPU36qsX1DM=;
 b=ANOe122zdBrqd/fFYXy8mY/fJZeSWOsHB++onYdPQnSbk+fldstxzkYyhlOQZeNx6iYF
 WvN3DQi+Xy6xxx2uPkl41f2fgrwZC9ts3N1AqRyIQrN+5whfODHcJU2u23fuCF867+2+
 VoqAgwLjHWi1T4laEpxZO+P2IcL6Snx5m+jUkk7GXzCvF4qMQvfe+4bvkC0Lz+uYae2g
 36sn2a565N8FHRSdkKUI0ywYZE8oWbLUwVvb7FGWCEf3ZbBVZN6vcm2BhnwgZQLGI0ws
 DoLMnfhKoVTOtkMwS82i1qh5LyvjZAC8jv1laKXevBl8tBsxZFff+UAGp+TGstC7MxGx Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35wftxdkku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:41:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JYtK9176190;
        Thu, 7 Jan 2021 19:39:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35v1fbmpdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:39:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107JdWdv025732;
        Thu, 7 Jan 2021 19:39:32 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 19:39:31 +0000
Date:   Thu, 7 Jan 2021 11:39:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: cover the log on freeze instead of cleaning it
Message-ID: <20210107193931.GL6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-10-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:27PM -0500, Brian Foster wrote:
> Filesystem freeze cleans the log and immediately redirties it so log
> recovery runs if a crash occurs after the filesystem is frozen. Now
> that log quiesce covers the log, there is no need to clean the log and
> redirty it to trigger log recovery because covering has the same
> effect. Update xfs_fs_freeze() to quiesce (and thus cover) the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Woot!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aedf622d221b..aed74a3fc787 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -889,8 +889,7 @@ xfs_fs_freeze(
>  	flags = memalloc_nofs_save();
>  	xfs_stop_block_reaping(mp);
>  	xfs_save_resvblks(mp);
> -	xfs_log_clean(mp);
> -	ret = xfs_sync_sb(mp, true);
> +	ret = xfs_log_quiesce(mp);
>  	memalloc_nofs_restore(flags);
>  	return ret;
>  }
> -- 
> 2.26.2
> 
