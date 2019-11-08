Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0822FC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C35E42178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1b19VQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKHBGD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:06:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHBGD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:06:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80wsjv160906;
        Fri, 8 Nov 2019 01:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=GJYW+C68Q4Z8lfMCDuZ7EHhEYp9q8Q/2sUaiG7njyVs=;
 b=g1b19VQ8IXyom7drZWCDJrQOeZp+l9CohLzX5e20tbD+q7Qpd8Jv/OwCs8as6g4hee2b
 VI1bQ1BSCeuTW9Lb+iCe/LYUe1eb/HBh9Xg2VjnUY/x1+JcOyfQK3tcYxI4AHY9zKCMa
 1vZhJ+wmwL80zcw7Q3hhtkqb0g6SKOdz0VC3nDoHDZeT6jqYSSmMpFPm3b9ncTwkAk6R
 IgAEv7RLHk2y0Hl2PQ7GFhQxd2nFg04kHxq+98Yt9oiU5C3cTYJl8SHY8r2xwdQKVIPd
 C7f0jCQujIYl1Z1IUnyYO3YR7rSs8inQVF7GXHjHL4w3Dz2jZJM1fEN5VYt2QbiZT10i EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w120kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:05:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA814Q3e061621;
        Fri, 8 Nov 2019 01:05:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w41wb88mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:05:59 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA815wab029990;
        Fri, 8 Nov 2019 01:05:58 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 17:05:58 -0800
Date:   Thu, 7 Nov 2019 17:05:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/46] xfs: cleanup xfs_dir2_data_entsize
Message-ID: <20191108010558.GI6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-42-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-42-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:24:05PM +0100, Christoph Hellwig wrote:
> Remove the XFS_DIR2_DATA_ENTSIZE and XFS_DIR3_DATA_ENTSIZE and open
> code them in their only caller, which now becomes so simple that
> we can turn it into an inline function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
>  fs/xfs/libxfs/xfs_dir2_priv.h | 15 ++++++++++++++-
>  2 files changed, 14 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 0e35e613fbf3..dd2389748672 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -19,39 +19,6 @@
>   * Directory data block operations
>   */
>  
> -/*
> - * For special situations, the dirent size ends up fixed because we always know
> - * what the size of the entry is. That's true for the "." and "..", and
> - * therefore we know that they are a fixed size and hence their offsets are
> - * constant, as is the first entry.
> - *
> - * Hence, this calculation is written as a macro to be able to be calculated at
> - * compile time and so certain offsets can be calculated directly in the
> - * structure initaliser via the macro. There are two macros - one for dirents
> - * with ftype and without so there are no unresolvable conditionals in the
> - * calculations. We also use round_up() as XFS_DIR2_DATA_ALIGN is always a power
> - * of 2 and the compiler doesn't reject it (unlike roundup()).
> - */
> -#define XFS_DIR2_DATA_ENTSIZE(n)					\
> -	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
> -		 sizeof(xfs_dir2_data_off_t)), XFS_DIR2_DATA_ALIGN)
> -
> -#define XFS_DIR3_DATA_ENTSIZE(n)					\
> -	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
> -		 sizeof(xfs_dir2_data_off_t) + sizeof(uint8_t)),	\
> -		XFS_DIR2_DATA_ALIGN)
> -
> -int
> -xfs_dir2_data_entsize(
> -	struct xfs_mount	*mp,
> -	int			n)
> -{
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> -		return XFS_DIR3_DATA_ENTSIZE(n);
> -	else
> -		return XFS_DIR2_DATA_ENTSIZE(n);
> -}
> -
>  static uint8_t
>  xfs_dir2_data_get_ftype(
>  	struct xfs_dir2_data_entry *dep)
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index a6c3fb3a2f7b..54bbfdd6ad69 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -57,7 +57,6 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
>  		struct xfs_buf *lbp, struct xfs_buf *dbp);
>  
>  /* xfs_dir2_data.c */
> -int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
>  __be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
>  		struct xfs_dir2_data_entry *dep);
>  
> @@ -172,4 +171,18 @@ extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
>  extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
>  		       struct dir_context *ctx, size_t bufsize);
>  
> +static inline int
> +xfs_dir2_data_entsize(
> +	struct xfs_mount	*mp,
> +	int			namelen)

Why not unsigned int here?  Neither names nor entries can have negative
length.  Other than that, looks fine...

--D

> +{
> +	size_t			len;
> +
> +	len = offsetof(struct xfs_dir2_data_entry, name[0]) + namelen +
> +			sizeof(xfs_dir2_data_off_t) /* tag */;
> +	if (xfs_sb_version_hasftype(&mp->m_sb))
> +		len += sizeof(uint8_t);
> +	return round_up(len, XFS_DIR2_DATA_ALIGN);
> +}
> +
>  #endif /* __XFS_DIR2_PRIV_H__ */
> -- 
> 2.20.1
> 
