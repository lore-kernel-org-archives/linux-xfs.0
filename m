Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:31403 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751308AbcLFXZw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 18:25:52 -0500
Date: Wed, 7 Dec 2016 10:25:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_io: support -c "open foo" command
Message-ID: <20161206232547.GH4219@dastard>
References: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
 <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net>
 <CAOQ4uxhw8Y_9NVwuAZ_xzvPYZ8k1CRonmQ=CAn=Y9j-_nkToMA@mail.gmail.com>
 <00b2b645-3cd2-f3b2-b026-40dfc97f3f90@sandeen.net>
 <CAOQ4uxhmLe32AMkBmRJx37Pmg3oZMFLt_6Q0kTNYxix_qz7vZA@mail.gmail.com>
 <20161205221548.GD4326@dastard>
 <CAOQ4uxiSDniBTpfgOT9AQ8YGG5Ffz1rSLcBvWdm8TgY_OEArJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiSDniBTpfgOT9AQ8YGG5Ffz1rSLcBvWdm8TgY_OEArJA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Dec 06, 2016 at 07:24:12AM +0200, Amir Goldstein wrote:
> On Tue, Dec 6, 2016 at 12:15 AM, Dave Chinner <david@fromorbit.com> wrote:
> > It's the command loop iteration problem we need to fix, not neuter
> > the multiple file capability of xfs_io.
> >
> 
> OK, v4 it is.
> For some reason you fail to spell out your idea of "fixing",
> so I keep having to guess what you mean.

I outlined the probable fix last week:

https://www.spinics.net/lists/fstests/msg04544.html

i.e. fix the one-shot commands with CMD_FLAG_GLOBAL, but indicated
we'd need to look at the git history to be sure of what is
necessary.

> This time I am guessing that you mean:
> - open all the files in args list (all using the same -r/-f flags)
> - iterate all commands exactly once without implicitly changing "file"

Nope. I meant "go look at the git history and determine what the
historical behaviour was and determine how we ended up with this
mess. Then from that analysis, decide what to do."

Unfortunately, you haven't shown any indication that you've looked
at the git history, nor that you actually listened to me about the
CMD_FLAG_GLOBAL. I've now done that code archeology and it indicates
that my suggestion was correct.

If you didn't understand what I suggested, then say so clearly and
unambiguously so I know I need to explain it more clearly.  The
/worst/ thing you can do is keep sending new patches that take the
same path to one I've already NACKed without having looked at the
solution I proposed or done the historical analysis I suggested was
necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
