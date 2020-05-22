Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B89C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 21:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ADAE20757
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 21:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aonD63+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgEVVP7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 17:15:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54380 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730976AbgEVVP7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 17:15:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLCLQp118940;
        Fri, 22 May 2020 21:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/N0Eqvsb9xekBqe+a3Et1NPOZRRjregnwRVQY3GEifE=;
 b=aonD63+KqKPRKhFNAVWlLwxQhqyrxiJDQHmmZiX9s2XVAt0E3jfwAcaECM8td/6K1+Js
 xBK1dcO5oFGCc3kzHv6O+uHyBQDPuLk0XNcIAGSHPFMJAJalnvSBS2mS/h97bQdHxPwd
 w0cAqXJLDJSJmq7etkUrzRjfsU1t/o7M3tbp+NdK0M+kBCqCM1T5yto3TkWrPn+jazRU
 7XwDDO268vXRjWE8AwZp+H+y4ImGk1tIQhAKf71LL5nh5MxTHFiN1T2MqQb4Fz49O1CO
 3ZLiX6ZTvOZZ/H3MocON72ml/CSV0LBFR7FgWa4+TC7S7Z73S0FNfmRGkwFyHWQFWbpR VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31501rpb6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 21:15:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLDJE9071302;
        Fri, 22 May 2020 21:13:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31502506ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 21:13:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MLDuJ2028604;
        Fri, 22 May 2020 21:13:56 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 14:13:55 -0700
Date:   Fri, 22 May 2020 14:13:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/24] xfs: remove logged flag from inode log item
Message-ID: <20200522211354.GE8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This was used to track if the item had logged fields being flushed
> to disk. We log everything in the inode these days, so this logic is
> no longer needed. Remove it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

