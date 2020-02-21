Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67509C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F732073A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hUhboWp3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgBUP1t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:27:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUP1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:27:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFRh4C139512;
        Fri, 21 Feb 2020 15:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8yvraRDZ9EJd4iqLKycVcN4WRQ52mzynK4JEIWo2Ex8=;
 b=hUhboWp3XkUUYk43anyHJTTxK9WXkliQt+Ke2PMi1wmyFLwJH+DIvgR4uErT3hQIWV4F
 aYxfb1TLOaDRytj+iaC5VDUED475EXUVDNRFsLStD73jfoNLLVPaEzgRNDj1dCCUIepE
 MrHQMEvqHB4vO5VTjj9XhmGR+lg+tcDj8aw4m19b9+4lwopYpV+VxGYOV5VW8U7YTiKh
 Hl5g2/90iDjkcR+ty6yi8VkjgpKuyHiNYz34SL2TC/lTjvnUcXXYlx1DfHxctJMyIhyl
 f3aBtHEjMmkAqd+01YvzU4f4Jl9VnxXAf01CQhZ7xApR9NV4n8SryMUlMS615CvnVwH0 RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udks5vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:27:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFReu9005151;
        Fri, 21 Feb 2020 15:27:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8udfc2xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:27:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LFRhba023783;
        Fri, 21 Feb 2020 15:27:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:27:43 -0800
Date:   Fri, 21 Feb 2020 07:27:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 29/31] xfs: remove XFS_DA_OP_INCOMPLETE
Message-ID: <20200221152742.GN9506@magnolia>
References: <20200221141154.476496-1-hch@lst.de>
 <20200221141154.476496-30-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221141154.476496-30-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:11:52AM -0800, Christoph Hellwig wrote:
> Now that we use the on-disk flags field also for the interface to the
> lower level attr routines we can use the XFS_ATTR_INCOMPLETE definition
> from the on-disk format directly instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
>  fs/xfs/libxfs/xfs_types.h     |  6 ++----
>  3 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ff4f34f8f74c..067716be6d73 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -898,7 +898,7 @@ xfs_attr_node_addname(
>  		 * The INCOMPLETE flag means that we will find the "old"
>  		 * attr, not the "new" one.
>  		 */
> -		args->op_flags |= XFS_DA_OP_INCOMPLETE;
> +		args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  		state = xfs_da_state_alloc();
>  		state->args = args;
>  		state->mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 5f3702172e96..4be04aeee278 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -456,7 +456,12 @@ xfs_attr_match(
>  		return false;
>  	if (memcmp(args->name, name, namelen) != 0)
>  		return false;
> -	if (args->attr_filter != (flags & XFS_ATTR_NSP_ONDISK_MASK))
> +	/*
> +	 * If we are looking for incomplete entries, show only those, else only
> +	 * show complete entries.
> +	 */
> +	if (args->attr_filter !=
> +	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
>  		return false;
>  	return true;
>  }
> @@ -2387,14 +2392,6 @@ xfs_attr3_leaf_lookup_int(
>  /*
>   * GROT: Add code to remove incomplete entries.
>   */
> -		/*
> -		 * If we are looking for INCOMPLETE entries, show only those.
> -		 * If we are looking for complete entries, show only those.
> -		 */
> -		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
> -		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
> -			continue;
> -		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
>  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
>  			if (!xfs_attr_match(args, name_loc->namelen,
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 04d0d11ec7a9..2f4b4e25aec4 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -194,7 +194,7 @@ typedef struct xfs_da_args {
>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
> -	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
> +	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
>  	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
>  	xfs_dahash_t	hashval;	/* hash value of name */
>  	xfs_ino_t	inumber;	/* input/output inode number */
> @@ -225,7 +225,6 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
>  #define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
> -#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -233,8 +232,7 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
> -	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> +	{ XFS_DA_OP_NOTIME,	"NOTIME" }
>  
>  /*
>   * Type verifier functions
> -- 
> 2.24.1
> 
