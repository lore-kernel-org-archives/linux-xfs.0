Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17952C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 22:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB51320801
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 22:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgBQWPm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 17:15:42 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55162 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgBQWPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 17:15:42 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8AE837E9C6E;
        Tue, 18 Feb 2020 09:15:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3ofz-0003Q2-0u; Tue, 18 Feb 2020 09:15:39 +1100
Date:   Tue, 18 Feb 2020 09:15:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/31] xfs: use strndup_user in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20200217221538.GJ10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-6-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=QMJNcwjdRDogb9IiVAAA:9
        a=jgZg2VXXFmi3iGAR:21 a=btIgfXDAKQXfHWRP:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:31PM +0100, Christoph Hellwig wrote:
> Simplify the user copy code by using strndup_user.  This means that we
> now do one memory allocation per operation instead of one per ioctl,
> but memory allocations are cheap compared to the actual file system
> operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 17 +++++------------
>  fs/xfs/xfs_ioctl32.c | 17 +++++------------
>  2 files changed, 10 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index b806003caacd..bb490a954c0b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -448,11 +448,6 @@ xfs_attrmulti_by_handle(
>  		goto out_dput;
>  	}
>  
> -	error = -ENOMEM;
> -	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> -	if (!attr_name)
> -		goto out_kfree_ops;
> -
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
>  		if ((ops[i].am_flags & ATTR_ROOT) &&
> @@ -462,12 +457,11 @@ xfs_attrmulti_by_handle(
>  		}
>  		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
>  
> -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> -				ops[i].am_attrname, MAXNAMELEN);
> -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> -		if (ops[i].am_error < 0)
> +		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> +		if (IS_ERR(attr_name)) {
> +			ops[i].am_error = PTR_ERR(attr_name);
>  			break;
> +		}

This changes the error returned for an invalid attr name length from
-ERANGE to either -EINVAL or -EFAULT. Can you please document that
in the commit message. This change requires updates to the 
path_to_handle(3) man page shipped in xfsprogs in the xfslibs-dev
package (xfsprogs::man/man3/handle.3) to document the differences in
return values.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
