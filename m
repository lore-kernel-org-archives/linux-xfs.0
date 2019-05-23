Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37605 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbfEWPSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 11:18:42 -0400
Received: by mail-lj1-f196.google.com with SMTP id h19so374195ljj.4
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 08:18:41 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id b28sm6136370lfj.37.2019.05.23.08.18.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:40 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id w1so5882563ljw.0
        for <linux-xfs@vger.kernel.org>; Thu, 23 May 2019 08:18:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190523100013.52a8d2a6@gandalf.local.home>
In-Reply-To: <20190523100013.52a8d2a6@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 May 2019 08:10:44 -0700
Message-ID: <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, May 23, 2019 at 7:00 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> +# define roundup_64(x, y) (                            \
> +{                                                      \
> +       typeof(y) __y = y;                              \
> +       typeof(x) __x = (x) + (__y - 1);                \
> +       do_div(__x, __y);                               \
> +       __x * __y;                                      \
> +}                                                      \

The thing about this is that it absolutely sucks for power-of-two arguments.

The regular roundup() that uses division has the compiler at least
optimize them to shifts - at least for constant cases. But do_div() is
meant for "we already know it's not a power of two", and the compiler
doesn't have any understanding of the internals.

And it looks to me like the use case you want this for is very much
probably a power of two. In which case division is all kinds of just
stupid.

And we already have a power-of-two round up function that works on
u64. It's called "round_up()".

I wish we had a better visual warning about the differences between
"round_up()" (limited to powers-of-two, but efficient, and works with
any size) and "roundup()" (generic, potentially horribly slow, and
doesn't work for 64-bit on 32-bit).

Side note: "round_up()" has the problem that it uses "x" twice.

End result: somebody should look at this, but I really don't like the
"force division" case that is likely horribly slow and nasty.

                  Linus
