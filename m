Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729506AbeGZPdF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 11:33:05 -0400
Date: Thu, 26 Jul 2018 10:15:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH, RFC] xfs: completely disable toggling DAX flag via ioctl
 on reg files
Message-ID: <20180726141556.GA18068@bfoster>
References: <405e182f-0c24-81fe-9d04-1031a8bbac17@redhat.com>
 <20180726120854.GA16980@bfoster>
 <892f27ac-f985-bf8f-1cc9-bc0a996136f7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <892f27ac-f985-bf8f-1cc9-bc0a996136f7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>

On Thu, Jul 26, 2018 at 06:23:58AM -0700, Eric Sandeen wrote:
> On 7/26/18 5:08 AM, Brian Foster wrote:
> > On Wed, Jul 25, 2018 at 02:20:54PM -0700, Eric Sandeen wrote:
> >> 742d842 xfs: disable per-inode DAX flag was, I think, intended
> >> as a short-term workaround to avoid races when toggling DAX on
> >> and off of active inodes until mm/ sorted that out.
> >>
> >> (It's also a confusing title, as it didn't really disable
> >> per-inode DAX at all.)
> >>
> >> However, it has the surprising (to me, at least) result that while
> >> the ioctl succeeds, no behavior changes until the inode is cycled
> >> out of cache and re-read from disk at some unknown later time.
> >> This seems to badly violate the principle of least surprise.
> >>
> >> Until said races are properly resolved, it seems most prudent to
> >> disallow modification of the flag on regular files altogether.
> >> We can still allow per-inode DAX flagging via directory inheritance.
> >>
> >> Since DAX is still flagged as experimental (in part due to these
> >> concerns) I don't think it's a problem to (temporarily?) break
> >> this interface further.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> > 
> > I'm not in tune with the latest state of dax, but if the situation is
> > that we don't currently have a means to correctly switch the per-inode
> > state for an active inode (and thus have simply skipped changing the
> > online flag while carrying on with the on-disk flag, leading to this
> > inode cache cycling requirement), then I think this makes sense. The
> > current interface is essentially incomplete, I don't see any reason to
> > allow unless/until it actually works sanely.
> > 
> > BTW, what bits are actually missing to make that happen? Why is the
> > flush/inval currently in this function not sufficient?
> 
> TBH I don't actually know the low-level details. :/
> 

Ok, it would be nice if somebody in the know could chime in on that. ;)

> > Implementation wise, I'm a little curious why we're piling on hacks
> > (such as the return short-circuit and the previous #if 0) as opposed to
> > just removing the code. The code can always be restored directly from
> > the git history, right?
> 
> Well, fair point.  If this goes in it should probably at least remove
> the other #if 0 so it's not stacking hacks on hacks, but if the issue
> is in mm/ it might be a big ask for anyone eventually working on that
> to dig supporting code back out of xfs git history ...
> 

If that's the case, shouldn't it essentially just be a revert of this
patch that rips the code out? Even if the surrounding code changes in
the meantime, we should be able to add it back fairly easily. If that's
not the case, then it sounds like that dead code would need to change
anyways. 

Brian

> -Eric
