Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551BFC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 06:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D452072E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 06:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389187AbgFXGw2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 02:52:28 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49206 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388972AbgFXGw2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 02:52:28 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C72905AC9D7;
        Wed, 24 Jun 2020 16:52:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnzGM-0003h6-L3; Wed, 24 Jun 2020 16:52:02 +1000
Date:   Wed, 24 Jun 2020 16:52:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200624065202.GD2005@dread.disaster.area>
References: <20200624035133.GH7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624035133.GH7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=ai0ONhx_MLLrA7oNV9sA:9 a=-p-osk2MJmHGva9Z:21 a=Jic8J4YJ3vQHp8f_:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 08:51:33PM -0700, Darrick J. Wong wrote:
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
> v3: don't play this game where we clear the mapping error only to re-set it
> v2: explain why it's ok to keep going even if writeback fails
> ---
>  fs/xfs/scrub/bmap.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 7badd6dfe544..c4c2477a94ae 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -45,9 +45,30 @@ xchk_setup_inode_bmap(
>  	 */
>  	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
>  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
> +		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
> +
>  		inode_dio_wait(VFS_I(sc->ip));
> -		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> -		if (error)
> +
> +		/*
> +		 * Try to flush all incore state to disk before we examine the
> +		 * space mappings for the data fork.  Leave accumulated errors
> +		 * in the mapping for the writer threads to consume.
> +		 */
> +		error = filemap_fdatawrite(mapping);
> +		if (!error)
> +			error = filemap_fdatawait_keep_errors(mapping);
> +		if (error == -ENOSPC || error == -EIO) {
> +			/*
> +			 * On ENOSPC or EIO writeback errors, we continue into
> +			 * the extent mapping checks because write failures do
> +			 * not necessarily imply anything about the correctness
> +			 * of the file metadata.  The metadata and the file
> +			 * data could be on completely separate devices; a
> +			 * media failure might only affect a subset of the
> +			 * disk, etc.  We can handle delalloc extents in the
> +			 * scrubber, so leaving them in memory is fine.
> +			 */
> +		} else if (error)
>  			goto out;
>  	}

Functionality is fine, but the if() that does nothing but contain a
comment is a bit weird. Promote the error handling comment, and that
can formatted as:

		/*
		 * Try to flush all incore state to disk before we examine the
		 * space mappings for the data fork.  Leave accumulated errors
		 * in the mapping for the writer threads to consume.
		 *
		 * On ENOSPC or EIO writeback errors, we continue into the
		 * extent mapping checks because write failures do not
		 * necessarily imply anything about the correctness of the file
		 * metadata.  The metadata and the file data could be on
		 * completely separate devices; a media failure might only
		 * affect a subset of the disk, etc.  We can handle delalloc
		 * extents in the scrubber, so leaving them in memory is fine.
		 */
		error = filemap_fdatawrite(mapping);
		if (!error)
			error = filemap_fdatawait_keep_errors(mapping);
		if (error && (error != -ENOSPC && error !== -EIO))
			goto out;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
