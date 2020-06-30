Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9FAC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B35520768
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kvD7eZ0Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbgF3R6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:58:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3R6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:58:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqmCK046086;
        Tue, 30 Jun 2020 17:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MuIo3k+uyiBcMNAqYvsA8CR2pw7tKFkYMXDD1xq5kEM=;
 b=kvD7eZ0Yh3lXWAO/uj7RkaqDkHXJw3IpXyzMbKfdONk3OUXNpLbRiaPJfIA8hFzRlIew
 LGWHFgE7vIVck/AYL8zAsfgZZbFQAejZavNzqNRc+YotiLdnZ3IiwJzv2fzFjDEVYIhD
 P70P2FbmDTwhU85ymmnX7o6IL4OPTDgMaYzkr7VsDs304sxNx9dEpRRuHotTtbv4u0T5
 T+86tfSATsZJkg9e5NsjcE9sYOgZTNi1LLcUEvFM/4+Gc5QC91T5GMBygLczOsxuYhuz
 jLQaCTzxbhUoRbQmdwXcjDRh5wy3k+LbuBFiV7YR1wrGQJQkdAAOX9cJVSlhBQnkrB4C CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn623r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:58:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqa9I159899;
        Tue, 30 Jun 2020 17:56:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvstaua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:56:20 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHuJbv017320;
        Tue, 30 Jun 2020 17:56:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:56:19 +0000
Date:   Tue, 30 Jun 2020 10:56:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: move the di_dmstate field to struct xfs_inode
Message-ID: <20200630175618.GL7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-16-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:11:02AM +0200, Christoph Hellwig wrote:
> Move the di_dmstate into struct xfs_inode, and thus finally kill of
> the xfs_icdinode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hooray, it's gone finally...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  6 ++----
>  fs/xfs/libxfs/xfs_inode_buf.h | 10 ----------
>  fs/xfs/xfs_inode.c            |  2 +-
>  fs/xfs/xfs_inode.h            |  3 +--
>  fs/xfs/xfs_inode_item.c       |  3 +--
>  fs/xfs/xfs_itable.c           |  3 ---
>  6 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d361803102d0e1..e4e96a47e0bab6 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -185,7 +185,6 @@ xfs_inode_from_disk(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*from)
>  {
> -	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  	xfs_failaddr_t		fa;
> @@ -247,7 +246,7 @@ xfs_inode_from_disk(
>  	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	ip->i_forkoff = from->di_forkoff;
>  	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
> -	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
> +	ip->i_dmstate	= be16_to_cpu(from->di_dmstate);
>  	ip->i_diflags	= be16_to_cpu(from->di_flags);
>  
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> @@ -282,7 +281,6 @@ xfs_inode_to_disk(
>  	struct xfs_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> -	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> @@ -313,7 +311,7 @@ xfs_inode_to_disk(
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
> -	to->di_dmstate = cpu_to_be16(from->di_dmstate);
> +	to->di_dmstate = cpu_to_be16(ip->i_dmstate);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>  
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 0cfc1aaff6c6f3..834c8b3e917370 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -9,16 +9,6 @@
>  struct xfs_inode;
>  struct xfs_dinode;
>  
> -/*
> - * In memory representation of the XFS inode. This is held in the in-core struct
> - * xfs_inode and represents the current on disk values but the structure is not
> - * in on-disk format.  That is, this structure is always translated to on-disk
> - * format specific structures at the appropriate time.
> - */
> -struct xfs_icdinode {
> -	uint16_t	di_dmstate;	/* DMIG state info */
> -};
> -
>  /*
>   * Inode location information.  Stored in the inode and passed to
>   * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index db48c910c8d7b0..79436ed0b14e89 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -834,7 +834,7 @@ xfs_ialloc(
>  
>  	ip->i_extsize = 0;
>  	ip->i_dmevmask = 0;
> -	ip->i_d.di_dmstate = 0;
> +	ip->i_dmstate = 0;
>  	ip->i_diflags = 0;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e64df2e7438aa0..f0537ead8bad90 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -68,8 +68,7 @@ typedef struct xfs_inode {
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
>  	uint32_t		i_dmevmask;	/* DMIG event mask */
> -
> -	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> +	uint16_t		i_dmstate;	/* DMIG state info */
>  
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 9b7860025c497d..628f8190abddca 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -301,7 +301,6 @@ xfs_inode_to_log_dinode(
>  	struct xfs_log_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> -	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = XFS_DINODE_MAGIC;
> @@ -331,7 +330,7 @@ xfs_inode_to_log_dinode(
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = ip->i_dmevmask;
> -	to->di_dmstate = from->di_dmstate;
> +	to->di_dmstate = ip->i_dmstate;
>  	to->di_flags = ip->i_diflags;
>  
>  	/* log a dummy value to ensure log structure is fully initialised */
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7945c6c4844940..cd1f09e57b9483 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -58,7 +58,6 @@ xfs_bulkstat_one_int(
>  	xfs_ino_t		ino,
>  	struct xfs_bstat_chunk	*bc)
>  {
> -	struct xfs_icdinode	*dic;		/* dinode core info pointer */
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
>  	struct xfs_bulkstat	*buf = bc->buf;
> @@ -79,8 +78,6 @@ xfs_bulkstat_one_int(
>  	ASSERT(ip->i_imap.im_blkno != 0);
>  	inode = VFS_I(ip);
>  
> -	dic = &ip->i_d;
> -
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -- 
> 2.26.2
> 
