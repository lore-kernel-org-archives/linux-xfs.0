Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DF3C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Nov 2021 05:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhK3FZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Nov 2021 00:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhK3FZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Nov 2021 00:25:10 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C7EC061574
        for <linux-xfs@vger.kernel.org>; Mon, 29 Nov 2021 21:21:51 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e8so19890425ilu.9
        for <linux-xfs@vger.kernel.org>; Mon, 29 Nov 2021 21:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AsqwVQeqBmwAPkBDTfygG/ooBNLQjg7kJvX/jDpM4CM=;
        b=gMU4cAxFk7CDzgLQQMv8e1/ZNDQapSO2dQsF68eSIAi8tRlgTUW0iVDS2qhFIBnoVg
         ZifAXTijP4DEnFEp8vHlfaVowP/GyncruBH+umwFYouhmEPoCLzxGximQkye8gKYg2g2
         fXWsnClAcp9A5VfSP5cn5dU/uRzqpePbm9Y3+gInuICKd9UL6e0Tntl6irQq/I3DINWM
         RLgyma8civTAK5P6fdcJFu+uL17Iig/BxVnO0oe0V1WBaJtHjVA5SbE4Ct8ao6UTQKGp
         XaQ+4ztMTO+ZRddXvZVf7znx92RGo+D6TVzYBJ/yDyArHXbJmkXT3GRxfTg8sf9BrHhN
         EIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AsqwVQeqBmwAPkBDTfygG/ooBNLQjg7kJvX/jDpM4CM=;
        b=BloZZQnIK6oDvud9gBN+7OL51kDPNYCcZVE3/hmP08SfWRJ533/2mUGX9NbmfUoEOj
         HCOXee0zvl8h77gK0d49RAJVZtJe7X7jPT/O0URGg8eiUkNPEeJh+2AAZFHH6xKEL75c
         H82y7phdfbA20JHGhRbWovyYXrKkkvEARxV/oQpdx/iD12TxO/dLpj0yZJUDgI7lJ+Hs
         rAC+u7BM3iehjVjbVSJRZE0xc3rtM1Iprjro+5r7B7fYXQMw+/aA2J69TfuH99vaFe4k
         ICSdRzLSbSba4FFvWPN4zXIzNz4Dtjq4sejjetYWjhanxRkc1gybbVCtSYg1MY4K9kft
         ObmA==
X-Gm-Message-State: AOAM5336C9MQIirnDyu5nz+wDg5iA4eUK7aOjX7mlwgsSqTktCL95+NF
        OmSFkXoNYP4zQjnxyB/pcchZMfB28SvVM288HgxoRLuM+q0=
X-Google-Smtp-Source: ABdhPJxlBl79qilWGMgc8snKNkf48QxBHfZW5a88VbszLZUcizK3gc7tXP4oQ7GxKaWjDzpNP+6nVXpTSfnayw1M00o=
X-Received: by 2002:a92:c88e:: with SMTP id w14mr50842100ilo.24.1638249710749;
 Mon, 29 Nov 2021 21:21:50 -0800 (PST)
MIME-Version: 1.0
References: <473f18c6-dc0c-caa4-26d6-2b76ae0d3b35@redhat.com> <6502995c-2586-2cea-3ae6-01babb63034b@sandeen.net>
In-Reply-To: <6502995c-2586-2cea-3ae6-01babb63034b@sandeen.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 30 Nov 2021 07:21:40 +0200
Message-ID: <CAOQ4uxhkFYZ-TpEooEr_A0_ADdZ8nCff-4NZS8gCU9dd0b2ixQ@mail.gmail.com>
Subject: Re: XFS: Assertion failed: !(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE))
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 29, 2021 at 11:33 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 11/26/21 9:56 AM, Paolo Bonzini wrote:
> > Hi all,
> >
> > I have reached the following ASSERT today running a kernel from
> > git commit 5d9f4cf36721:
> >
> >          /*
> >           * If we are doing a whiteout operation, allocate the whiteout inode
> >           * we will be placing at the target and ensure the type is set
> >           * appropriately.
> >           */
> >          if (flags & RENAME_WHITEOUT) {
> >                  ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
> >                  error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
> >                  if (error)
> >                          return error;
> >
> >                  /* setup target dirent info as whiteout */
> >                  src_name->type = XFS_DIR3_FT_CHRDEV;
> >          }
>
>
> Hmm.  Is our ASSERT correct?  rename(2) says:
>
> RENAME_NOREPLACE can't be employed together with RENAME_EXCHANGE.
> RENAME_WHITEOUT  can't be employed together with RENAME_EXCHANGE.
>
> do_renameat2() does enforce this:
>
>          if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
>              (flags & RENAME_EXCHANGE))
>                  goto put_names;
>
> but our assert seems to check for something different: that neither
> NOREPLACE nor EXCHANGE is employed with WHITEOUT. Is that a thinko?

Probably.

RENAME_NOREPLACE and RENAME_WHITEOUT are independent -
The former has to do with the target and enforced by generic vfs.
The latter has to do with the source and is implemented by specific fs.

Overlayfs adds RENAME_WHITEOUT flag is some cases to a rename
before performing it on underlying fs (i.e. xfs) to leave a whiteout instead
of the renamed path, so renameat2(NOREPLACE) on overlayfs could
end up with (RENAME_NOREPLACE | RENAME_WHITEOUT) to xfs.

Thanks,
Amir.
