Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713C3C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 07:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53E416139A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 07:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbhESIA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 04:00:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236042AbhESIAy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 04:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621411175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Slk/XuwxK/9gayeUH6u/0wrbQKWj6w71NpJgLO3bVQ=;
        b=BSD73OI7bQROnmH5l9Ys3egcGcsnbNa60UPiC+fbxq4cyOutYgcp9UxNRzR8qKLwGYZmJj
        0X9hhWe38FEHh/y/JB9UmPfZYqdaqa8PxIHz7DQFy0ZCjj2Idtn9nF4eY4oej/1JZqoVSS
        PGn1On9fYAJPOZBnG9Z4f9TEwRjvxz4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-QqOmoHV7MC-y0NHJqzh52g-1; Wed, 19 May 2021 03:59:33 -0400
X-MC-Unique: QqOmoHV7MC-y0NHJqzh52g-1
Received: by mail-wm1-f71.google.com with SMTP id f8-20020a1c1f080000b0290169855914dfso1250028wmf.3
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 00:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=6Slk/XuwxK/9gayeUH6u/0wrbQKWj6w71NpJgLO3bVQ=;
        b=jlDX7lvUZehyprtiKcFrKtkYovBB5zE7F7Bjdwk466ktVltc36KKmlIZUqM7yV0YVo
         pst67rEhjqsJVt86E2idpumGWfvent+oNIfvcsHXJctg/RXUJYEjglu2Ph8xJBM6fU0n
         Ym2TQbRu3x7aiJAovTMFUHWFryGoHB+24n6AJYCGnrmorC61V1MIGm5dMCeaJ3wwla/o
         ohNTqqwB1mNimNL6pYOI+wekFB0H8qW2CG9qguFZB1yugjLIb678ea6QdL5CpqqtnUfj
         dzqQyCJUNswOIPmwBnLUUQL7rPjmn83REfKMtma0m+/BaTLXC83z4/YYMjs77wsPXbwG
         raZg==
X-Gm-Message-State: AOAM53008+4o959BBO0/HwENsi2o1ubXDGxy14e/rQhER7mwx6HDxCMO
        H1K2nnvmARJftTzYwneUa5LC/HJuByQWbvw9NWBgdW7tERIcbK2QelQZc5DCXXb/ThDbbSbV4go
        x0bQL2DiGk5lKBPNP68nO
X-Received: by 2002:adf:e608:: with SMTP id p8mr13157264wrm.162.1621411172174;
        Wed, 19 May 2021 00:59:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb5cAiqZwO09FOLkaAvCfVp+OO5Lf4tdIPPYTftoE0/Lb4NmkM8pyu8uNCM70t476HGND4sA==
X-Received: by 2002:adf:e608:: with SMTP id p8mr13157245wrm.162.1621411171942;
        Wed, 19 May 2021 00:59:31 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id f6sm28465266wru.72.2021.05.19.00.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 00:59:31 -0700 (PDT)
Date:   Wed, 19 May 2021 09:59:29 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210519075929.glb3kdbthuybywcs@omega.lan>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20210519011920.450421-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210519011920.450421-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:19:20AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because this happens at high thread counts on high IOPS devices
> doing mixed read/write AIO-DIO to a single file at about a million
> iops:
> 
>    64.09%     0.21%  [kernel]            [k] io_submit_one
>    - 63.87% io_submit_one
>       - 44.33% aio_write
>          - 42.70% xfs_file_write_iter
>             - 41.32% xfs_file_dio_write_aligned
>                - 25.51% xfs_file_write_checks
>                   - 21.60% _raw_spin_lock
>                      - 21.59% do_raw_spin_lock
>                         - 19.70% __pv_queued_spin_lock_slowpath
> 
> This also happens of the IO completion IO path:
> 
>    22.89%     0.69%  [kernel]            [k] xfs_dio_write_end_io
>    - 22.49% xfs_dio_write_end_io
>       - 21.79% _raw_spin_lock
>          - 20.97% do_raw_spin_lock
>             - 20.10% __pv_queued_spin_lock_slowpath                                                                                                            ▒
> 
> IOWs, fio is burning ~14 whole CPUs on this spin lock.
> 
> So, do an unlocked check against inode size first, then if we are
> at/beyond EOF, take the spinlock and recheck. This makes the
> spinlock disappear from the overwrite fastpath.
> 
> I'd like to report that fixing this makes things go faster.

