Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA784E7737E
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Sep 2023 18:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjI3SEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 14:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjI3SEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Sep 2023 14:04:11 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFA5E1
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 11:04:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9b2cee55056so386040466b.3
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 11:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1696097046; x=1696701846; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GUrGw+oIpm434a0jwZAXwfA3uceDoUYkG3/g20/aCBk=;
        b=X/272eClGGTRzQnvxueso+cc9Qghp5geSpz4eV6flvNDaSYHZN+LNutPISU5QQMDia
         Dirgvr2nNGOmLhjlgS1MGOvF1ZlZsBMqWR/g5JldFQf6ELbvtXSYwHn2sv+ySK6KaDcm
         oXeBI+IQhVqIEwKMyxqtZgfAsb8SnNdUyLzFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696097046; x=1696701846;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUrGw+oIpm434a0jwZAXwfA3uceDoUYkG3/g20/aCBk=;
        b=DWXEFlTXsQCwi4MBTWiJTwITsErFVWL84TJDllG2OHsr7B32sp/2Ulb0Ia1Kyhfe6z
         hktQayGhjAVMlffeEdRzphi7s7oqrgijQmLWNN5/Dt+MqoQRpucCRVinA3dAgJJYigvm
         nDbaqsjy6IxnwnHWmZ046kGq/myt36yy3PyD72L2ZHcSFS7lv6TTUqpJb39ldKy42TTJ
         /1i5ySDcEX7g78hTDC8Uto2izwPfLTY0WXQwPVbIfSM32Z0+mnf8ceISNhrTsd2syiCp
         ZEscShoRuoieSGxoT2ccEcdILavfJQUIyVYuUdnF/S5LwViV8C8MGRBGwwTqnAHbDg21
         5Gjg==
X-Gm-Message-State: AOJu0Yz1zTd94ie9OBc8bBtx3NlPAUVuNM3lDnqWa3GZ4/jToZiV7K33
        q/UUC2ADISHG4pw9fbzNjsA34QcKRrG4Qb15Zn8MWQ==
X-Google-Smtp-Source: AGHT+IGOKx/EZK00HkTzMsXJr9JpXODpHY+jTGEjhCPRhvS2FaB7KS0fR1CJbwW1tMqSNuKzir/Ppw==
X-Received: by 2002:a17:906:5e:b0:9b2:d78c:afe9 with SMTP id 30-20020a170906005e00b009b2d78cafe9mr4011763ejg.49.1696097046329;
        Sat, 30 Sep 2023 11:04:06 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id gq23-20020a170906e25700b009ad75d318ffsm14479008ejb.17.2023.09.30.11.04.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Sep 2023 11:04:05 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-406609df1a6so14102105e9.3
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 11:04:05 -0700 (PDT)
X-Received: by 2002:adf:f507:0:b0:323:2d06:9dbb with SMTP id
 q7-20020adff507000000b003232d069dbbmr6329330wro.12.1696097045037; Sat, 30 Sep
 2023 11:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <169608776189.1016505.15445601632237284088.stg-ugh@frogsfrogsfrogs>
 <CAHk-=wjHA1d1kGhnzfXw7BsLuR93CPizeFzN0sNJruWsqvqzTQ@mail.gmail.com> <20230930172129.GA21298@frogsfrogsfrogs>
In-Reply-To: <20230930172129.GA21298@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 30 Sep 2023 11:03:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whu=nfBvBn3JG9pBVdgV=tTpCLh=iDdBfsgNsEY6w4KwQ@mail.gmail.com>
Message-ID: <CAHk-=whu=nfBvBn3JG9pBVdgV=tTpCLh=iDdBfsgNsEY6w4KwQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc4
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     bodonnel@redhat.com, geert+renesas@glider.be, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 30 Sept 2023 at 10:21, Darrick J. Wong <djwong@kernel.org> wrote:
>
> Doh, wrong repo.  I'm kinda surprised that git request-pull didn't
> complain about that.

I suspect it did complain, but that one-liner is admittedly much too
easy to overlook when everything else looks sane.

> Will send a new one.

Thanks, pulled.

             Linus
