Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CD3C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 12:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23B062083E
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 12:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVo+rN/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0Mby (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 08:31:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47974 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgC0Mby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 08:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585312313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tMwY5OZG7zkXktMIEf9BFpYN8abKS+zV9GcC/UTYALI=;
        b=RVo+rN/6P2h6oe3LFMcR9r7UWfDdzYhJRkvVoOQeRBR3/UcKB9qB0sHrrSOvGwHBLR1nrI
        oPMz/hhVe4KFlu2s5rXU47ujEfcVmmAyv1KVWYPVwjlhyNiPffH6/HD4lm0Pf/JQAPLmEB
        03WsqFQxb3ZBqZfReZFIoL/gp50RL+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Yw-msq4gOA6LTN-DdRA9rA-1; Fri, 27 Mar 2020 08:31:51 -0400
X-MC-Unique: Yw-msq4gOA6LTN-DdRA9rA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80EE71937FE0;
        Fri, 27 Mar 2020 12:31:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 097E85DA75;
        Fri, 27 Mar 2020 12:31:49 +0000 (UTC)
Date:   Fri, 27 Mar 2020 08:31:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't write a corrupt unmount record to force
 summary counter recalc
Message-ID: <20200327123148.GA27785@bfoster>
References: <20200327011417.GF29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327011417.GF29339@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 06:14:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit f467cad95f5e3, I added the ability to force a recalculation of
> the filesystem summary counters if they seemed incorrect.  This was done
> (not entirely correctly) by tweaking the log code to write an unmount
> record without the UMOUNT_TRANS flag set.  At next mount, the log
> recovery code will fail to find the unmount record and go into recovery,
> which triggers the recalculation.
> 
> What actually gets written to the log is what ought to be an unmount
> record, but without any flags set to indicate what kind of record it
> actually is.  This worked to trigger the recalculation, but we shouldn't
> write bogus log records when we could simply write nothing.
> 
> Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c |   27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 46108ca20d85..00fda2e8e738 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -835,19 +835,6 @@ xlog_unmount_write(
>  	if (error)
>  		goto out_err;
>  
> -	/*
> -	 * If we think the summary counters are bad, clear the unmount header
> -	 * flag in the unmount record so that the summary counters will be
> -	 * recalculated during log recovery at next mount.  Refer to
> -	 * xlog_check_unmount_rec for more details.
> -	 */
> -	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
> -			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
> -		xfs_alert(mp, "%s: will fix summary counters at next mount",
> -				__func__);
> -		flags &= ~XLOG_UNMOUNT_TRANS;
> -	}
> -
>  	error = xlog_write_unmount_record(log, tic, &lsn, flags);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
> @@ -913,6 +900,20 @@ xfs_log_unmount_write(
>  
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return;
> +
> +	/*
> +	 * If we think the summary counters are bad, avoid writing the unmount
> +	 * record to force log recovery at next mount, after which the summary
> +	 * counters will be recalculated.  Refer to xlog_check_unmount_rec for
> +	 * more details.
> +	 */
> +	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
> +			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
> +		xfs_alert(mp, "%s: will fix summary counters at next mount",
> +				__func__);
> +		return;
> +	}
> +
>  	xfs_log_unmount_verify_iclog(log);
>  	xlog_unmount_write(log);
>  }
> 

