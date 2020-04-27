Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF84EC81981
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C07ED214D8
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kOAMZKtJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgD0SFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 14:05:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgD0SFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 14:05:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RI2hNS163334;
        Mon, 27 Apr 2020 18:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3LXwwXxy+AcaPk+w767jsHCo2VqTrEdRj6HQcKPRh3Q=;
 b=kOAMZKtJKb6Kff+E7+IFMnzV34mlvPgObT58x9hJ3jr9zKBLIyyw+Wl9lEup2nefy4SF
 na2I1eWpcPORhWxzkU/XMoJ4znUCF+HaV1eFiEFDVhLPhubNTTELOJ+iUpSTQmSO01vZ
 N8da9VQcODt6vy7rfGu+XhT2BFJaIn/6o+H7L28A1T1OlaLqZuC6lwftJ6timvDPxJor
 w2SMtWTmo8G5AOCcRYbBvJarxpdsFetTvqBnXeGOBEqKooJfjzLeGIe/zob2xq0IiT2z
 PPIS3B5c1sp2/8VKjVBVJjrkXexvHsHJoYcvd38pjcnnA+hc9bDt/Q/VHu6GAh4QcBMM jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucfu6rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 18:05:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RI2vOL062660;
        Mon, 27 Apr 2020 18:05:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0a5e77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 18:05:04 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RI53f6007132;
        Mon, 27 Apr 2020 18:05:03 GMT
Received: from localhost (/10.159.145.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 11:05:03 -0700
Date:   Mon, 27 Apr 2020 11:05:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: rename inode_list xlog_recover_reorder_trans
Message-ID: <20200427180502.GV6742@magnolia>
References: <20200427135229.1480993-1-hch@lst.de>
 <20200427135229.1480993-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135229.1480993-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 03:52:29PM +0200, Christoph Hellwig wrote:
> This list contains pretty much everything that is not a buffer.  The
> comment calls it item_list, which is a much better name than inode
> list, so switch the actual variable name to that as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM, who doesn't know where the "inode_list" name came from... :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 750a81b941ea4..33cac61570abe 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1847,7 +1847,7 @@ xlog_recover_reorder_trans(
>  	LIST_HEAD(cancel_list);
>  	LIST_HEAD(buffer_list);
>  	LIST_HEAD(inode_buffer_list);
> -	LIST_HEAD(inode_list);
> +	LIST_HEAD(item_list);
>  
>  	list_splice_init(&trans->r_itemq, &sort_list);
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
> @@ -1883,7 +1883,7 @@ xlog_recover_reorder_trans(
>  		case XFS_LI_BUD:
>  			trace_xfs_log_recover_item_reorder_tail(log,
>  							trans, item, pass);
> -			list_move_tail(&item->ri_list, &inode_list);
> +			list_move_tail(&item->ri_list, &item_list);
>  			break;
>  		default:
>  			xfs_warn(log->l_mp,
> @@ -1904,8 +1904,8 @@ xlog_recover_reorder_trans(
>  	ASSERT(list_empty(&sort_list));
>  	if (!list_empty(&buffer_list))
>  		list_splice(&buffer_list, &trans->r_itemq);
> -	if (!list_empty(&inode_list))
> -		list_splice_tail(&inode_list, &trans->r_itemq);
> +	if (!list_empty(&item_list))
> +		list_splice_tail(&item_list, &trans->r_itemq);
>  	if (!list_empty(&inode_buffer_list))
>  		list_splice_tail(&inode_buffer_list, &trans->r_itemq);
>  	if (!list_empty(&cancel_list))
> -- 
> 2.26.1
> 
