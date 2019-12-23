Return-Path: <SRS0=dkq6=2N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337E9C2D0C0
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 17:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B731206CB
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Dec 2019 17:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="avwAUEIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfLWRdE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Dec 2019 12:33:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfLWRdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Dec 2019 12:33:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNHTJRt123688;
        Mon, 23 Dec 2019 17:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mBca1zVE0VDEUNqftwnudKS23v0qr3Kl/0tRP1JYpWc=;
 b=avwAUEIX6WXd9SRbYl99yUJ/jnbfsWzqYNPA3skmYaY+rov6+3JemKbBaGdCSwt2wu5c
 IZe34ZLSkK2ipR52Jt5FWhD8wnLXHJUADyu2Mi69mb1PeR2lxlr9Q64/86h/lBFGO3LG
 e4SG+ENFCmjgpXPkMKGGUX9RRmpOPxILisLwjLRRQA8dPDrmn8Z49PC7xEhUQ0aA0sD0
 kp8ipQda/IW4CtMCRCnqCSO6mb6ssgjbiDvdtUjH8P/QpnvzbZmsGtajBIjzOH4THJj9
 SPXm3cZTlDnYpWW5mPtWd3gqeqoI5vRB9+/h0PsDYvxU6d3SytCFdNJdVCldxDIM4BR/ oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x1attg1mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 17:32:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNHTAlT134844;
        Mon, 23 Dec 2019 17:32:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x1vwwnmdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 17:32:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBNHWlSw001181;
        Mon, 23 Dec 2019 17:32:47 GMT
Received: from localhost (/10.159.131.244)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Dec 2019 09:32:46 -0800
Date:   Mon, 23 Dec 2019 09:32:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: change return value of xfs_inode_need_cow to int
Message-ID: <20191223173246.GU7489@magnolia>
References: <1577087776-59093-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577087776-59093-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912230148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912230149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 23, 2019 at 03:56:16PM +0800, zhengbin wrote:
> Fixes coccicheck warning:
> 
> fs/xfs/xfs_reflink.c:236:9-10: WARNING: return of 0/1 in function 'xfs_inode_need_cow' with return type bool
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  fs/xfs/xfs_reflink.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index de45123..21eeb94 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -223,7 +223,7 @@ xfs_reflink_trim_around_shared(
>  	}
>  }
> 
> -bool
> +int
>  xfs_inode_need_cow(

I started to think "just fix this predicate so it doesn't return 1--"

But then I realized that this is /not/ an inode predicate, it's a
reflink trim wrapper for block mappings.  "xfs_bmap_trim_cow" is a
somewhat better name, so I'll commit this with a name change.

And yeah, we turned negative errno into bool and back to int.  Wow.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index d18ad7f..9a288b2 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -22,7 +22,7 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared);
> -bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> +int xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
>  		bool *shared);
> 
>  int xfs_reflink_allocate_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> --
> 2.7.4
> 
