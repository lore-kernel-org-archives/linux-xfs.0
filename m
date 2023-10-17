Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C239CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 23:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjJQX7R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 19:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJQX7Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 19:59:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1119F
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 16:59:14 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1ca816f868fso18950405ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 16:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1697587154; x=1698191954; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mymn6Ev7LT4fkJcLX0h4viDzLu29fSl5aIbbz+46d+E=;
        b=PPrPfsH+c7viVls8zBWgGjLc2ryQiaWYUiFO1541YeEz2pWW72ORSReSquvrSnogjX
         YdNZIggkhDOzrwZThMBfJMhhvaMAnWK2nJs7PdHKBZ7hXgk4IhkJRT8a1MA54qnwdbF9
         dbo7NXFlaPFvLUdDzyBE03IwwA1PwEK7zKFlW7pLsNNKFXGRZ3kj+ghkqfvttANKup+/
         DS6BKgQNt/xgM4q/6MTt3VkyV+lSAzdGxk6VY86UDOh3JA6w1kE31RQDkeDAURpn+5c1
         qDIs8NFPeAn3S9Dmr3HoOhqN2g7iKTwX8Mfwk0uBRwQ55OWnqUHnAZEkhFiR8bFTQm4P
         PtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697587154; x=1698191954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mymn6Ev7LT4fkJcLX0h4viDzLu29fSl5aIbbz+46d+E=;
        b=WML4jIaqOwVyLkYrSgErRTdDMNsGkgGLTLMVy87zGi2/QwfP9g/9gGpGS0B3gY7X40
         mDxnVH8YPgJCKxqZnHKW+IzZJgoJjcUGr4Oa7erMiD+PLJX3u38yfXbV77mBguKhMen3
         6UQrSe3pU2f10lDfxTfA9OPnabwARaO4287CMI7UQ8/evvAS/2YofBdTtwQZXmeckNRj
         OkOf7cbrCgU0NoNdL9egiqplpPSx/8pus5T7TGeBr22joBWhoUqBdPI22+kjKP8xOOLy
         MKyKK2A5gYAAuZj6OgR/YANgvYzYG8LfGUlXeqx17AkewIFEfYQaUx5FNPY8K78R0Lh+
         k5kg==
X-Gm-Message-State: AOJu0Yy7KgOytTIiXsiMEG+oCGStDrZGZfdz5jIwZlqvi1JI+IOrrrHJ
        Tftvgenb0Cxj0UjnfZBdl9hRxQ==
X-Google-Smtp-Source: AGHT+IEtBcy3CzgL0WILfTbC2c+HY12HgrhP6ou+IJsd2Ed+qdM0SO/SEvIfjOlB5hmh4EvYqc4QeQ==
X-Received: by 2002:a17:902:f0d4:b0:1c9:d667:4e77 with SMTP id v20-20020a170902f0d400b001c9d6674e77mr3332139pla.65.1697587154321;
        Tue, 17 Oct 2023 16:59:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090264c900b001c61901ed37sm2196589pli.191.2023.10.17.16.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 16:59:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qstxu-000TwC-0V;
        Wed, 18 Oct 2023 10:59:10 +1100
Date:   Wed, 18 Oct 2023 10:59:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZS8fztyv43GKNdZR@dread.disaster.area>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017201208.18127-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 01:12:08PM -0700, Catherine Hoang wrote:
> One of our VM cluster management products needs to snapshot KVM image
> files so that they can be restored in case of failure. Snapshotting is
> done by redirecting VM disk writes to a sidecar file and using reflink
> on the disk image, specifically the FICLONE ioctl as used by
> "cp --reflink". Reflink locks the source and destination files while it
> operates, which means that reads from the main vm disk image are blocked,
> causing the vm to stall. When an image file is heavily fragmented, the
> copy process could take several minutes. Some of the vm image files have
> 50-100 million extent records, and duplicating that much metadata locks
> the file for 30 minutes or more. Having activities suspended for such
> a long time in a cluster node could result in node eviction.
> 
> Clone operations and read IO do not change any data in the source file,
> so they should be able to run concurrently. Demote the exclusive locks
> taken by FICLONE to shared locks to allow reads while cloning. While a
> clone is in progress, writes will take the IOLOCK_EXCL, so they block
> until the clone completes.
> 
> Link: https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_file.c    | 67 +++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_inode.c   | 17 +++++++++++
>  fs/xfs/xfs_inode.h   |  9 ++++++
>  fs/xfs/xfs_reflink.c |  4 +++
>  4 files changed, 84 insertions(+), 13 deletions(-)

All looks OK - one minor nit below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 203700278ddb..3b9500e18f90 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -214,6 +214,47 @@ xfs_ilock_iocb(
>  	return 0;
>  }
>  
> +static int
> +xfs_ilock_iocb_for_write(
> +	struct kiocb		*iocb,
> +	unsigned int		*lock_mode)
> +{
> +	ssize_t			ret;
> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +
> +	ret = xfs_ilock_iocb(iocb, *lock_mode);
> +	if (ret)
> +		return ret;
> +
> +	if (*lock_mode == XFS_IOLOCK_EXCL)
> +		return 0;
> +	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
> +		return 0;
> +
> +	xfs_iunlock(ip, *lock_mode);
> +	*lock_mode = XFS_IOLOCK_EXCL;
> +	ret = xfs_ilock_iocb(iocb, *lock_mode);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

This last bit could simply be:

	xfs_iunlock(ip, *lock_mode);
	*lock_mode = XFS_IOLOCK_EXCL;
	return xfs_ilock_iocb(iocb, *lock_mode);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
