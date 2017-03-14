Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdCNLgB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Mar 2017 07:36:01 -0400
Date: Tue, 14 Mar 2017 07:35:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: remove readonly checks from xfs_release &
 xfs_inactive
Message-ID: <20170314113554.GB18042@bfoster.bfoster>
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
 <0d11326f-ebfc-913a-ed1a-b88421982753@sandeen.net>
 <20170313132309.GC4153@bfoster.bfoster>
 <fe60066a-e906-7615-4584-0756e186b20e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe60066a-e906-7615-4584-0756e186b20e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 13, 2017 at 05:16:07PM -0500, Eric Sandeen wrote:
> On 3/13/17 8:23 AM, Brian Foster wrote:
> > I think some ASSERT(!ro) calls would be prudent in the newly reachable
> > codepaths that would make modifications (in both xfs_release() and
> > xfs_inactive()), just to catch any future bugs that would otherwise go
> > undetected. Otherwise, both patches seem reasonable to me.
> 
> Ok, well - we can't assert (!ro) because we /do/ get here in the early
> stages of an ro mount.
> 

Ok, I suppose we'd have to filter out from "mounting" context. That is
only for the case where we run log recovery though, right?

> I want to rework all this like Dave had suggested, but it's not getting
> done this release cycle, and I thought a couple targeted changes like this
> which fix the bug without making the code beautiful might still make it :)
> 
> Maybe the best shortcut for now is to stash, remove, and replace the RO
> mount flag like we do for log recovery itself, and clean it all up in
> the next round.
> 

Hmm, that does sound like a cleaner approach.

Brian

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
