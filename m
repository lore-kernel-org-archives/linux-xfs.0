Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82A9C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C282071C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0GHuUdb8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCLOsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:48:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54996 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbgCLOsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:48:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEihIS166479;
        Thu, 12 Mar 2020 14:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nyFkPnKxBZJ81Tdhoh386KbdqzidqMjCiGxb4Zh1lzY=;
 b=0GHuUdb8F/Z9ZToGX65Y2uyvyPkXfPHdj1G5V+hz1HQryE+v46pS6SFKsp2qP0Cmy6s3
 mYFu+UpQ+VDwAiCHL/YlcUmz7pafJH+6nGFNfBNITMy8J4UUQd2OjGNn+udY/DalMHQ1
 f7QsEFbE6DkchNA1RfJsm/p4WM0A74eQBaemy0ltHiSVhVM7kbctHaJNALZoBVaVRZJi
 zzOuzwoBA3gezeGNpyX/wXA7150P5W7Db5Uw2WIqDFXqlQGGe2gaLvtGSNLgaM4LU57j
 ZuzYPSymk3eocwsur6EvJNXMcskYuMNUzug57IV+/KSXxzHDs9PcNLHniIvt9ht4D9EQ 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yp9v6d4dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:48:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEgGhT089125;
        Thu, 12 Mar 2020 14:48:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yqkvmt69e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:48:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CEmhXY019044;
        Thu, 12 Mar 2020 14:48:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:48:42 -0700
Date:   Thu, 12 Mar 2020 07:48:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Tommi Rantala <tommi.t.rantala@nokia.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix regression in "cleanup xfs_dir2_block_getdents"
Message-ID: <20200312144841.GL8045@magnolia>
References: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 10:57:28AM +0200, Tommi Rantala wrote:
> Commit 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents") introduced
> a getdents regression, when it converted the pointer arithmetics to
> offset calculations: offset is updated in the loop already for the next
> iteration, but the updated offset value is used incorrectly in two
> places, where we should have used the not-yet-updated value.
> 
> This caused for example "git clean -ffdx" failures to cleanup certain
> directory structures when running in a container.
> 
> Fix the regression by making sure we use proper offset in the loop body.
> Thanks to Christoph Hellwig for suggestion how to best fix the code.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents")
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>

Looks ok, sorry I didn't catch this either...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

How might we package this up as a fstest so we can actually do
regression testing?

--D

> ---
>  fs/xfs/xfs_dir2_readdir.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 0d3b640cf1cc..871ec22c9aee 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -147,7 +147,7 @@ xfs_dir2_block_getdents(
>  	xfs_off_t		cook;
>  	struct xfs_da_geometry	*geo = args->geo;
>  	int			lock_mode;
> -	unsigned int		offset;
> +	unsigned int		offset, next_offset;
>  	unsigned int		end;
>  
>  	/*
> @@ -173,9 +173,10 @@ xfs_dir2_block_getdents(
>  	 * Loop over the data portion of the block.
>  	 * Each object is a real entry (dep) or an unused one (dup).
>  	 */
> -	offset = geo->data_entry_offset;
>  	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
> -	while (offset < end) {
> +	for (offset = geo->data_entry_offset;
> +	     offset < end;
> +	     offset = next_offset) {
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  		uint8_t filetype;
> @@ -184,14 +185,15 @@ xfs_dir2_block_getdents(
>  		 * Unused, skip it.
>  		 */
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			offset += be16_to_cpu(dup->length);
> +			next_offset = offset + be16_to_cpu(dup->length);
>  			continue;
>  		}
>  
>  		/*
>  		 * Bump pointer for the next iteration.
>  		 */
> -		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
> +		next_offset = offset +
> +			xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
>  
>  		/*
>  		 * The entry is before the desired starting point, skip it.
> -- 
> 2.21.1
> 
