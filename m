Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0023C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 23:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6906561363
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhETXe4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 19:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232547AbhETXez (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 19:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31DC261363;
        Thu, 20 May 2021 23:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621553613;
        bh=JDC1LMC/3h337CCfINJvAE6/Ulw77Vppj6OjkFEwCpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+vEUNbVp7gI+Ic1Kg4OYrKyB6L+9ZUfzaupzlVA0AuBHwTIPYn4rCGOQU9ApmvAR
         AUpUHtOEjUoF4gfQqa+PQtb0YusIFltbmId7v0zT+Al3kHDjJrbRZIIV6UNr8YJosl
         kLdDlJ4qdgC/PxP56gOKbE/k8B8mFE/1fLZHG4mjR4zmUXLjWPmGD4p/B2fuYsvUg4
         GVD13EgNznyRzgaMM61Y28HeG+JG9rqeyRLNj56JnLE9uMQQDvQ+RPC7/TZoUL4NBu
         rlWTHVm1apGBCBPfVcIFlYgW9RBUhtOvv3SAxHfFHYCaIrK7QJXYq3r2k7tEsY9bMK
         MByUaAabHnBZA==
Date:   Thu, 20 May 2021 16:33:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210520233332.GB9675@magnolia>
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

Super long line there.

> 
> IOWs, fio is burning ~14 whole CPUs on this spin lock.
> 
> So, do an unlocked check against inode size first, then if we are
> at/beyond EOF, take the spinlock and recheck. This makes the
> spinlock disappear from the overwrite fastpath.
> 
> I'd like to report that fixing this makes things go faster. It
> doesn't - it just exposes the the XFS_ILOCK as the next severe
> contention point doing extent mapping lookups, and that now burns
> all the 14 CPUs this spinlock was burning.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
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

Is truncate locked out at this point too?  I /think/ it is since we
still hold the iolock (shared or excl) which blocks truncate?

--D

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
