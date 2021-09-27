Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12835C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 15:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC20F60F39
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 15:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhI0PHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234975AbhI0PHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 11:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632755142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fjjwjlac9LThfqDXQCNKZL1bMW2ZwRzeGobYZR24RZc=;
        b=LfB3yTbVGkd9FtZmdQn9a58zlbPUxhZCxjTe1v5lNFPdqWX9MCjgkL39pvfSG+gVcnC0Np
        wC7QtgA9y/QOF9RaABJkD+9Wy7bqRZ7gMosoKWPgsnrlleem0PMjCVwHSdksIUYAMKxiPj
        iD8J+S0vZvBVqq7z41ewzts3okVRNNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-JSK6dttAN3KBkI909fAD5g-1; Mon, 27 Sep 2021 11:05:40 -0400
X-MC-Unique: JSK6dttAN3KBkI909fAD5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77EC3802B9F;
        Mon, 27 Sep 2021 15:05:39 +0000 (UTC)
Received: from redhat.com (unknown [10.22.17.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BBDD719D9D;
        Mon, 27 Sep 2021 15:05:38 +0000 (UTC)
Date:   Mon, 27 Sep 2021 10:05:36 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2 1/2] xfsdump: Revert "xfsdump: handle bind mount
 targets"
Message-ID: <20210927150536.o44njqkdaswmtrf2@redhat.com>
References: <20201103023315.786103-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103023315.786103-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 10:33:14AM +0800, Gao Xiang wrote:
> Bind mount mntpnts will be forbided in the next commits
> instead since it's not the real rootdir.
> 
> This cannot be reverted cleanly due to several cleanup
> patches, but the logic is reverted equivalently.
> 
> This reverts commit 25195ebf107dc81b1b7cea1476764950e1d6cc9d.
> 
> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  dump/content.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/dump/content.c b/dump/content.c
> index 30232d4..c11d9b4 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -1382,17 +1382,10 @@ baseuuidbypass:
>  	}
>  
>  	/* figure out the ino for the root directory of the fs
> -	 * and get its struct xfs_bstat for inomap_build().  This could
> -	 * be a bind mount; don't ask for the mount point inode,
> -	 * find the actual lowest inode number in the filesystem.
> +	 * and get its xfs_bstat_t for inomap_build()
>  	 */
>  	{
>  		stat64_t rootstat;
> -		xfs_ino_t lastino = 0;
> -		int ocount = 0;
> -		struct xfs_fsop_bulkreq bulkreq;
> -
> -		/* Get the inode of the mount point */
>  		rval = fstat64(sc_fsfd, &rootstat);
>  		if (rval) {
>  			mlog(MLOG_NORMAL, _(
> @@ -1404,21 +1397,11 @@ baseuuidbypass:
>  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>  		assert(sc_rootxfsstatp);
>  
> -		/* Get the first valid (i.e. root) inode in this fs */
> -		bulkreq.lastip = (__u64 *)&lastino;
> -		bulkreq.icount = 1;
> -		bulkreq.ubuffer = sc_rootxfsstatp;
> -		bulkreq.ocount = &ocount;
> -		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
> +		if (bigstat_one(sc_fsfd, rootstat.st_ino, sc_rootxfsstatp) < 0) {
>  			mlog(MLOG_ERROR,
>  			      _("failed to get bulkstat information for root inode\n"));
>  			return BOOL_FALSE;
>  		}
> -
> -		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
> -			mlog (MLOG_NORMAL | MLOG_NOTE,
> -			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
> -			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
>  	}
>  
>  	/* alloc a file system handle, to be used with the jdm_open()
> -- 
> 2.18.1
> 

