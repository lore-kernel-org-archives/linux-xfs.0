Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CE4EB64DC
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Jun 2023 18:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjFXSZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Jun 2023 14:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjFXSZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Jun 2023 14:25:49 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3F51BC1
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jun 2023 11:25:44 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-62ffe4cabc0so14033986d6.1
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jun 2023 11:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687631143; x=1690223143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nAqmTGl3Ar509uWL5B5CVIqe/ep4FsCEtSXfox80pks=;
        b=MehdBcZzo+oJ4VFph4S12dbzN6HO0+hty4E/cQszBZWhR7o1e3fnajIX6MbEZf6tYy
         5xW5voWXJiqu+ubAYgCzCQQmIy3V54W2SrQ19stz3zSqfQE9sn5cRGd7yEpms2LKJD8+
         jIxQpNr9AxeKt29KV2AyFwW94hNXdmV5XlAq0JP9KruORckL0FGACEl5gqI/2JvcYbDx
         xAmo0+HeY5jcsqt9T+0ninL/+gCEH50LXQV9ycVtFiBma6zi1fYXmHAkylxBqETKJWkx
         iaXre6lYFkBgXoSH6u4OLG3rSUMoL8gFSGhzFGdR/k3/GleqhywIrISeWVfIXJ764vkE
         jteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687631143; x=1690223143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAqmTGl3Ar509uWL5B5CVIqe/ep4FsCEtSXfox80pks=;
        b=MYOj6hEMRqBi9usntxEkc+KQN37VXuyWUGWBpRRKwA5gpse1yxV48ukycacNxTOsOo
         pHH9WJ19vt/zRPR7YJF7Zy9vCN+HLG7B4OKVHK93BiKw2o4qm0GRFCqLL6Ozf9df7lEd
         kA7gx1cIyPdS+hoOcL4dufsYvj8HFzpO5JSzUrExIW8NysUGTeMPV64JnHj50ygQFc7o
         +Nr3SuNfrzgIREL+6u5b/NxI+wmI72OYQPwkAr+8ppgJPctlX5MzYiWRSmv0eMfgiN2F
         KL38jZmrnUS2oOeYdAunSz9dqNrn3QXbbDe4dR2D3UpEnK7KFXpVGXnKPu6KWCOJypb9
         AL8Q==
X-Gm-Message-State: AC+VfDwJlu1E71x53fSGFfpK6eYg2XTG0espPanpSAMQsyQdTK+GdJVh
        92foAoYGdIV5BTxLByiBZQwV4GpTK8XDl5nfG7onsF9z
X-Google-Smtp-Source: ACHHUZ5QECnWOxJxazOXMlSXZjPrLC+FB3qeItOmTEc9cRSidaBMSfAIlZEI+RzaFr6RnEva27vvq/OJEFFaOZPEc/Q=
X-Received: by 2002:a05:6214:4008:b0:635:7744:c08e with SMTP id
 kd8-20020a056214400800b006357744c08emr1559495qvb.58.1687631143384; Sat, 24
 Jun 2023 11:25:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
 <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net> <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
 <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
In-Reply-To: <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
From:   Fernando CMK <ferna.cmk@gmail.com>
Date:   Sat, 24 Jun 2023 15:25:32 -0300
Message-ID: <CAEBim7BZsCYxjucpN5R8HpP+BpFezSzZ1QiA1COqU3-MZ18eXQ@mail.gmail.com>
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 24, 2023 at 12:26=E2=80=AFAM Eric Sandeen <sandeen@sandeen.net>=
 wrote:
>
> On 6/23/23 6:26 PM, Fernando CMK wrote:
> > On Fri, Jun 23, 2023 at 6:14=E2=80=AFPM Eric Sandeen <sandeen@sandeen.n=
et> wrote:
> >>
> >> On 6/23/23 3:25 PM, Fernando CMK wrote:
> >>> Scenario
> >>>
> >>> opensuse 15.5, the fs was originally created on an earlier opensuse
> >>> release. The failed file system is on top of a mdadm raid 5, where
> >>> other xfs file systems were also created, but only this one is having
> >>> issues. The others are doing fine.
> >>>
> >>> xfs_repair and xfs_repair -L both fail:
> >>
> >> Full logs please, not the truncated version.
> >
> > Phase 1 - find and verify superblock...
> >         - reporting progress in intervals of 15 minutes
> > Phase 2 - using internal log
> >         - zero log...
> >         - 16:14:46: zeroing log - 128000 of 128000 blocks done
> >         - scan filesystem freespace and inode maps...
> > stripe width (17591899783168) is too large
> > Metadata corruption detected at 0x55f819658658, xfs_sb block 0xfa00000/=
0x1000
> > stripe width (17591899783168) is too large
>
> <repeated many times>
>
> It seems that the only problem w/ the filesystem detected by repair is a
> ridiculously large stripe width, and that's found on every superblock.

If that's the issue, is there a way to set the correct stripe width?
Also... the md array involved has 3 disks, if that's of any help.

>
> dmesg (expectedly) finds the same error when mounting.
>
> Pretty weird, I've never seen this before. And, xfs_repair seems unable
> to fix this type of corruption.
>
> can you do:
>
> dd if=3D<filesystem device or image> bs=3D512 count=3D1 | hexdump -C
>
> and paste that here?
>
> I'd also like to see what xfs_ifo says about other filesystems on the md
> raid.
>
> -Eric
>
