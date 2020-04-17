Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16CBC38A29
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 22:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC01214D8
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 22:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CfhdeIfA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgDQWhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 18:37:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48418 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgDQWhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 18:37:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HMXiPv094028;
        Fri, 17 Apr 2020 22:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=49JIxjUksK0uJLabWn+kC2E/p0dQTp2vB/yuME3snmg=;
 b=CfhdeIfAU4ZexNKYvQKA87U/Qauvz9nJC4bJLmQmuztFXlbx3chnMJlN+V+bypopdGgL
 tMhP9+yWccrm1JNZnup43hzLU08AtXAF0N1y7AfAMoiGiA0GVX/D5m4j02cgf0XJwQlL
 04nv4p3eu8YI8Oiguzg/XTwyzyZWMzIfivx4HBKnkf23ausr28VZxuGgBSUXMpgfeKAr
 KPsLhfT18chaBwJvaVqoH5MIJvZtRUzi/xqAOPxG6hVoXhElJ6Ux0MP3AhogvI9s+h4l
 nmmJjaEK55vJ2SwqWhXlNEN+u3PzP8MwhvD5jbB8+l4eEwAuomOjMNlfGDoFJwlEWmlC PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30e0aaf1vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 22:37:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HMVxns148806;
        Fri, 17 Apr 2020 22:37:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30dyp3pd8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 22:37:09 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03HMb8n4023441;
        Fri, 17 Apr 2020 22:37:08 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 15:37:08 -0700
Subject: Re: [PATCH 02/12] xfs: factor out buffer I/O failure simulation code
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-3-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1170b146-b503-e9f7-fae4-8901356b93d6@oracle.com>
Date:   Fri, 17 Apr 2020 15:37:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=2 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/17/20 8:08 AM, Brian Foster wrote:
> We use the same buffer I/O failure simulation code in a few
> different places. It's not much code, but it's not necessarily
> self-explanatory. Factor it into a helper and document it in one
> place.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c      | 23 +++++++++++++++++++----
>   fs/xfs/xfs_buf.h      |  1 +
>   fs/xfs/xfs_buf_item.c | 22 +++-------------------
>   fs/xfs/xfs_inode.c    |  7 +------
>   4 files changed, 24 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9ec3eaf1c618..93942d8e35dd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1248,6 +1248,24 @@ xfs_buf_ioerror_alert(
>   			-bp->b_error);
>   }
>   
> +/*
> +  * To simulate an I/O failure, the buffer must be locked and held with at least
> + * three references. The LRU reference is dropped by the stale call. The buf
> + * item reference is dropped via ioend processing. The third reference is owned
> + * by the caller and is dropped on I/O completion if the buffer is XBF_ASYNC.
> + */
> +void
> +xfs_buf_iofail(
> +	struct xfs_buf	*bp,
> +	int		flags)
> +{
> +	bp->b_flags |= flags;
> +	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_stale(bp);
> +	xfs_buf_ioerror(bp, -EIO);
> +	xfs_buf_ioend(bp);
> +}
> +
>   int
>   xfs_bwrite(
>   	struct xfs_buf		*bp)
> @@ -1480,10 +1498,7 @@ __xfs_buf_submit(
>   
>   	/* on shutdown we stale and complete the buffer immediately */
>   	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
> -		xfs_buf_ioerror(bp, -EIO);
> -		bp->b_flags &= ~XBF_DONE;
> -		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
> +		xfs_buf_iofail(bp, 0);
>   		return -EIO;
>   	}
>   
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 9a04c53c2488..a6bce4702b2e 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -263,6 +263,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>   		xfs_failaddr_t failaddr);
>   #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
>   extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
> +void xfs_buf_iofail(struct xfs_buf *, int);
>   
>   extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
>   static inline int xfs_buf_submit(struct xfs_buf *bp)
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8796adde2d12..72d37a4609d8 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -471,28 +471,12 @@ xfs_buf_item_unpin(
>   		xfs_buf_relse(bp);
>   	} else if (freed && remove) {
>   		/*
> -		 * There are currently two references to the buffer - the active
> -		 * LRU reference and the buf log item. What we are about to do
> -		 * here - simulate a failed IO completion - requires 3
> -		 * references.
> -		 *
> -		 * The LRU reference is removed by the xfs_buf_stale() call. The
> -		 * buf item reference is removed by the xfs_buf_iodone()
> -		 * callback that is run by xfs_buf_do_callbacks() during ioend
> -		 * processing (via the bp->b_iodone callback), and then finally
> -		 * the ioend processing will drop the IO reference if the buffer
> -		 * is marked XBF_ASYNC.
> -		 *
> -		 * Hence we need to take an additional reference here so that IO
> -		 * completion processing doesn't free the buffer prematurely.
> +		 * The buffer must be locked and held by the caller to simulate
> +		 * an async I/O failure.
>   		 */
>   		xfs_buf_lock(bp);
>   		xfs_buf_hold(bp);
> -		bp->b_flags |= XBF_ASYNC;
> -		xfs_buf_ioerror(bp, -EIO);
> -		bp->b_flags &= ~XBF_DONE;
> -		xfs_buf_stale(bp);
> -		xfs_buf_ioend(bp);
> +		xfs_buf_iofail(bp, XBF_ASYNC);
>   	}
>   }
>   
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d1772786af29..b539ee221ce5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3629,12 +3629,7 @@ xfs_iflush_cluster(
>   	 * xfs_buf_submit().
>   	 */
>   	ASSERT(bp->b_iodone);
> -	bp->b_flags |= XBF_ASYNC;
> -	bp->b_flags &= ~XBF_DONE;
> -	xfs_buf_stale(bp);
> -	xfs_buf_ioerror(bp, -EIO);
> -	xfs_buf_ioend(bp);
> -
> +	xfs_buf_iofail(bp, XBF_ASYNC);
>   	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   
>   	/* abort the corrupt inode, as it was not attached to the buffer */
> 
