Return-Path: <SRS0=JBSb=7N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5112C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 17:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5AB6206DA
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 17:08:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTP1Kt8B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEaRIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 May 2020 13:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgEaRIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 13:08:11 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64703C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 10:08:11 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q8so4524884iow.7
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 10:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kslATGJ0Qe7K7MjKWwRRmoONJOGiN4WQ150K/1RG/48=;
        b=fTP1Kt8B2JSyuSAuam8nWeqntOAJKGAbbv4Uq2sBJIRcZ5JaFwrP2tyYaRDcKb7pIm
         yWL9rgB3XfNj9fu79x8/lbchB408hHOg9Dg/7BLbySMj5t4lKa/T7xQQN2CwrwG5r6Ke
         VSCV38XXNuVrRX2yRxllqxaeNUJXUM13UKMtSgDAX65PeOhVe4uJBfoDKP0HPReC+W8J
         cWPi27V6UOTkAtCyz3XZhKmBTfKK/C2Ny+yoYV5jNnSVl/Q+yHHQn+DET5yVL5STAfuV
         qsZgDXOp7Rb29+u5pOk5DZ85OVaF+n0ymcdmeWUycGr0macKLvCtjwhpV87syJ2MogS6
         k+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kslATGJ0Qe7K7MjKWwRRmoONJOGiN4WQ150K/1RG/48=;
        b=N/CR5CUfwThUl61v8mcqUGSoJ8o/zmDY2lOhwFr8NIbaiQZ31PulqqttYdV4nebxYF
         NnnNa5moErwh+E6xsdJ8YyJz3Naj8S6Ipxw6fF+TB8c04Y1YRo7OcmmWxo8v3HjLrIr7
         U881sIEO+zYkTGygPPyCfLnpd/hFnMUjRvOKF/a0oCBG9g+kHz1jSDOiguyiHlLbBepj
         YO88i+8sQlZNdn6Cx7Y8+AbrnarQRbohKz8+FUsuT9Knthf2LQNbPN0Fa+irwXxQOD7y
         gymNgcEUrkNsr06PIgihxj7BhhjnawXqaAo+8L2hhzMBFoO0TSRzZXgE/Pz+0WkxB5N9
         jVSw==
X-Gm-Message-State: AOAM532Z/XC+loPNQxCzGBoPoC7hNFSyyby5gwGriO/IRSyljBb3BHsy
        K5kMI9z166GV8cpb43A+tJUsiHzVTsXDKaHaB1Gv5lhL
X-Google-Smtp-Source: ABdhPJwSS72fmaQ4fEmFmcW4FF7YVXFXcGK0K++xkLaLk4qbroHnLAvOaaUJmJUNN2VAhPvXaRaQlpSRTHdPPe0baQ0=
X-Received: by 2002:a02:5184:: with SMTP id s126mr15824767jaa.30.1590944890630;
 Sun, 31 May 2020 10:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia> <157784114490.1364230.7521571821422773694.stgit@magnolia>
In-Reply-To: <157784114490.1364230.7521571821422773694.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 31 May 2020 20:07:59 +0300
Message-ID: <CAOQ4uxgvnuVtfxz41W+FuTxy2GZ5QZwwUhacHgfMzJMKJ_db1g@mail.gmail.com>
Subject: Re: [PATCH 13/14] xfs: enable bigtime for quota timers
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 1, 2020 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Enable the bigtime feature for quota timers.  We decrease the accuracy
> of the timers to ~4s in exchange for being able to set timers up to the
> bigtime maximum.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  |   72 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_format.h     |   22 ++++++++++++
>  fs/xfs/libxfs/xfs_quota_defs.h |   11 ++++--
>  fs/xfs/scrub/quota.c           |    5 +++
>  fs/xfs/xfs_dquot.c             |   71 +++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_ondisk.h            |    6 +++
>  fs/xfs/xfs_qm.c                |   13 ++++---
>  fs/xfs/xfs_qm.h                |    8 ++--
>  fs/xfs/xfs_qm_syscalls.c       |   19 ++++++-----
>  9 files changed, 186 insertions(+), 41 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 72e0fcfef580..2b5d51a6d64b 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -40,6 +40,8 @@ xfs_dquot_verify(
>         xfs_dqid_t              id,
>         uint                    type)   /* used only during quotacheck */
>  {
> +       uint8_t                 dtype;
> +
>         /*
>          * We can encounter an uninitialized dquot buffer for 2 reasons:
>          * 1. If we crash while deleting the quotainode(s), and those blks got
> @@ -60,11 +62,22 @@ xfs_dquot_verify(
>         if (ddq->d_version != XFS_DQUOT_VERSION)
>                 return __this_address;
>
> -       if (type && ddq->d_flags != type)
> +       dtype = ddq->d_flags & XFS_DQ_ALLTYPES;

Suggest dtype = XFS_DQ_TYPE(ddq->d_flags);

[...]

> @@ -540,13 +551,28 @@ xfs_dquot_from_disk(
>         dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
>         dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
>
> -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
> +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_btimer);
>         dqp->q_btimer = tv.tv_sec;
> -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
> +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_itimer);
>         dqp->q_itimer = tv.tv_sec;
> -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
> +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_rtbtimer);
>         dqp->q_rtbtimer = tv.tv_sec;
>
> +       /* Upgrade to bigtime if possible. */
> +       if (xfs_dquot_add_bigtime(dqp->q_mount, iddq)) {
> +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_btimer);
> +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_btimer, &tv);
> +               dqp->q_btimer = tv.tv_sec;
> +
> +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_itimer);
> +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_itimer, &tv);
> +               dqp->q_itimer = tv.tv_sec;
> +
> +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_rtbtimer);
> +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_rtbtimer, &tv);
> +               dqp->q_rtbtimer = tv.tv_sec;
> +       }
> +

This is better than the inode timestamp conversion because at
least the bigtime flag incore is always consistent with the incore values.
But I think it would be safer if the conversion happened inside the helper.

Thanks,
Amir.
