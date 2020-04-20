Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9867FC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 19:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 799EB2074F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 19:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PADZkL7B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgDTTTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:19:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgDTTTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 15:19:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KJJ3sk001670;
        Mon, 20 Apr 2020 19:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VjJbSJBloohbqfLOaQDrgp0oNo77/IxLY5FKBvFtyow=;
 b=PADZkL7Bk1ekX/UPgu/vqSN/w5OAELldjQV9vP96ZQDutLtOv6eKb8viJ4btoCzaAi6c
 iV3QN8xK64xuCPSxMT9tDPVxVih1bOM5+sJJd6Gkc21nXsIkS3Cxke+q6Y++7imSyr1u
 Ehtp4K0JQVQz9ok/mNUmY2RGW5xENaSEHdZjZU++BdzTKKM1Yt4KYqy2+7uHnVV/1xZa
 5cmdfzZlvFsEe1jdJvttV64T6olD2/obwdEl4SlLKchEAzQVYMFV4Id3o+HByN5uczjA
 B+0pzf6+rFtzVjiXPmkIDJynmnd6rzwZHwU84q560uNHeNOZpuURELY8PydcKzPiqHst Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30fsgks7qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 19:19:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KJGQYX065372;
        Mon, 20 Apr 2020 19:19:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30gbbbdqr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 19:19:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KJJmWr019889;
        Mon, 20 Apr 2020 19:19:48 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 12:19:48 -0700
Subject: Re: [PATCH 11/12] xfs: remove unused iflush stale parameter
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-12-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d3dd4f3c-d4b4-8ca6-2d49-b034d7383fc7@oracle.com>
Date:   Mon, 20 Apr 2020 12:19:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-12-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/17/20 8:08 AM, Brian Foster wrote:
> The stale parameter was used to control the now unused shutdown
> parameter of xfs_trans_ail_remove().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_icache.c     | 2 +-
>   fs/xfs/xfs_inode.c      | 2 +-
>   fs/xfs/xfs_inode_item.c | 7 +++----
>   fs/xfs/xfs_inode_item.h | 2 +-
>   4 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a7be7a9e5c1a..9088716465e7 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1118,7 +1118,7 @@ xfs_reclaim_inode(
>   	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>   		xfs_iunpin_wait(ip);
>   		/* xfs_iflush_abort() drops the flush lock */
> -		xfs_iflush_abort(ip, false);
> +		xfs_iflush_abort(ip);
>   		goto reclaim;
>   	}
>   	if (xfs_ipincount(ip)) {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 98ee1b10d1b0..502ffe857b12 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3701,7 +3701,7 @@ xfs_iflush(
>   	return 0;
>   
>   abort:
> -	xfs_iflush_abort(ip, false);
> +	xfs_iflush_abort(ip);
>   shutdown:
>   	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   	return error;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f8dd9bb8c851..b8cbd0c61ce0 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -757,10 +757,9 @@ xfs_iflush_done(
>    */
>   void
>   xfs_iflush_abort(
> -	xfs_inode_t		*ip,
> -	bool			stale)
> +	struct xfs_inode		*ip)
>   {
> -	xfs_inode_log_item_t	*iip = ip->i_itemp;
> +	struct xfs_inode_log_item	*iip = ip->i_itemp;
>   
>   	if (iip) {
>   		xfs_trans_ail_remove(&iip->ili_item);
> @@ -788,7 +787,7 @@ xfs_istale_done(
>   	struct xfs_buf		*bp,
>   	struct xfs_log_item	*lip)
>   {
> -	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode, true);
> +	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode);
>   }
>   
>   /*
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 07a60e74c39c..a68c114b79a0 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -34,7 +34,7 @@ extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>   extern void xfs_inode_item_destroy(struct xfs_inode *);
>   extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
>   extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
> -extern void xfs_iflush_abort(struct xfs_inode *, bool);
> +extern void xfs_iflush_abort(struct xfs_inode *);
>   extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>   					 struct xfs_inode_log_format *);
>   
> 
