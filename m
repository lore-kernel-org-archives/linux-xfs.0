Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F62C07E9B
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A366196A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhGEPyP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 11:54:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231806AbhGEPyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 11:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625500298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=94h8HuvsNXIPuzkfFYVmJcfX+faEonOANTvfeqnyEF4=;
        b=LJepe8uDId3SWjXPFf4Ek1QgHJawfnLRuXBTZ3x0kdEyq15ecfMVUOVEgPifWkbzStK1Qi
        Sm4A9ic6GRM3wL3Lxn9hIY4R+Avs3CQqd6XVP62yOzCx79Bo6+D1UUzOy3Ii403d8VIflD
        aow0b0pWIfRH7ghvgmyRbaD3k+N6Ofs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-ytdc-2FdNpKeqigfJ4yzfg-1; Mon, 05 Jul 2021 11:51:35 -0400
X-MC-Unique: ytdc-2FdNpKeqigfJ4yzfg-1
Received: by mail-wm1-f69.google.com with SMTP id a129-20020a1ce3870000b02901f050bc61d2so121363wmh.8
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jul 2021 08:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=94h8HuvsNXIPuzkfFYVmJcfX+faEonOANTvfeqnyEF4=;
        b=EvgT4rPLtCu0b8Ox1GXMB1L/xEQtZAfkDcfub+GgigYHZXXMX76XgOg3IfwqJQBSc8
         PSXJkWaeSaOmkKr+wOuKN+LRj3+2L8izKJsU6mUqqAx0+MGP7HElfj8glcu/8XbySGcy
         rRAfhywZGP0QsDXSIaNvTWc3Qb8+jEtzcjkIAXuQ+xyUujoUrDkXAQ5Kq+9W53YNZZQ2
         SoB6vkuFgK3gosoBjYntGJAIjLC/5U2tE1aIQ8clCx5vCyjvonHioCvXjXQOcqKxSh7n
         rSkILbY4vCX9tb2WmOARWSFkF0YJNPzVOCogCpxRndJ8lAM0AMNST+b+61eEaX7k21cM
         XVhA==
X-Gm-Message-State: AOAM531dPx1nJ+k7rewkC/esRMRS/rqV13vtiDqL8ZbJcKGsJoqJtPng
        dxOJIuAFYfm88yCuUEfXcZVtOBcbu0xsb84ugyd59hSMfztJd4q6TugaYT7wcyYbqaNCX29v0kJ
        VjofczR/tJu/iblmmiI3QV7DDXkPgEpB9m7n/
X-Received: by 2002:a7b:c40d:: with SMTP id k13mr15672999wmi.97.1625500293822;
        Mon, 05 Jul 2021 08:51:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwt0xgTY8Fc/m6wSLIkQmnvuBGTo0ib6uAwtg1dnYqClFwZpSqUixG70VxfLezXErN7AKL1pIfnEj+ourL3X3M=
X-Received: by 2002:a7b:c40d:: with SMTP id k13mr15672989wmi.97.1625500293712;
 Mon, 05 Jul 2021 08:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210628172727.1894503-1-agruenba@redhat.com> <YNoJPZ4NWiqok/by@casper.infradead.org>
 <YNoLTl602RrckQND@infradead.org> <YNpGW2KNMF9f77bk@casper.infradead.org>
 <YNqvzNd+7+YtXfQj@infradead.org> <CAHc6FU7+Q0D_pnjUbLXseeHfVQZ2nHTKMzH+0ppLh9cpX-UaPg@mail.gmail.com>
In-Reply-To: <CAHc6FU7+Q0D_pnjUbLXseeHfVQZ2nHTKMzH+0ppLh9cpX-UaPg@mail.gmail.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 5 Jul 2021 17:51:22 +0200
Message-ID: <CAHc6FU6NWgVGPkvLM_mb+TpK3aM2BK+RrLgKgfS20kCLVV=ECg@mail.gmail.com>
Subject: Re: [PATCH 0/2] iomap: small block problems
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 2:29 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> Darrick,
>
> will you pick up those two patches and push them to Linus? They both
> seem pretty safe.

Hello, is there anybody out there?

I've put the two patches here with the sign-offs they've received:

https://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2.git/log/?h=for-next.iomap

Thanks,
Andreas

