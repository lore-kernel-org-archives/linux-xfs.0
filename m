Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4996C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 18:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985E020772
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 18:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKLYp59s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHRSkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 14:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgHRSki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 14:40:38 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BB9C061389;
        Tue, 18 Aug 2020 11:40:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q75so22279045iod.1;
        Tue, 18 Aug 2020 11:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AS/xcDqR5i18Pe4BX138D58yv0hsxGS2TOQViVenGEY=;
        b=pKLYp59sdGX0KQbQ/wOzd7Y8bAj/JZxeA6kwVqax003PccC8g2C5OD1Ud9oPBWIvhh
         D48XfmBmq5FCJJPh2ifcxnWQDRj+cOqjRo6ga9KmN/zb6cImh0qr3XlqbYzLd4FF7i0d
         IEJNr2B1gZ0oSYCh2UuKcNfN1ItXHQcKf2WYS2rJtGgQPzWdAKUp1LIyPoiZzu0yuJ1w
         tPHtzdXq4JRQibmIpYrzK5qIlNMezZDAUbpXl0+77LBsG956gu1NxeAMASKpCuXyRTrt
         L13zze/EM6zT+OvrMwbZmwmRJTHrz+luFPIYpdld6+N5qp06b0jt22tNTcmroBFpnA4N
         vOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AS/xcDqR5i18Pe4BX138D58yv0hsxGS2TOQViVenGEY=;
        b=FotFo9O97KvwoVszmNPUczhLiWr9cusCPrioONClu0TWAOUwmk213EFVuefFGLP49c
         vDoUa2EazQ4tlX7cn9opuCsahe5vT5xISTrjxAQojuZjJmK8cbdkCawzaDYeYD9N0RF4
         61PEHqZQKdC02Q01n8rXbEoizw3LORDTAYNV8u8P/ZesPOQUU+p77hAGCO0zLg6kLdYF
         IxFrF28AeX3ZVYsjQO20ci5E6yIK84hmljlVvjad5v5UNXFkQ7LY9QQvnGwthat09qDy
         TWL1LV9jsC7bwgIbLuKpfQkx6MwHwzuo8eolJyb0WFEHKtDplvEyV73Xc2X2rp5zT1nm
         i0Dg==
X-Gm-Message-State: AOAM530OEFjPWCD0uZ1YxhTj/rPf/5LUL3tpipoHP7z8ODKXbxnt8lC7
        ZrHhfhO9rDZEoQZbrZiwObGXaLpD2h3ooqZ0moI=
X-Google-Smtp-Source: ABdhPJyiHsvBAJdccmMylF3fPZTX4qeFUsya3Rbb5GtgVWk3P//CUQTGQsvS6yYxPyDFK2dwQmKzzdiFQZfRGQ4n0+Q=
X-Received: by 2002:a02:9a05:: with SMTP id b5mr20094745jal.123.1597776037296;
 Tue, 18 Aug 2020 11:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <159770525400.3960575.11977829712550002800.stgit@magnolia>
 <159770527916.3960575.1560206777561534458.stgit@magnolia> <CAOQ4uxg9MG8N=hF++y=RtXLo7Up0wM3uF=tC3HW8c2ivWsjqCA@mail.gmail.com>
 <20200818182322.GX6096@magnolia>
In-Reply-To: <20200818182322.GX6096@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 21:40:26 +0300
Message-ID: <CAOQ4uxgzMD_Zi90OwYiv2PH7rRs+W7MSYU3Zf0KVG1Kw-rQ-KA@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > Darrick,
> >
> > These tests look great, but I wonder.
> > generic/402 has more test coverage than above.
> > It tests several data points and it tests them with and without mount cycle.
>
> Um... these two tests exist to make sure that /upgrading/ works, whereas
> generic/402 tests whatever it finds on the formatted scratch filesystem.
>
> > With your current tests, bigtime will enjoy this test coverage only if
> > the entire
> > run is configured with custom XFS_MKFS_OPTIONS or when bigtime
> > becomes default for mkfs.
>
> I don't understand the line of reasoning.  Both tests format with
> specific mkfs options, or skip the test entirely if mkfs doesn't know
> what bigtime is.
>

I was referring to generic/402.

> > Do you think we should have a temporary clone of generic/402 for xfs which
> > enables bigtime for the time being?
>
> <shrug> I pushed most of my testing to the cloud, so I just spawn enough
> VMs so that one of them will test bigtime=0 and another does
> bigtime=1...
>

Fine by me. As long as there is test coverage for generic/402 with bigtime.

Thanks,
Amir.
