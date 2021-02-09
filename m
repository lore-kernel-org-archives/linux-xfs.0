Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA4BC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF60D64E7E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhBIRWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:22:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232909AbhBIRWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:22:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xrgkxCtbBUgHJfgpFrTLA7WX9JMip9bJ5YWNPi4PZG8=;
        b=Af0WEZi2dCs3sFr78HfY+v81vtaMLFwDWzcAUyA0+3YW4ywokAEdIl5HqRzbSMpb25r8bC
        YZmpuPWtuQtwadD+srvjtKz6xFRiA+pGaXtQEavSr+nutGUaoLjPbk0bGhXOjDVS/EZFXa
        N1twxpOspCJskg2koW116EOJh2XqFnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98---Ls4RuFNQewZieokXJ3cg-1; Tue, 09 Feb 2021 12:20:32 -0500
X-MC-Unique: --Ls4RuFNQewZieokXJ3cg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 884CA1934104;
        Tue,  9 Feb 2021 17:20:31 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17B2A60CD2;
        Tue,  9 Feb 2021 17:20:31 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:20:29 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs_repair: clear the needsrepair flag
Message-ID: <20210209172029.GD14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284383828.3057868.1762356472271947821.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284383828.3057868.1762356472271947821.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:38PM -0800, Darrick J. Wong wrote:
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
>  include/xfs_mount.h |    1 +
>  libxfs/init.c       |   25 +++++++++++++------------
>  repair/agheader.c   |   21 +++++++++++++++++++++
>  repair/xfs_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 80 insertions(+), 12 deletions(-)
> 
> 
...
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 9fe13b8d..98057b78 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -867,25 +867,17 @@ _("%s: Flushing the %s failed, err=%d!\n"),
>  }
>  
>  /*
> - * Flush all dirty buffers to stable storage and report on writes that didn't
> - * make it to stable storage.
> + * Persist all disk write caches and report on writes that didn't make it to
> + * stable storage.  Callers should flush (or purge) the libxfs buffer caches
> + * before calling this function.
>   */
> -static int
> +int
>  libxfs_flush_mount(
>  	struct xfs_mount	*mp)
>  {
>  	int			error = 0;
>  	int			err2;
>  
> -	/*
> -	 * Purge the buffer cache to write all dirty buffers to disk and free
> -	 * all incore buffers.  Buffers that fail write verification will cause
> -	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
> -	 * cannot be written will cause the LOST_WRITE flag to be set in the
> -	 * buftarg.
> -	 */
> -	libxfs_bcache_purge();
> -

FWIW, my comment on the previous version was that I think it's
reasonable to call libxfs_bcache_flush() here instead of the purge so
callers don't necessarily have to do anything special. The one caller
that does the purge is free to do so before calling
libxfs_flush_mount(), as that essentially supercedes the flush that
would otherwise occur here. Either way, the patch looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	/* Flush all kernel and disk write caches, and report failures. */
>  	if (mp->m_ddev_targp) {
>  		err2 = libxfs_flush_buftarg(mp->m_ddev_targp, _("data device"));
> @@ -923,6 +915,15 @@ libxfs_umount(
>  
>  	libxfs_rtmount_destroy(mp);
>  
> +	/*
> +	 * Purge the buffer cache to write all dirty buffers to disk and free
> +	 * all incore buffers.  Buffers that fail write verification will cause
> +	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
> +	 * cannot be written will cause the LOST_WRITE flag to be set in the
> +	 * buftarg.  Once that's done, instruct the disks to persist their
> +	 * write caches.
> +	 */
> +	libxfs_bcache_purge();
>  	error = libxfs_flush_mount(mp);
>  
>  	for (agno = 0; agno < mp->m_maxagi; agno++) {
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 8bb99489..2af24106 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -452,6 +452,27 @@ secondary_sb_whack(
>  			rval |= XR_AG_SB_SEC;
>  	}
>  
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (i == 0) {
> +			if (!no_modify)
> +				do_warn(
> +	_("clearing needsrepair flag and regenerating metadata\n"));
> +			else
> +				do_warn(
> +	_("would clear needsrepair flag and regenerate metadata\n"));
> +		} else {
> +			/*
> +			 * Quietly clear needsrepair on the secondary supers as
> +			 * part of ensuring them.  If needsrepair is set on the
> +			 * primary, it will be cleared at the end of repair
> +			 * once we've flushed all other dirty blocks to disk.
> +			 */
> +			sb->sb_features_incompat &=
> +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +			rval |= XR_AG_SB_SEC;
> +		}
> +	}
> +
>  	return(rval);
>  }
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 32755821..f607afcb 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -712,6 +712,48 @@ check_fs_vs_host_sectsize(
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
> +	libxfs_bcache_flush();
> +	error = -libxfs_flush_mount(mp);
> +	if (error) {
> +		do_warn(
> +	_("Cannot clear needsrepair due to flush failure, err=%d.\n"),
> +			error);
> +		return;
> +	}
> +
> +	/* Clear needsrepair from the superblock. */
> +	bp = libxfs_getsb(mp);
> +	if (!bp || bp->b_error) {
> +		do_warn(
> +	_("Cannot clear needsrepair from primary super, err=%d.\n"),
> +			bp ? bp->b_error : ENOMEM);
> +	} else {
> +		mp->m_sb.sb_features_incompat &=
> +				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +		libxfs_buf_mark_dirty(bp);
> +	}
> +	if (bp)
> +		libxfs_buf_relse(bp);
> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> @@ -1131,6 +1173,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
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

