Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB7DC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 16:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD452073D
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 16:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5rMDM/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCFQMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:12:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbgCFQMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 11:12:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583511161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KqfbwDN0gWd3+PqjyVHbdt9LhdciRCyxa2u+KydWisQ=;
        b=A5rMDM/KdPy0FUueEXZNvaMUe4+Ax3WN7GxoBUK8zckhtH447MuiETHSiPd5sqjVrhv9/W
        a2m2CoNQ2wu8srvVlQpw4FEjjux0ZJK8CkO9gXP4MoxAD21psj98g2d3e/6JG2PAYSOptk
        3l/wfHN0Hyk6WnOCC6UU+qwTdC5uAv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-c5U9xyktMombLUHvRjuulA-1; Fri, 06 Mar 2020 11:12:40 -0500
X-MC-Unique: c5U9xyktMombLUHvRjuulA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F5D3800D50;
        Fri,  6 Mar 2020 16:12:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA85819C69;
        Fri,  6 Mar 2020 16:12:38 +0000 (UTC)
Date:   Fri, 6 Mar 2020 11:12:37 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] xfs: cleanup xfs_log_unmount_write
Message-ID: <20200306161237.GF2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:33AM -0700, Christoph Hellwig wrote:
> Move the code for verifying the iclog state on a clean unmount into a
> helper, and instead of checking the iclog state just rely on the shutdown
> check as they are equivalent.  Also remove the ifdef DEBUG as the
> compiler is smart enough to eliminate the dead code for non-debug builds.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b56432d4a9b8..89f2e68eb570 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -946,6 +946,18 @@ xfs_log_write_unmount_record(
>  	}
>  }
>  
> +static void
> +xfs_log_unmount_verify_iclog(
> +	struct xlog	 	*log)
> +{
> +	struct xlog_in_core	 *iclog = log->l_iclog;
> +
> +	do {
> +		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +		ASSERT(iclog->ic_offset == 0);
> +	} while ((iclog = iclog->ic_next) != log->l_iclog);
> +}
> +
>  /*
>   * Unmount record used to have a string "Unmount filesystem--" in the
>   * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
> @@ -954,13 +966,10 @@ xfs_log_write_unmount_record(
>   * As far as I know, there weren't any dependencies on the old behaviour.
>   */
>  static void
> -xfs_log_unmount_write(xfs_mount_t *mp)
> +xfs_log_unmount_write(
> +	struct xfs_mount	*mp)
>  {
> -	struct xlog	 *log = mp->m_log;
> -	xlog_in_core_t	 *iclog;
> -#ifdef DEBUG
> -	xlog_in_core_t	 *first_iclog;
> -#endif
> +	struct xlog	 	*log = mp->m_log;
>  
>  	/*
>  	 * Don't write out unmount record on norecovery mounts or ro devices.
> @@ -974,18 +983,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -#ifdef DEBUG
> -	first_iclog = iclog = log->l_iclog;
> -	do {
> -		if (iclog->ic_state != XLOG_STATE_IOERROR) {
> -			ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> -			ASSERT(iclog->ic_offset == 0);
> -		}
> -		iclog = iclog->ic_next;
> -	} while (iclog != first_iclog);
> -#endif
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return;
> +	xfs_log_unmount_verify_iclog(log);
>  	xfs_log_write_unmount_record(mp);
>  }
>  
> -- 
> 2.24.1
> 

