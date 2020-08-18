Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287F9C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05F9A206B5
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 06:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T08i9Wi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHRGsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 02:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgHRGs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 02:48:26 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1E2C061389
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 23:48:26 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s189so20186038iod.2
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 23:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aA+i6T7COwZYU4EOVaQhsajvVqaSMNWIwTdfe5Embx0=;
        b=T08i9Wi2wnjrz1TFqn9PHGUKGdKFXsW2gGIVozIlwi6Lflkg7sQmlbY97Da8UoE3uU
         /tV/S1PyB6SuMWaiCSXmDo89ZzSjeyRxj7FsLk2d7Ak0bLaVKO6rMT9QYBMJ8Lhg3IA5
         J0TVpmx2JLLgTxJJXeJUOsmCLTOfKPcSEG8bxoxIpOzyegn0UT1mNL1JHB/054tp1lBh
         g2KdpKmnRZxviVQ/2KmHdigGrZJVKaVZo/FXpR4oSlsbHcrIKhxy5y0mbEc+TVD6cJvK
         EWEtZH3L4KUZjnOtMEg3uc0KtaBK2faM+mcCoJCCQc6eDYntnupOSJsTuWMfF+mHGaxM
         UL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aA+i6T7COwZYU4EOVaQhsajvVqaSMNWIwTdfe5Embx0=;
        b=c9gll3oliAW5RUVBj7VXvGgTNYLX9K97vYE7heoSo5xLin9jnjNTVpGO/VjpFDivar
         lM7xhW0UMblcZG7BytVoC1c7VO9wNEm3hdd9n81tjVDMaLWumSuRSDgU4E9ulZgkcdF1
         H8BGSBzeDTezlDiYpD6QPKp/MvmKGffeDSwrnl6/9dsjqON5zm0S9M0DcegdmMjhm3e8
         BvNnX/CN0l3aOPSvSHvqiXZnhTQQLLxxpm02hi3YN/zKfHOzEofhq2PbwGaprXF8Ie4n
         I5jBrPeS6MRCnXRyO4WnR7+eEzXJQ5XA9dvrDek43yedKuOCMDg3DAMfinLse6o9fNie
         OEhA==
X-Gm-Message-State: AOAM531UriPq5VgZM/pbN1eQUwIUs/6rYt9iC8nwfGsZP9zjgTI9+Wmf
        dyp7oKUkf1okv8psKJZsT8aYgosZdXzt0aPD5xJngjcvToM=
X-Google-Smtp-Source: ABdhPJxhPU+CEEBYqKdGqIwDeTZTtId9vbUPdONufCo+bcwyTVLUIax3ukOXt91AXZGRuy0CwyDZXlBU/jUx3qppF+s=
X-Received: by 2002:a02:82c3:: with SMTP id u3mr17901117jag.81.1597733306118;
 Mon, 17 Aug 2020 23:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770502083.3956827.8660123941779980742.stgit@magnolia>
In-Reply-To: <159770502083.3956827.8660123941779980742.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 09:48:14 +0300
Message-ID: <CAOQ4uxiekcHPfyjvJJMBhW-7uSDZ3Gb=Zyu5ZpyKhxz1QmMcnw@mail.gmail.com>
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:59 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Define explicit limits on the range of quota grace period expiration
> timeouts and refactor the code that modifies the timeouts into helpers
> that clamp the values appropriately.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Question below...

...

> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1c542b4a5220..b16d533a6feb 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -483,9 +483,14 @@ xfs_setqlim_timer(
>         struct xfs_quota_limits *qlim,
>         s64                     timer)
>  {
> -       res->timer = timer;
> -       if (qlim)
> +       if (qlim) {
> +               /* Set the length of the default grace period. */
> +               res->timer = timer;
>                 qlim->time = timer;
> +       } else {
> +               /* Set the grace period expiration on a quota. */
> +               xfs_dquot_set_timeout(&res->timer, timer);
> +       }
>  }

I understand why you did this. This is mid series craft, but it looks very odd
to your average reviewer.

Maybe leave a TODO comment above res->timer = timer which will be
removed later in the series?

Not critical.

Thanks,
Amir.
