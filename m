Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59175C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Feb 2022 15:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiBIPUW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Feb 2022 10:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiBIPUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Feb 2022 10:20:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C18E7C0613C9
        for <linux-xfs@vger.kernel.org>; Wed,  9 Feb 2022 07:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644420023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HWJxSwYp7jtZ92shaLhTfEcqyJ4FcqxLKxSHScXMFmA=;
        b=iBY+ulJPQibRmd9kZqkz3IglfvJPBukJOhuzj86snotR7LwPOBQILqxZtkjMZLi57CW7JX
        0B8kjl0vms6wM4J5wJsfeNdvOJK8RkrQhnm97aim+cLcpA+qrvKDe/ERK5cxG49McU5dta
        mJeMuzaJ7oxIZbZkCcweMZT5dZWoy68=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-Hilp20buNUyLc_C773Np5A-1; Wed, 09 Feb 2022 10:20:22 -0500
X-MC-Unique: Hilp20buNUyLc_C773Np5A-1
Received: by mail-wr1-f72.google.com with SMTP id j8-20020adfc688000000b001e3322ced69so1226604wrg.13
        for <linux-xfs@vger.kernel.org>; Wed, 09 Feb 2022 07:20:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWJxSwYp7jtZ92shaLhTfEcqyJ4FcqxLKxSHScXMFmA=;
        b=3ycSOD9OA8I58OPNAwKvfAdRxbUoL/iNdV39zJXHoeyimkJR/W8LSIuSCdUlXmFsvP
         o5IzxKtjGsOW4Iz2VED5lOiU9Z2lzKEFXNfCXfBNWaqFvMJfy/wAOMEfbNrG+Bsot12r
         DjxQfmYhRnOAQ0zwj10wmrV2OnKkX78mcYm3YJvxFzhdGqaeIZumSqOnBdpNEPCRXiqw
         O8gVMjp6ZVUQj7Xhna71yBXLaHzEjhXgk9/P9U23MUI1aq3lyZ8R6ZytHElN4nfHEX/y
         BHVpj1GaSAMmsx3hLw64FSlxqBd+tYi85BNYOr3EWQ7xE6UsymoAYL08ekq/xrE3Glpc
         Y+7g==
X-Gm-Message-State: AOAM533xX4PiH+SiwVBcwoMDn/jAa4jS2zGf6GYzLrianIVHvHY1pOdw
        5+x4by/ZLbZPB68hUTxZZZ0VDLzk0TCaV0HwkCpKUxemRqgCbKUP5TJEZ3JwDyJhzB4JKEv/McG
        mg36rjujIu/TU5MRDdvIlQt89OstrXR0QXUHy
X-Received: by 2002:a1c:2942:: with SMTP id p63mr2494641wmp.75.1644420021705;
        Wed, 09 Feb 2022 07:20:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBIOqCE7cDbpGvT5TmCSizl7rrPw18L3EY0Uy8onixaMONTzYS0XvUHUkxcZEdMAG886y96+4xK4BB/NuuR5w=
X-Received: by 2002:a1c:2942:: with SMTP id p63mr2494623wmp.75.1644420021540;
 Wed, 09 Feb 2022 07:20:21 -0800 (PST)
MIME-Version: 1.0
References: <20220209085243.3136536-1-lee.jones@linaro.org> <20220209150904.GA22025@lst.de>
In-Reply-To: <20220209150904.GA22025@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 9 Feb 2022 16:20:10 +0100
Message-ID: <CAHc6FU5e4GaQTfh6Z2_2vhcgxY+dbwUBOgazrXB3XW4=DRpLHQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 9, 2022 at 4:09 PM Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Feb 09, 2022 at 08:52:43AM +0000, Lee Jones wrote:
> > This reverts commit 60263d5889e6dc5987dc51b801be4955ff2e4aa7.
> >
> > Reverting since this commit opens a potential avenue for abuse.
> >
> > The C-reproducer and more information can be found at the link below.

This reproducer seems to be working fine on gfs2, but the locking in
gfs2 differs hugely from that of other filesystems.

> > With this patch applied, I can no longer get the repro to trigger.
>
> Well, maybe you should actually debug and try to understand what is
> going on before blindly reverting random commits.

Andreas

