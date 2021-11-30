Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DB5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Nov 2021 10:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhK3Kkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhK3Kkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Nov 2021 05:40:39 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091ADC061574
        for <linux-xfs@vger.kernel.org>; Tue, 30 Nov 2021 02:37:20 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id 84so13239851vkc.6
        for <linux-xfs@vger.kernel.org>; Tue, 30 Nov 2021 02:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IGVZZ/2aF3j5rVkFeR0AAXzkjkCEePZoynLbse/dWRg=;
        b=muNy2+9h3P6Kzwef6kkrLVQEKADBtBWJabpWf4Lr/UsF8qMolzIhikWB/BctQX8w+u
         gE2Jc3NuRdd6KxRPxbRpxcI7ZQLmIeXK5ymImRwO4T83Iftna9by0Swh974SA01+pvhh
         3qHVARGszlj6G1n5eD98ct3cNH7CXv+UEp1C4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IGVZZ/2aF3j5rVkFeR0AAXzkjkCEePZoynLbse/dWRg=;
        b=R1HNcQfKWx3R4VCLGctr7ahuywDt0nZBrq3EH5Nyw8lJ8fuixdzizC87F8aDYNX7uZ
         Ujhz0qJNJI1FgvB2iv4H38ZTBnVW+ydQ/z4jetAPzPY29FoeTP9hDUBHLmr1g/d+AWNP
         5zGjbMRMHLgWEPB90tqL+LqDyp9t/9GGUe7hk6PSH0tTWJYhQm9fvjsIjfKeWB/qVZK1
         Lnvdw5M/M0NufZIqcDJI+2IZkSpGCIrdlUFj2Du3x651sffOkPDt9p8oN1ts19Ofs/sv
         Jvn2TWLTU8KKIxjP9CY/yOkHl0Jv4kg5u3G67c9DocSwBhqW/VywB/05mGzrK7TgIWim
         PUzg==
X-Gm-Message-State: AOAM533KZifFMShKao4f3ZO3MZQtGQVMO+J86D4jwCZuW5N+Imh9grR3
        Oo5YKwuP4YAVd9mNIXob7wMTwxcq3hPCgwDqqs6TvQ==
X-Google-Smtp-Source: ABdhPJx35lEZkTvCqplPv3LO69WRFjlK+XNJLJgg1LfX/eRwsg6lP0LnobS9iRh5TX54S9fvYsCV8FxlUe1VGagEXBY=
X-Received: by 2002:a1f:cd47:: with SMTP id d68mr42492237vkg.33.1638268639231;
 Tue, 30 Nov 2021 02:37:19 -0800 (PST)
MIME-Version: 1.0
References: <473f18c6-dc0c-caa4-26d6-2b76ae0d3b35@redhat.com>
 <6502995c-2586-2cea-3ae6-01babb63034b@sandeen.net> <CAOQ4uxhkFYZ-TpEooEr_A0_ADdZ8nCff-4NZS8gCU9dd0b2ixQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhkFYZ-TpEooEr_A0_ADdZ8nCff-4NZS8gCU9dd0b2ixQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 30 Nov 2021 11:37:08 +0100
Message-ID: <CAJfpegtjYuAhkpoz5DHD2ZYVd8m+rSWMs6wwA+iXYo=CeJF6Qg@mail.gmail.com>
Subject: Re: XFS: Assertion failed: !(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE))
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 30 Nov 2021 at 06:21, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Nov 29, 2021 at 11:33 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > On 11/26/21 9:56 AM, Paolo Bonzini wrote:
> > > Hi all,
> > >
> > > I have reached the following ASSERT today running a kernel from
> > > git commit 5d9f4cf36721:
> > >
> > >          /*
> > >           * If we are doing a whiteout operation, allocate the whiteout inode
> > >           * we will be placing at the target and ensure the type is set
> > >           * appropriately.
> > >           */
> > >          if (flags & RENAME_WHITEOUT) {
> > >                  ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
> > >                  error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
> > >                  if (error)
> > >                          return error;
> > >
> > >                  /* setup target dirent info as whiteout */
> > >                  src_name->type = XFS_DIR3_FT_CHRDEV;
> > >          }
> >
> >
> > Hmm.  Is our ASSERT correct?  rename(2) says:
> >
> > RENAME_NOREPLACE can't be employed together with RENAME_EXCHANGE.
> > RENAME_WHITEOUT  can't be employed together with RENAME_EXCHANGE.
> >
> > do_renameat2() does enforce this:
> >
> >          if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
> >              (flags & RENAME_EXCHANGE))
> >                  goto put_names;
> >
> > but our assert seems to check for something different: that neither
> > NOREPLACE nor EXCHANGE is employed with WHITEOUT. Is that a thinko?
>
> Probably.
>
> RENAME_NOREPLACE and RENAME_WHITEOUT are independent -
> The former has to do with the target and enforced by generic vfs.
> The latter has to do with the source and is implemented by specific fs.
>
> Overlayfs adds RENAME_WHITEOUT flag is some cases to a rename
> before performing it on underlying fs (i.e. xfs) to leave a whiteout instead
> of the renamed path, so renameat2(NOREPLACE) on overlayfs could
> end up with (RENAME_NOREPLACE | RENAME_WHITEOUT) to xfs.

Agreed, the assert makes no sense.

Thanks,
Miklos
