Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4D4C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763C221744
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SRBN2Qh6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgBYPIN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:08:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728065AbgBYPIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5jhQm4V2YgLi63zeFdibDuJxhJEvdiKT+VQEUQnaXPM=;
        b=SRBN2Qh6uD91xqtzGdZi4f/iT7yc2eyf0SbevKeV6JJeImiDxu9GXEGxGsmFRCLqARn6gV
        eitnR/OVqIodgCT5DdZXhZzD9Y//wShQydRZ7ghL4SPjNTVAOkjVLHSP6Rxzo+3qSxHe7E
        9dyHKI/nPZn+jfAHcTW2cFSZplNYHJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-8qtWfhPgPnai1oyvM8jgEQ-1; Tue, 25 Feb 2020 10:08:09 -0500
X-MC-Unique: 8qtWfhPgPnai1oyvM8jgEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9276801E67;
        Tue, 25 Feb 2020 15:08:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B1465D9E5;
        Tue, 25 Feb 2020 15:08:08 +0000 (UTC)
Date:   Tue, 25 Feb 2020 10:08:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] mkfs: check that metadata updates have been committed
Message-ID: <20200225150805.GB26938@bfoster>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258945969.451075.3231072619586225611.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258945969.451075.3231072619586225611.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:10:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that all the metadata we wrote in the process of formatting
> the filesystem have been written correctly, or exit with failure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  mkfs/xfs_mkfs.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1f5d2105..1038e604 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3940,13 +3940,16 @@ main(
>  	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
>  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  
> -	libxfs_umount(mp);
> +	/* Report failure if anything failed to get written to our new fs. */
> +	error = -libxfs_umount(mp);
> +	if (error)
> +		exit(1);
> +
>  	if (xi.rtdev)
>  		libxfs_device_close(xi.rtdev);
>  	if (xi.logdev && xi.logdev != xi.ddev)
>  		libxfs_device_close(xi.logdev);
>  	libxfs_device_close(xi.ddev);
>  	libxfs_destroy();
> -
>  	return 0;
>  }
> 

