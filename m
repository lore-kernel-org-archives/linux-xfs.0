Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB58CC4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 09:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC4123F37
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 09:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390126AbgLKJaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 04:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405629AbgLKJ3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 04:29:35 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26C6C0613CF
        for <linux-xfs@vger.kernel.org>; Fri, 11 Dec 2020 01:28:54 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id lj6so501692pjb.0
        for <linux-xfs@vger.kernel.org>; Fri, 11 Dec 2020 01:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u5RY3uToIQUfzkmsXDCHP9TJSZ1jiYnmnIcL9t7vCzM=;
        b=qi/NpO3WpXHCTbzWKJM8mn5+SdJkXIK13Y6XnmJKQOHCFdL8NDp0GnRuPWPSrgqCpc
         UBTqjhjCydwf8NY9ervJ2Vsi/Ek3K5zccJwmxsxBNS/CqVAEVZH/YYRAgr7UvikSb/nA
         ptFO9Qap7ViR4fUvb0ChSkZuT8OsY/HeF5nY28SnkV+yBuiQpEJl2uMG1+Sgb1PeT7U3
         1s1cafooQb1iDFkoSVI1mj7TqqNzyyJbTgLV6M3oxqpmeMFWGSdJUEIiOru3pHbTAgil
         ct3A6MR8srseuyuOT23Enk1W6DgCY7b9XjeeBpy7FNIgQwlADKfxM+E8Q1w7vhO4tvAF
         xTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u5RY3uToIQUfzkmsXDCHP9TJSZ1jiYnmnIcL9t7vCzM=;
        b=i0Ut4jOF8Gh31KbNv+P6MT2Jadi2+jin+4d/S2xwDaL4azkPJx7nSnofQ6zzrlGCrP
         4rLZ9uK/UbDVsUWN/PD/IujxrKOqJUgXuVL9nSwu+RMyiAVOUY8BU2Ffh1UMZGmwv6oC
         cmUV6WZcEMyhX7W+ip/b+U5XukcS/qHTf9HwC7nr1mkyIaJuarJP00q0GRznyedNnb6G
         fXJGjBaZj6JTVVJoVrj1+YEEEKQQV/qrVc/7FQROb0Xd6HOHgaA5hZ8YLTb81rIWNUM1
         iecuxWAgEYjeAm04z5V9aJnkNKud3VqoYEG7E+xxs8P1/eBlITQYZuNY2ijtBAxZAaON
         9m0w==
X-Gm-Message-State: AOAM532KrqiSkYMd5EPlv+VOZ4n1FhgAYihN1VlgXa3chr6FSjYNsWom
        LKaYaL4it9T2Vd7FaILaOBEoZXLcHGI=
X-Google-Smtp-Source: ABdhPJzUvIqvjFDK38d+CfZXdqnp8jdFlxqZavFDI10EhMbyYNfQ0PQY2XKz86eHN2wDee+X9BTXsw==
X-Received: by 2002:a17:90a:c905:: with SMTP id v5mr12349662pjt.183.1607678934389;
        Fri, 11 Dec 2020 01:28:54 -0800 (PST)
Received: from garuda.localnet ([122.167.39.189])
        by smtp.gmail.com with ESMTPSA id a22sm9568741pfa.215.2020.12.11.01.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 01:28:53 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't drain buffer lru on freeze and read-only remount
