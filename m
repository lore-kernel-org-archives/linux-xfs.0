Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140EAC4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBF2520659
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NNS9jp0d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388802AbfJDPYW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:24:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37902 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389224AbfJDPYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 11:24:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94F4XBI075905;
        Fri, 4 Oct 2019 15:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JrObOJxiA7LZ4v9/pvmvL5S945qv4zyAwhw9ITLtiWc=;
 b=NNS9jp0dPc4kB1A7PIvU5RE+/NzOpriPXID3lMAtJMrapTefWBLsmnvkuUpgUj3Znsnh
 K8HOG/D6r9lniWQ3vMLrDWoVMkIYzSzQ6LjPK7mBwcp320WBNF6Jv7aMXwGz0ayAPUPy
 Ki1GV7iPAAG62mcVN8/NG0oNfjhpS/uklylhEftsID2W5KALzMT5TkiOVz856lA3Qi2I
 3W6QVbpYMGYf/KB6ORKlyaaN0CQsRUZzYc1u1MY7+LuARo9+vNxlBVBaJBTGreEdkTMv
 3WmER+8hi2QcDzfHMgvJibHHRpepLWnysXYn7n1tqrbl9Jo1pILMkmivzsx6C5djNsXi +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05sc41h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 15:24:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94F56mV024096;
        Fri, 4 Oct 2019 15:24:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vdn19ynj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 15:24:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x94FO9f8019342;
        Fri, 4 Oct 2019 15:24:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 08:24:08 -0700
Date:   Fri, 4 Oct 2019 08:24:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: log the inode on directory sf to block format change
Message-ID: <20191004152408.GL13108@magnolia>
References: <20191004125520.7857-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004125520.7857-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 04, 2019 at 08:55:20AM -0400, Brian Foster wrote:
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
> Update xfs_dir2_sf_to_block() to log the inode when the on-disk
> format is changed. This ensures that any subsequent errors after the
> format has changed cause the transaction to abort.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_block.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 9595ced393dc..3d1e5f6d64fd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1098,6 +1098,7 @@ xfs_dir2_sf_to_block(
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
>  	xfs_bmap_local_to_extents_empty(dp, XFS_DATA_FORK);
>  	dp->i_d.di_size = 0;
> +	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);

I think the general idea looks ok, but is there any reason why we don't
log the inode in xfs_bmap_local_to_extents_empty, since it changes the
ondisk format?

Also, does xfs_attr_shortform_to_leaf have a similar problem?

--D

>  
>  	/*
>  	 * Add block 0 to the inode.
> -- 
> 2.20.1
> 
