Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E444C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 06:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKPGCg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 01:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiKPGCe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 01:02:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320D122B09
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 22:02:33 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so1408482pjk.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 22:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K714+99/oT1NLf06mlgtnAfAje2FK6I93/3xxJx7Kgw=;
        b=dyhVvYArzSTUQa8WJgtt2GTPFTtM23XCoyrZWhW6Pc5Ng6rh46LeOc9SmtUq6+umhe
         O3f6pMUke5nwRaeGudYg4x+RbRG4nn4EzPJJrj5BelAO37ngl28j1JKX1kJgbaRilQc2
         l5ljVvkZBSoDWwTNq51fBN/LJbayI5gOQ3fVeRLJ61daTrEoeKVYETtVRXbD0EypzC2T
         hhI2JIziPaFo2HhebdeGDcUiE3MFD82zjzb5LVsGnrf64T58pVY8s5Y50neo5tJxnkkI
         mSf6WFjTlsfG+uSutMGqgHa2akV0OZ83xRHLuSJrexVdo9tcqGNnpl42QuhlUB6d9XXb
         fU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K714+99/oT1NLf06mlgtnAfAje2FK6I93/3xxJx7Kgw=;
        b=C88uwuV/u0SPKtDU/tnR9SopXitCRWmH6GAz68aCZME1Ef81z5oq/UUeYZSQLUKOWU
         JniNDFIGyNHK891aPSR92mvYWKKSTbwwLuOJtlI9uFWQWwMk4d5fWiCyDv3HL9mJky19
         rdn+TqGf4ZOzi/1gsIiF52Cz0S4D0I3S0hi5oGIBmmkmx74YwP6ongJiTv1SkVYb0P7/
         Ls0w9dB6YtmXcZDeRWibJVJ0LMKMZYBz7QBZ26Awh6+rEU6DFDkKjysW2UcK5PKURLvy
         zwEbXrPbFhSbZ33XV5HtL7wVI4RwuhRmQLKdZm5q9H/pqjGAK29dap5fh1SkbCY3Lzlo
         I2BQ==
X-Gm-Message-State: ANoB5pnK3p+Jg8q1k5WGf+9G3cIFPbQwTV06E6qnM8yNRpKZ+zehNr3K
        Oo+va2OAE9NhI7uBKBLwXOMJkw==
X-Google-Smtp-Source: AA0mqf4usT1DIWKRfxdHYarKeUBVgsEbXTIy6sSvku9rd0Z8QXzVt5BpJGrf7iQmsdsadUsF/+I06g==
X-Received: by 2002:a17:902:9a01:b0:186:c090:fc56 with SMTP id v1-20020a1709029a0100b00186c090fc56mr7551038plp.99.1668578552663;
        Tue, 15 Nov 2022 22:02:32 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id x3-20020aa78f03000000b0056c3a0dc65fsm9806551pfr.71.2022.11.15.22.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 22:02:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ovBVF-00EnIH-Fb; Wed, 16 Nov 2022 17:02:29 +1100
Date:   Wed, 16 Nov 2022 17:02:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, djwong@kernel.org, fangwei1@huawei.com,
        houtao1@huawei.com, jack.qiu@huawei.com, leo.lilong@huawei.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        zengheng4@huawei.com, zhengbin13@huawei.com
Subject: Re: [PATCH v3 1/2] xfs: wait xlog ioend workqueue drained before
 tearing down AIL
Message-ID: <20221116060229.GC3600936@dread.disaster.area>
References: <20221107142716.1476166-2-guoxuenan@huawei.com>
 <20221108140605.1558692-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108140605.1558692-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2022 at 10:06:05PM +0800, Guo Xuenan wrote:
> Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
> In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
> xlog_state_shutdown_callbacks") changed the order of running callbacks
> and wait for iclog completion to avoid unmount path untimely destroy AIL.
> But which seems not enough to ensue this, adding mdelay in
> `xfs_buf_item_unpin` can prove that.
> 
> The reproduction is as follows. To ensure destroy AIL safely,
> we should wait all xlog ioend workers done and sync the AIL.

