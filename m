Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29B410E1
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 00:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="di+VAPlB"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d3f8af8297so25052915ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 16:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704934071; x=1705538871; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A+Hk4QyLfFz5zkfAU8rw+RiITCFE8Kxvn51NJlWlNzM=;
        b=di+VAPlB2VB3pmaHAQAlHKTKlHhxN2UBHiMMG2ffjo14l+Mf/sMh9Cc5Gi+9bDtkzU
         tE/2v0clXzCt5knoe5APuVG1oNpCVPS/CA/Ux4iKj58fhz8cJSqpBBR3r/6vgM1uCj6y
         TuArN7WwxyM4FVrHj836B1AhXODz4/J5l+zU67TGd2Uv/6Zonf3Qk+v1jyfEnwG8Rr2d
         WRdddCJrbO6m/nXqZkHD24DK6RmX7rmrUihq6K22RHFulI3/z/Et0p39nDAqZFJYnBWv
         TVfuEdHIcebQAcsJbJz/wINJMymB8dgkJ77aMjdcBNQslT26IT8z6AjDpGfubXSyFIvz
         eOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704934071; x=1705538871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+Hk4QyLfFz5zkfAU8rw+RiITCFE8Kxvn51NJlWlNzM=;
        b=VJLY2hbvOa89sWCBFY9gulSvzetFY3nFanA5JLn5wBExN7M6SVoeNyVorVjPec6ecc
         FUDP0Q5Cn/xeILG6vFKgixUNcXAu3YA29MH3VF0l40fToeua9Jq3hjeIXiZbQuXZTVOY
         D3ks/I8qzPo7vxBV4aPURSdzZ4+HjKscBcfZAfinD394GpHvT9gTJ+Pg0hw7TJpc8DQw
         NAHnEicQq1XRBy2gW453Jbl+PLAnTgHMwYmpivQCke5oAMn/hrheHUA3f1/xbz09OQJa
         Fp1x+Vce2l78Q7rytMmiVRFMSsvSAIyVRbewwkS7dj5KOPTrnOJF9LuZI1dCuQnjaz6Y
         14EQ==
X-Gm-Message-State: AOJu0YyAZwOfzbHww7YmsDMePkoYAjzvkT0Ggpp3mj2138Oa+ZaNCknx
	LyXlFf/6XQj+8OzzEBzWhPeaz9XTqFEOlQ==
X-Google-Smtp-Source: AGHT+IH3+VRxI/431mAz5uer83cKqmNiaraADAcJ+TBISMZYLDFbOhlDr6CFHV4qZaSRW3so6JFPLQ==
X-Received: by 2002:a17:902:8686:b0:1d4:3b8a:6389 with SMTP id g6-20020a170902868600b001d43b8a6389mr261593plo.135.1704934071069;
        Wed, 10 Jan 2024 16:47:51 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id n10-20020a1709026a8a00b001cfc35d1326sm4243030plk.177.2024.01.10.16.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 16:47:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rNjEZ-008jYc-3D;
	Thu, 11 Jan 2024 11:47:48 +1100
Date: Thu, 11 Jan 2024 11:47:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZZ86sxUcO0xUpqno@dread.disaster.area>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228124646.142757-1-leo.lilong@huawei.com>

On Thu, Dec 28, 2023 at 08:46:46PM +0800, Long Li wrote:
> In order to make sure that submits buffers on lsn boundaries in the
> abnormal paths, we need to check error status before submit buffers that
> have been added from the last record processed. If error status exist,
> buffers in the bufffer_list should be canceled.
> 
> Canceling the buffers in the buffer_list directly isn't correct, unlike
> any other place where write list was canceled, these buffers has been
> initialized by xfs_buf_item_init() during recovery and held by buf
> item, buf items will not be released in xfs_buf_delwri_cancel(). If
> these buffers are submitted successfully, buf items assocated with
> the buffer will be released in io end process. So releasing buf item
> in write list cacneling process is needed.

I still don't think this is correct.

> Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_buf.c         |  2 ++
>  fs/xfs/xfs_log_recover.c | 22 +++++++++++++---------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8e5bd50d29fe..6a1b26aaf97e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2075,6 +2075,8 @@ xfs_buf_delwri_cancel(
>  		xfs_buf_lock(bp);
>  		bp->b_flags &= ~_XBF_DELWRI_Q;
>  		xfs_buf_list_del(bp);
> +		if (bp->b_log_item)
> +			xfs_buf_item_relse(bp);
>  		xfs_buf_relse(bp);

I still don't think this is safe.  The buffer log item might still be
tracked in the AIL when the delwri list is cancelled, so the delwri
list cancelling cannot release the BLI without removing the item
from the AIL, too. The delwri cancelling walk really shouldn't be
screwing with AIL state, which means it can't touch the BLIs here.

At minimum, it's a landmine for future users of
xfs_buf_delwri_cancel().  A quick look at the quotacheck code
indicates that it can cancel delwri lists that have BLIs in the AIL
(for newly allocated dquot chunks), so I think this is a real concern.

This is one of the reasons for submitting the delwri list on error;
the IO completion code does all the correct cleanup of log items
including removing them from the AIL because the buffer is now
either clean or stale and no longer needs to be tracked by the AIL.

If the filesystem has been shut down, then delwri list submission
will error out all buffers on the list via IO submission/completion
and do all the correct cleanup automatically.

I note that write IO errors during log recovery will cause immediate
shutdown of the filesytsem via xfs_buf_ioend_handle_error():

	/*
         * We're not going to bother about retrying this during recovery.
         * One strike!
         */
        if (bp->b_flags & _XBF_LOGRECOVERY) {
                xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
                return false;
        }

So I'm guessing that the IO error injection error that caused this
failure was on a buffer read part way through recovering items.

Can you confirm that the failure is only seen after read IO error
injection and that write IO error injection causes immediate
shutdown and so avoids the problem altogether?

If so, then all we need to do to handle instantiation side errors (EIO, ENOMEM,
etc) is this:

	/*
	 * Submit buffers that have been dirtied by the last record recovered.
	 */
	if (!list_empty(&buffer_list)) {
		if (error) {
			/*
			 * If there has been an item recovery error then we
			 * cannot allow partial checkpoint writeback to
			 * occur.  We might have multiple checkpoints with the
			 * same start LSN in this buffer list, and partial
			 * writeback of a checkpoint in this situation can
			 * prevent future recovery of all the changes in the
			 * checkpoints at this start LSN.
			 *
			 * Note: Shutting down the filesystem will result in the
			 * delwri submission marking all the buffers stale,
			 * completing them and cleaning up _XBF_LOGRECOVERY
			 * state without doing any IO.
			 */
			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
		}
		error2 = xfs_buf_delwri_submit(&buffer_list);
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
