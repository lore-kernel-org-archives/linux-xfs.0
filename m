Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AE4C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 558192078B
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aR5yVRn6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgC0Pq7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 11:46:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbgC0Pq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 11:46:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RFhJlb037343;
        Fri, 27 Mar 2020 15:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JowM6eLik9VMWJheXYPkMCgmY1LpFTvWcjfQc9uy9qY=;
 b=aR5yVRn6MZ5CSllx9PwrnEPIjPWDeEWQen28vkKRkA6nbyHBasczhex5J88nTU1lP+nk
 8S7mGnRWGDRqcGsgZrvKRh+qxZOPLWNw5mMF2B5W8mekzy+J8yuhKU0rAaUneyWUX/ff
 Q6BA/qpueC0NecrKU86YTi4H8d1aSF8OxDiC6Mi7J9xH59M3XIzIdaCwH3EdesPb8n9s
 wWN3RoYKVBcHNJoDLP9xa6X5BOYF/5QPKpVPCAXvk8ZAzJvRmMTbkXgZr5b9rvNAy3JL
 ceOk3JmJ7lj3nm6bKx+gI28zMOcbV1uFU2svt4NihItL+aAE5i8A3RrH9wgYrF0x6FnI Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 301459bvdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:45:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RFfkxH054160;
        Fri, 27 Mar 2020 15:45:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3003gp68qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:45:54 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02RFjrec018168;
        Fri, 27 Mar 2020 15:45:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 08:45:53 -0700
Date:   Fri, 27 Mar 2020 08:45:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove unnecessary judgment from xfs_create
Message-ID: <20200327154551.GK29339@magnolia>
References: <1585287956-2808-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585287956-2808-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=1 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 01:45:56PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since the "no-allocation" reservations for file creations has
> been removed, the resblks value should be larger than zero, so
> remove unnecessary judgment.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Seems reasonable, will test all this...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6..e41bddf 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1219,8 +1219,7 @@
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> -				   resblks ?
> -					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
> +					resblks - XFS_IALLOC_SPACE_RES(mp));
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
>  		goto out_trans_cancel;
> -- 
> 1.8.3.1
> 
