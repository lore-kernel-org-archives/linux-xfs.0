Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB22C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0BBF2072F
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J9NlL/7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgFCAhC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:37:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgFCAhC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 20:37:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530MFs9002989;
        Wed, 3 Jun 2020 00:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tXPWbp7TF0eQIy1j74fG4t8qSiCYyIGQGIh4g6qluvU=;
 b=J9NlL/7IEnEn2ON6mubpt0XUjvxv/y7PApYGKXP6L1uKV7EfSTlWTZYLdcenp5Z0itcz
 evpG/zqEWCuMrdCD+APR27eyl7a64/gIIaggmaDQDSUZNBsMI2l7KJIM4oPmeEACcABp
 +prOmBytK59TAjpjq6hlRtd6Ge7Q1pDQmc1ztaRH16PTqvA8k1DMi/EEM17RHLL96cb9
 EiWdcka25jw0sBKKs8BFpKh+GDfWpgJpTd4ktuOrJnMUxOdekTzv+9yb9HxoA6RI75fd
 7RvEMY1KIjYqqmPbkibooyn4JoC3B8uL0u2Yo5o/F+VT1YO7VFHzZCJuXGbM3bjUs86+ 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31dkruknk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 00:36:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530I0l0013863;
        Wed, 3 Jun 2020 00:36:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25qfasd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 00:36:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0530av6s005831;
        Wed, 3 Jun 2020 00:36:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 17:36:57 -0700
Date:   Tue, 2 Jun 2020 17:36:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: move the di_dmevmask field to struct xfs_inode
Message-ID: <20200603003656.GX8230@magnolia>
References: <20200524091757.128995-1-hch@lst.de>
 <20200524091757.128995-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524091757.128995-14-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=5 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 11:17:56AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> dmevmask field into the containing xfs_inode structure.

Do we even use dmevmask or dmstate?  Why not just get rid of them and
set them to zero ondisk?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_inode.c            | 4 ++--
>  fs/xfs/xfs_inode.h            | 1 +
>  fs/xfs/xfs_inode_item.c       | 2 +-
>  fs/xfs/xfs_log_recover.c      | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index af595ee23635a..d361803102d0e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -246,7 +246,7 @@ xfs_inode_from_disk(
>  	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
>  	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	ip->i_forkoff = from->di_forkoff;
> -	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> +	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	ip->i_diflags	= be16_to_cpu(from->di_flags);
>  
> @@ -312,7 +312,7 @@ xfs_inode_to_disk(
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> +	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
>  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 2a8e7a7ed8d18..0cfc1aaff6c6f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
>  };
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index aa91217b0fd7f..0b92ce18cf957 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -833,7 +833,7 @@ xfs_ialloc(
>  	inode->i_ctime = tv;
>  
>  	ip->i_extsize = 0;
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  	ip->i_d.di_dmstate = 0;
>  	ip->i_diflags = 0;
>  
> @@ -2753,7 +2753,7 @@ xfs_ifree(
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_diflags = 0;
>  	ip->i_diflags2 = 0;
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  	ip->i_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c77ecde5e6e0d..46dc9612af138 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -67,6 +67,7 @@ typedef struct xfs_inode {
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
> +	uint32_t		i_dmevmask;	/* DMIG event mask */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index dff3bc6a33720..9b7860025c497 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -330,7 +330,7 @@ xfs_inode_to_log_dinode(
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = from->di_dmevmask;
> +	to->di_dmevmask = ip->i_dmevmask;
>  	to->di_dmstate = from->di_dmstate;
>  	to->di_flags = ip->i_diflags;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec015df55b77a..d096b8c401381 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2720,7 +2720,7 @@ xlog_recover_process_one_iunlink(
>  	 * Prevent any DMAPI event from being sent when the reference on
>  	 * the inode is dropped.
>  	 */
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  
>  	xfs_irele(ip);
>  	return agino;
> -- 
> 2.26.2
> 
