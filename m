Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC9EC64E8A
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D5E22248
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 17:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbgLBRmv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728887AbgLBRmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 12:42:50 -0500
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C69C0617A6
        for <linux-xfs@vger.kernel.org>; Wed,  2 Dec 2020 09:42:04 -0800 (PST)
Received: by mail-vk1-xa43.google.com with SMTP id r9so580757vkf.10
        for <linux-xfs@vger.kernel.org>; Wed, 02 Dec 2020 09:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1x85fibtNgk8eCqEQNDAdM4H9CAeQh2Tw033sLE9au0=;
        b=k17fYGcwuvMZ1Z8sW8ED5NcNXVNtT2pFk45+2PoxoQU8LXfOr6AYnwMnP48duoDTOX
         KkETXo8kz86TN9x3hgA72/j3TAPJcyMySF/dKg3fqDLhxHHqn0b6mMjJvCX9YFgXcZSE
         meXC9GzKinsBSDUgRWYmV1DBRcJbE7gisVkLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1x85fibtNgk8eCqEQNDAdM4H9CAeQh2Tw033sLE9au0=;
        b=bUlbzN1Qw9azCJMR2DwLy2WgcWNcfDXF9DdsKCvYGHqms6td052CXmhtHZrSQJAAdi
         5aSeZjW+YBi7c3K4u0VRJv9zlkDXz6c8P2f01rnUyRTO7nXD9cWGappnQYt0XpOO4t+q
         pD1O3/aW93sKc69fsp0PWECCAIqcZLOpKi6xBhb8opczCN8rgx2A+MjVJPGMSSbiAlEa
         2dhdTGHIaf7ZcyL6YenqfPI5acJZ7F5tsXnCsiSizXGn1KH9II6Ob255d80nq83okP1r
         tDWr9a6/9aGgAA5VrE6IO4Pr/RY1Fl6VfhgYWUwZVW3UGYHmrjhq6roAnLxVkE7XSpFl
         4DOw==
X-Gm-Message-State: AOAM532YEtxYgdM9tiFhoalEf2Uj/mXLraYK4b/D9n+wtgrl8oD18V5Y
        tbbJarUhYvxDe0rTngQAHpNp6eFeyiqZCp55vjj7DQ==
X-Google-Smtp-Source: ABdhPJwTheLKPeYlIrrssTfR1rpgEOPwTCjeb+0/mDlt+DYvNW/fgwgzHLBBS7di/GI9wgwe9tiBOAwzgf9hYJ07zfU=
X-Received: by 2002:a1f:b245:: with SMTP id b66mr2625951vkf.3.1606930923918;
 Wed, 02 Dec 2020 09:42:03 -0800 (PST)
MIME-Version: 1.0
References: <3e28d2c7-fbe5-298a-13ba-dcd8fd504666@redhat.com>
 <20201202160049.GD1447340@iweiny-DESK2.sc.intel.com> <CAJfpegt6w4h28VLctpaH46r2pkbcUNJ4pUhwUqZ-zbrOrXPEEQ@mail.gmail.com>
 <641397.1606926232@warthog.procyon.org.uk>
In-Reply-To: <641397.1606926232@warthog.procyon.org.uk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 2 Dec 2020 18:41:43 +0100
Message-ID: <CAJfpegsQxi+_ttNshHu5MP+uLn3px9+nZRoTLTxh9-xwU8s1yg@mail.gmail.com>
Subject: Re: [PATCH V2] uapi: fix statx attribute value overlap for DAX & MOUNT_ROOT
To:     David Howells <dhowells@redhat.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        linux-kernel@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 2, 2020 at 5:24 PM David Howells <dhowells@redhat.com> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > Stable cc also?
> >
> > Cc: <stable@vger.kernel.org> # 5.8
>
> That seems to be unnecessary, provided there's a Fixes: tag.

Is it?

Fixes: means it fixes a patch, Cc: stable means it needs to be
included in stable kernels.  The two are not necessarily the same.

Greg?

Thanks,
Miklos
