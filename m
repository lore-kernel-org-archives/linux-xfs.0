Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6148C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 20:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDE52065F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 20:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ib1tg/4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgENUwQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 16:52:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39036 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgENUwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 16:52:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EKpeth014037;
        Thu, 14 May 2020 20:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=J20eIaiqaKzkLjQlxIt2M5ZQDhpTH586Yv5yBL/ud+8=;
 b=Ib1tg/4W0Y3I+q+0x4G2For0AfCwCKRnj4gJNxGs6MCCKB7MfO3c6Vqfy13A9Ssy7kOS
 dgHrFoOXQa2TERW8ZmOE7R2uiXUDgZsGXj3gIFjG2sHbiS6QpBkDdCRjfuk++V9xlunF
 QkSRUQ0kqiiQyzbOOTV8M2WbNE0rmZSvw7XtVtJDObmCu+hUlk1f7PGogqwKRPgBUXjY
 swjbWkalOs2apmruQZYxFKPYTPQ3ck9ybVWBhyRWattWc0G2GnuuNeXEmuVcvCk2tzOH
 U6xx55O/j8FS+7r77l2vVE3yLfly9ND9m/UlxZ/uGYKGCQpQxB78REcj0ZdFAnJIJa+U DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xwn3b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 20:52:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EKm7h9056292;
        Thu, 14 May 2020 20:52:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100yhh4yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 20:52:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EKqBmI025860;
        Thu, 14 May 2020 20:52:11 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 13:52:11 -0700
Date:   Thu, 14 May 2020 13:52:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't fail verifier on empty attr3 leaf block
Message-ID: <20200514205210.GJ6714@magnolia>
References: <20200513145343.45855-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513145343.45855-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 10:53:43AM -0400, Brian Foster wrote:
> The attr fork can transition from shortform to leaf format while
> empty if the first xattr doesn't fit in shortform. While this empty
> leaf block state is intended to be transient, it is technically not
> due to the transactional implementation of the xattr set operation.
> 
> We historically have a couple of bandaids to work around this
> problem. The first is to hold the buffer after the format conversion
> to prevent premature writeback of the empty leaf buffer and the
> second is to bypass the xattr count check in the verifier during
> recovery. The latter assumes that the xattr set is also in the log
> and will be recovered into the buffer soon after the empty leaf
> buffer is reconstructed. This is not guaranteed, however.
> 
> If the filesystem crashes after the format conversion but before the
> xattr set that induced it, only the format conversion may exist in
> the log. When recovered, this creates a latent corrupted state on
> the inode as any subsequent attempts to read the buffer fail due to
> verifier failure. This includes further attempts to set xattrs on
> the inode or attempts to destroy the attr fork, which prevents the
> inode from ever being removed from the unlinked list.
> 
> To avoid this condition, accept that an empty attr leaf block is a
> valid state and remove the count check from the verifier. This means
> that on rare occasions an attr fork might exist in an unexpected
> state, but is otherwise consistent and functional. Note that we
> retain the logic to avoid racing with metadata writeback to reduce
> the window where this can occur.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v1:
> - Remove the verifier check instead of warn.
> rfc: https://lore.kernel.org/linux-xfs/20200511185016.33684-1-bfoster@redhat.com/
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 863444e2dda7..6b94bb9de378 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -308,14 +308,6 @@ xfs_attr3_leaf_verify(
>  	if (fa)
>  		return fa;
>  
> -	/*
> -	 * In recovery there is a transient state where count == 0 is valid
> -	 * because we may have transitioned an empty shortform attr to a leaf
> -	 * if the attr didn't fit in shortform.

/me wonders if it would be useful for future spelunkers to retain some
sort of comment here that we once thought count==0 was bad but screwed
it up enough that we now allow it?

Moreso that future me/fuzzrobot won't come along having forgotten
everything and think "Oh, we need to validate hdr.count!" :P

--D

> -	 */
> -	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
> -		return __this_address;
> -
>  	/*
>  	 * firstused is the block offset of the first name info structure.
>  	 * Make sure it doesn't go off the block or crash into the header.
> -- 
> 2.21.1
> 
