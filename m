Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2060C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FEEA214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4aequbU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKHB1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:27:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:27:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA81NtBw191844
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 01:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=OJoPmk8z/nrL7CNXvgPVggC2J4JtJaYLPoVQHh/CdoI=;
 b=J4aequbUNZhSzwR+wMNTgHw1e7iQUkziNoPS4AW65AwOhV1TVfRVUJNs1v40HI/GhWs1
 DdGQPX9BHWSqoZtLkCXFIeX/ii1mS518S+55R2/M9s68puYtyUit16i5l/Fo6iOIp18z
 qtQc3Jt0MPaQj4zjID1sjbe66TvlAJYKJ57X69Gi8rVjcL0KhqgFbimfFHKer+sjd87C
 Lm97xR6dYUMNJHpM5K7rxsLZKZu094j8JuiWRoy8qCs1DLd/502UZa1gU6pDmYjwmYCa
 jZNXOmx/zNzu3aEDTj7P7H2OlgOsDt0xqyEnTPUEwhBKHMUfNF0Kw3mjmQbwLYpRi0/y Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w121xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 01:27:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA81Nw1L112132
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 01:25:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41wb9h0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 01:25:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA81Pewd021783
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 01:25:40 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 17:25:40 -0800
Date:   Thu, 7 Nov 2019 17:25:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 03/17] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20191108012540.GL6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-4-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:47PM -0700, Allison Collins wrote:
> This patch embeds an xfs_name in xfs_da_args, replacing the name,
> namelen, and flags members.  This helps to clean up the xfs_da_args
> structure and make it more uniform with the new xfs_name parameter
> being passed around.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |  36 +++++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 106 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.c    |   5 +-
>  fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>  fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
>  fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +--
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>  fs/xfs/scrub/attr.c             |  12 ++---
>  fs/xfs/xfs_trace.h              |  20 ++++----
>  12 files changed, 128 insertions(+), 125 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5a9624a..b77b985 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -72,13 +72,12 @@ xfs_attr_args_init(
>  	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
> -	args->flags = flags;
> -	args->name = name->name;
> -	args->namelen = name->len;
> -	if (args->namelen >= MAXNAMELEN)
> +	name->type = flags;

Is there a purpose for modifying the caller's @name, instead of setting
args.name.type = flags after the memcpy?

> +	memcpy(&args->name, name, sizeof(struct xfs_name));
> +	if (args->name.len >= MAXNAMELEN)
>  		return -EFAULT;		/* match IRIX behaviour */
>  
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->hashval = xfs_da_hashname(args->name.name, args->name.len);
>  	return 0;
>  }
>  
> @@ -236,7 +235,7 @@ xfs_attr_try_sf_addname(
>  	 * Commit the shortform mods, and we're done.
>  	 * NOTE: this is also the error path (EEXIST, etc).
>  	 */
> -	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
> +	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> @@ -357,6 +356,9 @@ xfs_attr_set(
>  	if (error)
>  		return error;
>  
> +	/* Use name now stored in args */
> +	name = &args.name;

You could probably set this as part of the variable declaration, e.g.

struct xfs_name		*name = &args.name;

> +
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> @@ -372,7 +374,7 @@ xfs_attr_set(
>  	 */
>  	if (XFS_IFORK_Q(dp) == 0) {
>  		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> -			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
> +			XFS_ATTR_SF_ENTSIZE_BYNAME(args.name.len, valuelen);

If you're going to keep the convenience variable @name, then please use
it throughout the function.

>  
>  		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
>  		if (error)

<snip>

> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 4fd1223..129ec09 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2040,8 +2040,9 @@ xfs_da_compname(
>  	const unsigned char *name,
>  	int		len)
>  {
> -	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
> -					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;

Wow that's gross. :)

	if (args->name.len == len && !memcmp(args->name.name, name, len))
		return XFS_CMP_EXACT;

	return XFS_CMP_DIFFERENT;

Hmm, is that better?

The rest looks reasonable...

--D
