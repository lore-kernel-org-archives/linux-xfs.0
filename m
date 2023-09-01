Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D990CA0FF8
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 23:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245571AbjIAXum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 19:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351231AbjIAXum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 19:50:42 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B38AB5
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 16:50:39 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7928dc54896so89557339f.3
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2023 16:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693612238; x=1694217038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8klfhXedLQ4WQTaVcniKGNfnP6fi2hBCnt9g+dYBP/o=;
        b=jTEWfHiQk28Kl4rIExar/OK/mKqU2z3vFCrmkaoS9CAra/YEY5JUGgM+D9RVAbP1Wb
         3F49KbBPEt95tHkqMJ6DOObuvbcNRYdmirBhbxNLP7p23Tgob/LcpDwld4YCx9KePW74
         psdDxFh+GRlFrcAHkeHZUBY0bI0IWzDui4eL/ojQST9UkLjchUkk1GxmyYQu57Ba/qbV
         PuQItBbGzRhWSbQUFXXYd+8o9AeoBG6TI4E8bgkzA+W7Y1dJHyHFe11NBr3hkOkGz+hW
         Ss0UbeRa49Qah5MzWsFUZ/t+LPXz4BIE9tHOrZz/G0W7QWOEh1ynf008fg70F6LKo31m
         6KKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693612239; x=1694217039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8klfhXedLQ4WQTaVcniKGNfnP6fi2hBCnt9g+dYBP/o=;
        b=LePOEXPDxAMolhbYuyhf/sM/DTz947YrT8gR3Y2JcXXqURUm9wZ1sMmdFnOyvLjbrC
         Nr4DOy6XmtTpBH/DYcq35azdt246gZFe1/2tMGO9KWVzToO8CRqPcZYzJASVEIlgNITc
         OzFEg4u6M87mgQAgO5kStPFMfIt1tQI9nsmpsoYHWI4sF3S2HGm5bzJ6QQ8Q6J+MgXoC
         /yg6814pjR8tcS2cGfnCwBJJB8W8JX4ZNvpuSf+3h+jXKRbd4/JERH5Y7O/5ofK2CjoB
         EtQNJ/CeHjWXREBa00NbMxabIpwNLYVc4RXklHnzCOfPaa6epRmJAQczFvmJ4s6NGXhf
         X+8g==
X-Gm-Message-State: AOJu0YxpZv8oIphpYPzB1coPepqmwNrU9c6AV5AntlEn4lxYdLEAWVc1
        Iw+Zupj7gH0ozpKbI/NguFTR6OXeuBOMY2oR5RDFnYGi
X-Google-Smtp-Source: AGHT+IE9BDy387/Harf9PYJUjYe1qQhWZ5yA73WL3xkhmsyX6kQcyVGXk6TlkevsgRI3kN+4Yh1vDxDJOAZmjiZ+438=
X-Received: by 2002:a05:6e02:b47:b0:34c:e84b:4c5e with SMTP id
 f7-20020a056e020b4700b0034ce84b4c5emr5467723ilu.8.1693612238569; Fri, 01 Sep
 2023 16:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
 <20221129213436.GG3600936@dread.disaster.area> <CAB-bdyQw7hRpRPn9JTnpyJt1sA9vPDTVsUTmrhke-EMmGfaHBA@mail.gmail.com>
 <ZOl2IHacyqSUFgfi@dread.disaster.area> <CAB-bdyRTKNQeukwjuB=fCT91BDO5uTJzA_Y7msOdEPBDAURbzg@mail.gmail.com>
 <ZOvx2Xg31EbJXPgr@dread.disaster.area> <CAB-bdyQG0gDBJDt5cHHsi7avUazDtL5RO8G6UwQZj5Rw7k-CXQ@mail.gmail.com>
 <ZPFewPuuv78ZUaxo@dread.disaster.area>
In-Reply-To: <ZPFewPuuv78ZUaxo@dread.disaster.area>
From:   Shawn <neutronsharc@gmail.com>
Date:   Fri, 1 Sep 2023 16:50:02 -0700
Message-ID: <CAB-bdyTYnDMhqWAhW3h=G+-QRmAe7=9rYvA_gH5b3_TUKHRfEg@mail.gmail.com>
Subject: Re: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 31, 2023 at 8:47=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Thu, Aug 31, 2023 at 06:06:23PM -0700, Shawn wrote:
> > Hi Dave,
> > If ext size hint is not set at all,  what's the default extent size
> > alignment if the FS doesn't do striping (which is my case)?
>
> No alignment. XFS will allocate exact sized extents for the
> writes being issued...

=3D> Seems this can explain why io_submit() latency was very high for
small aio_write (4KB, 12KB, etc).
When I did fallocate() 1MB space before moving on to the next 1MB
chunk, then io_submit latency becomes normal.

So ext size hint can achieve the same effect as fallocate() in this
case, might be even better.

>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
