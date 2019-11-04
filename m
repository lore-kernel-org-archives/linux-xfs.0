Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ACEC47E49
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C94321928
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o8P3v6xm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfKDUtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:49:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbfKDUtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:49:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KnBBE148092;
        Mon, 4 Nov 2019 20:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RO3wzXxiGrZm/ICqCt6PbqgaZhqRzo9gozLYHwv9iCY=;
 b=o8P3v6xmz3ZxSjK5UCw7tMktwNXjW9uzfQszFHpYLD7cEnuCBJ+PeKU8O1lXnw+9A+jL
 3iUQNaLZhNLtBgQSmyAc5J3HGCSKGHPVWXSOmKVQ+EqmFv4iZgpOF5dJymX3/v/eGxWj
 /34CXCpnu5Mw3618Gr4cjYoIB0MVtWp+tVxjrJ0UDdmmpttpLikNIkYTZs4aZEhZC7+G
 xtZ2fmqnxs7U2h0uHx1XeJRPWzKxOk5IDLKYXD+hyytGtztFzxw2ASPw2Fg8zHBRrAab
 aSVofWeZYqTjgEda38L/JVR3BywgFPRXgRYKc2A1DmMm+vkKkm85j0YwXz9R/BqHwhDR Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tt208-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:49:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KnUNX114917;
        Mon, 4 Nov 2019 20:49:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w1k8vg0je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:49:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KmVwt013364;
        Mon, 4 Nov 2019 20:48:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:48:31 -0800
Date:   Mon, 4 Nov 2019 12:48:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/34] xfs: cleanup xfs_dir2_data_entsize
Message-ID: <20191104204830.GE4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-30-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-30-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:14PM -0700, Christoph Hellwig wrote:
> Remove the XFS_DIR2_DATA_ENTSIZE and XFS_DIR3_DATA_ENTSIZE and open
> code them in their only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
>  fs/xfs/libxfs/xfs_dir2_data.c | 14 ++++++++++++++
>  2 files changed, 14 insertions(+), 33 deletions(-)
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
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 81ba13854f8d..c44c455b961f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -24,6 +24,20 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>  		struct xfs_dir2_data_unused *dup,
>  		struct xfs_dir2_data_free **bf_ent);
>  
> +int
> +xfs_dir2_data_entsize(
> +	struct xfs_mount	*mp,
> +	int			namelen)
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
>  /*
>   * Pointer to an entry's tag word.
>   */
> -- 
> 2.20.1
> 
