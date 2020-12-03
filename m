Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE82C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E00AE221E7
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgLCTHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:07:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgLCTHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:07:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IwLaQ021703;
        Thu, 3 Dec 2020 19:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yH66ZOVSWrANUbMQ027t27rUTWgbFMupCfCbxnqnZLU=;
 b=dnv3U+xhKDcac2qiRcqX7R2ktIrwnipsFnG2kRTHBBHoI5p5Dgzyi1XTfhDm0oXzRTUu
 +mBp+v9EDnaFPdM3tfidFP+F0GH+iDgpsiVgUCEOb/Aw/VgRrKlbfYO2maEalE2ybh/r
 8pM7AyqAZpFHurQ9d+svk54IMVaTUpJz44c930TN/RAAyDe8w02pL0ZjqqgqzlAHzNwh
 rxrLRazUqNmv2leJkxmYbKBD0G8hGd3SuJ9OQS1KrHXlWZEcmo6MYQHWyTqyVOWQjB/a
 ZgE3bZ6VdgGlt5Rv+UfG6jp+bmz9kD4B383wE5T7+MssAxx9LFr2AXfylF/C9j41dhPU XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkyq4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:06:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IuOus067387;
        Thu, 3 Dec 2020 19:06:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540awn7nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:06:19 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3J6JMS028733;
        Thu, 3 Dec 2020 19:06:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:06:18 -0800
Date:   Thu, 3 Dec 2020 11:06:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 10/14] xfs: Introduce error injection to reduce
 maximum inode fork extent count
Message-ID: <20201203190616.GC106272@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
 <20201117134416.207945-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117134416.207945-11-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 17, 2020 at 07:14:12PM +0530, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
> userspace programs to test "Inode fork extent count overflow detection"
> by reducing maximum possible inode fork extent count to 35.
> 
> With block size of 4k, xattr (with local value) insert operation would
> require in the worst case "XFS_DA_NODE_MAXDEPTH + 1" plus
> "XFS_DA_NODE_MAXDEPTH + (64k / 4k)" (required for guaranteeing removal
> of a maximum sized xattr) number of extents. This evaluates to ~28
> extents. To allow for additions of two or more xattrs during extent
> overflow testing, the pseudo max extent count is set to 35.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_errortag.h   | 4 +++-
>  fs/xfs/libxfs/xfs_inode_fork.c | 4 ++++
>  fs/xfs/xfs_error.c             | 3 +++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 53b305dea381..1c56fcceeea6 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -56,7 +56,8 @@
>  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>  #define XFS_ERRTAG_BUF_IOERROR				35
> -#define XFS_ERRTAG_MAX					36
> +#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> +#define XFS_ERRTAG_MAX					37
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -97,5 +98,6 @@
>  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> +#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 8d48716547e5..989b20977654 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -24,6 +24,7 @@
>  #include "xfs_dir2_priv.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_types.h"
> +#include "xfs_errortag.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> @@ -745,6 +746,9 @@ xfs_iext_count_may_overflow(
>  
>  	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
>  
> +	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +		max_exts = 35;

Please add a comment here explaining why 35.

Sorry about the longish review delay, last week was a US holiday and
this week I have eye problems again. :(

--D

> +
>  	nr_exts = ifp->if_nextents + nr_to_add;
>  	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
>  		return -EFBIG;
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 7f6e20899473..3780b118cc47 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>  	XFS_RANDOM_IUNLINK_FALLBACK,
>  	XFS_RANDOM_BUF_IOERROR,
> +	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> +XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> +	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>  	NULL,
>  };
>  
> -- 
> 2.28.0
> 
