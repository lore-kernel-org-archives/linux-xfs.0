Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ACAC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2698B20678
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yz8kuQyW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAUSss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:48:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:48:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImR1E030533;
        Tue, 21 Jan 2020 18:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8i6jpm5qvTuFTPLSNBqR7tzF2EAcfj07C6/l3Qf9CIk=;
 b=Yz8kuQyWcrH9+8xLLp8m8vK2l5C7szDuQ5F4ENxRxueKUNP/uPgavLbGoXXRIpq1rfNB
 GhcPnISveiB/8nFnsm6EH5yAwMontb5hqvv6GW7VRg+LfCDkjSJa+GN/7s6MALwDjZV/
 MSL1D5U12kvBF8jQjW8YtT+P7j9pm40HQKCzs3WUc7npv+ZarZWsyRDl0lH+0OwsoH0p
 E79G2xNWewybRq7kXeaYI0RVVSbWUBF7JO4gecA+8dt1B0dIfLSJp0RCjhRG8UeDZesC
 pMtuqJkcu59Rkzj2zLanmdmfPGAu/AW0w6VsFlfgPggcfn3NcphBlTlD9RqDd222GEUx jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseuf633-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:48:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LImaRB034815;
        Tue, 21 Jan 2020 18:48:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xnsj558mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:48:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LIm8Fo011186;
        Tue, 21 Jan 2020 18:48:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:48:07 -0800
Date:   Tue, 21 Jan 2020 10:48:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 08/29] xfs: move struct xfs_da_args to xfs_types.h
Message-ID: <20200121184806.GW8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:30AM +0100, Christoph Hellwig wrote:
> To allow passing a struct xfs_da_args to the high-level attr helpers
> it needs to be easily includable by files like xfs_xattr.c.  Move the
> struct definition to xfs_types.h to allow for that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.h | 64 ------------------------------------
>  fs/xfs/libxfs/xfs_types.h    | 60 +++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 0f4fbb0889ff..dd2f48b8ee07 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -36,70 +36,6 @@ struct xfs_da_geometry {
>  	size_t		data_entry_offset;
>  };
>  
> -/*========================================================================
> - * Btree searching and modification structure definitions.
> - *========================================================================*/
> -
> -/*
> - * Search comparison results
> - */
> -enum xfs_dacmp {
> -	XFS_CMP_DIFFERENT,	/* names are completely different */
> -	XFS_CMP_EXACT,		/* names are exactly the same */
> -	XFS_CMP_CASE		/* names are same but differ in case */
> -};
> -
> -/*
> - * Structure to ease passing around component names.
> - */
> -typedef struct xfs_da_args {
> -	struct xfs_da_geometry *geo;	/* da block geometry */
> -	const uint8_t		*name;		/* string (maybe not NULL terminated) */
> -	int		namelen;	/* length of string (maybe no NULL) */
> -	uint8_t		filetype;	/* filetype of inode for directories */
> -	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
> -	int		valuelen;	/* length of value */
> -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> -	xfs_dahash_t	hashval;	/* hash value of name */
> -	xfs_ino_t	inumber;	/* input/output inode number */
> -	struct xfs_inode *dp;		/* directory inode to manipulate */
> -	struct xfs_trans *trans;	/* current trans (changes over time) */
> -	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
> -	int		whichfork;	/* data or attribute fork */
> -	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
> -	int		index;		/* index of attr of interest in blk */
> -	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
> -	int		rmtblkcnt;	/* remote attr value block count */
> -	int		rmtvaluelen;	/* remote attr value length in bytes */
> -	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
> -	int		index2;		/* index of 2nd attr in blk */
> -	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
> -	int		rmtblkcnt2;	/* remote attr value block count */
> -	int		rmtvaluelen2;	/* remote attr value length in bytes */
> -	int		op_flags;	/* operation flags */
> -	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
> -} xfs_da_args_t;
> -
> -/*
> - * Operation flags:
> - */
> -#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
> -#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
> -#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
> -#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
> -#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> -#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
> -#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
> -
> -#define XFS_DA_OP_FLAGS \
> -	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> -	{ XFS_DA_OP_RENAME,	"RENAME" }, \
> -	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
> -	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
> -	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
> -	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> -
>  /*
>   * Storage for holding state during Btree searches and split/join ops.
>   *
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 397d94775440..e2711d119665 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -175,6 +175,66 @@ enum xfs_ag_resv_type {
>  	XFS_AG_RESV_RMAPBT,
>  };
>  
> +/*
> + * Dir/attr btree search comparison results.
> + */
> +enum xfs_dacmp {
> +	XFS_CMP_DIFFERENT,	/* names are completely different */
> +	XFS_CMP_EXACT,		/* names are exactly the same */
> +	XFS_CMP_CASE		/* names are same but differ in case */
> +};
> +
> +/*
> + * Structure to ease passing around dir/attr component names.
> + */
> +typedef struct xfs_da_args {
> +	struct xfs_da_geometry *geo;	/* da block geometry */
> +	const uint8_t	*name;		/* string (maybe not NULL terminated) */
> +	int		namelen;	/* length of string (maybe no NULL) */
> +	uint8_t		filetype;	/* filetype of inode for directories */
> +	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
> +	int		valuelen;	/* length of value */
> +	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> +	xfs_dahash_t	hashval;	/* hash value of name */
> +	xfs_ino_t	inumber;	/* input/output inode number */
> +	struct xfs_inode *dp;		/* directory inode to manipulate */
> +	struct xfs_trans *trans;	/* current trans (changes over time) */
> +	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
> +	int		whichfork;	/* data or attribute fork */
> +	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
> +	int		index;		/* index of attr of interest in blk */
> +	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
> +	int		rmtblkcnt;	/* remote attr value block count */
> +	int		rmtvaluelen;	/* remote attr value length in bytes */
> +	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
> +	int		index2;		/* index of 2nd attr in blk */
> +	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
> +	int		rmtblkcnt2;	/* remote attr value block count */
> +	int		rmtvaluelen2;	/* remote attr value length in bytes */
> +	int		op_flags;	/* operation flags */
> +	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
> +} xfs_da_args_t;
> +
> +/*
> + * Operation flags:
> + */
> +#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
> +#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
> +#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
> +#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
> +#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> +#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
> +#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
> +
> +#define XFS_DA_OP_FLAGS \
> +	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> +	{ XFS_DA_OP_RENAME,	"RENAME" }, \
> +	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
> +	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
> +	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> +	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
> +	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
> +
>  /*
>   * Type verifier functions
>   */
> -- 
> 2.24.1
> 
