Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09957C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD667218AC
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ftYPu0pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLRVdK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:33:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54644 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLRVdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:33:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILTpV4039718;
        Wed, 18 Dec 2019 21:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WZSMG/eamV7EqcDxJQrMXWu7tXM1jyWEdwRR+EnnIIY=;
 b=ftYPu0pjS1RatRLZm+tfOKYBXu71+gMV2g9CzeeJVjFnkcgBc2wx0pnDA6cXn7+LCUI+
 bgz0wr/93iM+wATOkSgk/a3xdLeDom/adxUHWtNqB3RW+a8pgCRSSja+//3uJJlv+hTu
 FkeoGiIFe46ydKNvDpI1R5K1iIxpDXB+foqhUbDWNecYjSoYO5SbR1c8BE2I5lllCT4B
 yakV+NkqfRjC+/OUyz09DOm7+8MRO5SeiUfH6+Yklo7hk6d7j7fc4sHi/HrcfNAcG5RH
 wSlb8mPI3aqJCOZFs/Rsn8yuVf79P1nwZOWVbewpssDhAFhKTZED2bN7qwzNnkgY5JRV cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wvq5urd87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:33:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILTdI8040789;
        Wed, 18 Dec 2019 21:33:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wyp08abv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:33:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBILX4m6008575;
        Wed, 18 Dec 2019 21:33:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:33:04 -0800
Date:   Wed, 18 Dec 2019 13:33:03 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 04/33] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
Message-ID: <20191218213303.GG7489@magnolia>
References: <20191212105433.1692-1-hch@lst.de>
 <20191212105433.1692-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212105433.1692-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 11:54:04AM +0100, Christoph Hellwig wrote:
> XFS_ATTR_INCOMPLETE is a flag in the on-disk attribute format, and thus
> in a different namespace as the ATTR_* flags in xfs_da_args.flags.
> Switch to using a XFS_DA_OP_INCOMPLETE flag in op_flags instead.  Without
> this users might be able to inject this flag into operations using the
> attr by handle ioctl.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
>  fs/xfs/libxfs/xfs_da_btree.h  | 4 +++-
>  fs/xfs/libxfs/xfs_da_format.h | 2 --
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0d7fcc983b3d..2368a1bfe7e8 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1007,7 +1007,7 @@ xfs_attr_node_addname(
>  		 * The INCOMPLETE flag means that we will find the "old"
>  		 * attr, not the "new" one.
>  		 */
> -		args->flags |= XFS_ATTR_INCOMPLETE;
> +		args->op_flags |= XFS_DA_OP_INCOMPLETE;
>  		state = xfs_da_state_alloc();
>  		state->args = args;
>  		state->mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 08d4b10ae2d5..fed537a4353d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2403,8 +2403,8 @@ xfs_attr3_leaf_lookup_int(
>  		 * If we are looking for INCOMPLETE entries, show only those.
>  		 * If we are looking for complete entries, show only those.
>  		 */
> -		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
> -		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
> +		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
> +		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
>  			continue;
>  		}
>  		if (entry->flags & XFS_ATTR_LOCAL) {
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index e16610d1c14f..0f4fbb0889ff 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -89,6 +89,7 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
>  #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
>  #define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
> +#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -96,7 +97,8 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
> -	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
> +	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
> +	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
>  
>  /*
>   * Storage for holding state during Btree searches and split/join ops.
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 3dee33043e09..05615d1f4113 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -683,8 +683,6 @@ struct xfs_attr3_leafblock {
>  
>  /*
>   * Flags used in the leaf_entry[i].flags field.
> - * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
> - * on the system call, they are "or"ed together for various operations.
>   */
>  #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
>  #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
> -- 
> 2.20.1
> 
