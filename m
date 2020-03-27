Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B84CC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F78D20658
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Em47dtt1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgC0PlV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 11:41:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0PlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 11:41:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RFeWQq012703;
        Fri, 27 Mar 2020 15:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DPJmn0fzLoSH2G6oC49lqvF9Psl2H3tgoC+by28F9Us=;
 b=Em47dtt1sjys1mCWPCSgLzLqedBfq9z7sDeBTx2EEmjRVOXObBTMLH/ubSLwK+beHlo8
 a7VjVmbUX6jWU7UIUWO/NHaCAC1ncUW1RgEGuAYwMKkd05yMv1CwLvb+mN2zG9q+dF0t
 xJxHJnGj3zzJk645L40dN8uX4kUnZfcILdFItZ5tPT3Jr0lhTck4MXFy6Kn9s90TaXxg
 /Vd7lqpR11/fwCo6PGXyjoiQ+01BXYslMi2ATFwI+KZEJkThAxi5aandaUj8LKxuPtEl
 CEVzkJfKSUlIYbFPXSab8eTndpfijZg293ugW+YrrdOmXf7gz4Oi6lzqTHx9RVV8pMhh Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3019veayd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:41:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RFcaGd046226;
        Fri, 27 Mar 2020 15:39:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yxw4w366v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:39:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02RFdGRU014757;
        Fri, 27 Mar 2020 15:39:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 08:39:16 -0700
Date:   Fri, 27 Mar 2020 08:39:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: return locked status of inode buffer on xfsaild
 push
Message-ID: <20200327153913.GI29339@magnolia>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326131703.23246-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=940 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 09:17:03AM -0400, Brian Foster wrote:
> If the inode buffer backing a particular inode is locked,
> xfs_iflush() returns -EAGAIN and xfs_inode_item_push() skips the
> inode. It still returns success to xfsaild, however, which bypasses
> the xfsaild backoff heuristic. Update xfs_inode_item_push() to
> return locked status if the inode buffer couldn't be locked.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems pretty straightforward,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode_item.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4a3d13d4a022..9a903babbcf7 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -552,7 +552,8 @@ xfs_inode_item_push(
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  		xfs_buf_relse(bp);
> -	}
> +	} else if (error == -EAGAIN)
> +		rval = XFS_ITEM_LOCKED;
>  
>  	spin_lock(&lip->li_ailp->ail_lock);
>  out_unlock:
> -- 
> 2.21.1
> 