maybe you meant this does not make things go faster?

> It
> doesn't - it just exposes the the XFS_ILOCK as the next severe
> contention point doing extent mapping lookups, and that now burns
> all the 14 CPUs this spinlock was burning.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

The patch looks good, and the comments about why it's safe to not take the
spinlock (specially why the EOF can't be moved back) is much welcomed.

Feel free to add:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_file.c | 42 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 396ef36dcd0a..c068dcd414f4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -384,21 +384,30 @@ xfs_file_write_checks(
>  		}
>  		goto restart;
>  	}
> +
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> -	 * write.  If zeroing is needed and we are currently holding the
> -	 * iolock shared, we need to update it to exclusive which implies
> -	 * having to redo all checks before.
> +	 * write.  If zeroing is needed and we are currently holding the iolock
> +	 * shared, we need to update it to exclusive which implies having to
> +	 * redo all checks before.
> +	 *
> +	 * We need to serialise against EOF updates that occur in IO completions
> +	 * here. We want to make sure that nobody is changing the size while we
> +	 * do this check until we have placed an IO barrier (i.e.  hold the
> +	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
> +	 * spinlock effectively forms a memory barrier once we have the
> +	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
> +	 * hence be able to correctly determine if we need to run zeroing.
>  	 *
> -	 * We need to serialise against EOF updates that occur in IO
> -	 * completions here. We want to make sure that nobody is changing the
> -	 * size while we do this check until we have placed an IO barrier (i.e.
> -	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
> -	 * The spinlock effectively forms a memory barrier once we have the
> -	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
> -	 * and hence be able to correctly determine if we need to run zeroing.
> +	 * We can do an unlocked check here safely as IO completion can only
> +	 * extend EOF. Truncate is locked out at this point, so the EOF can
> +	 * not move backwards, only forwards. Hence we only need to take the
> +	 * slow path and spin locks when we are at or beyond the current EOF.
>  	 */
> +	if (iocb->ki_pos <= i_size_read(inode))
> +		goto out;
> +
>  	spin_lock(&ip->i_flags_lock);
>  	isize = i_size_read(inode);
>  	if (iocb->ki_pos > isize) {
> @@ -426,7 +435,7 @@ xfs_file_write_checks(
>  			drained_dio = true;
>  			goto restart;
>  		}
> -	
> +
>  		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
>  		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
>  				NULL, &xfs_buffered_write_iomap_ops);
> @@ -435,6 +444,7 @@ xfs_file_write_checks(
>  	} else
>  		spin_unlock(&ip->i_flags_lock);
>  
> +out:
>  	return file_modified(file);
>  }
>  
> @@ -500,7 +510,17 @@ xfs_dio_write_end_io(
>  	 * other IO completions here to update the EOF. Failing to serialise
>  	 * here can result in EOF moving backwards and Bad Things Happen when
>  	 * that occurs.
> +	 *
> +	 * As IO completion only ever extends EOF, we can do an unlocked check
> +	 * here to avoid taking the spinlock. If we land within the current EOF,
> +	 * then we do not need to do an extending update at all, and we don't
> +	 * need to take the lock to check this. If we race with an update moving
> +	 * EOF, then we'll either still be beyond EOF and need to take the lock,
> +	 * or we'll be within EOF and we don't need to take it at all.
>  	 */
> +	if (offset + size <= i_size_read(inode))
> +		goto out;
> +
>  	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode)) {
>  		i_size_write(inode, offset + size);
> -- 
> 2.31.1
> 

-- 
Carlos

