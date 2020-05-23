Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55624C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 00:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1985C2074B
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 00:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zLM2mEcy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgEWAQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 20:16:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgEWAQQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 20:16:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0D4ra069167;
        Sat, 23 May 2020 00:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=EpPC6MkXudQLmt7h/kY+LPXNRLSeAe6M4p8IJE+GdU0=;
 b=zLM2mEcy8r73DbHsEeyOJa18vDeokWWJQmuLsCe7C20XUkDtajx7FZbXu38i0GYK4AQf
 9il9ObQI4JDShPbUe6T47Q5oGATWjCvim2ShDzz3M0z9HvMHLWk/3OTXCz+LFNd7/Yep
 D9f1Fq76gM8Udp0MQmlswZORxnT2pY0z/hGVn5CbTW6G2pjmA/EuYkEK4EetY3avbX7d
 PrJR96fHLXicwTeoc4/Zns2pfTAgu/gu/fPGu3IjW9GQS4AVwEeLjYzUDXGO7EqStyii
 JKbp1jRBT60RCMxiP2inSNW5eGwUdae1Eb+SYxiNqsp/LFPm1LGcj4yP6LZzmRucQeuT 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284mg5q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 00:16:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0ClEF097687;
        Sat, 23 May 2020 00:16:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj8d64f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 00:16:12 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N0GC62029643;
        Sat, 23 May 2020 00:16:12 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 17:16:11 -0700
Date:   Fri, 22 May 2020 17:16:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/24] xfs: remove xfs_inobp_check()
Message-ID: <20200523001610.GA8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200522035029.3022405-25-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:29PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This debug code is called on every xfs_iflush() call, which then
> checks every inode in the buffer for non-zero unlinked list field.
> Hence it checks every inode in the cluster buffer every time a
> single inode on that cluster it flushed. This is resulting in:
> 
> -   38.91%     5.33%  [kernel]  [k] xfs_iflush                                                                                                              ▒
>    - 17.70% xfs_iflush                                                                                                                                      ▒
>       - 9.93% xfs_inobp_check                                                                                                                                   ▒
>            4.36% xfs_buf_offset                                                                                                                                 ▒

Overly long lines there ^^^^^.

> 
> 10% of the CPU time spent flushing inodes is repeatedly checking
> unlinked fields in the buffer. We don't need to do this.
> 
> The other place we call xfs_inobp_check() is
> xfs_iunlink_update_dinode(), and this is after we've done this
> assert for the agino we are about to write into that inode:
> 
> 	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> 
> which means we've already checked that the agino we are about to
> write is not 0 on debug kernels. The inode buffer verifiers do
> everything else we need, so let's just remove this debug code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

But with that fixed up,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 24 ------------------------
>  fs/xfs/libxfs/xfs_inode_buf.h |  6 ------
>  fs/xfs/xfs_inode.c            |  2 --
>  3 files changed, 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 1af97235785c8..6b6f67595bf4e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -20,30 +20,6 @@
>  
>  #include <linux/iversion.h>
>  
> -/*
> - * Check that none of the inode's in the buffer have a next
> - * unlinked field of 0.
> - */
> -#if defined(DEBUG)
> -void
> -xfs_inobp_check(
> -	xfs_mount_t	*mp,
> -	xfs_buf_t	*bp)
> -{
> -	int		i;
> -	xfs_dinode_t	*dip;
> -
> -	for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
> -		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
> -		if (!dip->di_next_unlinked)  {
> -			xfs_alert(mp,
> -	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
> -				i, (long long)bp->b_bn);
> -		}
> -	}
> -}
> -#endif
> -
>  /*
>   * If we are doing readahead on an inode buffer, we might be in log recovery
>   * reading an inode allocation buffer that hasn't yet been replayed, and hence
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 865ac493c72a2..6b08b9d060c2e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -52,12 +52,6 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
>  void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
>  			       struct xfs_dinode *to);
>  
> -#if defined(DEBUG)
> -void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
> -#else
> -#define	xfs_inobp_check(mp, bp)
> -#endif /* DEBUG */
> -
>  xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
>  			   struct xfs_dinode *dip);
>  xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7db0f97e537e3..98a494e42aa6a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2146,7 +2146,6 @@ xfs_iunlink_update_dinode(
>  	xfs_dinode_calc_crc(mp, dip);
>  	xfs_trans_inode_buf(tp, ibp);
>  	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -	xfs_inobp_check(mp, ibp);
>  }
>  
>  /* Set an in-core inode's unlinked pointer and return the old value. */
> @@ -3538,7 +3537,6 @@ xfs_iflush(
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
>  		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
> -	xfs_inobp_check(mp, bp);
>  
>  	/*
>  	 * We've recorded everything logged in the inode, so we'd like to clear
> -- 
> 2.26.2.761.g0e0b3e54be
> 
