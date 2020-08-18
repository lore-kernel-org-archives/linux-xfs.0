Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E93C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 12:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB71220786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 12:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECOAcP5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHRMBG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHRMBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 08:01:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F7CC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 05:01:01 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p13so17337811ilh.4
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3l2MEZmF5bn+Wsu2kK/TGD68wHKDxPP+TH25U5JBvjc=;
        b=ECOAcP5Mp+tQeYK2IHxPZRbtAMUI16dz4/ayDYvqkSa8a7H3d2s5yVvbZT60len0Ki
         E17YU8JqDksUWxMyl6tajONultlEuN/6VUnfV+SOhLLsfktoTbCKTX9vPP6cWuKLui4i
         Amc7OpAsq+7DKEo8vkDWmDMrHe/LbuFdckMJr+2cQTkVSOCZjsimxtabI4D+TNlNgU05
         r2xWy7WbYaJWwpwp63X72TMoZqWufjxChbNJgi6RJipNOK+FXPUU8tXyMvBrMtuCnZkT
         b9qhaL4JxcQT7awRk0XoXA70g/rt65uv0u2FvCMT7cZtN8CVwvIIt9TjPAbxkkl4jp+w
         CrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3l2MEZmF5bn+Wsu2kK/TGD68wHKDxPP+TH25U5JBvjc=;
        b=BqRvBZkxBJSz1764dA+rXLthtX1SQeU6JYGoXMQcYbRwWL0RbVDq6to6UDm7zDJ1Oz
         n8FWJaIOCS0tmT3EbRj99J37u0siRJjhZCBhwuC4bKQiAoymOkp6R3CQjgQJHxerGUC9
         DKw2yp+TQhmeITBY7jCfFGL1UYrWthqWYzWby23C6oVT15Jcmv3HcU9kvl6LQDdcd+5k
         rJ5udFmCTVfPyzOjQjyxVAuMjFxRhgbz65VUjsDgYt3qG+QKix1P3ylnvVlJAQp9Tpbl
         TqKci4JSMrHQWIr2joHZfur8xQn5YK4SZUwmcV1dkKDHMJ1kW7RL9bjVkmXAa7+r+fnj
         ee1w==
X-Gm-Message-State: AOAM530ExOrPa/zCKXg+ZnWFn0Ktq4DA7HMzdnv/6SxCrNRX+Z9ux/LO
        oNIVzHbEo9qacNowG2BIVQhhAvyD9HDoz2N7WXQ=
X-Google-Smtp-Source: ABdhPJyE+2B1nSOFBzhBg5/jrb0dzmCsMfRjQLsnbAjwdBooW2b+w9Yk4voGaCLCHSimpH9JH/dAnx1PRp89aQtuwIs=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr18100631ilf.250.1597752060672;
 Tue, 18 Aug 2020 05:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770505894.3956827.5973810026298120596.stgit@magnolia>
In-Reply-To: <159770505894.3956827.5973810026298120596.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 15:00:49 +0300
Message-ID: <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
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
> Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> time epoch).  This enables us to handle dates up to 2486, which solves
> the y2038 problem.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
...

> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 9f036053fdb7..b354825f4e51 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -190,6 +190,11 @@ xchk_inode_flags2(
>         if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
>                 goto bad;
>
> +       /* the incore bigtime iflag always follows the feature flag */
> +       if (!!xfs_sb_version_hasbigtime(&mp->m_sb) ^
> +           !!(flags2 & XFS_DIFLAG2_BIGTIME))
> +               goto bad;
> +

Seems like flags2 are not the incore iflags and that the dinode iflags
can very well
have no bigtime on fs with bigtime support:

xchk_dinode(...
...
                flags2 = be64_to_cpu(dip->di_flags2);

What am I missing?

Thanks,
Amir.