AFAICT the only dinode field that isn't tracked through the inode item
is di_next_unlinked, which has always been applied separately (via the
inode cluster buffer).

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c      | 13 ++++---------
>  fs/xfs/xfs_inode_item.c | 35 ++++++++++-------------------------
>  fs/xfs/xfs_inode_item.h |  1 -
>  3 files changed, 14 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 64f5f9a440aed..ca9f2688b745d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2658,7 +2658,6 @@ xfs_ifree_cluster(
>  		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>  			if (lip->li_type == XFS_LI_INODE) {
>  				iip = (struct xfs_inode_log_item *)lip;
> -				ASSERT(iip->ili_logged == 1);
>  				lip->li_cb = xfs_istale_done;
>  				xfs_trans_ail_copy_lsn(mp->m_ail,
>  							&iip->ili_flush_lsn,
> @@ -2687,7 +2686,6 @@ xfs_ifree_cluster(
>  			iip->ili_last_fields = iip->ili_fields;
>  			iip->ili_fields = 0;
>  			iip->ili_fsync_fields = 0;
> -			iip->ili_logged = 1;
>  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  						&iip->ili_item.li_lsn);
>  
> @@ -3819,19 +3817,16 @@ xfs_iflush_int(
>  	 *
>  	 * We can play with the ili_fields bits here, because the inode lock
>  	 * must be held exclusively in order to set bits there and the flush
> -	 * lock protects the ili_last_fields bits.  Set ili_logged so the flush
> -	 * done routine can tell whether or not to look in the AIL.  Also, store
> -	 * the current LSN of the inode so that we can tell whether the item has
> -	 * moved in the AIL from xfs_iflush_done().  In order to read the lsn we
> -	 * need the AIL lock, because it is a 64 bit value that cannot be read
> -	 * atomically.
> +	 * lock protects the ili_last_fields bits.  Store the current LSN of the
> +	 * inode so that we can tell whether the item has moved in the AIL from
> +	 * xfs_iflush_done().  In order to read the lsn we need the AIL lock,
> +	 * because it is a 64 bit value that cannot be read atomically.
>  	 */
>  	error = 0;
>  flush_out:
>  	iip->ili_last_fields = iip->ili_fields;
>  	iip->ili_fields = 0;
>  	iip->ili_fsync_fields = 0;
> -	iip->ili_logged = 1;
>  
>  	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  				&iip->ili_item.li_lsn);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ba47bf65b772b..b17384aa8df40 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -528,8 +528,6 @@ xfs_inode_item_push(
>  	}
>  
>  	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> -	ASSERT(iip->ili_logged == 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> -
>  	spin_unlock(&lip->li_ailp->ail_lock);
>  
>  	error = xfs_iflush(ip, &bp);
> @@ -690,30 +688,24 @@ xfs_iflush_done(
>  			continue;
>  
>  		list_move_tail(&blip->li_bio_list, &tmp);
> -		/*
> -		 * while we have the item, do the unlocked check for needing
> -		 * the AIL lock.
> -		 */
> +
> +		/* Do an unlocked check for needing the AIL lock. */
>  		iip = INODE_ITEM(blip);
> -		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> +		if (blip->li_lsn == iip->ili_flush_lsn ||
>  		    test_bit(XFS_LI_FAILED, &blip->li_flags))
>  			need_ail++;
>  	}
>  
>  	/* make sure we capture the state of the initial inode. */
>  	iip = INODE_ITEM(lip);
> -	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
> +	if (lip->li_lsn == iip->ili_flush_lsn ||
>  	    test_bit(XFS_LI_FAILED, &lip->li_flags))
>  		need_ail++;
>  
>  	/*
> -	 * We only want to pull the item from the AIL if it is
> -	 * actually there and its location in the log has not
> -	 * changed since we started the flush.  Thus, we only bother
> -	 * if the ili_logged flag is set and the inode's lsn has not
> -	 * changed.  First we check the lsn outside
> -	 * the lock since it's cheaper, and then we recheck while
> -	 * holding the lock before removing the inode from the AIL.
> +	 * We only want to pull the item from the AIL if it is actually there
> +	 * and its location in the log has not changed since we started the
> +	 * flush.  Thus, we only bother if the inode's lsn has not changed.
>  	 */
>  	if (need_ail) {
>  		xfs_lsn_t	tail_lsn = 0;
> @@ -721,8 +713,7 @@ xfs_iflush_done(
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(blip, &tmp, li_bio_list) {
> -			if (INODE_ITEM(blip)->ili_logged &&
> -			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
> +			if (blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
>  				/*
>  				 * xfs_ail_update_finish() only cares about the
>  				 * lsn of the first tail item removed, any
> @@ -740,14 +731,13 @@ xfs_iflush_done(
>  	}
>  
>  	/*
> -	 * clean up and unlock the flush lock now we are done. We can clear the
> +	 * Clean up and unlock the flush lock now we are done. We can clear the
>  	 * ili_last_fields bits now that we know that the data corresponding to
>  	 * them is safely on disk.
>  	 */
>  	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
>  		list_del_init(&blip->li_bio_list);
>  		iip = INODE_ITEM(blip);
> -		iip->ili_logged = 0;
>  		iip->ili_last_fields = 0;
>  		xfs_ifunlock(iip->ili_inode);
>  	}
> @@ -768,16 +758,11 @@ xfs_iflush_abort(
>  
>  	if (iip) {
>  		xfs_trans_ail_delete(&iip->ili_item, 0);
> -		iip->ili_logged = 0;
> -		/*
> -		 * Clear the ili_last_fields bits now that we know that the
> -		 * data corresponding to them is safely on disk.
> -		 */
> -		iip->ili_last_fields = 0;
>  		/*
>  		 * Clear the inode logging fields so no more flushes are
>  		 * attempted.
>  		 */
> +		iip->ili_last_fields = 0;
>  		iip->ili_fields = 0;
>  		iip->ili_fsync_fields = 0;
>  	}
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 60b34bb66e8ed..4de5070e07655 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -19,7 +19,6 @@ struct xfs_inode_log_item {
>  	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
>  	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
>  	unsigned short		ili_lock_flags;	   /* lock flags */
> -	unsigned short		ili_logged;	   /* flushed logged data */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
>  	unsigned int		ili_fsync_fields;  /* logged since last fsync */
> -- 
> 2.26.2.761.g0e0b3e54be
> 
