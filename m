Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2ECC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D89A206E7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jdy/sN5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCLOxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:53:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgCLOxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:53:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEgX9q088402;
        Thu, 12 Mar 2020 14:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AUsJPonOi6pBd0A/9Z7JoRoKOmxUwjCo/pCFKUKFJDY=;
 b=Jdy/sN5tfAnPhxh1YvYw1kGrg33/pGLGkd8UjBy0prs7ooeuKp/oxac/x+o9UZlrrKkf
 5E/vdpkcE3UQLfBIxuJwVkAFFgVtzNpvdqIEWkKfGkWJIsl+WEhwTSylydxrBbj+gF/U
 duK3Ld6W8pf99OmvEMZGmbHuUo97/o80kdEIKA6fsYN+ZYCh2XZLg5RuLCXHmka4/ee7
 DbG4HDJgjCf7QnP0boSdU2ytVcZz1Sjn/in2lGxl0fkKMLE6f/Hly/lqM/BQDtDG2dZY
 /uO74VLT3gdjOvjh/xLZPVAIOKIcEpEz6naUsv4Oy8FJGQNfp0lSUkvLaVLFSJzXSAU3 YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31ut2bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:53:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEoW9t004305;
        Thu, 12 Mar 2020 14:53:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yqkvmtct8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:53:11 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CEr9Sf021783;
        Thu, 12 Mar 2020 14:53:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:53:09 -0700
Date:   Thu, 12 Mar 2020 07:53:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: remove xfs_buf_oneshot
Message-ID: <20200312145308.GM8045@magnolia>
References: <20200312141715.550387-1-hch@lst.de>
 <20200312141715.550387-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312141715.550387-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:17:13PM +0100, Christoph Hellwig wrote:
> This function doesn't exist in the kernel and is purely a stub in
> xfsprogs, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/libxfs_priv.h | 2 --
>  libxfs/xfs_sb.c      | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 17a0104b..723dddcd 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -375,8 +375,6 @@ static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
>  	return NULL;
>  }
>  
> -#define xfs_buf_oneshot(bp)		((void) 0)
> -
>  #define XBRW_READ			LIBXFS_BREAD
>  #define XBRW_WRITE			LIBXFS_BWRITE
>  #define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index 4f750d19..b931fee7 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -982,7 +982,6 @@ xfs_update_secondary_sbs(
>  		}
>  
>  		bp->b_ops = &xfs_sb_buf_ops;
> -		xfs_buf_oneshot(bp);

Removing this will cause xfsprogs' libxfs to fall further out of sync
with the kernel's libxfs.  Eric and I have been trying to keep that to a
minimum.

--D

>  		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
>  		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
>  		xfs_buf_delwri_queue(bp, &buffer_list);
> @@ -1170,7 +1169,6 @@ xfs_sb_get_secondary(
>  	if (!bp)
>  		return -ENOMEM;
>  	bp->b_ops = &xfs_sb_buf_ops;
> -	xfs_buf_oneshot(bp);
>  	*bpp = bp;
>  	return 0;
>  }
> -- 
> 2.24.1
> 
