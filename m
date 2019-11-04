Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09C4C47E49
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABA3F20848
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:26:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RDHDw/kv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfKDU02 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:26:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37542 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDU02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:26:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KNoKf127257;
        Mon, 4 Nov 2019 20:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VpUKyXJh5EEJA7+6rc+74aQy0XdmV9RVWOzjNzDhTWw=;
 b=RDHDw/kvYpZmG6ziOcW+vLD+dnS9/77sdVEHAivghrZRXJnwpjtDp1kuCp4qO7kI0b/c
 4g85MhDwhmgILw8kQdU6TWHe70oTpmSxTYP8liOD1JfWkALvRfoJFHbcCmhrmbVaJk4U
 moK5GXFy0NvQAuX5odDBt/y7B8vhVfn8aA8hwAIXAimRw3h+Mf9ceWLag+16cacDoZjY
 y78IxucTsBAwJ3UyALtXA2XqknhB6+dYAEyZx6bs558FiKLBocVPRdSItBfOBonT2wAA
 F9ZwR75OgYqoYoU1bHcTtYc4PEl5BR3JDPWK7AlYvGzCxqFTeS26/wdTIbLMcHRrWzAq bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117tsxe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:26:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KODi3129538;
        Mon, 4 Nov 2019 20:26:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w1kxdwrfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:26:24 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KQM7W003956;
        Mon, 4 Nov 2019 20:26:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:26:22 -0800
