Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F157C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 21:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6F02072E
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 21:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ddgBIr0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389880AbgFWVTR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 17:19:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389713AbgFWVTQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 17:19:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NLHppI073740;
        Tue, 23 Jun 2020 21:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rBwd7NGnfZnoSNlE2W9ieiwdCYIGzdzUrbDLVo4qcOc=;
 b=ddgBIr0tJCpZrWNUKl93hL7hem15XVA9BExZGAbhY7hrkQFEZSUeuMjv2142SiaG5qzB
 nlq+H40jXN4TCkl6Hc+emZu8HZrU4kYmfcfEjZzqrY9KqkaFPqz4bz5L1gyf5CPZAFX0
 hlZPFOR8nBbHpnR6iKRmpH2BfNg6bpgoCjR8QK04kNrpHlnSVHnM6QD35cD3YdbSAAox
 0wjMH41H5LvgXatrQk0YLO9Cvuosa6tiCY1MJVmDj1A9bMjepw8QmYzBwXGtDY/mUlQI
 90P3jvi2mhlNiE02IUWKg1amXsOPqw0+YSAwpgvXee6X4ztFJx6yd9+zSiGwQpXYROJp lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uk3c29bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 21:19:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NLJC68142209;
        Tue, 23 Jun 2020 21:19:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uk42jmkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 21:19:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NLJBPs016007;
        Tue, 23 Jun 2020 21:19:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 21:19:11 +0000
Date:   Tue, 23 Jun 2020 14:19:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200623211910.GG7606@magnolia>
References: <20200623052059.1893966-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623052059.1893966-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006120000
 definitions=main-2006230144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=1 adultscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006120000
 definitions=main-2006230144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 03:20:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The page faultround path ->map_pages is implemented in XFS via

What does "faultround" mean?

I'm pretty convinced that this is merely another round of whackamole wrt
taking the MMAPLOCK before relying on or doing anything to pages in the
page cache, I just can't tell if 'faultround' is jargon or typo.

--D

> filemap_map_pages(). This function checks that pages found in page
> cache lookups have not raced with truncate based invalidation by
> checking page->mapping is correct and page->index is within EOF.
> 
> However, we've known for a long time that this is not sufficient to
> protect against races with invalidations done by operations that do
> not change EOF. e.g. hole punching and other fallocate() based
> direct extent manipulations. The way we protect against these
> races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
> lock so they serialise against fallocate and truncate before calling
> into the filemap function that processes the fault.
> 
> Do the same for XFS's ->map_pages implementation to close this
> potential data corruption issue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7b05f8fd7b3d..4b185a907432 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1266,10 +1266,23 @@ xfs_filemap_pfn_mkwrite(
>  	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
> +static void
> +xfs_filemap_map_pages(
> +	struct vm_fault		*vmf,
> +	pgoff_t			start_pgoff,
> +	pgoff_t			end_pgoff)
> +{
> +	struct inode		*inode = file_inode(vmf->vma->vm_file);
> +
> +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	filemap_map_pages(vmf, start_pgoff, end_pgoff);
> +	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +}
> +
>  static const struct vm_operations_struct xfs_file_vm_ops = {
>  	.fault		= xfs_filemap_fault,
>  	.huge_fault	= xfs_filemap_huge_fault,
> -	.map_pages	= filemap_map_pages,
> +	.map_pages	= xfs_filemap_map_pages,
>  	.page_mkwrite	= xfs_filemap_page_mkwrite,
>  	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
>  };
> -- 
> 2.26.2.761.g0e0b3e54be
> 