Like Darrick, I didn't see this either because it's in an old
thread....
>  fs/xfs/xfs_log.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f02a0dd522b3..467bac00951c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -82,6 +82,9 @@ STATIC int
>  xlog_iclogs_empty(
>  	struct xlog		*log);
>  
> +static void
> +xlog_wait_iodone(struct xlog *log);
> +

Why do we need a forward prototype definition?

>  static int
>  xfs_log_cover(struct xfs_mount *);
>  
> @@ -886,6 +889,23 @@ xlog_force_iclog(
>  	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
>  }
>  
> +/*
> + * Cycle all the iclogbuf locks to make sure all log IO completion
> + * is done before we tear down AIL/CIL.
> + */
> +static void
> +xlog_wait_iodone(struct xlog *log)
> +{
> +	int		i;
> +	xlog_in_core_t	*iclog = log->l_iclog;
> +
> +	for (i = 0; i < log->l_iclog_bufs; i++) {
> +		down(&iclog->ic_sema);
> +		up(&iclog->ic_sema);
> +		iclog = iclog->ic_next;
> +	}
> +}

This doesn't guarantee no iclog IO is in progress, just that it
waited for each iclog to finish any IO it had in progress. If we are
in a normal runtime condition, xfs_log_force(mp, XFS_LOG_SYNC)
performs this "wait for journal IO to complete" integrity operation.

Which, in normal runtime unmount operation, we get from
xfs_log_cover().....

> +
>  /*
>   * Wait for the iclog and all prior iclogs to be written disk as required by the
>   * log force state machine. Waiting on ic_force_wait ensures iclog completions
> @@ -1276,6 +1296,12 @@ xfs_log_cover(
>  		xfs_ail_push_all_sync(mp->m_ail);
>  	} while (xfs_log_need_covered(mp));
>  
> +	/*
> +	 * Cycle all the iclogbuf locks to make sure all log IO completion
> +	 * is done before we tear down AIL.
> +	 */
> +	xlog_wait_iodone(mp->m_log);

.... and so this call is redundant for normal runtime log quiesce
operations.  That's because the synchronous transaction run in this
loop:

       do {
>>>>>>          error = xfs_sync_sb(mp, true);
                if (error)
                        break;
                xfs_ail_push_all_sync(mp->m_ail);
        } while (xfs_log_need_covered(mp));

causes a xfs_log_force(mp, XFS_LOG_SYNC) to be issued to force the
transaction to disk and it *waits for the journal IO to complete.
Further, it is iclog IO completion that moves the log covered state
forwards, so this loop absolutely relies on the journal IO being
fully completed and both the CIL and AIL being empty before it will
exit.

Hence adding xlog_wait_iodone() here would only have an effect if
the log had been shut down. however, we never get here if the log
has been shut down because the xfs_log_writable(mp) check at the
start of xfs_log_cover() will fail. Hence we return without trying
to cover the log or wait for iclog completion.

IOWs, I don't see how this code does anything to avoid the problem
that has been described - if the iclog callback runs the shutdown,
by the time it gets to running shutdown callbacks it's already
marked both the log and the mount as shut down, so unmount will
definitely not run this code and so will not wait for the iclog
running shutdown callbacks during IO completion....

----

Really, the only place this iclog walk matters is in the unmount
path prior to tearing down internal structures, and it only matters
when ths filesystem has been shut down. That means it needs
to be a part of xfs_log_unmount(), not part of the normal runtime
freeze/remount readonly/unmount log quiescing.

If we are shut down, then we have to guarantee that we've
finished processing the iclogs before we tear down the things that
use log items - the CIL, the AIL, the iclogs themselves, etc. It
*must* also run in the shutdown case, so it can't be put in a
function that is conditional on a normal running filesystem.
Something like this:

 void
 xfs_log_unmount(
         struct xfs_mount        *mp)
 {
        xfs_log_clean(mp);

+	/*
+	 * If shutdown has come from iclog IO context, the log
+	 * cleaning will have been skipped and so we need to wait
+	 * for ithe iclog to complete shutdown processing before we
+	 * tear anything down.
+	 */
+	xfs_iclog_iodone_wait(mp->m_log);
        xfs_buftarg_drain(mp->m_ddev_targp);

And the iclog walk can be removed from xlog_dealloc_log() as we've
already done the checks it needs before tearing down the iclogs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
