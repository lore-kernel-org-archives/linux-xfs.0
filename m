Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41EAC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 912CD20723
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M11O+x46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgF3RuG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:50:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60880 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388679AbgF3RuB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:50:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHmBB0029097;
        Tue, 30 Jun 2020 17:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hOZ+eZhAgtbiCUiAX7oK/hCG49fDN4GB90iYZ1ZHLGw=;
 b=M11O+x46jh7g/ThZo5y6YZrWQqonMCUNFLNFtKyTfhLK8F2qK5JMXc3jPhuYYVGtBM3k
 Omw3RT/V1V93rI2o9dkEoHPMBFaytWOG0JD3INXkJnuP/nGxuK/C15Ih8CDJA4TtZI+z
 17JjD8Rrt4TJAXD+V0VdwM5pRNVAYgzWlhefwtJkBEgXNlT1LjH4STiLnnE+2L4Lrcxe
 OYYnR7RTny4W4ssDPTbmQHYKl/s99/jO8JebUK2PNRkcvI5TeWbX/hPk51XWi9dHY6LK
 GSPo24LM0OXOp7zJWWWCmMnjJReRPmhB/Rru0Udr5QTWyeGy6E9wZOfT9iTm9PbkVpmE +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn60pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:49:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHcdvI080637;
        Tue, 30 Jun 2020 17:47:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvst0rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:47:57 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHlvpx017099;
        Tue, 30 Jun 2020 17:47:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:47:56 +0000
Date:   Tue, 30 Jun 2020 10:47:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: move the di_extsize field to struct xfs_inode
Message-ID: <20200630174755.GB7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-6-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:52AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the extsize
> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c      |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_inode.c            | 10 +++++-----
>  fs/xfs/xfs_inode.h            |  1 +
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  fs/xfs/xfs_ioctl.c            | 10 +++++-----
>  fs/xfs/xfs_itable.c           |  2 +-
>  8 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 54f3015f08285a..692159357ed8e5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2942,7 +2942,7 @@ xfs_bmap_add_extent_hole_real(
>   */
>  
>  /*
> - * Adjust the size of the new extent based on di_extsize and rt extsize.
> + * Adjust the size of the new extent based on i_extsize and rt extsize.
>   */
>  int
>  xfs_bmap_extsize_align(
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d1a15778e86a38..e51b15c44bb3e1 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -243,7 +243,7 @@ xfs_inode_from_disk(
>  
>  	ip->i_disk_size = be64_to_cpu(from->di_size);
>  	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
> -	to->di_extsize = be32_to_cpu(from->di_extsize);
> +	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
> @@ -306,7 +306,7 @@ xfs_inode_to_disk(
>  
>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
> -	to->di_extsize = cpu_to_be32(from->di_extsize);
> +	to->di_extsize = cpu_to_be32(ip->i_extsize);
>  	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = from->di_forkoff;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index a322e1adf0a348..d420ea835c8390 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 19d132acc499cb..6d1891f902aaa9 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -61,8 +61,8 @@ xfs_get_extsz_hint(
>  	 */
>  	if (xfs_is_always_cow_inode(ip))
>  		return 0;
> -	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
> -		return ip->i_d.di_extsize;
> +	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
> +		return ip->i_extsize;
>  	if (XFS_IS_REALTIME_INODE(ip))
>  		return ip->i_mount->m_sb.sb_rextsize;
>  	return 0;
> @@ -834,7 +834,7 @@ xfs_ialloc(
>  	inode->i_atime = tv;
>  	inode->i_ctime = tv;
>  
> -	ip->i_d.di_extsize = 0;
> +	ip->i_extsize = 0;
>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_dmstate = 0;
>  	ip->i_d.di_flags = 0;
> @@ -866,7 +866,7 @@ xfs_ialloc(
>  					di_flags |= XFS_DIFLAG_RTINHERIT;
>  				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
>  					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
> -					ip->i_d.di_extsize = pip->i_d.di_extsize;
> +					ip->i_extsize = pip->i_extsize;
>  				}
>  				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
>  					di_flags |= XFS_DIFLAG_PROJINHERIT;
> @@ -875,7 +875,7 @@ xfs_ialloc(
>  					di_flags |= XFS_DIFLAG_REALTIME;
>  				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
>  					di_flags |= XFS_DIFLAG_EXTSIZE;
> -					ip->i_d.di_extsize = pip->i_d.di_extsize;
> +					ip->i_extsize = pip->i_extsize;
>  				}
>  			}
>  			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 828f49f109475e..af90c6f745549b 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -57,6 +57,7 @@ typedef struct xfs_inode {
>  	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
> +	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0980fa43472cf8..8b8c99809f273e 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -325,7 +325,7 @@ xfs_inode_to_log_dinode(
>  
>  	to->di_size = ip->i_disk_size;
>  	to->di_nblocks = ip->i_nblocks;
> -	to->di_extsize = from->di_extsize;
> +	to->di_extsize = ip->i_extsize;
>  	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = from->di_forkoff;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d93f4fc40fd99e..efe3b5bc1178dc 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1107,7 +1107,7 @@ xfs_fill_fsxattr(
>  	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
> -	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
> +	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_projid = ip->i_projid;
> @@ -1209,7 +1209,7 @@ xfs_ioctl_setattr_xflags(
>  	/* If realtime flag is set then must have realtime device */
>  	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
>  		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
> -		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
> +		    (ip->i_extsize % mp->m_sb.sb_rextsize))
>  			return -EINVAL;
>  	}
>  
> @@ -1381,7 +1381,7 @@ xfs_ioctl_setattr_check_extsize(
>  	xfs_fsblock_t		extsize_fsb;
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> -	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
> +	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
>  		return -EINVAL;
>  
>  	if (fa->fsx_extsize == 0)
> @@ -1569,9 +1569,9 @@ xfs_ioctl_setattr(
>  	 * are set on the inode then unconditionally clear the extent size hint.
>  	 */
>  	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> -		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> +		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
>  	else
> -		ip->i_d.di_extsize = 0;
> +		ip->i_extsize = 0;
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7af144500bbfdb..b0f0c19fd7822e 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -103,7 +103,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_mode = inode->i_mode;
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
> -	buf->bs_extsize_blks = dic->di_extsize;
> +	buf->bs_extsize_blks = ip->i_extsize;
>  	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
> -- 
> 2.26.2
> 
