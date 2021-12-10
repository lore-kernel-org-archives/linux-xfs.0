Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCB8C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 19:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhLJUAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243472AbhLJUAv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 15:00:51 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62D0C0617A1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 11:57:15 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id v138so23785783ybb.8
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 11:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dBKi6HQxwWvRYMSgc6jDMkVgEiAkjfFEykJbQr8uLHA=;
        b=4jAK1KAMKjrNNWRZMcDiAi7X9bSDK97shh0gE9/rWqKL0twouN3hY2vTMZWo3saVcx
         +VyY5vnAk0/u7tjc4LtBj1pUN7VJxn+XNLmV+BdiZi+OgxWiRKNQX8Sz8x5vvxmGcWKy
         aiJFek+XZ1idC1Zmxi0/1cnF7wx3Dig3vuuQFMh+94jkPYaZskIS04LMdwv9bUyhjLgP
         0XPEszy0YKmyMdAA0/38jVPyxaTPUnsK6HaGlf72tQOBFLeDi9n9sSPpRkH8Gpzlgpb7
         q743Anams8qp30KFAKWQuiVNX8PpFcLIdjh2c70K1Fm48xQ1oGJKQa7GnG6zMcR0x974
         B5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dBKi6HQxwWvRYMSgc6jDMkVgEiAkjfFEykJbQr8uLHA=;
        b=DivrLzKc+QOw+wX/HU8Ag96ztaubwZxAffws7AJ1wQLLon1z1YiHL5tq+/CfrDvRNQ
         IMSlwA20hPSMBxFhN+CqE7zOGuQVksyT05RcyGx0wsC7hcQg0Hz34WfuWv7PXvIwxBmQ
         bXpyxSPGsYTuDVTDFPYwvzVOob0cRi2Xmp7fQgyrKA2QAMalWaF9BjIqHM5MlXXOurcX
         JRucix+b751rBtzH1m1rPrnhJuoYT9O68Uwl/3iXBxfJkpZVESev+2gjhdEGJYpYbpvq
         hT2QA0IuvMhmYceyU/S2o/MhyCWEHZMV07TgTov1QNb4fX6XxKXmCK+VwZLdqLOH0d6O
         9C1A==
X-Gm-Message-State: AOAM532OUHlDlodunBSKfyy2wbPO2LpPXpJBR/1ysP/dkMvktagTQBoB
        bgagMR5KgZqN7BzjxVSSJzkvr36NZrk7e8vfLXC0kg==
X-Google-Smtp-Source: ABdhPJyq2SWGzVS/XUp61en39MHxkIccSHtatBDyiFyt/LEdKleRabgFH0dSvbjv5CTh/jYdzor4qsqt7rwcL7e4Qps=
X-Received: by 2002:a25:e057:: with SMTP id x84mr16207664ybg.385.1639166235148;
 Fri, 10 Dec 2021 11:57:15 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
 <054e4e59-a585-5375-e80b-5db3ade2f633@gmail.com>
In-Reply-To: <054e4e59-a585-5375-e80b-5db3ade2f633@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 10 Dec 2021 14:56:59 -0500
Message-ID: <CAJCQCtSneTaMQXGxoopvnkZ7mu9zPYFLRx4iPo_33m+4-QkdnQ@mail.gmail.com>
Subject: Re: VMs getting into stuck states since kernel ~5.13
To:     =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 9, 2021 at 9:56 AM Arkadiusz Mi=C5=9Bkiewicz
<a.miskiewicz@gmail.com> wrote:
>
> W dniu 08.12.2021 o 19:54, Chris Murphy pisze:
> > Hi,
> >
> > I'm trying to help progress a kernel regression hitting Fedora
> > infrastructure in which dozens of VMs run concurrently to execute QA
> > testing. The problem doesn't happen immediately, but all the VM's get
> > stuck and then any new process also gets stuck, so extracting
> > information from the system has been difficult and there's not a lot
> > to go on, but this is what I've got so far.
>
> Does qemu there have this fix?
>
> https://github.com/qemu/qemu/commit/cc071629539dc1f303175a7e2d4ab854c0a8b=
20f

I don't think so. The problem appeared in Fedora 34 which had
qemu-5.2.0 and now Fedora 35 which has qemu-6.1.0. I'll see about
backporting that patch if it hasn't already been in 6.1.0-13.fc35


--=20
Chris Murphy
