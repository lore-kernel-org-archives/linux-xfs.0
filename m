Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB152C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 02:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiEZC4x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 22:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbiEZC4w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 22:56:52 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF61BCE9E
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 19:56:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id wh22so601760ejb.7
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 19:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/f+kIrdBFHC65DVHSr+BTnTC0fF5q81rMDDOfyiD654=;
        b=Z/rNiCa09OUBCMiQjoRDx83QdZD702DaqjPDsUPMD9T+5L1M4LKv/sAnmlOalu/TF9
         vfhab89ZlrhWprBxvUy4qqjmS6TXouMB1W2bCmtdC+y4kkhHTAIXEWexSFGb8rPos9eF
         bVnf4I0g2l86xNx+ofyWhsIQeBy7iubJ3LdDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/f+kIrdBFHC65DVHSr+BTnTC0fF5q81rMDDOfyiD654=;
        b=m2lU/G7WXJ776FuI5rzKZWKkxqjEvhaBNRHphaukcs00F+VmwS59MeoxOsw5+s+JVO
         R2V4I6tKRjV6GWwsYoOEG4n+8MJo6iqQLBRgl3yEkcXO3nTATOaCHp3rBhS44uMt0F8r
         8xHVWGGbfXela2wvVl7dt/0hblOwd7z6Iwc6I8Wre9TKHrX3a1JmMwN1uOjMTVlVbrHJ
         h6rnzBLeKXm0bUvZBiGTiHGotqjF6ohNPubSVmXyXFWSPso+yog3/6O4QYEd2NVNcsqv
         g8YQF+mkHG3jq6FKcyXXjv/ZuXai6CnSxpSOEWh6hkqFFqyqTB2PGvMTHS9T2rQ4+74w
         IgFA==
X-Gm-Message-State: AOAM530BCZ0LkIz/AmVBF9ps5oWYSptXcFfrzo8MOLh801AKmOCsoZmT
        Y5lcs1K4klyD13jNJTZSfn28aT4GPS9Cp8x31EA=
X-Google-Smtp-Source: ABdhPJzCf4M3xqG4vYkI+l8IMFJth4OGOpHtYcX6GMhOXUojZ4cis9z8mhvZKcmDoILGh3OL3ifTyA==
X-Received: by 2002:a17:907:6da4:b0:6fe:fa71:a726 with SMTP id sb36-20020a1709076da400b006fefa71a726mr14089437ejc.518.1653533808997;
        Wed, 25 May 2022 19:56:48 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id v19-20020a50d093000000b0042bd2d0b40csm176753edd.17.2022.05.25.19.56.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 19:56:48 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id k30so480038wrd.5
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 19:56:47 -0700 (PDT)
X-Received: by 2002:a5d:58cc:0:b0:20e:643d:e46a with SMTP id
 o12-20020a5d58cc000000b0020e643de46amr28382959wrf.97.1653533807553; Wed, 25
 May 2022 19:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220526022053.GY2306852@dread.disaster.area>
In-Reply-To: <20220526022053.GY2306852@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 25 May 2022 19:56:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8R2sYVKi7bgwVN8n-exN766PSJwYg+18SLbR=+vQtVA@mail.gmail.com>
Message-ID: <CAHk-=wg8R2sYVKi7bgwVN8n-exN766PSJwYg+18SLbR=+vQtVA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 5.19
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 7:21 PM Dave Chinner <david@fromorbit.com> wrote:
>
> Can you please pull the XFS updates for 5.19 from the tag listed
> below? It merges cleanly with the TOT kernel I just pulled a couple
> of minutes ago, though the diffstat I got on merge:
>
> 105 files changed, 4862 insertions(+), 2773 deletions(-)
>
> is slightly different to the diffstat the pull request generated.

Funky. I get the same diffstat that you list below in the pull
request, not the above.

Different diff algorithms do get different results, so the actual line
numbers vary a bit with the default myers vs minimal vs patience vs
histogram algorithms. But while that changes line numbers, it
shouldn't then change the actual number of files...

I wonder what the difference is, but I'm not going to delve into it
further since what I see matches the pull request and it all looks
fine.

I do notice that if I use

   git diff -C10 ..

to make git more eagerly find file copies, I get

 [...]
 104 files changed, 4444 insertions(+), 3125 deletions(-)
 copy fs/xfs/{xfs_bmap_item.c => xfs_attr_item.c} (13%)
 create mode 100644 fs/xfs/xfs_attr_item.h

and adding "-B/10%" to make git also look for rewrites (ie files that
might be better shown as "remove file and then re-add") gives:

 [..]
 104 files changed, 5449 insertions(+), 4130 deletions(-)
 rewrite fs/xfs/libxfs/xfs_attr.c (43%)
 copy fs/xfs/{xfs_bmap_item.c => xfs_attr_item.c} (13%)
 create mode 100644 fs/xfs/xfs_attr_item.h
 rewrite fs/xfs/xfs_log.h (31%)
 rewrite fs/xfs/xfs_message.h (30%)

so it might be something along those lines where our git configs
differ. I couldn't get it to give "105 files", though.

Not important. I just got curious.

And it might also be as simple as you just having had something else
in your tree at the same time, that you didn't want to send, but
forgot about when you did the test-merge. That would be the simplest
explanation..

> If I've made any mistakes or done stuff that is considered wrong or
> out of date, let me know and I'll fix them up - it's been a while
> since I built a tree for upstream merge.

It all looks fine.

I might wish that your merge commit messages were a bit more
consistent about the merge details ("why and what"), but you are most
definitely not the only one with that, and a number of them are quite
nice (ie the merge of the large extent counters has a nice informative
commit message, as does the rmap speedup one).

And then some of them are the uninformative one-lines that just say
"Merge branch X"

               Linus
