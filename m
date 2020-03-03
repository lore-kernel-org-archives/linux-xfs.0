Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA12FC3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C17E82083E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="udfR8Cv/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgCCQwH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 11:52:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729156AbgCCQwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 11:52:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GmsIB126273;
        Tue, 3 Mar 2020 16:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kGUVJT+9yLhYM9OqIOxubmW17y4MPgJy9kKZsXdS1kw=;
 b=udfR8Cv/8qxVMpuyphu0s8izG5lFeQnYmTX+PjXc2YMDzr3GFzjR0SMDbXqqxd5FZSmh
 3HxBg+IP2qcGrxQ9MDzSz9/iQy0MwXDxuml3Wj6+YIfNtkrYmHhrZhwtslJJ05zPtv2p
 Iu+a46X0ynt0yEoxtwqOhTx/c2XFEl+GdDaNy9LJG9IrR7rY5Z5T3IqS5eXm9jEh0RIT
 A7tAPS1xzs2M/CjCnvKSH5SH4JJSw1efhqdydgyNnjh5hKorOaSA7zFLTYf5VSnKtM32
 VBc5jZLucD/Wt92hPhZuwOv6GOlV7KRqZLMI72xWdg09ZkmmF6dnYqI5ChOmz3hl6QMZ lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yghn34cvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 16:52:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GkcFA167790;
        Tue, 3 Mar 2020 16:52:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yg1rmgf5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 16:52:02 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023GpwQe010758;
        Tue, 3 Mar 2020 16:51:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 08:51:58 -0800
Date:   Tue, 3 Mar 2020 08:51:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: don't override sis->bdev in
 xfs_iomap_swapfile_activate
Message-ID: <20200303165157.GC8045@magnolia>
References: <20200301144925.48343-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301144925.48343-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 01, 2020 at 07:49:25AM -0700, Christoph Hellwig wrote:
> The swapon code itself sets sis->bdev up early, and performs various check
> on the block devices.  Changing it later in the fact thus will cause a
> mismatch of capabilities and must be avoided.

What kind of mismatch?  Are you talking about the bdi_cap_* and
blk_queue_nonrot() logic in swapon()?  I wonder how much of that could
be moved to after the ->swapfile_activate call.

> The practical implication
> of this change is that it forbids swapping to the RT subvolume, which might
> have had all kinds of issues anyway.

<shrug> I didn't find any the one time I tried it on a pair of
homogeneous devices. :)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 58e937be24ce..f9929a952ef1 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -637,7 +637,6 @@ xfs_iomap_swapfile_activate(
>  	struct file			*swap_file,
>  	sector_t			*span)
>  {
> -	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;

That said, btrfs copypasta'd this when they ported to iomap swapfile, so
that needs fixing too.

--D

>  	return iomap_swapfile_activate(sis, swap_file, span,
>  			&xfs_read_iomap_ops);
>  }
> -- 
> 2.24.1
> 
