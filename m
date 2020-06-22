Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF48C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 22:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34CF12073E
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 22:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgFVWIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 18:08:44 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:60829 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgFVWIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 18:08:44 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7E4441AA599;
        Tue, 23 Jun 2020 08:08:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnUcJ-0000g3-Uh; Tue, 23 Jun 2020 08:08:39 +1000
Date:   Tue, 23 Jun 2020 08:08:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200622220839.GV2005@dread.disaster.area>
References: <20200622171713.GG11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622171713.GG11245@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=m6S3wBO24_YhWdYwnekA:9 a=UiYtIJt4SKle1YlE:21 a=QpOlqvn8cCqr-vcK:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 10:17:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The data fork scrubber calls filemap_write_and_wait to flush dirty pages
> and delalloc reservations out to disk prior to checking the data fork's
> extent mappings.  Unfortunately, this means that scrub can consume the
> EIO/ENOSPC errors that would otherwise have stayed around in the address
> space until (we hope) the writer application calls fsync to persist data
> and collect errors.  The end result is that programs that wrote to a
> file might never see the error code and proceed as if nothing were
> wrong.
> 
> xfs_scrub is not in a position to notify file writers about the
> writeback failure, and it's only here to check metadata, not file
> contents.  Therefore, if writeback fails, we should stuff the error code
> back into the address space so that an fsync by the writer application
> can pick that up.
> 
> Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/bmap.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 7badd6dfe544..03be7cf3fe5a 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -47,7 +47,15 @@ xchk_setup_inode_bmap(
>  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
>  		inode_dio_wait(VFS_I(sc->ip));
>  		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> -		if (error)
> +		if (error == -ENOSPC || error == -EIO) {
> +			/*
> +			 * If writeback hits EIO or ENOSPC, reflect it back
> +			 * into the address space mapping so that a writer
> +			 * program calling fsync to look for errors will still
> +			 * capture the error.
> +			 */
> +			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);
> +		} else if (error)
>  			goto out;

calling mapping_set_error() seems reasonable here and you've
explained that well, but shouldn't the error then be processed the
same way as all other errors? i.e. by jumping to out?

If we are now continuing to scrub the bmap after ENOSPC/EIO occur,
why?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
