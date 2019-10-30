Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27B4CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 19:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F112080F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 19:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ee+QZNbU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJ3T2k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 15:28:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfJ3T2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 15:28:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UJSYer062104;
        Wed, 30 Oct 2019 19:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iwKMsvRqseX4TFVqNyGidJBqb6NJRPL2upmqDNe4K3w=;
 b=ee+QZNbUJMWjB8XEAluKadgjTh115yk02m5mr5DM5T9lRPD8ywSFnYDBM23DjvNDhvDr
 37DicUofCGXCRLAG/6HjcXEu5s6b9C6xJsmlTE/hJW0aY//BIXsALG+OasVAu4dSpKV3
 OXjfwEwoI/P0E/9GQIDV0HRmAJhZ2T68G7GUXgBWWS7dHUUAJKKriA66O8HLQun/efio
 xWYsva+/OWqx0/E45D6nSrmX+nrd3cW0NNSwUqc/HpEjtfD4L30RQounL+Vi/N1nBWFq
 92uRKA5Hd8o7xIc1qsCjJI9TZOyiRkHUjw6v7o/MVGdUG8FXkOICK6jYIHgWa6g3s5z/ VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vxwhfpgqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 19:28:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UJORFl073476;
        Wed, 30 Oct 2019 19:26:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vxwhwnr1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 19:26:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9UJQWTA005992;
        Wed, 30 Oct 2019 19:26:32 GMT
Received: from localhost (/10.145.178.60)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 12:26:31 -0700
Date:   Wed, 30 Oct 2019 12:26:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: slightly tweak an assert in xfs_fs_map_blocks
Message-ID: <20191030192631.GR15222@magnolia>
References: <20191030180419.13045-1-hch@lst.de>
 <20191030180419.13045-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030180419.13045-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 11:04:14AM -0700, Christoph Hellwig wrote:
> We should never see delalloc blocks for a pNFS layout, write or not.
> Adjust the assert to check for that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_pnfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index c637f0192976..3634ffff3b07 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -148,11 +148,11 @@ xfs_fs_map_blocks(
>  	if (error)
>  		goto out_unlock;
>  
> +	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
> +
>  	if (write) {
>  		enum xfs_prealloc_flags	flags = 0;
>  
> -		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> -
>  		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
>  			/*
>  			 * xfs_iomap_write_direct() expects to take ownership of
> -- 
> 2.20.1
> 
