Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55412 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752541AbdCMWQJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Mar 2017 18:16:09 -0400
Subject: Re: [PATCH 2/2] xfs: remove readonly checks from xfs_release &
 xfs_inactive
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
 <0d11326f-ebfc-913a-ed1a-b88421982753@sandeen.net>
 <20170313132309.GC4153@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fe60066a-e906-7615-4584-0756e186b20e@sandeen.net>
Date: Mon, 13 Mar 2017 17:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <20170313132309.GC4153@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 3/13/17 8:23 AM, Brian Foster wrote:
> I think some ASSERT(!ro) calls would be prudent in the newly reachable
> codepaths that would make modifications (in both xfs_release() and
> xfs_inactive()), just to catch any future bugs that would otherwise go
> undetected. Otherwise, both patches seem reasonable to me.

Ok, well - we can't assert (!ro) because we /do/ get here in the early
stages of an ro mount.

I want to rework all this like Dave had suggested, but it's not getting
done this release cycle, and I thought a couple targeted changes like this
which fix the bug without making the code beautiful might still make it :)

Maybe the best shortcut for now is to stash, remove, and replace the RO
mount flag like we do for log recovery itself, and clean it all up in
the next round.

-Eric
