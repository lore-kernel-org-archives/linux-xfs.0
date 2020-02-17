Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55352C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 22:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 302C12070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 22:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgBQW2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 17:28:14 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45728 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbgBQW2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 17:28:14 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C85603A1E4A;
        Tue, 18 Feb 2020 09:28:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3os5-0003Za-2N; Tue, 18 Feb 2020 09:28:09 +1100
Date:   Tue, 18 Feb 2020 09:28:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 06/31] xfs: factor out a helper for a single
 XFS_IOC_ATTRMULTI_BY_HANDLE op
Message-ID: <20200217222809.GK10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-7-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=AmeXwgXc8m8_EU3lb0IA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:32PM +0100, Christoph Hellwig wrote:
> Add a new helper to handle a single attr multi ioctl operation that
> can be shared between the native and compat ioctl implementation.
> 
> There is a slight change in heavior in that we don't break out of the
> loop when copying in the attribute name fails.  The previous behavior
> was rather inconsistent here as it continued for any other kind of
> error.

Nice cleanup!

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 97 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_ioctl.h   | 18 ++------
>  fs/xfs/xfs_ioctl32.c | 50 +++--------------------
>  3 files changed, 59 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bb490a954c0b..cfdd80b4ea2d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -349,7 +349,7 @@ xfs_attrlist_by_handle(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_attrmulti_attr_get(
>  	struct inode		*inode,
>  	unsigned char		*name,
> @@ -381,7 +381,7 @@ xfs_attrmulti_attr_get(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_attrmulti_attr_set(
>  	struct inode		*inode,
>  	unsigned char		*name,
> @@ -412,6 +412,51 @@ xfs_attrmulti_attr_set(
>  	return error;
>  }
>  
> +int
> +xfs_ioc_attrmulti_one(
> +	struct file		*parfilp,

Weird name for the file pointer. It's just a file pointer in this
context, similar to...

> +	struct inode		*inode,

... it just being an inode pointer in this context.

> +	uint32_t		opcode,
> +	void __user		*uname,
> +	void __user		*value,
> +	uint32_t		*len,
> +	uint32_t		flags)
> +{
> +	unsigned char		*name;
> +	int			error;
> +
> +	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
> +		return -EINVAL;
> +	flags &= ~ATTR_KERNEL_FLAGS;

Ok, so this is a user ABI visible change - the old code would return
to userspace with these flags cleared from ops[i].am_flags. Now that
doesn't happen. I don't see this as a problem, but it needs to be
documented in the commit message.

> +
> +	name = strndup_user(uname, MAXNAMELEN);
> +	if (IS_ERR(name))
> +		return PTR_ERR(name);
> +
> +	switch (opcode) {
> +	case ATTR_OP_GET:
> +		error = xfs_attrmulti_attr_get(inode, name, value, len, flags);
> +		break;
> +	case ATTR_OP_REMOVE:
> +		value = NULL;
> +		*len = 0;
> +		/*FALLTHRU*/

All the recent code we've added uses:

		/* fall through */

for this annotation - it's the most widely used variant in the
XFS codebase, so it would be good to be consistent here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
