Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37426 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731858AbeG0Cjo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 22:39:44 -0400
Subject: Re: [PATCH, RFC] xfs: completely disable toggling DAX flag via ioctl
 on reg files
References: <405e182f-0c24-81fe-9d04-1031a8bbac17@redhat.com>
 <20180726120854.GA16980@bfoster>
 <892f27ac-f985-bf8f-1cc9-bc0a996136f7@sandeen.net>
 <20180726231754.GB2234@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e1caad41-40c2-3ff2-3ed4-46cf603fc4d2@sandeen.net>
Date: Thu, 26 Jul 2018 18:20:01 -0700
MIME-Version: 1.0
In-Reply-To: <20180726231754.GB2234@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>

On 7/26/18 4:17 PM, Dave Chinner wrote:

...

> As it is, I don't think we can remove this now - people are using
> the on-disk flags already, and the inherit flag from the directory
> has none of the problems of changing S_DAX dynamically.

Which is why I left the inheritance part ...

> Hence just
> disabling it is the wrong thing to do because it removes the ability
> for people to manage the flags that are already on disk....

Well, it's EXPERIMENTAL... o_O

But yeah, this does remove the ability to turn off the flag, at least
w/o making a file copy or some other gross thing.

> I'd much prefer we fix the page fault synchronisation problem than
> break stuff that /isn't actually broken/. Yes, it's current
> behaviour is suboptimal, but that is only supposed to be /temporary/
> until the aops callout problem is fixed.

Well, it's super confusing and from the user POV more or less
nondeterministic, at this point.  That borders on broken/unusable IMHO.
"Change the flag and some time later, not really within your control, the
behavior will change."

It's been broken for a year.  TBH I'm not sure I personally have
the knowledge/skill (and I almost certainly don't have the time)
to fix it.  Just trying to make the best of a sticky situation.
This seemed better to me, modulo the inability to remove the
flag.  :/  And I figured more permissive flag manipulation could
be added back later if it ever does get fixed.

Thanks,
-Eric
 
> Cheers,
> 
> Dave.
> 
