Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA38C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23B37206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HXwPAgTI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgCLO4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:56:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34618 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLO4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:56:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEiX3A166371;
        Thu, 12 Mar 2020 14:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6Kq0FubJH9mldICeT3cCyhzXuAwPkMn700uFcJU0poM=;
 b=HXwPAgTIxw9VxA2oX+Sd/t+eevZzaTNubX2e45Dos8opiFX62wfqvaxvIfZf8HDP5Ly2
 v9YLcZsHHqeYQvG4snRwLp4xhy/ggx84zbP6wrS3aSLIbaQVDCD7ELfyS4s4DH9KMhCu
 PnpPkV8UbHgqf7pjsLlp0hZT90Ch6fs5HyHdQihJPcu9hAywiloeh1YjmKkFCw8u8j5J
 CTQ1mFqP6k/f+tfX32pmUeQ/bSLQIM18KGbv064vXEgIxMkmhtcjk8ZAPslRzax066kW
 ALKs3PX+vFTYx3NzE42aTQrORG0nmFm5LYJrb7m/XGzxjaDwUi3A9HWFF+jb6hW0W0+K Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v6d5xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:56:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEoMBI194605;
        Thu, 12 Mar 2020 14:56:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yqkvmthxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:56:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CEuE9N015018;
        Thu, 12 Mar 2020 14:56:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:56:14 -0700
Date:   Thu, 12 Mar 2020 07:56:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: turn the xfs_buf_incore stub into an inline
 function
Message-ID: <20200312145613.GN8045@magnolia>
References: <20200312141715.550387-1-hch@lst.de>
 <20200312141715.550387-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312141715.550387-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:17:12PM +0100, Christoph Hellwig wrote:
> Replace the macro with an inline function to avoid compiler warnings with new
> backports of kernel code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  libxfs/libxfs_priv.h | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 5d6dd063..17a0104b 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -369,14 +369,12 @@ roundup_64(uint64_t x, uint32_t y)
>  #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
>  #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
>  
> -/* avoid gcc warning */
> -#define xfs_buf_incore(bt,blkno,len,lockit) ({		\
> -	typeof(blkno) __foo = (blkno);			\
> -	typeof(len) __bar = (len);			\
> -	(blkno) = __foo;				\
> -	(len) = __bar; /* no set-but-unused warning */	\
> -	NULL;						\
> -})
> +static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
> +		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
> +{
> +	return NULL;
> +}
> +
>  #define xfs_buf_oneshot(bp)		((void) 0)
>  
>  #define XBRW_READ			LIBXFS_BREAD
> -- 
> 2.24.1
> 
