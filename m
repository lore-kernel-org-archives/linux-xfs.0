Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EFAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 10:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiEXKrw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 06:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiEXKrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 06:47:51 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F07260AA6
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:47:48 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id v14so14440145qtc.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mUYpErWT/ENGOL6r7dnzJ9kNaD9CmxfzD81AuTe4KI=;
        b=W0qsFXtVvepWx/aZTqh87Uy/ZIpqTx82qL1qxMsa50zAwQJsl5/Ix4kFsGUYbeMxsz
         cttrCXDEQPguF1Ltk//C8pnD0M57npNMAKxoyCCDx/3ZhLDhWU2H7t4P2ks6pKOHRAsW
         9L0arYzgS2QfttpQLGKS/xN6W6OVe9fE7f6HgLX7M/V0Dd1c+JqI1CDlMSoR3ix8XqOK
         cAXGSNKwfsJ+st6e9utjRyZbvB1XDMO4eEFAKPUczDO6HxlDTU8uq5/gFPUEQqOMJ8QX
         kdbauDJYGk41BqnNT2Q5E6/1KZ66xkvtArFsGc0HyBE2SiaaLWNZEXFxw5UoRCz1ct89
         B9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mUYpErWT/ENGOL6r7dnzJ9kNaD9CmxfzD81AuTe4KI=;
        b=JZabZzgdPGwHOdaXwBULQcAMy+Nf5yY6nlj4EuoqamEB64tQjvCMgrZX/u119XdcOy
         hTHF6LjzcyV48IDsVZroaVUgGx8i9+qOdD4FheAhQo9ybWlNR6kKExU+F/LjK8cWmNjt
         lxgd1/wLX8JmBKDIAMDwMbsW54E77eb6m2lUbEE0oU6aKgWeNkr8zEdWmiY3DtMbzIuI
         vo1QSXdG3j/warkxd7ZAEsF2pulXgyKfUikDnYpMzPCN2dhCRoV2NhbSPaNnQmUzza4e
         N7uorJm7/yRe908IbTYnPJ3AOGjRhyZ7gBbE+IhOfq7MixuEq+BYsJo5cIUq6VddK6sR
         f4gg==
X-Gm-Message-State: AOAM531u5WthaPfIFrTSS+2YXyrZK1U2j4iVWQWhAsRopWTLXsPXAoJo
        Ps25eKTSNV4KaKASO7uIAMX8Qx5Uoe4sg3WT5PnvMk5cB1y78Q==
X-Google-Smtp-Source: ABdhPJyWo6fqwaRXTS6Vc/J/wdWa3Iuk3MpSXHbYCcfB5U9KS52/OYg7GYknhzbXCNhNJViROkPYiaQPp//phOCk76Y=
X-Received: by 2002:a05:622a:1a9c:b0:2f3:d873:4acc with SMTP id
 s28-20020a05622a1a9c00b002f3d8734accmr19689652qtc.424.1653389267308; Tue, 24
 May 2022 03:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220524063802.1938505-1-david@fromorbit.com> <20220524063802.1938505-3-david@fromorbit.com>
In-Reply-To: <20220524063802.1938505-3-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 May 2022 13:47:36 +0300
Message-ID: <CAOQ4uxj7q=XpAzPjcC46AUD3cmDzFwKaYsxmQSm=1pzCQrw+wQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Chris Dunlop <chris@onthe.net.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 1:37 PM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> The current blocking mechanism for pushing the inodegc queue out to
> disk can result in systems becoming unusable when there is a long
> running inodegc operation. This is because the statfs()
> implementation currently issues a blocking flush of the inodegc
> queue and a significant number of common system utilities will call
> statfs() to discover something about the underlying filesystem.
>
> This can result in userspace operations getting stuck on inodegc
> progress, and when trying to remove a heavily reflinked file on slow
> storage with a full journal, this can result in delays measuring in
> hours.
>
> Avoid this problem by adding "push" function that expedites the
> flushing of the inodegc queue, but doesn't wait for it to complete.
>
> Convert xfs_fs_statfs() to use this mechanism so it doesn't block
> but it does ensure that queued operations are expedited.
>
> Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> Reported-by: Chris Dunlop <chris@onthe.net.au>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 20 +++++++++++++++-----
>  fs/xfs/xfs_icache.h |  1 +
>  fs/xfs/xfs_super.c  |  7 +++++--
>  fs/xfs/xfs_trace.h  |  1 +
>  4 files changed, 22 insertions(+), 7 deletions(-)
>
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 786702273621..2609825d53ee 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1862,19 +1862,29 @@ xfs_inodegc_worker(
>  }
>
>  /*
> - * Force all currently queued inode inactivation work to run immediately and
> - * wait for the work to finish.
> + * Expedite all pending inodegc work to run immediately. This does not wait for
> + * completion of the work.
>   */
>  void
> -xfs_inodegc_flush(
> +xfs_inodegc_push(
>         struct xfs_mount        *mp)
>  {
>         if (!xfs_is_inodegc_enabled(mp))
>                 return;
> +       trace_xfs_inodegc_push(mp, __return_address);
> +       xfs_inodegc_queue_all(mp);
> +}
>
> +/*
> + * Force all currently queued inode inactivation work to run immediately and
> + * wait for the work to finish.
> + */
> +void
> +xfs_inodegc_flush(
> +       struct xfs_mount        *mp)
> +{
> +       xfs_inodegc_push(mp);
>         trace_xfs_inodegc_flush(mp, __return_address);

Unintentional(?) change of behavior:
trace_xfs_inodegc_flush() will be called in
(!xfs_is_inodegc_enabled(mp)) case.

I also wonder if trace_xfs_inodegc_flush()
should not be before trace_xfs_inodegc_push() in this flow,
but this is just a matter of tracing conventions and you should
know best how it will be convenient for xfs developers to be
reading the trace events stream.

Thanks,
Amir.
