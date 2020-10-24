Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37128C2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BAF21D41
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RibPM8tq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762827AbgJXUoc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:44:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39682 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764498AbgJXUoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 16:44:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKewuT155136;
        Sat, 24 Oct 2020 20:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=67BiUFEaPrYOQ6pkW7VlktGNUM85AHhLDuMZAgmKeQI=;
 b=RibPM8tq44eCpfVXgxV4oR9Xo2mYmKxKu2zUHCnPyrSV82v7zCaesj+0zQpQ8RGypH82
 try+RSjf2vL1wXUANBTVS7z9CKEKKLnOhFQefdqEapoIp3OTgYY1qaRf3SexnO99V25O
 GvIcn9WszF32PY6RUFWkELNPMkUnMbtPVa5Bf1Zb92tLpHEHb1BxU95LaSvPP9khgsoX
 jFRKh9XCiW79SvENEYl/nfL9bzsvQozJsdcULqdT2gJ9AtyyfMrCBx8MZp9LqrxwzGsk
 ezDNfBOx4IIlt6NW3QU/w+PU4bkfA/0Oao16nCMssq36paISvO99T2giJ4ztrl/1mNNT Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sah7u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 20:44:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKa5dP161845;
        Sat, 24 Oct 2020 20:44:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cbkhp1rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 20:44:24 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OKiJ59030963;
        Sat, 24 Oct 2020 20:44:20 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 13:44:18 -0700
Subject: Re: [PATCH V7 10/14] xfs: Introduce error injection to reduce maximum
 inode fork extent count
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-11-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e952264e-79de-31c9-f205-4d96a0eeabac@oracle.com>
Date:   Sat, 24 Oct 2020 13:44:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-11-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240159
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
> userspace programs to test "Inode fork extent count overflow detection"
> by reducing maximum possible inode fork extent count to 10.
> 
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_errortag.h   | 4 +++-
>   fs/xfs/libxfs/xfs_inode_fork.c | 4 ++++
>   fs/xfs/xfs_error.c             | 3 +++
>   3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 53b305dea381..1c56fcceeea6 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -56,7 +56,8 @@
>   #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>   #define XFS_ERRTAG_BUF_IOERROR				35
> -#define XFS_ERRTAG_MAX					36
> +#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> +#define XFS_ERRTAG_MAX					37
>   
>   /*
>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -97,5 +98,6 @@
>   #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>   #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> +#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
>   
>   #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 8d48716547e5..e080d7e07643 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -24,6 +24,7 @@
>   #include "xfs_dir2_priv.h"
>   #include "xfs_attr_leaf.h"
>   #include "xfs_types.h"
> +#include "xfs_errortag.h"
>   
>   kmem_zone_t *xfs_ifork_zone;
>   
> @@ -745,6 +746,9 @@ xfs_iext_count_may_overflow(
>   
>   	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
>   
> +	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +		max_exts = 10;
> +
>   	nr_exts = ifp->if_nextents + nr_to_add;
>   	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
>   		return -EFBIG;
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 7f6e20899473..3780b118cc47 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
>   	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>   	XFS_RANDOM_IUNLINK_FALLBACK,
>   	XFS_RANDOM_BUF_IOERROR,
> +	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
>   };
>   
>   struct xfs_errortag_attr {
> @@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>   XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>   XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> +XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>   
>   static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>   	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> +	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>   	NULL,
>   };
>   
> 
