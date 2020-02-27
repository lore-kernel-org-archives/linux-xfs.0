Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2DFC3F2C6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97669246A4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cNKWya0V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgB0Xdc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 18:33:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbgB0Xdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 18:33:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNSapN104486;
        Thu, 27 Feb 2020 23:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=N+z/KfsBR6xlCh0eayXY5gW+IOAhtOALQffQ5ZSfCxI=;
 b=cNKWya0VoA98YKKKbp/CWvep1HhIXdLQxsa40+TXqNMEEwginnVjZ+zHgozQnWyXEHWN
 tCQB3GIWizr1dF12QgGHh47gDfyVbWInWSTZD7KZxfkzHFFmDoGBJ00t15FZj7agWe8X
 3eNuAMS26zOWq9pKV6e4JVhCWSMjfQ/ZFDb0H51g1wsZw4DMXYG+oh1auJ4L/vHniZ17
 zv7OvN0OuU7ezPr50FcgZUsIKvofwcfFqYMEuOl0WAp/8UQHp8azPQ1vKPuuh1Qait3J
 vhWlSvwKKOsRX7qPVgBYYC/AkxyL8JgZqKnc0Qt8ZlxXwd7UbcF0WQpQtVmAoB2GPKSy 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yehxrssug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:33:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNW9gI178692;
        Thu, 27 Feb 2020 23:33:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ydj4nwsx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:33:27 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RNXQW8027508;
        Thu, 27 Feb 2020 23:33:27 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 15:33:26 -0800
Subject: Re: [RFC v5 PATCH 7/9] xfs: buffer relogging support prototype
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-8-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <12e69f70-13e6-830c-83ef-9ad5b222301e@oracle.com>
Date:   Thu, 27 Feb 2020 16:33:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-8-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/27/20 6:43 AM, Brian Foster wrote:
> Add a quick and dirty implementation of buffer relogging support.
> There is currently no use case for buffer relogging. This is for
> experimental use only and serves as an example to demonstrate the
> ability to relog arbitrary items in the future, if necessary.
> 
> Add a hook to enable relogging a buffer in a transaction, update the
> buffer log item handlers to support relogged BLIs and update the
> relog handler to join the relogged buffer to the relog transaction.
> 
Alrighty, thanks for the example!  It sounds like it's meant more to be 
a demo than to really be applied though?

Allison

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_buf_item.c  |  5 +++++
>   fs/xfs/xfs_trans.h     |  1 +
>   fs/xfs/xfs_trans_ail.c | 19 ++++++++++++++++---
>   fs/xfs/xfs_trans_buf.c | 22 ++++++++++++++++++++++
>   4 files changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 663810e6cd59..4ef2725fa8ce 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -463,6 +463,7 @@ xfs_buf_item_unpin(
>   			list_del_init(&bp->b_li_list);
>   			bp->b_iodone = NULL;
>   		} else {
> +			xfs_trans_relog_item_cancel(lip, false);
>   			spin_lock(&ailp->ail_lock);
>   			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
>   			xfs_buf_item_relse(bp);
> @@ -528,6 +529,9 @@ xfs_buf_item_push(
>   		return XFS_ITEM_LOCKED;
>   	}
>   
> +	if (test_bit(XFS_LI_RELOG, &lip->li_flags))
> +		return XFS_ITEM_RELOG;
> +
>   	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
>   
>   	trace_xfs_buf_item_push(bip);
> @@ -956,6 +960,7 @@ STATIC void
>   xfs_buf_item_free(
>   	struct xfs_buf_log_item	*bip)
>   {
> +	ASSERT(!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags));
>   	xfs_buf_item_free_format(bip);
>   	kmem_free(bip->bli_item.li_lv_shadow);
>   	kmem_cache_free(xfs_buf_item_zone, bip);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 1637df32c64c..81cb42f552d9 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -226,6 +226,7 @@ void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
>   void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
>   bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
>   void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
> +bool		xfs_trans_relog_buf(struct xfs_trans *, struct xfs_buf *);
>   void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
>   void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
>   void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 71a47faeaae8..103ab62e61be 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -18,6 +18,7 @@
>   #include "xfs_error.h"
>   #include "xfs_log.h"
>   #include "xfs_log_priv.h"
> +#include "xfs_buf_item.h"
>   
>   #ifdef DEBUG
>   /*
> @@ -187,9 +188,21 @@ xfs_ail_relog(
>   			xfs_log_ticket_put(ailp->ail_relog_tic);
>   		spin_unlock(&ailp->ail_lock);
>   
> -		xfs_trans_add_item(tp, lip);
> -		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> -		tp->t_flags |= XFS_TRANS_DIRTY;
> +		/*
> +		 * TODO: Ideally, relog transaction management would be pushed
> +		 * down into the ->iop_push() callbacks rather than playing
> +		 * games with ->li_trans and looking at log item types here.
> +		 */
> +		if (lip->li_type == XFS_LI_BUF) {
> +			struct xfs_buf_log_item	*bli = (struct xfs_buf_log_item *) lip;
> +			xfs_buf_hold(bli->bli_buf);
> +			xfs_trans_bjoin(tp, bli->bli_buf);
> +			xfs_trans_dirty_buf(tp, bli->bli_buf);
> +		} else {
> +			xfs_trans_add_item(tp, lip);
> +			set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +			tp->t_flags |= XFS_TRANS_DIRTY;
> +		}
>   		/* XXX: include ticket owner task fix */
>   		error = xfs_trans_roll(&tp);
>   		ASSERT(!error);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 08174ffa2118..e17715ac23fc 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -787,3 +787,25 @@ xfs_trans_dquot_buf(
>   
>   	xfs_trans_buf_set_type(tp, bp, type);
>   }
> +
> +/*
> + * Enable automatic relogging on a buffer. This essentially pins a dirty buffer
> + * in-core until relogging is disabled. Note that the buffer must not already be
> + * queued for writeback.
> + */
> +bool
> +xfs_trans_relog_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +
> +	ASSERT(tp->t_flags & XFS_TRANS_RELOG);
> +	ASSERT(xfs_buf_islocked(bp));
> +
> +	if (bp->b_flags & _XBF_DELWRI_Q)
> +		return false;
> +
> +	xfs_trans_relog_item(&bip->bli_item);
> +	return true;
> +}
> 