Date:   Fri, 11 Dec 2020 14:58:51 +0530
Message-ID: <5058397.6zluo7qbvW@garuda>
In-Reply-To: <20201210144607.1922026-3-bfoster@redhat.com>
References: <20201210144607.1922026-1-bfoster@redhat.com> <20201210144607.1922026-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 10 Dec 2020 09:46:07 -0500, Brian Foster wrote:
> xfs_buftarg_drain() is called from xfs_log_quiesce() to ensure the
> buffer cache is reclaimed during unmount. xfs_log_quiesce() is also
> called from xfs_quiesce_attr(), however, which means that cache
> state is completely drained for filesystem freeze and read-only
> remount. While technically harmless, this is unnecessarily
> heavyweight. Both freeze and read-only mounts allow reads and thus
> allow population of the buffer cache. Therefore, the transitional
> sequence in either case really only needs to quiesce outstanding
> writes to return the filesystem in a generally read-only state.
> 
> Additionally, some users have reported that attempts to freeze a
> filesystem concurrent with a read-heavy workload causes the freeze
> process to stall for a significant amount of time. This occurs
> because, as mentioned above, the read workload repopulates the
> buffer LRU while the freeze task attempts to drain it.
> 
> To improve this situation, replace the drain in xfs_log_quiesce()
> with a buffer I/O quiesce and lift the drain into the unmount path.
> This removes buffer LRU reclaim from freeze and read-only [re]mount,
> but ensures the LRU is still drained before the filesystem unmounts.
>

One change that the patch causes is that xfs_log_unmount_write() is now
invoked while xfs_buf cache is still populated (though none of the xfs_bufs
would be undergoing I/O). However, I don't see this causing any erroneous
behaviour. Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 20 +++++++++++++++-----
>  fs/xfs/xfs_buf.h |  1 +
>  fs/xfs/xfs_log.c |  6 ++++--
>  3 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index db918ed20c40..d3fce3129f6e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1815,14 +1815,13 @@ xfs_buftarg_drain_rele(
>  	return LRU_REMOVED;
>  }
>  
> +/*
> + * Wait for outstanding I/O on the buftarg to complete.
> + */
>  void
> -xfs_buftarg_drain(
> +xfs_buftarg_wait(
>  	struct xfs_buftarg	*btp)
>  {
> -	LIST_HEAD(dispose);
> -	int			loop = 0;
> -	bool			write_fail = false;
> -
>  	/*
>  	 * First wait on the buftarg I/O count for all in-flight buffers to be
>  	 * released. This is critical as new buffers do not make the LRU until
> @@ -1838,6 +1837,17 @@ xfs_buftarg_drain(
>  	while (percpu_counter_sum(&btp->bt_io_count))
>  		delay(100);
>  	flush_workqueue(btp->bt_mount->m_buf_workqueue);
> +}
> +
> +void
> +xfs_buftarg_drain(
> +	struct xfs_buftarg	*btp)
> +{
> +	LIST_HEAD(dispose);
> +	int			loop = 0;
> +	bool			write_fail = false;
> +
> +	xfs_buftarg_wait(btp);
>  
>  	/* loop until there is nothing left on the lru list. */
>  	while (list_lru_count(&btp->bt_lru)) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index ea32369f8f77..96c6b478e26e 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -347,6 +347,7 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  extern struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *,
>  		struct block_device *, struct dax_device *);
>  extern void xfs_free_buftarg(struct xfs_buftarg *);
> +extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
>  extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5ad4d5e78019..46ea4017fcec 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -936,13 +936,13 @@ xfs_log_quiesce(
>  
>  	/*
>  	 * The superblock buffer is uncached and while xfs_ail_push_all_sync()
> -	 * will push it, xfs_buftarg_drain() will not wait for it. Further,
> +	 * will push it, xfs_buftarg_wait() will not wait for it. Further,
>  	 * xfs_buf_iowait() cannot be used because it was pushed with the
>  	 * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait for
>  	 * the IO to complete.
>  	 */
>  	xfs_ail_push_all_sync(mp->m_ail);
> -	xfs_buftarg_drain(mp->m_ddev_targp);
> +	xfs_buftarg_wait(mp->m_ddev_targp);
>  	xfs_buf_lock(mp->m_sb_bp);
>  	xfs_buf_unlock(mp->m_sb_bp);
>  
> @@ -962,6 +962,8 @@ xfs_log_unmount(
>  {
>  	xfs_log_quiesce(mp);
>  
> +	xfs_buftarg_drain(mp->m_ddev_targp);
> +
>  	xfs_trans_ail_destroy(mp);
>  
>  	xfs_sysfs_del(&mp->m_log->l_kobj);
> 


-- 
chandan



