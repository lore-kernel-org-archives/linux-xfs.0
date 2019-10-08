Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB66C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 119742070B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KIXVfZ9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfJHQLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:11:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfJHQLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 12:11:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98FsTKC164374;
        Tue, 8 Oct 2019 16:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=O1HnlNsX0SbW70OYOuge2YaAAhHevtDb5c+LRnvtxrM=;
 b=KIXVfZ9W8gMKyfZgi7iQzulBzrrf0UX/mS3TDmYUaIbiBu/8E0asAOX57zX8AzsgRveQ
 +OUcEQ8bwgE70Tehtgtez1GVBgk6lKKnXm8KkTMs/T4gKn+fqUcvRDkItK7FDcCrut2S
 lxJmruMrj75xc1q/0KtVwBA7M/3EX08iXUaAw+I0QOAsiH26pAH7GTGl85qszY1PHXSo
 B4aEuXnAEmYgxCCPbieOkY7RytzHE4M/w2op87GcBGnoCwkIaC1JilXfRJ2jek015XWF
 16jE4mEf7N/AEWn25OvFXvdHnUNz6C3OjHK/rLPagy9IsOH6pO0y5eY05xGpM/yjKHnB 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vejkued36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 16:11:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98FrJ7t049021;
        Tue, 8 Oct 2019 16:11:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vg206mycm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 16:11:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x98GBA74019631;
        Tue, 8 Oct 2019 16:11:10 GMT
Received: from localhost (/10.159.136.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 09:11:10 -0700
Date:   Tue, 8 Oct 2019 09:11:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] xfs: log the inode on directory sf to block
 format change
Message-ID: <20191008161109.GC13108@magnolia>
References: <20191007131938.23839-1-bfoster@redhat.com>
 <20191007131938.23839-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007131938.23839-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:19:36AM -0400, Brian Foster wrote:
> When a directory changes from shortform (sf) to block format, the sf
> format is copied to a temporary buffer, the inode format is modified
> and the updated format filled with the dentries from the temporary
> buffer. If the inode format is modified and attempt to grow the
> inode fails (due to I/O error, for example), it is possible to
> return an error while leaving the directory in an inconsistent state
> and with an otherwise clean transaction. This results in corruption
> of the associated directory and leads to xfs_dabuf_map() errors as
> subsequent lookups cannot accurately determine the format of the
> directory. This problem is reproduced occasionally by generic/475.
> 
> The fundamental problem is that xfs_dir2_sf_to_block() changes the
> on-disk inode format without logging the inode. The inode is
> eventually logged by the bmapi layer in the common case, but error
> checking introduces the possibility of failing the high level
> request before this happens.
> 
> Update both of the dir2 and attr callers of
> xfs_bmap_local_to_extents_empty() to log the inode core as
> consistent with the bmap local to extent format change codepath.
> This ensures that any subsequent errors after the format has changed
> cause the transaction to abort.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 1 +
>  fs/xfs/libxfs/xfs_dir2_block.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b9f019603d0b..36c0a32cefcf 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -827,6 +827,7 @@ xfs_attr_shortform_to_leaf(
>  
>  	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
>  	xfs_bmap_local_to_extents_empty(dp, XFS_ATTR_FORK);
> +	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
>  
>  	bp = NULL;
>  	error = xfs_da_grow_inode(args, &blkno);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 9595ced393dc..3d1e5f6d64fd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1098,6 +1098,7 @@ xfs_dir2_sf_to_block(
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
>  	xfs_bmap_local_to_extents_empty(dp, XFS_DATA_FORK);
>  	dp->i_d.di_size = 0;
> +	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
>  	/*
>  	 * Add block 0 to the inode.
> -- 
> 2.20.1
> 
