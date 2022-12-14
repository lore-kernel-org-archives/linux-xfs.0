Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461D2C4167B
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 02:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiLNCHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 21:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiLNCHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 21:07:20 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CC523397
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 18:07:19 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id w26so3489526pfj.6
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 18:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2yada/KnafVNYigK13PoZRgLOYaT3jgGxoabPrfVPI=;
        b=zrS6Feh2bqobhUJ1AuNx78gDRuv1YDU8ME6pKF8quiuD2meqVfF9JxOYp00YAkHr7g
         MzSFOOuLCr6B9QQbpd4pFEic7mzLuEYQ+tiwNuvfQma1HeqtJ2z+zN0DlaFvBTsZ40JX
         XxYczSgkXCbPcZVskLb06orsOW9tjYhof4qBEOv/fdpVLgHeQPVwAON3/aU2FXeDtOb3
         zcWUMFXuEAnTu6mdd5NxvIlfFj1ZpCQTqKg80ceHxkQzVAruESCLonydWKbIuHOMATUD
         /SQasVnPY5ASaB1HU0NGNPrC8gqxWevB1zMruNs7OVYlV8RTTUHG6yn/GnmUwaq6XqNT
         Xfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2yada/KnafVNYigK13PoZRgLOYaT3jgGxoabPrfVPI=;
        b=mWQ2232f34N3ywtY+fNraCKrB7MOxuXX3eQ58pbz+9cmflOCD+i/O0YPhoG5uAXE9x
         J73iw+PGMvKFEinCkjkO/axyAJrJzMaMln2My+u6x9z11EDzo2QHbkydgOa052hr7XM4
         YTYHdOd0iBKQpEB+wJGJP5r/96mEevZ5MvNiDbbzr8Ffc451S/FJKPEBWAzF/ad4cn3/
         KtVaIOhNmRdTxvSZJSzklawgakuZTqhg006e5F8aM6vpCUnDDQZ0tlcwGs4lIIbJkYIa
         BOWQKBgL3yEAmj8hPFtZ2XeqBlYfwlfvF6PatVCvsLOnfxNeM6e6ZJxIc5Iz5Wh3bHWG
         h5SQ==
X-Gm-Message-State: ANoB5pn3JWkII8l3IicyZaO40S/9UX0iiQeIFk4z3cW6lJxHnXzqlO5Q
        hEvctTznyuOMuX6YDTokmFJSjQ==
X-Google-Smtp-Source: AA0mqf6dPRpg7QXDWHEWdtXN8EmtwkQeogIGd1awAxkcU0KwUzPLk7NIZMah4rgqHxbovGcHiYxW3w==
X-Received: by 2002:aa7:95b5:0:b0:576:df1d:423d with SMTP id a21-20020aa795b5000000b00576df1d423dmr25346441pfk.31.1670983638761;
        Tue, 13 Dec 2022 18:07:18 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id x2-20020a628602000000b00576d4d69909sm8285632pfd.8.2022.12.13.18.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 18:07:18 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5HAx-008AfE-Lt; Wed, 14 Dec 2022 13:07:15 +1100
Date:   Wed, 14 Dec 2022 13:07:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 07/11] xfs: disable direct read path for fs-verity
 sealed files
Message-ID: <20221214020715.GG3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-8-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-8-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:31PM +0100, Andrey Albershteyn wrote:
> The direct path is not supported on verity files. Attempts to use direct
> I/O path on such files should fall back to buffered I/O path.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5eadd9a37c50e..fb4181e38a19d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -245,7 +245,8 @@ xfs_file_dax_read(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*to)
>  {
> -	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret = 0;
>  
>  	trace_xfs_file_dax_read(iocb, to);
> @@ -298,10 +299,17 @@ xfs_file_read_iter(
>  
>  	if (IS_DAX(inode))
>  		ret = xfs_file_dax_read(iocb, to);

fsverity is supported on DAX?

Eric, I was under the impression that the DAX io path does not
support fsverity, but I can't see anything that prevents ext4 from
using fsverity on dax enabled filesystems. Does this work (is it
tested regularly?), or is the lack of checking simply an oversight
in that nobody thought to check DAX status when fsverity is enabled?

> -	else if (iocb->ki_flags & IOCB_DIRECT)
> +	else if (iocb->ki_flags & IOCB_DIRECT && !fsverity_active(inode))
>  		ret = xfs_file_dio_read(iocb, to);
> -	else
> +	else {
> +		/*
> +		 * In case fs-verity is enabled, we also fallback to the
> +		 * buffered read from the direct read path. Therefore,
> +		 * IOCB_DIRECT is set and need to be cleared
> +		 */
> +		iocb->ki_flags &= ~IOCB_DIRECT;
>  		ret = xfs_file_buffered_read(iocb, to);
> +	}

Is this IOCB_DIRECT avoidance a limitation of the XFS
implementation, or a generic limitation of the fsverity
infrastructure?

If it's a limitation of the fsverity infrastructure, then we
shouldn't be working around this in every single filesystem that
supports fsverity.  If all the major filesystems are having to check
fsverity_active() and clear IOCB_DIRECT on every single IOCB_DIRECT
IO that is issued on a fsverity inode, then shouldn't we just elide
IOCB_DIRECT from file->f_iocb_flags in the first place?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
