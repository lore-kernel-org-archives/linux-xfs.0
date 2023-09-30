Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146EFE7737A
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Sep 2023 16:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbjI3QxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 12:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbjI3QxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Sep 2023 12:53:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA14EB
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 09:53:01 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5334f9a56f6so19689225a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 09:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1696092780; x=1696697580; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q746Z1/4KkmfJytKGnhZ2GnWo6R2JLlvnS7OdRP9O1g=;
        b=eJ3Qhcyeh4PZcEiA4NTlNP+IhSOn2HJuTIVUk2LxUckZ3MT1/kOdWByzrJ6Gvc6R2c
         IEdErusaWASWjEZIOaojcqpM5piTP3ndTtrXJIsE28JN+qUFJxFmFchYXfamH483n+wY
         KiZBbzkyGXcXDWDJqrg7HRV8LUYRl0vmWN/l4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696092780; x=1696697580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q746Z1/4KkmfJytKGnhZ2GnWo6R2JLlvnS7OdRP9O1g=;
        b=FKjNVSt8G/OZ+4ffhYq5Hf4q3bKI0W+tDCGD0oQTxLL9w+RIq2RWi/KUXlR4e+xw52
         Hh0xc4IVWzG1eJYV0jTIlb0k2QMCtqZUmDuEyehlEQqi9e9WpXeORPB2Z5A3ks7klMLz
         cwwc2xQt9NwfDTXYqJaGbJ99QwmQbLXrifIsoN1IZoQNNVEzYwqjpFuCzJUT70W5NZmC
         pEGHu5pBlLX38W69AYgqkZXFIysgg6X0tBdPDbdx1inKVb8CFwGOMj1Z90jdd/Y0Ased
         GI1glsuVctkuxQ7oQ7WWftKizBkRNJT63eJhFzuKGgmUapxiyDnYyUzanBN0epoX4KKV
         Hbbw==
X-Gm-Message-State: AOJu0YxiXkSOzWQEnPqti/G1ATm8mG7KiYPXI/YYZrWJP1SJHWYHHzzA
        ZT/wcpez4IMVn+79yCoQ3mEKKLq/rIcDFf53iCrGisB2
X-Google-Smtp-Source: AGHT+IHVjy84rTpqYD7rjYR158fNyGAOtTzCefNPPJIfz5lN+kJ8PDEY7Zo+5NnZuBPxiiSx6asAXQ==
X-Received: by 2002:a17:906:8468:b0:9a1:cdf1:ba6 with SMTP id hx8-20020a170906846800b009a1cdf10ba6mr4948092ejc.12.1696092779786;
        Sat, 30 Sep 2023 09:52:59 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id lw13-20020a170906bccd00b0098884f86e41sm14018676ejb.123.2023.09.30.09.52.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Sep 2023 09:52:58 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5334d78c5f6so19784338a12.2
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 09:52:58 -0700 (PDT)
X-Received: by 2002:a05:6402:385:b0:52f:2a38:1f3 with SMTP id
 o5-20020a056402038500b0052f2a3801f3mr5973565edv.2.1696092778396; Sat, 30 Sep
 2023 09:52:58 -0700 (PDT)
MIME-Version: 1.0
References: <169608776189.1016505.15445601632237284088.stg-ugh@frogsfrogsfrogs>
In-Reply-To: <169608776189.1016505.15445601632237284088.stg-ugh@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 Sep 2023 09:52:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjHA1d1kGhnzfXw7BsLuR93CPizeFzN0sNJruWsqvqzTQ@mail.gmail.com>
Message-ID: <CAHk-=wjHA1d1kGhnzfXw7BsLuR93CPizeFzN0sNJruWsqvqzTQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc4
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     bodonnel@redhat.com, geert+renesas@glider.be, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 30 Sept 2023 at 08:31, Darrick J. Wong <djwong@kernel.org> wrote:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-4

No such tag - and not even a branch with a matching commit.

Forgot to push out?

                 Linus
