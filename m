Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C79C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 23:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23B62072C
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 23:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgBQXlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 18:41:42 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47644 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgBQXll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 18:41:41 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 695913A1F8C;
        Tue, 18 Feb 2020 10:41:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3q1A-0003xz-4b; Tue, 18 Feb 2020 10:41:36 +1100
Date:   Tue, 18 Feb 2020 10:41:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 21/31] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Message-ID: <20200217234136.GV10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-22-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-22-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=t1EurSIWo3ec4TgTiyEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:47PM +0100, Christoph Hellwig wrote:
> The old xfs_attr_list code is only used by the attrlist by handle
> ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
> attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
> user ABIs.  They are used through libattr headers with the same name
> by at least xfsdump.  Also document this relation so that it doesn't
> require a research project to figure out.

That's a bit nasty. I suspect that also needs documentation in the
path_to_handle(3) man page, too.

[...]

> +int
> +xfs_ioc_attr_list(
> +	struct xfs_inode		*dp,
> +	char				*buffer,
> +	int				bufsize,
> +	int				flags,
> +	struct attrlist_cursor_kern	*cursor)
> +{
> +	struct xfs_attr_list_context	context;
> +	struct xfs_attrlist		*alist;
> +	int				error;
> +
> +	/*
> +	 * Validate the cursor.
> +	 */
> +	if (cursor->pad1 || cursor->pad2)
> +		return -EINVAL;
> +	if ((cursor->initted == 0) &&
> +	    (cursor->hashval || cursor->blkno || cursor->offset))
> +		return -EINVAL;
> +
> +	/*
> +	 * Check for a properly aligned buffer.
> +	 */
> +	if (((long)buffer) & (sizeof(int)-1))
> +		return -EFAULT;
> +
> +	/*
> +	 * Initialize the output buffer.
> +	 */
> +	memset(&context, 0, sizeof(context));
> +	context.dp = dp;
> +	context.cursor = cursor;
> +	context.resynch = 1;
> +	context.flags = flags;
> +	context.buffer = buffer;
> +	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */

ALIGN()?

Otherwise looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
