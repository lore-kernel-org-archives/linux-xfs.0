Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52412C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 294A4206DA
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:58:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xt6jsDAt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgHRN6t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHRN6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 09:58:47 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ED5C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 06:58:47 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g13so6962620ioo.9
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ztlePRrLBPHMOGudxYsG7ff5drH18M9/ttVCgeJ6Iv0=;
        b=Xt6jsDAtla5O1SNqIcJzFlUuGduOSAVj0ICMm2VYROwU8GiemQgmIjm9ziLjTBdMC/
         Fl7ydHBd57kHHJTO0elDYt7jw2Nuk1I7csM2CdNYnlBSQ8iYjc+6VkH47Z2Jcfor/mND
         u0HrE5TbbiYm3z/1JzPPMhsUeCW+i9tqGhuAMe5zgYz89E5GY23ez9dTWgDXPrHZE17D
         VCckAYcTps/auX3JHuCMR7TFLxKKn4RdvTpxoqKzhiKpaB9VQ8PTiz2AZn+yiRc8/Nui
         fvKIumj64DI3H2y7MbKTmKYsjVpfKehxM+X9rcqs7MlTx7YYL8Q4tsqb/teIlcKguyXo
         B+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ztlePRrLBPHMOGudxYsG7ff5drH18M9/ttVCgeJ6Iv0=;
        b=obtemx5MkAP7VMjmJbQQJ33zOFERm1O4wOBaFtq6XRRu3sHEMlk8ptO2SU6T4mC646
         gjaiQrcbMdSvUseMPZ2rjxQPEkKAL5BVWpJ7aws6LbOXsEUolaC2UCjKD4n+OJPnNYF8
         3mG+iWnVa8ucWtwdrX0+3QXrOvOqDwZ7ARaS7p4DVOdK4AuN5JeoP2Jq7h8annD3Ikai
         vGEZLZUZX2+whiOvwmWpaHhZU9alkrBcaIdvz8rSA4bfKyH3RCh19WHryiEI+RY4D1Lq
         JR15aUkHyhR9ftfy7YDU9t0hHK5sUg38OG0cGpH7XyOkuVc52a503lmJrXApCPsx5cer
         SGpQ==
X-Gm-Message-State: AOAM531nMWc6I7bezkLJYEj1wUWugBHsjlvWN5cXXuqCBUxqFK299RrN
        FtpCD2uy1gjSfAuSBKQyPEtlanKdvh1BIGIZEA4=
X-Google-Smtp-Source: ABdhPJwEFsC4LpmPtsb56kuc1w419gBRojmwHCtk2znnBYd9rdtM2rFpbxmQP6/3OVFEKRlSaN9RDjXt9wZ4mGV+VW0=
X-Received: by 2002:a02:9a05:: with SMTP id b5mr19080979jal.123.1597759126603;
 Tue, 18 Aug 2020 06:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770507160.3956827.6960595082057299697.stgit@magnolia>
In-Reply-To: <159770507160.3956827.6960595082057299697.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 16:58:35 +0300
Message-ID: <CAOQ4uxjMUicQ9202SHuad4W+5QpDeQabNqHCNqV=8ksxNE6Avg@mail.gmail.com>
Subject: Re: [PATCH 10/11] xfs: enable bigtime for quota timers
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Enable the bigtime feature for quota timers.  We decrease the accuracy
> of the timers to ~4s in exchange for being able to set timers up to the
> bigtime maximum.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Minor suggestion below...


> @@ -306,5 +327,24 @@ xfs_dquot_to_disk_timestamp(
>         __be32                  *dtimer,
>         time64_t                timer)
>  {
> +       /* Zero always means zero, regardless of encoding. */
> +       if (!timer) {
> +               *dtimer = cpu_to_be32(0);
> +               return;
> +       }
> +
> +       if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
> +               uint64_t        t = timer;
> +
> +               /*
> +                * Round the end of the grace period up to the nearest bigtime
> +                * interval that we support, to give users the most time to fix
> +                * the problems.
> +                */
> +               t = roundup_64(t, 1U << XFS_DQ_BIGTIME_SHIFT);
> +               *dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);
> +               return;
> +       }
> +
>         *dtimer = cpu_to_be32(timer);
>  }

This suggestion has to do with elegance which is subjective...

/*
 * When bigtime is enabled, we trade a few bits of precision to expand the
 * expiration timeout range to match that of big inode timestamps.  The grace
 * periods stored in dquot 0 are not shifted, since they record an interval,
 * not a timestamp.
 */
#define XFS_DQ_BIGTIME_SHIFT   (2)
#define XFS_DQ_BIGTIME_SLACK ((1U << XFS_DQ_BIGTIME_SHIFT)-1)

               /*
                * Round the end of the grace period up to the nearest bigtime
                * interval that we support, to give users the most time to fix
                * the problems.
                */
               uint64_t        t = timer + XFS_DQ_BIGTIME_SLACK;
               *dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);

Take it or leave it.

Thanks,
Amir.
