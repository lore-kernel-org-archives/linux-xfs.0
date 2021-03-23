Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA0AC433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 09:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87240619A5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 09:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhCWJju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 05:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhCWJjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 05:39:39 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396E5C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 02:39:39 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y17so5891634ila.6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 02:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=UYVc46l1wemFaKt0h36ZCeEzQHLGZ1en5ssaz7BBBhA=;
        b=F0Z2BPU4BYRAjfTbdMxiOH04eZHkSZmyt65R8XJy2QrrazTHmMCpyRXoyasI/GLxP9
         e9feV3TPyc67rl3b9s5GUdMP51rXQwQjI5M7lThDIqReHuB/6R8abVSRZtb5y/ZFvmsv
         x2jC+s7QTQ/eOmPru3UanW1VLJTjlc0YkZ2CaszPQ92OGIEczI2RtOR9krpB0JWelkmD
         4/TufBA0+3bRK4t17vqJPQn5DNerQhRXpvWHZoYlVDTSImYAg4EgzsuGiItY1469yC88
         57/IOCcuHMsTWdgGAPmIFy2ijofcLAqyw/KLy92TOHruf3RCv+pwHD7Bog7eSDTAbl1e
         9utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=UYVc46l1wemFaKt0h36ZCeEzQHLGZ1en5ssaz7BBBhA=;
        b=GuDB4NdZLv+xI6TzY1PXOAYi1zY//6hv9hF0h+pfQR/2fWC33Y61epYBp9kVYgOj2b
         +2O8F5u2Dg+sCrwXnHKC0oSRASs8/Y6MU+wS9l1w8YUFcaNJpMkvqdTiqHPIeJD+c+Tz
         79jY4Qt71c0aRkNZ2NNTQNfhK4Yn9gge3ozCZFPfhepzvAy+Bo2HnidFfRvgcRCgx+ea
         7pSSJXEGQ2XQ/qlyLsQio/m0LjMV2BFDSXszMVf7O3S5RqowUOr4m3VbgsOP4FS9TVB4
         fNDSBJSRIlNAU3VOFI+s8+q/w5TrqWl3+upFp0Po018fo+2SP1cQCJx4hYun5rfqGq+F
         OD1g==
X-Gm-Message-State: AOAM530LXjYC85De6/sEEDnWRGakFFXEyEA43H1bn1SBCvFD1ct/bGZz
        D3NoohkOt1qv85K4QVI0LE5McMGR1docau1FFrD2aZ4J2gw=
X-Google-Smtp-Source: ABdhPJx4DNooWXQ2Uz1iiZtDAU1Xd9DqnjQtB1quOW+Yt7Jz4WAcUrg8sHMNTkMQjMB+oeDepJ9fnc+E/AyMLg/L9vQ=
X-Received: by 2002:a92:cd0c:: with SMTP id z12mr4054237iln.109.1616492378674;
 Tue, 23 Mar 2021 02:39:38 -0700 (PDT)
MIME-Version: 1.0
References: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
 <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com> <20210322215039.GV63242@dread.disaster.area>
In-Reply-To: <20210322215039.GV63242@dread.disaster.area>
From:   =?UTF-8?Q?Ralf_Gro=C3=9F?= <ralf.gross+xfs@gmail.com>
Date:   Tue, 23 Mar 2021 10:39:27 +0100
Message-ID: <CANSSxyk0sKzTmUKitwsxvip-N+TdLmPDrHYFAL9TUDB7gs1Bsg@mail.gmail.com>
Subject: Re: memory requirements for a 400TB fs with reflinks
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

> People are busy, and you posted on a weekend. Have some patience,
> please.

I know, sorry for that.

> ....
>
> So there's no one answer - the amount of RAM xfs_repair might need
> largely depends on what you are storing in the filesystem.

I just checked our existing backups repositories. The backup files are
VMware image backup files, daily ones are smaller, weekly/GFS larger.
But the are not millions of smaller files. For primary backup there
are ~25.000 files in 68 TB of a 100 TB share, for a new repository
with a 400 TB fs this would result in ~150.000 files. For the the
secondary copy repository I see 3000 files in a 100 TB share. This
would there result in ~200.000 files in a 700 TB repository. Is there
any formula to calculate the memory requirement for a number of files?

Ralf
