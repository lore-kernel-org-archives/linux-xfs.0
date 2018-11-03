Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36468 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeKDCZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 22:25:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id h192so3376857lfg.3
        for <linux-xfs@vger.kernel.org>; Sat, 03 Nov 2018 10:13:57 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id x19-v6sm850926lji.37.2018.11.03.10.13.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Nov 2018 10:13:54 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id t9-v6so1220882ljh.6
        for <linux-xfs@vger.kernel.org>; Sat, 03 Nov 2018 10:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20181102051459.GS6311@dastard> <CAHk-=whrpyMSWM4wxYE+E4fSbpkD3yBATjLnzvvAKBfhGwUaAw@mail.gmail.com>
 <20181102233651.GH19305@dastard>
In-Reply-To: <20181102233651.GH19305@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 3 Nov 2018 10:13:37 -0700
Message-ID: <CAHk-=wiJdzKEq2RsQCe5R1X2W0AEiOYOt8womcyTfkD=mgQAug@mail.gmail.com>
Subject: Re: [GIT PULL] vfs: fix many problems in vfs clone/dedupe implementation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: djwong@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Fri, Nov 2, 2018 at 4:36 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Nov 02, 2018 at 09:35:23AM -0700, Linus Torvalds wrote:
> >
> > I don't love the timing of this at the end of the merge window, but pulled,
>
> When would have been a better time? It's too big for a late -rc, and
> it contains stuff that needs fixing pretty urgently. So if the merge
> window is not appropriate, what should we have done here?

No, I think that with the timing of the problem finding, it was
probably the only thing to do, but generally I like these kinds of
somewhat scary and disruptive patches (just because it touches
multiple filesystems) _early_ in the merge window if at all possible,
and showing that the development was done before and not some rushed
thing..

                Linus
