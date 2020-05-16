Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93768C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 00:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C44D207CB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 00:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ClPdHJut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgEPASo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 20:18:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgEPASo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 20:18:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0Btln037076;
        Sat, 16 May 2020 00:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ytOcaPhVIDwBLX76y/MJijYYw2Y9eUkvBn6u7w2/Kmc=;
 b=ClPdHJutkoYXuKeazQXT6/laqg4dPoM4oxpjfZGxtVvGKN+9RD2zqAb8JN/AgCjeIDI0
 G2WTUbu5PfHxUmYNjbK77p5Y4PyRcDEbv15n8C/r3QFKN9AWxjN3S3yppgqAAx3BPU14
 vZgD4QxflFWMRWj5Cg1tdOqo8Tcd5M5vJt+5+6gLF4EWNoM3SPiKpPBwzF3fUz5cYO1n
 dIZtsDIhDyiTMRVWVro2zvNcM50OtMd6VGW23qnpL7HEhgia7NhF2HjbhwAyai+sWyH9
 ri04gIoBRozIQ8mtZZLTBVYOIclN/6pA96QNwhBXspL9gRZ5MTzfcdU+GqF4nqLbyn7P Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xwxdg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 00:18:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0I93k099066;
        Sat, 16 May 2020 00:18:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31259qgm58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 00:18:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04G0IdJJ002550;
        Sat, 16 May 2020 00:18:40 GMT
Received: from localhost (/10.159.241.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 17:18:39 -0700
Date:   Fri, 15 May 2020 17:18:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: don't fail verifier on empty attr3 leaf block
Message-ID: <20200516001838.GQ6714@magnolia>
References: <20200515160648.56487-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515160648.56487-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 12:06:48PM -0400, Brian Foster wrote:
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

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Add comment.
> v1: https://lore.kernel.org/linux-xfs/20200513145343.45855-1-bfoster@redhat.com/
> - Remove the verifier check instead of warn.
> rfc: https://lore.kernel.org/linux-xfs/20200511185016.33684-1-bfoster@redhat.com/
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 863444e2dda7..6d18e86bb9c7 100644
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
> -	 */
> -	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
> -		return __this_address;
> -
>  	/*
>  	 * firstused is the block offset of the first name info structure.
>  	 * Make sure it doesn't go off the block or crash into the header.
> @@ -331,6 +323,13 @@ xfs_attr3_leaf_verify(
>  	    (char *)bp->b_addr + ichdr.firstused)
>  		return __this_address;
>  
> +	/*
> +	 * NOTE: This verifier historically failed empty leaf buffers because
> +	 * we expect the fork to be in another format. Empty attr fork format
> +	 * conversions are possible during xattr set, however, and format
> +	 * conversion is not atomic with the xattr set that triggers it. We
> +	 * cannot assume leaf blocks are non-empty until that is addressed.
> +	*/
>  	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
>  	for (i = 0, ent = entries; i < ichdr.count; ent++, i++) {
>  		fa = xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
> -- 
> 2.21.1
> 
