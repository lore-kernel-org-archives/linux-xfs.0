Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A1CC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266EE20768
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jTQ/n5ks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390774AbgF3S1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:27:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389306AbgF3S1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 14:27:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UIDK4P011410;
        Tue, 30 Jun 2020 18:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Zo0P0tN+LhRM2+pccbKHMDnZc0dgRVPTWd64hER3Quk=;
 b=jTQ/n5ksVWlat7bXD1kxBytM3ihK+c6Cw+EArV0x0rvspDawK/WCFTfYEGKOHy9vJB0o
 slzuLorIl9Ng4lVo/tE8fNAigpSFRHWexNmRrlKEKOC3gQkimcBVoa8Gfn9jGZb0YTY0
 C2/wfrKxF3qcrlvXoZIraFTGfaWH3xK2egoHcQ7Zj9AqfwPza2WjOJ9Up1n1Q4egzlwb
 3fx6scUNTZZcto7cJOvu1Sdx9uhcsc/WYKFhy2XMn6JBWCf/oV9662mRwymLRWTRPv9s
 MCWZR1UUcMcXRfoswt/R8u43ihcls8OQ5ergWy2mpmxygQsZGumMZ+tfI4Gl1X9vxnzq Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31ywrbmevg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 18:27:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UIIYE8060320;
        Tue, 30 Jun 2020 18:27:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvsuh4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 18:27:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UIRnTo021197;
        Tue, 30 Jun 2020 18:27:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 18:27:49 +0000
Date:   Tue, 30 Jun 2020 11:27:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200630182748.GR7606@magnolia>
References: <20200623052059.1893966-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623052059.1893966-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 03:20:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The page faultround path ->map_pages is implemented in XFS via
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

Looks ok, notwithstanding the (semirelated) questions that Amir
unearthed elsewhere in this thread...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
