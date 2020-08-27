Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D04C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 513CB2177B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YeVrNk/M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgH0I47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0I47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:56:59 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3525C061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:56:58 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m23so5008790iol.8
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8CPihnAD/MoSu3zFsYWfnqO6B4Oohfc/xZ7aPglSL0=;
        b=YeVrNk/Mx/44SpdWg0A1ucVb8xCLutW1lJh0LKUDBlWvKA2LB83Np1dUDrxmrsv36l
         LyRVT0gwcHweAGoyBpclBiFiorrHlA8JmY8+BEzGwoW+WlUtOxhvkaJx3+T/2x9l9v15
         1ZTjkgoJ92ME+7JljMs5igRUANQXlhq5QcZDm/aiHANVp19PzmKzbizB1FeKFisYxkpn
         w3LNDlHn+wV34rvluuYwndNKsUJvTyjo8GZVHeK1Gh70a5WMH4nQdTcjsiCkEP61vEMA
         PORcwK85BsALLvuQrUAi/usDDLdpCCIB0jlkBXUdXMH3uOhWZaRlIbuJWXrHnPXFvesd
         3s/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8CPihnAD/MoSu3zFsYWfnqO6B4Oohfc/xZ7aPglSL0=;
        b=AyxXH86EgnI/rD/WpanBWv4Cy0cnc0XocyW3449QmiiNkoNsS77yDmpNYaJy5h5KEu
         ZeM3PYwGQMgqYn6lIgawE0y3wOVEwj1h4c1QDdyyYvO1e6qN+GEI9zv2ZqelUyWC4LUZ
         w4h+wbRVHS/6/Wq/R10/2dfFn2yCw11JF6h+rObM/QYw3A178I9wy54Mtl+zRBOlu7f9
         aQqBsqQ2KGL8dSo2JvDmqa1yQcEur7eDBIErPufPQV2O6Myt+0PXgNDfWPBuSEn+Cxxc
         +heNOf8tuvTUmBkcZF2RvX9UXyiW1Mig2h7d9QxHnepPW+Hs8mN2/fDxqGJHfFIFX36O
         NbxQ==
X-Gm-Message-State: AOAM532qrmQCaTfhlJv8OpUPSaHVA6vkXNBHriyv37zjel4N7uaKhCvs
        SSmDms4dmbCwdzf/yv08Zz05GebJwp8DysEg4so=
X-Google-Smtp-Source: ABdhPJzhz0gN41DR1/m/fXdBKqAtozKz7klkn6g2eo04AZhYEiAKIobE9oVp0ICUpqS1FuGuBdX3lQxXey3jTgh/FsE=
X-Received: by 2002:a05:6638:16d3:: with SMTP id g19mr15572735jat.123.1598518618006;
 Thu, 27 Aug 2020 01:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954327.2601708.9783406435973854389.stgit@magnolia> <20200827065114.GA17534@infradead.org>
 <CAOQ4uxiXNaboUgCs6A5zjfnMpmb8+=m+TaZ6fKj0-5sknie3Ag@mail.gmail.com> <20200827081845.GA9746@infradead.org>
In-Reply-To: <20200827081845.GA9746@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Aug 2020 11:56:46 +0300
Message-ID: <CAOQ4uxj9nEDsUNkq8VgOGeCnV0C38Dtof9ytmJaBX21vKnjC9w@mail.gmail.com>
Subject: Re: [PATCH 07/11] xfs: kill struct xfs_ictimestamp
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 11:18 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Aug 27, 2020 at 11:17:34AM +0300, Amir Goldstein wrote:
> > Looking at this my eyes pop out.
> > I realize that maintaining on-disk format of the log is challenging,
> > so if there is no other technical solution that will be easier for humans
> > to review and maintain going forward, I will step back and let others
> > review this code.
> >
> > But it bears the question: do we have to support replaying on BE a
> > log that was recorded on LE? Especially with so little BE machines
> > around these days, this sounds like over design to me.
> > Wouldn't it be better just to keep a bit in the log if it is LE or BE and refuse
> > to replay it on the wrong architecture?
>
> XFS has never supported replaying a BE log on LE machine or vice versa.

Right. Makes sense.
I guess I read this backwards:
https://lore.kernel.org/linux-xfs/20200825003945.GA6096@magnolia/T/#u

Sorry for the noise.

Thanks,
Amir.
