Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96EDEC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 21:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjKHV3j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHV3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 16:29:39 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9FC2586
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 13:29:36 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5409bc907edso158513a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Nov 2023 13:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1699478975; x=1700083775; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QsX9YSXgqoPg+e0gigeut8dVFOIqYYd3vJcAhcwMV2g=;
        b=RxClUojSYS6JQ0rotGZ/v7gi50AxFL7N8kU+gSbw5Kctw4Iu5ZwFgSW+KrINyFGSaJ
         NY/oSlI3koGWslkTRvSdLbPpAT948GpFUfpIwjEzKi+QJd2o64Fi8Edy5i4tP0ZpXuBW
         2XZjEjyT7P0mjdZC87UWAs/vqPBhPP+HzYJLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699478975; x=1700083775;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QsX9YSXgqoPg+e0gigeut8dVFOIqYYd3vJcAhcwMV2g=;
        b=W2X9G0NT90/Yl5g/HOSgDd8Ao40qkzlBrUNYqkQ3SzzZTgOdCZ+s+c1KZOI0yIARlI
         9Re7/KPHp4ZRsUKSqeKM5+Axwt/Bl6JxnaewIkacJjaUZ/Uqeg1U3rmT/aMoZb7sBruj
         CycpVp2UKaBdJaPM6Mxqe4aPCMzLi+1nvsXK0a9sN5wy2YvD4BrbwKkPCMJlMXJKObbi
         HQwuyhOWcPuO9Qa4XTSEjMD+pHS1/tQJsm8OHhCp+Vbndb3qh9GudnPEdKGr2NgWKOfZ
         HiZKlI8ZlsKGoi+rX/mIyPXKmYAIvbcHQi9S1Lwq/ubDXsVgO/ibgUphah6xnKp2dHRM
         kLvA==
X-Gm-Message-State: AOJu0Yy9zgPIzL6YhBrzlJS6d5RUONffsFE94V58HNGALqi1uDRkSlr8
        oYu/fuNjCPzH0hEGq9B1oivx/mUnHiKpt5U7p7bh3A==
X-Google-Smtp-Source: AGHT+IGFQxgcMb5A5FUeDneGLYBkDcgjfPUOjTib6LVnOARyEZIn5AZASu3r1O9TVMcwO2w5n0RGlQ==
X-Received: by 2002:a17:907:d27:b0:9b2:abb1:a4ab with SMTP id gn39-20020a1709070d2700b009b2abb1a4abmr2920393ejc.65.1699478975280;
        Wed, 08 Nov 2023 13:29:35 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id b20-20020a170906491400b009b65a834dd6sm1607448ejq.215.2023.11.08.13.29.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Nov 2023 13:29:34 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9d2c54482fbso32138566b.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Nov 2023 13:29:33 -0800 (PST)
X-Received: by 2002:a17:907:97c8:b0:9da:f391:409a with SMTP id
 js8-20020a17090797c800b009daf391409amr3121344ejc.26.1699478973426; Wed, 08
 Nov 2023 13:29:33 -0800 (PST)
MIME-Version: 1.0
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Nov 2023 13:29:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com>
Message-ID: <CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 6.7
To:     Chandan Babu R <chandanbabu@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>
Cc:     catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, djwong@kernel.org, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        osandov@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 8 Nov 2023 at 02:19, Chandan Babu R <chandanbabu@kernel.org> wrote:
>
> I had performed a test merge with latest contents of torvalds/linux.git.
>
> This resulted in merge conflicts. The following diff should resolve the merge
> conflicts.

Well, your merge conflict resolution is the same as my initial
mindless one, but then when I look closer at it, it turns out that
it's wrong.

It's wrong not because the merge itself would be wrong, but because
the conflict made me look at the original, and it turns out that
commit 75d1e312bbbd ("xfs: convert to new timestamp accessors") was
buggy.

I'm actually surprised the compilers don't complain about it, because
the bug means that the new

        struct timespec64 ts;

temporary isn't actually initialized for the !XFS_DIFLAG_NEWRTBM case.

The code does

  xfs_rtpick_extent(..)
  ...
        struct timespec64 ts;
        ..
        if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
                mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
                seq = 0;
        } else {
        ...
        ts.tv_sec = (time64_t)seq + 1;
        inode_set_atime_to_ts(VFS_I(mp->m_rbmip), ts);

and notice how 'ts.tv_nsec' is never initialized. So we'll set the
nsec part of the atime to random garbage.

Oh, I'm sure it doesn't really *matter*, but it's most certainly wrong.

I am not very happy about the whole crazy XFS model where people cast
the 'struct timespec64' pointer to an 'uint64_t' pointer, and then say
'now it's a sequence number'. This is not the only place that
happened, ie we have similar disgusting code in at least
xfs_rtfree_extent() too.

That other place in xfs_rtfree_extent() didn't have this bug - it does
inode_get_atime() unconditionally and this keeps the nsec field as-is,
but that other place has the same really ugly code.

Doing that "cast struct timespec64 to an uint64_t' is not only ugly
and wrong, it's _stupid_. The only reason it works in the first place
is that 'struct timespec64' is

  struct timespec64 {
        time64_t        tv_sec;                 /* seconds */
        long            tv_nsec;                /* nanoseconds */
  };

so the first field is 'tv_sec', which is a 64-bit (signed) value.

So the cast is disgusting - and it's pointless. I don't know why it's
done that way. It would have been much cleaner to just use tv_sec, and
have a big comment about it being used as a sequence number here.

I _assume_ there's just a simple 32-bit history to this all, where at
one point it was a 32-bit tv_sec, and the cast basically used both
32-bit fields as a 64-bit sequence number.  I get it. But it's most
definitely wrong now.

End result: I ended up fixing that bug and removing the bogus casts in
my merge. I *think* I got it right, but apologies in advance if I
screwed up. I only did visual inspection and build testing, no actual
real testing.

Also, xfs people may obviously have other preferences for how to deal
with the whole "now using tv_sec in the VFS inode as a 64-bit sequence
number" thing, and maybe you prefer to then update my fix to this all.
But that horrid casts certainly wasn't the right way to do it.

Put another way: please do give my merge a closer look, and decide
amongst yourself if you then want to deal with this some other way.

              Linus
