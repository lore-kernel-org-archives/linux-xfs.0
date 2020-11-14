Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221A9C4742C
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C10672225B
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P6cesCbv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKNAN5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNAN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:13:56 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A498C0613D1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 16:13:56 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id l11so4598166lfg.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 16:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OvZhzUo1BKEAMXk7J8Ec04lI724x0EKAq0CQHylr9Qk=;
        b=P6cesCbv6T5WyCEQ20G2iDas38QZ/BYEKN0z2D/4Rr0ZaXp5OCzkvwAUalCl7xlLJy
         aAByv62DKrnD/Fs9d+pfwMOOqDi/5mvBK7fI8ZM2kpLZkJIDq88qump9IeKexz7S1ono
         ZF4rQ13IKH35+KMT32xMULy9PwmXG6jpi7O1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvZhzUo1BKEAMXk7J8Ec04lI724x0EKAq0CQHylr9Qk=;
        b=akTRBkjtYeb7O0fkd0QN9SoRXU81hzBMo1Ja4/dL6Q53XrmaxL9y/1bbDrQdaboAen
         JZ9yCyn/aLk65PdcF+7GjaxpSCDMOguiipY+G6NYknf5fX+o+08qcB5/HYxxA8JZ1u5C
         meuoKMWHwR9lQxJvZ1wP01PtM0GnJfKdHI26y8aWk/ZR6g7YMN9UH7rfWLY2n3dq9+Iw
         nV9hKqT3pn6ZsX+0vy4yiMsVWoV8mwOO1lDEtRWW3tcRF2/h/wIk1eqIVzF+rYVa2rbL
         rYUlwR3eepL6eWY5CRrFtRjEmj+p5HBFS5xhJeFEcczcanM1trZ1SArglvsoR1B6zlZO
         sv0A==
X-Gm-Message-State: AOAM532yeaml3v4XW6LkDMzLiHjRf6joHpfm+kRnQLc3Lj3Oduo2SO+Q
        3/HHskNXzZVmDIilQPDyuFjI2hsp9AmArA==
X-Google-Smtp-Source: ABdhPJxCo8eHjDqxyu2XP9ywPLBTIX1yO+/iOdiJgNcMBgxhyKuteEHTxArWlzu3lAlILTurpnLiYQ==
X-Received: by 2002:a19:d14:: with SMTP id 20mr1702680lfn.87.1605312834334;
        Fri, 13 Nov 2020 16:13:54 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id t11sm1732856lff.253.2020.11.13.16.13.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 16:13:53 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id l11so4598099lfg.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 16:13:53 -0800 (PST)
X-Received: by 2002:ac2:598f:: with SMTP id w15mr1675126lfn.148.1605312832994;
 Fri, 13 Nov 2020 16:13:52 -0800 (PST)
MIME-Version: 1.0
References: <20201113233847.GG9685@magnolia>
In-Reply-To: <20201113233847.GG9685@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 13 Nov 2020 16:13:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=whvWbFBr-W8FvAT1_ekuzWk=q_g+6+_h2ChycsW8dMhmw@mail.gmail.com>
Message-ID: <CAHk-=whvWbFBr-W8FvAT1_ekuzWk=q_g+6+_h2ChycsW8dMhmw@mail.gmail.com>
Subject: Re: [GIT PULL] vfs: fs freeze fix for 5.10-rc4
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, fdmanana@kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 3:38 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Since the hack is unnecessary and causes thread race errors, just get
> rid of it completely.  Pushing this kind of vfs change midway through a
> cycle makes me nervous, but a large enough number of the usual
> VFS/ext4/XFS/btrfs suspects have said this looks good and solves a real
> problem vector, so I'm sending this for your consideration instead of
> holding off until 5.11.

Not a fan of the timing, but you make a good argument, and I love
seeing code removal. So I took it.

And once I took the real code change, the two cleanups looked like the
least of the problem, so I took them too.

I ended up doing it all just as a single pull, since it seemed
pointless to make history more complicated just to separate out the
cleanups in a separate pull.

Now I really hope this won't cause any problems, but it certainly
_looks_ harmless.

          Linus
