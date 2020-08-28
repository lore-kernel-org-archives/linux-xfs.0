Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EBDC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F4120936
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:08:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t7yX9oC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgH1EIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 00:08:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgH1EIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 00:08:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S40nD4025308;
        Fri, 28 Aug 2020 04:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5QA2mK5hzThcwUiywn2NO3psamTP78d6ffqZ9eVWWDQ=;
 b=t7yX9oC9gG8KCQyXIUSa9AmMIQc7AjtqsIEPtIhNhNcNVBbNhips3FT9QV1u1V/w8nCt
 nqh10TWCXl76jxXJGsMGAoGS4BXeek+vOnUgvJy+AqPviG2e3YjwMTg77X9CVlXvOGeR
 pOfsP0wXSxT3eVepRxc/UjhqVwVXqDOTKFzSupJ8/2l6DWjGfj2EuA0aIg83+4lYrX/X
 hhfmQAVJWXufAl/6OIaqhZmJ3bboD7pG2Z/WQx1PB6/HNVE6yYboMFRLQzjD9QtSWMIa
 PM6uayy5Ao6dTuC6yZ7D4HANNaIQjhOSXv0/CZTL5KPqVpDRK+FtvMuINtFQQ6C+QKR+ lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 336ht3hvtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 04:08:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S40Nq9157376;
        Fri, 28 Aug 2020 04:08:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 333ruerdha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 04:08:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S48Cmg031361;
        Fri, 28 Aug 2020 04:08:12 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 21:08:12 -0700
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847950453.2601708.10180221593902060367.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <135bb014-1636-f8c2-a5b4-2dc7b3626c87@oracle.com>
Date:   Thu, 27 Aug 2020 21:08:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847950453.2601708.10180221593902060367.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Formally define the inode timestamp ranges that existing filesystems
> support, and switch the vfs timetamp ranges to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
>   fs/xfs/xfs_super.c         |    4 ++--
>   2 files changed, 24 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index fe129fe16d5f..e57360a8fd16 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -848,11 +848,33 @@ struct xfs_agfl {
>   	    ASSERT(xfs_daddr_to_agno(mp, d) == \
>   		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
>   
> +/*
> + * XFS Timestamps
> + * ==============
> + *
> + * Traditional ondisk inode timestamps consist of signed 32-bit counters for
> + * seconds and nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC
> + * 1970, which means that the timestamp epoch is the same as the Unix epoch.
> + * Therefore, the ondisk min and max defined here can be used directly to
> + * constrain the incore timestamps on a Unix system.
> + */
>   typedef struct xfs_timestamp {
>   	__be32		t_sec;		/* timestamp seconds */
>   	__be32		t_nsec;		/* timestamp nanoseconds */
>   } xfs_timestamp_t;
>   
> +/*
> + * Smallest possible ondisk seconds value with traditional timestamps.  This
> + * corresponds exactly with the incore timestamp Dec 13 20:45:52 UTC 1901.
> + */
> +#define XFS_LEGACY_TIME_MIN	((int64_t)S32_MIN)
> +
> +/*
> + * Largest possible ondisk seconds value with traditional timestamps.  This
> + * corresponds exactly with the incore timestamp Jan 19 03:14:07 UTC 2038.
> + */
> +#define XFS_LEGACY_TIME_MAX	((int64_t)S32_MAX)
> +
>   /*
>    * On-disk inode structure.
>    *
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c7ffcb57b586..b3b0e6154bf2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1484,8 +1484,8 @@ xfs_fc_fill_super(
>   	sb->s_maxbytes = MAX_LFS_FILESIZE;
>   	sb->s_max_links = XFS_MAXLINK;
>   	sb->s_time_gran = 1;
> -	sb->s_time_min = S32_MIN;
> -	sb->s_time_max = S32_MAX;
> +	sb->s_time_min = XFS_LEGACY_TIME_MIN;
> +	sb->s_time_max = XFS_LEGACY_TIME_MAX;
>   	sb->s_iflags |= SB_I_CGROUPWB;
>   
>   	set_posix_acl_flag(sb);
> 
