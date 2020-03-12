Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7B7C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A0B206F7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kU1F8x/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCLXrM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 19:47:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgCLXrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 19:47:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNhMWc098697;
        Thu, 12 Mar 2020 23:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=U74uySgOa6CTEtNPm+mWBFYj/RWbGcDy0oppQslOSR4=;
 b=kU1F8x/xK+fhsNw0sMFy6zzqvojJK3X2OOxibF2SYDA8wSQx3RKbVhOrYpabmDaqba1J
 1voQ56RlVVu//6bl7TerPCknYYnT0CfGZo10C7YGoWZhuiDoB+u0hFfYnnu9xR8wKRpM
 Hb/z4xc0W55zpAhAOC/lDzLPykC4iqIZZkvRWFlKSnQ8nkVkAJmqc/ibrqZ9MfBozEq8
 15SM7fkphjLPRgeJh6MTYFLXDSTEZeyCvzAkN9F0UGXFg2kRleV82LKXaYYLo8519j4W
 bcDyHE/Uwow6W2HrJjl39w0mHuKVs4f2rfD9mo+NdA+kmUUmYOW2NBDWdZi01gfthBkC KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yqtaes4xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:47:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNgHdI028792;
        Thu, 12 Mar 2020 23:45:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yqtac4k7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:45:08 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CNj1uX010811;
        Thu, 12 Mar 2020 23:45:02 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 16:45:01 -0700
Date:   Thu, 12 Mar 2020 16:45:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: mark XLOG_FORCED_SHUTDOWN as unlikely
Message-ID: <20200312234501.GS8045@magnolia>
References: <20200312143959.583781-1-hch@lst.de>
 <20200312143959.583781-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312143959.583781-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:39:55PM +0100, Christoph Hellwig wrote:
> A shutdown log is a slow failure path.  Add an unlikely annotation to
> it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_priv.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b192c5a9f9fd..e400170ff4af 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -402,7 +402,8 @@ struct xlog {
>  #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
>  	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
>  
> -#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
> +#define XLOG_FORCED_SHUTDOWN(log) \
> +	(unlikely((log)->l_flags & XLOG_IO_ERROR))
>  
>  /* common routines */
>  extern int
> -- 
> 2.24.1
> 
