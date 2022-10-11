Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2774BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Oct 2022 03:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJKDkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 23:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJKDkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 23:40:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED497F26F
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 20:40:29 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id 13so28672146ejn.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 20:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=avYh2O9+fTzuaqehc7qCsubb1pxJLJq7WXmH7+DR4Pg=;
        b=DF04ZHZ2QIgJ45Yc9ZvfQyP3MWH2I9u4exEwdWpS3JvgqYR7eRcRl0CvUFQJjOzE9C
         GfYL+CUtZ+BJi+f5NTnlw60ACAyOJuVi1AafdNvEcIz2FAQWdpoq0zB2oQ/wbwFEaNJG
         MRcxEVfABtroTjEKPmQsi8ZPSqPOVf5IzHZoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=avYh2O9+fTzuaqehc7qCsubb1pxJLJq7WXmH7+DR4Pg=;
        b=zoqLMUFybkd0UVFekgHBkRKrEIyKo17KvBxfKNbu5ozauH0I4BuNCLZ2hmq2EYHBZN
         sOdZVZhUN08tpvEGeeKc2mXRRJRihkHiSt3IlJo18vy9d56MnzgOWHQ26iUE5sk0V+R2
         h4XvIv1Bas6ORiv6BDa+CSvOx0lwG35Xdb0drhMqRCZH2sYlMdvkklcpoYmMqLTRWHrg
         UfG/qYwvHkTqLAR7gHwuKcKUQj2IxW+dc0S+USyTJEZPswwM1L3jalPbvqaSreUeVi9O
         2ldIJtEbmNIQ27qfcMyBKVINA4vQp2kmnmUyX/xKAstYWnlv+yoAKWfxX6xHOJ+Ya6CZ
         pEfg==
X-Gm-Message-State: ACrzQf1QgPSx2FV4C+1GH6/QdAwP+XVlAhX0PeYqAEtC3Vf5oRRmbupp
        G1T78VFyYhMLaOzxWV4Mb8jPvPRtrwfCXhiAQ8r0OA==
X-Google-Smtp-Source: AMsMyM4mwkam5ifSSNpdyDLUCUktmjmYksmT3y4BiSIxeDjqGYocDQgNp+z5D8ZSKMdKE/Gs+Nl0yaxqThbT3qIk2T8=
X-Received: by 2002:a17:906:36d1:b0:76c:a723:9445 with SMTP id
 b17-20020a17090636d100b0076ca7239445mr16660315ejc.548.1665459627952; Mon, 10
 Oct 2022 20:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221010213827.GD2703033@dread.disaster.area>
In-Reply-To: <20221010213827.GD2703033@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Oct 2022 20:40:16 -0700
Message-ID: <CAADWXX8tVK6PZNsPhz874Y0kx5w6kKBcB+1QdqY59HiBqV=8ew@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: updates for 6.1
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 10, 2022 at 2:38 PM Dave Chinner <david@fromorbit.com> wrote:
>
> Can you please pull the latest XFS updates from the tag below?

Pulled.

However, I wanted to just note that this was in my spam folder.

Not usually a problem, since I tend to check it daily, but the
checking is admittedly fairly cursory. Generally a big "GIT PULL"
subject I will see, though.

I don't see anything actively suspicious in the email, but I do note
that you seem to have neither SPF nor DKIM set up on the mail server,
which is almost certainly one of the things that ends up pushing it
towards spam.

                Linus
