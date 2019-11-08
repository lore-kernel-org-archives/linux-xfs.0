Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F4AFC6197
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7922B207FA
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HNayugLR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbfKHVRl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:17:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47470 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHVRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:17:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8L96KQ191227
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Xu7fBa/yQTldtkEmGGQJZtLzuxsMAr1P4+jLN4tpZGA=;
 b=HNayugLRGofLtNtFJhU9SYrWrZ/9V4JhZRLQkZBnGJ0FlPxtKa/+F0L2fiYYhwtUyeOe
 hVhpa2Yg1eDCTNKy/cPaHfvZUAKK9tuGmSW7OYwbHt7UyHStni0kPKcp/k/BwX4lpAoy
 1mJ8D1mVQOO0tJgZT7gygdfdl3i07qmghGpk83iyr5Vcwvc/jAvxRlYt/7LKzLND0scw
 5desCrSn/N4ev6ASVP1RFHcFAxdmRs8UjHJc6/adn+Dc7tRX2QUtq4RZ12n0osjWGais
 aGRK6wjk8OPEKE6VB3KYmszg8w0UEXMwrrbhPGTZ0I2DkviqZu5hotwBT8zd6EwzwnfI +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w1ft42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:17:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8L91Ux194344
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:17:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w4k34cdww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:17:38 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8LHbGd019669
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:17:37 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:17:22 -0800
Date:   Fri, 8 Nov 2019 13:17:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 11/17] xfs: Add xfs_attr3_leaf helper functions
Message-ID: <20191108211721.GB6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-12-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:55PM -0700, Allison Collins wrote:
> And new helper functions xfs_attr3_leaf_flag_is_set and
> xfs_attr3_leaf_flagsflipped.  These routines check to see
> if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
> already been run.  We will need this later for delayed
> attributes since routines may be recalled several times
> when -EAGAIN is returned.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 94 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 +
>  2 files changed, 96 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 42c037e..023c616 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2809,6 +2809,40 @@ xfs_attr3_leaf_clearflag(
>  }
>  
>  /*
> + * Check if the INCOMPLETE flag on an entry in a leaf block is set.  This
> + * function can be used to check if xfs_attr3_leaf_setflag has already been
> + * called.  The INCOMPLETE flag is used during attr rename operations to mark
> + * entries that are being renamed. Since renames should be atomic, only one of

It's also used when creating an xattr with a value stored in a remote
block so that we can commit the name entry to the log (with INCOMPLETE
set), allocate/write the remote value with ordered buffers, and then
commit a second transaction clearing the INCOMPLETE flag.

Now that I think about it ... this predicate is for non-rename setting
of attrs with remote values, and the "flagsflipped" predicate is for
rename operations, aren't they?

> + * them should appear as a completed attribute.
> + *
> + * isset is set to true if the flag is set or false otherwise
> + */
> +int
> +xfs_attr3_leaf_flag_is_set(
> +	struct xfs_da_args		*args,
> +	bool				*isset)
> +{
> +	struct xfs_attr_leafblock	*leaf;
> +	struct xfs_attr_leaf_entry	*entry;
> +	struct xfs_buf			*bp;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno,
> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
> +	if (error)
> +		return error;
> +
> +	leaf = bp->b_addr;
> +	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
> +
> +	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
> +	xfs_trans_brelse(args->trans, bp);
> +
> +	return 0;
> +}
> +
> +/*
>   * Set the INCOMPLETE flag on an entry in a leaf block.
>   */
>  int
> @@ -2972,3 +3006,63 @@ xfs_attr3_leaf_flipflags(
>  
>  	return error;
>  }
> +
> +/*
> + * On a leaf entry, check to see if the INCOMPLETE flag is cleared
> + * in args->blkno/index and set in args->blkno2/index2.

Might be worth mentioning here that args->blkno is the old entry and
args->blkno2 is the new entry.  This predicate will be used (by the
deferred attr item recovery code) to decide if we have to finish that
part of a rename operation, right?

>  Note that they could be
> + * in different blocks, or in the same block.  This function can be used to
> + * check if xfs_attr3_leaf_flipflags has already been called.  The INCOMPLETE
> + * flag is used during attr rename operations to mark entries that are being
> + * renamed. Since renames should be atomic, only one of them should appear as a
> + * completed attribute.
> + *
> + * isflipped is set to true if flags are flipped or false otherwise
> + */
> +int
> +xfs_attr3_leaf_flagsflipped(

I don't like "flagsflipped" because it's not clear to me what "flipped"
means.

xfs_attr3_leaf_rename_is_incomplete() ?

> +	struct xfs_da_args		*args,
> +	bool				*isflipped)
> +{
> +	struct xfs_attr_leafblock	*leaf1;
> +	struct xfs_attr_leafblock	*leaf2;
> +	struct xfs_attr_leaf_entry	*entry1;
> +	struct xfs_attr_leaf_entry	*entry2;
> +	struct xfs_buf			*bp1;
> +	struct xfs_buf			*bp2;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	/*
> +	 * Read the block containing the "old" attr
> +	 */
> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno,
> +				    XFS_DABUF_MAP_NOMAPPING, &bp1);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Read the block containing the "new" attr, if it is different
> +	 */
> +	if (args->blkno2 != args->blkno) {
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
> +					   -1, &bp2);
> +		if (error)

bp1 leaks here, I think.

> +			return error;
> +	} else {
> +		bp2 = bp1;
> +	}
> +
> +	leaf1 = bp1->b_addr;
> +	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
> +
> +	leaf2 = bp2->b_addr;
> +	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
> +
> +	*isflipped = (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&

Nit: ((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) could be written as
!(entry1->flags & XFS_ATTR_INCOMPLETE)

> +		      (entry2->flags & XFS_ATTR_INCOMPLETE));
> +
> +	xfs_trans_brelse(args->trans, bp1);
> +	xfs_trans_brelse(args->trans, bp2);

This double-frees bp2 if bp1 == bp2.

--D


> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index e108b37..12283cf 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -57,7 +57,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
>  				   struct xfs_da_args *args, int forkoff);
>  int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args, bool *isset);
>  int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args, bool *isflipped);
>  
>  /*
>   * Routines used for growing the Btree.
> -- 
> 2.7.4
> 
