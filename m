Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEFCC432C3
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 23:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68F820718
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 23:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575328973;
	bh=vSzUO+RJmiCpSVyWW4tK/LpH0jUWkgemDgeoZdYmNyI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0uLl5M4Te5Av/KSZIMNambCjyouERC5igOTJHwIg6Bz73pyrfPExhLlIUVLtf4u7W
	 kOlksAXnv5RxQHMzsjfJoHcdSj1PDOb92IEmkenzadV9DQ86LQIZ5uy7eFwQ/sRiXC
	 qXzMLkKTyvr85hJfv6Yo2LaP1OB5f+RaLvvr86DM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfLBXWw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 18:22:52 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42670 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfLBXWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 18:22:52 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so1473024ljo.9
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 15:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zivbud+uo79674awuuW6IgbOjr9ZgzEppMzA23/d+3w=;
        b=UclclWVwgV4xGQBOpFikWRYV32woYv2h8DydWQGIKKlJaO6sY8EY4nxJo08fcognZc
         deheC2mhwyio+gu1GBFlvBcudM9owVwCIU2NYoX1t4/V4gtGiLscKYRmKWNT/nimRqlH
         YMCHJCulS4nnZJ4g1AhbL0Pc9o2mOYf7lgYmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zivbud+uo79674awuuW6IgbOjr9ZgzEppMzA23/d+3w=;
        b=RzZ28ZE6wgdCgIz+EX5HHma0A3WpJItgCE92pO4hQOiHjDaIULElQKCNg4c6xxEWQ8
         RnHb454cjV/TWaN6IaSwpqsPdIO73qoxG37FEr/w+wn4c9vkUAMpND0ZU/Ka4zt+j1vS
         JXvjnfZIse8B6hnT9R6vLxqBx6J5Tuf2qFlJEju5QVP7Eupi3A7n2ja61dvYRXGnCGR6
         M5KqLWilNzhpbB9072TVap347+9ElHpTxBH7lpPUHwCFQx++sDj829UYWd023u4DRnpr
         LKiGPp4fBPlso8Lkzb1M2GA0raIipxKGWXGaUZGQfYeQwb/DyA0tng+7I+PPxXL0GRNT
         yPMw==
X-Gm-Message-State: APjAAAWnnzl5OQ1HnglDziyfWbOx7PzgTSnJdFE1BCjxZSW8Xc0/htSr
        ZtprHpBIZQgGFFnfqrYoDPAbyezLZI4=
X-Google-Smtp-Source: APXvYqyN7aRJc1S0YiY2p3uuyIZKl44/83lzu6+qfo1Ym3TcZbxROfOFPeM5B8xBl0j3at8g54AyYA==
X-Received: by 2002:a2e:914d:: with SMTP id q13mr746950ljg.198.1575328968879;
        Mon, 02 Dec 2019 15:22:48 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id i19sm417017ljj.24.2019.12.02.15.22.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 15:22:48 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id b15so1286153lfc.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 15:22:47 -0800 (PST)
X-Received: by 2002:ac2:4946:: with SMTP id o6mr894542lfi.170.1575328967630;
 Mon, 02 Dec 2019 15:22:47 -0800 (PST)
MIME-Version: 1.0
References: <20191201184814.GA7335@magnolia>
In-Reply-To: <20191201184814.GA7335@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Dec 2019 15:22:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi+0suvJAw8hxLkKJHgYwRy-0vg4-dw9_Co6nQHK-XF9Q@mail.gmail.com>
Message-ID: <CAHk-=wi+0suvJAw8hxLkKJHgYwRy-0vg4-dw9_Co6nQHK-XF9Q@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 5.5
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 1, 2019 at 10:48 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> FYI, Stephen Rothwell reported a merge conflict with the y2038 tree at
> the end of October[1].  His resolution looked pretty straightforward,
> though the current y2038 for-next branch no longer changes fs/ioctl.c
> (and the changes that were in it are not in upstream master), so that
> may not be necessary.

The changes and conflicts are definitely still there (now upstream),
I'm not sure what made you not see them.  But thanks for the note, I
compared my end result with linux-next to verify.

My resolution is different from Stephen's. All my non-x86-64 FS_IOC_*
cases just do "goto found_handler", because the compat case is
identical for the native case outside of the special x86-64 alignment
behavior, and I think that's what Arnd meant to happen.

There was some other minor difference too, but it's also possible I
could have messed up, so cc'ing Stephen and Arnd on this just in case
they have comments.


               Linus
