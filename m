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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE460C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 12:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99ED164F54
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 12:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBBMC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 07:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBBMCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 07:02:21 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FFAC0613D6
        for <linux-xfs@vger.kernel.org>; Tue,  2 Feb 2021 04:01:41 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id m6so14192478pfk.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Feb 2021 04:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9Elq8hmCZzS3vWUKXd7rOVUX4T0XG8HWeaKl9SHLJjE=;
        b=fJS90jFYDiH+7RpSQLmF99NB9asC18RZQ318/XDDoMjDFKMb1iDuAyDLoZ84B8QMhA
         4ojtkJKnJlQUd9bwtEyHXWIhOwcXoICiUBPoIMvHPtGzf692GxQBZKSdF6Uw0fqdF53u
         INttfcm8uVmX73al33i4VCg+SaQjDvvbq5b0QbuIYBak67oFk9Sv7zPZTp6v9p38oU5a
         D7TDAas6k+wBxHZdP/R2vEvtcnsdMThoPGFPzNHCsPVXLuMVpVerDTgZGVCX2TFyHlR/
         yefjdkpSr/klYhR5+UvyVvyioXiscB6TzX1N9CIIm5MIlGp1agg8KdcjRObXXrnLj/5g
         0UJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=9Elq8hmCZzS3vWUKXd7rOVUX4T0XG8HWeaKl9SHLJjE=;
        b=GRnrY38Z7YfjbPIMhth5twYnJ5mdXF1Fx2Vsf+tnjvK6SJQXKueooQVCK24d65eXXq
         5wzIl26lUOAP7WNGlGw4OO6deHXKTcnPUC4uO0rEmCItB9ccnGukCkBg/mBGcVHAzXye
         Py7kknaK1IfphN3Y/9fuRAhYhTxaPPLkgUyRvDNBhLkuMvnPQgtW8ofO4pvZiHlckI9u
         c+cKmdpY2qoeXMRLotkRKnP/f1o5PPfNPx42PE30tlVXLGYE1/yPrpxFL3JOwUE6dWkk
         JHOTACU8ku4A7eZ2CMQmkgKxFdyBAloC+xFAccdqC5ZHx6dH66BajSaE6yGjCcHNDae6
         UKQw==
X-Gm-Message-State: AOAM531azXLHgGsCyyGiGzaIdJkQrNSGxw3G30QgHZY6ZdVcV0wvYYCW
        TkBlsFw2miwZL5IibR5vMRUh66e9VFA=
X-Google-Smtp-Source: ABdhPJzlrl6dGh2GPBphl3xZ4A1LH1PrrCb3ML4P/0tDEtpflBXi0P1NzOzrZAEtuI5WQjrCz0riTw==
X-Received: by 2002:a65:4288:: with SMTP id j8mr21429404pgp.346.1612267300463;
        Tue, 02 Feb 2021 04:01:40 -0800 (PST)
Received: from garuda ([122.167.157.84])
        by smtp.gmail.com with ESMTPSA id fh15sm2754156pjb.32.2021.02.02.04.01.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Feb 2021 04:01:40 -0800 (PST)
References: <20210128044154.806715-1-david@fromorbit.com> <20210128044154.806715-6-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reduce buffer log item shadow allocations
In-reply-to: <20210128044154.806715-6-david@fromorbit.com>
Date:   Tue, 02 Feb 2021 17:31:37 +0530
Message-ID: <87im7an0f2.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jan 2021 at 10:11, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> When we modify btrees repeatedly, we regularly increase the size of
> the logged region by a single chunk at a time (per transaction
> commit). This results in the CIL formatting code having to
> reallocate the log vector buffer every time the buffer dirty region
> grows. Hence over a typical 4kB btree buffer, we might grow the log
> vector 4096/128 =3D 32x over a short period where we repeatedly add
> or remove records to/from the buffer over a series of running
> transaction. This means we are doing 32 memory allocations and frees
> over this time during a performance critical path in the journal.
>
> The amount of space tracked in the CIL for the object is calculated
> during the ->iop_format() call for the buffer log item, but the
> buffer memory allocated for it is calculated by the ->iop_size()
> call. The size callout determines the size of the buffer, the format
> call determines the space used in the buffer.
>
> Hence we can oversize the buffer space required in the size
> calculation without impacting the amount of space used and accounted
> to the CIL for the changes being logged. This allows us to reduce
> the number of allocations by rounding up the buffer size to allow
> for future growth. This can safe a substantial amount of CPU time in
> this path:
>
> -   46.52%     2.02%  [kernel]                  [k] xfs_log_commit_cil
>    - 44.49% xfs_log_commit_cil
>       - 30.78% _raw_spin_lock
>          - 30.75% do_raw_spin_lock
>               30.27% __pv_queued_spin_lock_slowpath
>
> (oh, ouch!)
> ....
>       - 1.05% kmem_alloc_large
>          - 1.02% kmem_alloc
>               0.94% __kmalloc
>
> This overhead here us what this patch is aimed at. After:
>
>       - 0.76% kmem_alloc_large                                           =
                                                                           =
                =E2=96=92
>          - 0.75% kmem_alloc                                              =
                                                                           =
                =E2=96=92
>               0.70% __kmalloc                                            =
                                                                           =
                =E2=96=92

Apart from the trailing whitespace above,

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 17960b1ce5ef..0628a65d9c55 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -142,6 +142,7 @@ xfs_buf_item_size(
>  {
>  	struct xfs_buf_log_item	*bip =3D BUF_ITEM(lip);
>  	int			i;
> +	int			bytes;
>=20=20
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	if (bip->bli_flags & XFS_BLI_STALE) {
> @@ -173,7 +174,7 @@ xfs_buf_item_size(
>  	}
>=20=20
>  	/*
> -	 * the vector count is based on the number of buffer vectors we have
> +	 * The vector count is based on the number of buffer vectors we have
>  	 * dirty bits in. This will only be greater than one when we have a
>  	 * compound buffer with more than one segment dirty. Hence for compound
>  	 * buffers we need to track which segment the dirty bits correspond to,
> @@ -181,10 +182,18 @@ xfs_buf_item_size(
>  	 * count for the extra buf log format structure that will need to be
>  	 * written.
>  	 */
> +	bytes =3D 0;
>  	for (i =3D 0; i < bip->bli_format_count; i++) {
>  		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> -					  nvecs, nbytes);
> +					  nvecs, &bytes);
>  	}
> +
> +	/*
> +	 * Round up the buffer size required to minimise the number of memory
> +	 * allocations that need to be done as this item grows when relogged by
> +	 * repeated modifications.
> +	 */
> +	*nbytes =3D round_up(bytes, 512);
>  	trace_xfs_buf_item_size(bip);
>  }


--=20
chandan
