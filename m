Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10509C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 17:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA67F64E27
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 17:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbhBDR4z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 12:56:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237469AbhBDR4q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 12:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612461319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VVT9XZOi/APqYIcpFOJHwKho/nXda7GitLTejj7Jpo0=;
        b=CBp9JV+2Q1jp2RiOInDLIMAdEcSVbTqrNCyrFBAfAHUroYVRewv2Vd5Gz7mcLaUHHMmlRm
        7XNcltb8Q2g7hJYXCj9AodaT9S93dnJhH1Msl+tSHRQmvH8oJaNjGdvg4FPqzylv4sdgz9
        14ujQ+nTs85plyDL+5JZDYzPo8f0i3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-tgIXIpRoPzyQr8oUOzacFw-1; Thu, 04 Feb 2021 12:55:15 -0500
X-MC-Unique: tgIXIpRoPzyQr8oUOzacFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDD2815722;
        Thu,  4 Feb 2021 17:55:14 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C55C60937;
        Thu,  4 Feb 2021 17:55:14 +0000 (UTC)
Date:   Thu, 4 Feb 2021 12:55:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_repair: clear the needsrepair flag
Message-ID: <20210204175512.GC3721376@bfoster>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
 <161238142078.1278306.10769412408846256451.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161238142078.1278306.10769412408846256451.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 11:43:40AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the needsrepair flag, since it's used to prevent mounting of an
> inconsistent filesystem.  We only do this if we make it to the end of
> repair with a non-zero error code, and all the rebuilt indices and
> corrected metadata are persisted correctly.
> 
> Note that we cannot combine clearing needsrepair with clearing the quota
> checked flags because we need to clear the quota flags even if
> reformatting the log fails, whereas we can't clear needsrepair if the
> log reformat fails.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks sane, just some nits...

>  include/xfs_mount.h |    1 +
>  libxfs/init.c       |   12 ++++++++----
>  repair/agheader.c   |   21 +++++++++++++++++++++
>  repair/xfs_repair.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 79 insertions(+), 4 deletions(-)
> 
> 
...
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 9fe13b8d..99b1f72a 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -870,9 +870,10 @@ _("%s: Flushing the %s failed, err=%d!\n"),
>   * Flush all dirty buffers to stable storage and report on writes that didn't
>   * make it to stable storage.
>   */
> -static int
> +int
>  libxfs_flush_mount(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	bool			purge)
>  {
>  	int			error = 0;
>  	int			err2;
> @@ -884,7 +885,10 @@ libxfs_flush_mount(
>  	 * cannot be written will cause the LOST_WRITE flag to be set in the
>  	 * buftarg.
>  	 */
> -	libxfs_bcache_purge();
> +	if (purge)
> +		libxfs_bcache_purge();
> +	else
> +		libxfs_bcache_flush();

Instead of the parameter, could we just lift the purge into the call
that requires it and let libxfs_flush_mount() just do flushes? I'm
assuming the bcache would be empty in the umount case so the extra flush
should pretty much be a no-op.

>  
>  	/* Flush all kernel and disk write caches, and report failures. */
>  	if (mp->m_ddev_targp) {
> @@ -923,7 +927,7 @@ libxfs_umount(
>  
>  	libxfs_rtmount_destroy(mp);
>  
> -	error = libxfs_flush_mount(mp);
> +	error = libxfs_flush_mount(mp, true);
>  
>  	for (agno = 0; agno < mp->m_maxagi; agno++) {
>  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
...
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9409f0d8..4ca4fe5a 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -712,6 +712,52 @@ check_fs_vs_host_sectsize(
>  	}
>  }
>  
> +/* Clear needsrepair after a successful repair run. */
> +void
> +clear_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	/*
> +	 * If we're going to clear NEEDSREPAIR, we need to make absolutely sure
> +	 * that everything is ok with the ondisk filesystem.  At this point
> +	 * we've flushed the filesystem metadata out of the buffer cache and
> +	 * possibly rewrote the log, but we haven't forced the disks to persist
> +	 * the writes to stable storage.  Do that now, and if anything goes
> +	 * wrong, leave NEEDSREPAIR in place.  Don't purge the buffer cache
> +	 * here since we're not done yet.
> +	 */
> +	error = -libxfs_flush_mount(mp, false);
> +	if (error) {
> +		do_warn(
> +	_("Cannot clear needsrepair from primary super due to metadata checkpoint failure, err=%d.\n"),
> +			error);

Not sure what metadata checkpoint failure means.. maybe just say that a
flush failed?

> +		return;
> +	}
> +
> +	/* Clear needsrepair from the superblock. */
> +	bp = libxfs_getsb(mp);
> +	if (!bp) {
> +		do_warn(
> +	_("Cannot clear needsrepair from primary super, out of memory.\n"));
> +		return;
> +	}
> +	if (bp->b_error) {
> +		do_warn(
> +	_("Cannot clear needsrepair from primary super, IO err=%d.\n"),
> +			bp->b_error);
> +	} else {

Maybe try to condense this a bit to something like the following to
reduce the number of branches and strings to translate and whatnot:

	if (!bp || bp->b_error) {
		do_warn(
		"Failed to clear needsrepair from primary super, err=%d.\n",
			bp ? bp->b_error : -ENOMEM);
		goto out;
	}

	...
out:
	libxfs_buf_release(bp);
}

> +		mp->m_sb.sb_features_incompat &=
> +				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +		libxfs_buf_mark_dirty(bp);
> +	}
> +	libxfs_buf_relse(bp);
> +	return;

No need for the return statement here.

Brian

> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> @@ -1132,6 +1178,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	libxfs_bcache_flush();
>  	format_log_max_lsn(mp);
>  
> +	if (xfs_sb_version_needsrepair(&mp->m_sb))
> +		clear_needsrepair(mp);
> +
>  	/* Report failure if anything failed to get written to our fs. */
>  	error = -libxfs_umount(mp);
>  	if (error)
> 

