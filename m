Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35231 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752899AbcLGEVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 23:21:44 -0500
MIME-Version: 1.0
In-Reply-To: <20161206232547.GH4219@dastard>
References: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
 <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net> <CAOQ4uxhw8Y_9NVwuAZ_xzvPYZ8k1CRonmQ=CAn=Y9j-_nkToMA@mail.gmail.com>
 <00b2b645-3cd2-f3b2-b026-40dfc97f3f90@sandeen.net> <CAOQ4uxhmLe32AMkBmRJx37Pmg3oZMFLt_6Q0kTNYxix_qz7vZA@mail.gmail.com>
 <20161205221548.GD4326@dastard> <CAOQ4uxiSDniBTpfgOT9AQ8YGG5Ffz1rSLcBvWdm8TgY_OEArJA@mail.gmail.com>
 <20161206232547.GH4219@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Dec 2016 06:21:41 +0200
Message-ID: <CAOQ4uxj8VQ106M_3dHoWXHUx8TROUYkvDMOGyE0qHjWuJgdp4w@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: support -c "open foo" command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Dec 7, 2016 at 1:25 AM, Dave Chinner <david@fromorbit.com> wrote:
...
>
> Nope. I meant "go look at the git history and determine what the
> historical behaviour was and determine how we ended up with this
> mess. Then from that analysis, decide what to do."
>
> Unfortunately, you haven't shown any indication that you've looked
> at the git history, nor that you actually listened to me about the
> CMD_FLAG_GLOBAL. I've now done that code archeology and it indicates
> that my suggestion was correct.
>

Thank you for doing that digging. I might have gotten the wrong impression
that you were going to do that anyway and figured you would do a better
job at this than me, having a longer history with libxfs and xfs_io than me.

> If you didn't understand what I suggested, then say so clearly and
> unambiguously so I know I need to explain it more clearly.

Sorry I wasn't clear about that. My problem, or lack of clarity, was
revolving around the semantic changes that would have to be made.
I did not want to go fix the problem without knowing what those are
going to be, so in the mean while, I suggested a few starter options
which do not change semantics for existing known users, allow
overlay/016 to work properly and leave the multiple file semantics
for you to clarify.

> The
> /worst/ thing you can do is keep sending new patches that take the
> same path to one I've already NACKed without having looked at the
> solution I proposed or done the historical analysis I suggested was
> necessary.
>

Had I known /this/ was the worst thing in your book, I would have
avoided it. I took that path mainly because we seem to have little
overlap working hours, so the round trip of this thread makes progress
hard. I apologize if this came off as "shut up Dave! and take my patch".

The only reason I suggested changing behavior for multiple
files and "break existing users" is because Eric indicated he had
no idea about this feature and indicated that it is an undocumented
feature. With someone like Eric saying that, it grew my suspicion that
maybe we really do not need to fix multiple files for xfs_io??

Could you please consider this option for a moment?
Perhaps we are better off correcting a wrong turn taken in 2004
then fixing its consequences now?

After all, xfs_io is not the Linux kernel. Its a tool used mainly
by developers as you yourself indicated. If killing multiple files will
break someones use case, you should know about it pretty quick
and we can then resort to changing semantics and adding new
command line flags.

The motivation for taking this path is not just laziness to
"fix the real problem". It stands to make the code a lot simpler
and to keep the man page correct and coherent with expected
behavior rather then adding more obscure semantics which
/are/ going to be confusing.

For your consideration.
Sorry if we started off on the wrong foot.
Amir.
