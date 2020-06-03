Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E270CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 02:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C90207D0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 02:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591152063;
	bh=hMTZ0FxqVIqwxc4DoXgBc2TMxu3MOb8j4MrnOnw+cJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=yxPnIx8kYYq0HDpWJIHyJ/L9iRjC+QljD50CngVfz34+hE+Q5bK15wsTj1tal/ERC
	 wyySp6o3iIX6kg7Kb4fa6WMFxLoN41zS97+lcqCsz97bCwON9/Ge+Rij2tiuDOzcvY
	 qyULWPgW6pjNfRw0IkOPW83bSPdcWU484Fj7rSAY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgFCCk6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgFCCk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 22:40:56 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081A7C08C5C0
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 19:40:56 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id h188so317256lfd.7
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2020 19:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zTgMCCg/n7vIKmnl7JnJOYWZtJtsVV/Gf24uT9lr2Aw=;
        b=QcTPtcnEFRe4wGMNruzjSvrdchyjYkSAIk5hEnLYVqjEeoZ4zrQs/W1xUpzehhnR8c
         P327F8+VJu1M6lTDNEqANb4RW5ovuuGTM3+tD1GzoEYxzJget2it2p/ORrwwDG6+0K97
         N/TKfXmUqCnobORfjbBlOHbJDMbbld37vZe0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zTgMCCg/n7vIKmnl7JnJOYWZtJtsVV/Gf24uT9lr2Aw=;
        b=kIzt61Q4iWgmymrK9F0laz0NE1IZMmxGahKNvQSu9McGSXMWs++4cnT7TSGhWE9WNF
         7YNceInFCf/9UpiiqPpxpTGRK+La31+znOt4zCtV6fGDil4Yw6oA4DflECi/eccob70F
         5noPBfKfCJOoDhoan08DSH91Qp0Dixk0yEoBOfRP1HmumRQ0mDK9yERWLk6Wld1IPhOt
         zJPAg4HHt/VMx18ZkkoCmmaNbP2qJWO7Lg/Kz5+0mjC+utWnR1OujRD7pAY/Sjw3ui7B
         iIrX7HK9bWOWyPrbEJo54XLmjBcOjLoMB+Hw5G8m8/rULQeNJI6/iYCuZPCl5fjbx2Aw
         M4OA==
X-Gm-Message-State: AOAM530FcqDOFNlXvJGu7ToPsgl5/e5aKG3evgPz1uMMHvLWJ3Gsv7Yg
        4UAsp6yhzv5fT84kogvv2FCait0cWHo=
X-Google-Smtp-Source: ABdhPJzBgfPUa5nJNVIvjnFghzuTgxXVHcGfhvajh+eWC/9H3cHCd0mFd/oCRLpFrQJuv/YJ7/AhGw==
X-Received: by 2002:a19:23d2:: with SMTP id j201mr1167211lfj.83.1591152053520;
        Tue, 02 Jun 2020 19:40:53 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id a7sm226031lfm.4.2020.06.02.19.40.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 19:40:52 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id c12so310657lfc.10
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jun 2020 19:40:51 -0700 (PDT)
X-Received: by 2002:a05:6512:62:: with SMTP id i2mr1173928lfo.152.1591152051293;
 Tue, 02 Jun 2020 19:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200602162644.GE8204@magnolia>
In-Reply-To: <20200602162644.GE8204@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Jun 2020 19:40:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeiqB0TH_V2uTd2CX2hks+3TW344j73ftJFjqUteTxXA@mail.gmail.com>
Message-ID: <CAHk-=wgeiqB0TH_V2uTd2CX2hks+3TW344j73ftJFjqUteTxXA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 5.8 (now with fixed To line)
To:     "Darrick J. Wong" <djwong@kernel.org>
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

On Tue, Jun 2, 2020 at 9:26 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
>  102 files changed, 4244 insertions(+), 4817 deletions(-)

Interestingly, the changes to that xfs_log_recover.c file really seem
to break the default git diff algorithm (the linear-space Myers'
algorithm)

The default settings give me

 fs/xfs/xfs_log_recover.c                           | 2801 ++------------------
 102 files changed, 4366 insertions(+), 4939 deletions(-)

which is not very close to yours. With the extra effort "--minimal" I get

 fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
 102 files changed, 4246 insertions(+), 4819 deletions(-)

but based on your output, I suspect you used "--patience", which gives that

 fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
 102 files changed, 4244 insertions(+), 4817 deletions(-)

output (the difference there wrt minimal came from
fs/xfs/libxfs/xfs_symlink_remote.c).

I'm used to seeing small differences in the line counts due to
different diff heuristics, but that 250 line difference for
"--patience" is more than you usually get.

None of this matters, and I'm not at all suggesting you change any of
your workflow.

I'm just commenting because I was going "why am I not getting a
matching diffstat", and while I'm used to seeing small differences
from diff algorithms, that 240 line-count change was really a lot more
than I normally encounter.

                      Linus