Date:   Mon, 4 Nov 2019 12:26:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/34] xfs: devirtualize ->db_to_fdb and ->db_to_fdindex
Message-ID: <20191104202621.GT4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-19-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:03PM -0700, Christoph Hellwig wrote:
> Now that the max bests value is in struct xfs_da_geometry both instances
> of ->db_to_fdb and ->db_to_fdindex are identical.  Replace them with
> local xfs_dir2_db_to_fdb and xfs_dir2_db_to_fdindex functions in
> xfs_dir2_node.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems pretty straightforward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 47 -----------------------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  5 ----
>  fs/xfs/libxfs/xfs_dir2_node.c | 35 ++++++++++++++++++++------
>  3 files changed, 27 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index d2d3144c1598..2b708b9fae1a 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -400,44 +400,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
>  		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
>  }
>  
> -/*
> - * Convert data space db to the corresponding free db.
> - */
> -static xfs_dir2_db_t
> -xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> -{
> -	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
> -			(db / geo->free_max_bests);
> -}
> -
> -/*
> - * Convert data space db to the corresponding index in a free db.
> - */
> -static int
> -xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> -{
> -	return db % geo->free_max_bests;
> -}
> -
> -/*
> - * Convert data space db to the corresponding free db.
> - */
> -static xfs_dir2_db_t
> -xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> -{
> -	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
> -			(db / geo->free_max_bests);
> -}
> -
> -/*
> - * Convert data space db to the corresponding index in a free db.
> - */
> -static int
> -xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> -{
> -	return db % geo->free_max_bests;
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.sf_entsize = xfs_dir2_sf_entsize,
>  	.sf_nextentry = xfs_dir2_sf_nextentry,
> @@ -467,9 +429,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_first_entry_p = xfs_dir2_data_first_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
> -
> -	.db_to_fdb = xfs_dir2_db_to_fdb,
> -	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> @@ -501,9 +460,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
> -
> -	.db_to_fdb = xfs_dir2_db_to_fdb,
> -	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> @@ -535,9 +491,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_first_entry_p = xfs_dir3_data_first_entry_p,
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
> -
> -	.db_to_fdb = xfs_dir3_db_to_fdb,
> -	.db_to_fdindex = xfs_dir3_db_to_fdindex,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index e3c1385d1522..e302679d8c80 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -71,11 +71,6 @@ struct xfs_dir_ops {
>  		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_unused *
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
> -
> -	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
> -				   xfs_dir2_db_t db);
> -	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
> -				 xfs_dir2_db_t db);
>  };
>  
>  extern const struct xfs_dir_ops *
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 0fcd7351038e..ceb5936b58dd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -33,6 +33,25 @@ static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
>  				 int index, xfs_da_state_blk_t *dblk,
>  				 int *rval);
>  
> +/*
> + * Convert data space db to the corresponding free db.
> + */
> +static xfs_dir2_db_t
> +xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> +{
> +	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
> +			(db / geo->free_max_bests);
> +}
> +
> +/*
> + * Convert data space db to the corresponding index in a free db.
> + */
> +static int
> +xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> +{
> +	return db % geo->free_max_bests;
> +}
> +
>  /*
>   * Check internal consistency of a leafn block.
>   */
> @@ -676,7 +695,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  			 * Convert the data block to the free block
>  			 * holding its freespace information.
>  			 */
> -			newfdb = dp->d_ops->db_to_fdb(args->geo, newdb);
> +			newfdb = xfs_dir2_db_to_fdb(args->geo, newdb);
>  			/*
>  			 * If it's not the one we have in hand, read it in.
>  			 */
> @@ -700,7 +719,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  			/*
>  			 * Get the index for our entry.
>  			 */
> -			fi = dp->d_ops->db_to_fdindex(args->geo, curdb);
> +			fi = xfs_dir2_db_to_fdindex(args->geo, curdb);
>  			/*
>  			 * If it has room, return it.
>  			 */
> @@ -1320,7 +1339,7 @@ xfs_dir2_leafn_remove(
>  		 * Convert the data block number to a free block,
>  		 * read in the free block.
>  		 */
> -		fdb = dp->d_ops->db_to_fdb(args->geo, db);
> +		fdb = xfs_dir2_db_to_fdb(args->geo, db);
>  		error = xfs_dir2_free_read(tp, dp,
>  					   xfs_dir2_db_to_da(args->geo, fdb),
>  					   &fbp);
> @@ -1340,7 +1359,7 @@ xfs_dir2_leafn_remove(
>  		/*
>  		 * Calculate which entry we need to fix.
>  		 */
> -		findex = dp->d_ops->db_to_fdindex(args->geo, db);
> +		findex = xfs_dir2_db_to_fdindex(args->geo, db);
>  		longest = be16_to_cpu(bf[0].length);
>  		/*
>  		 * If the data block is now empty we can get rid of it
> @@ -1683,7 +1702,7 @@ xfs_dir2_node_add_datablk(
>  	 * Get the freespace block corresponding to the data block
>  	 * that was just allocated.
>  	 */
> -	fbno = dp->d_ops->db_to_fdb(args->geo, *dbno);
> +	fbno = xfs_dir2_db_to_fdb(args->geo, *dbno);
>  	error = xfs_dir2_free_try_read(tp, dp,
>  			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
>  	if (error)
> @@ -1698,11 +1717,11 @@ xfs_dir2_node_add_datablk(
>  		if (error)
>  			return error;
>  
> -		if (dp->d_ops->db_to_fdb(args->geo, *dbno) != fbno) {
> +		if (xfs_dir2_db_to_fdb(args->geo, *dbno) != fbno) {
>  			xfs_alert(mp,
>  "%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld",
>  				__func__, (unsigned long long)dp->i_ino,
> -				(long long)dp->d_ops->db_to_fdb(args->geo, *dbno),
> +				(long long)xfs_dir2_db_to_fdb(args->geo, *dbno),
>  				(long long)*dbno, (long long)fbno);
>  			if (fblk) {
>  				xfs_alert(mp,
> @@ -1731,7 +1750,7 @@ xfs_dir2_node_add_datablk(
>  	}
>  
>  	/* Set the freespace block index from the data block number. */
> -	*findex = dp->d_ops->db_to_fdindex(args->geo, *dbno);
> +	*findex = xfs_dir2_db_to_fdindex(args->geo, *dbno);
>  
>  	/* Extend the freespace table if the new data block is off the end. */
>  	if (*findex >= hdr->nvalid) {
> -- 
> 2.20.1
> 
